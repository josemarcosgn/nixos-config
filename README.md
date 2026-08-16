# nixos-config

Configuração NixOS declarativa, baseada em Flakes.

| | |
|---|---|
| Máquina | Lenovo ThinkBook 16 G8 IRL (`laptop-lenovo`) |
| Canal | `nixos-unstable` |
| Desktop | KDE Plasma 6 + SDDM, ou GNOME + GDM (ambos Wayland) |
| Disco | ext4 sobre LUKS, boot EFI |

## Uso

```bash
cd ~/.config/nixos-config

# Testar a avaliação sem ativar nada (rode isto antes de qualquer switch)
nixos-rebuild dry-build --flake .#laptop-lenovo

# Aplicar
sudo nixos-rebuild switch --flake .#laptop-lenovo

# Aplicar só no próximo boot
sudo nixos-rebuild boot --flake .#laptop-lenovo

# Atualizar o nixpkgs (regrava o flake.lock)
nix flake update
```

## As duas variantes de desktop

O flake expõe duas configurações para a **mesma** máquina, diferindo apenas no
ambiente gráfico:

| Configuração | Desktop |
|---|---|
| `.#laptop-lenovo` | KDE Plasma 6 + SDDM |
| `.#laptop-gnome` | GNOME + GDM |

Tudo o mais — hardware, usuário, programas — é compartilhado por construção:
`flake.nix` monta as duas a partir de `hosts/laptop-lenovo` e só acrescenta
`modules/desktop/plasma.nix` ou `modules/desktop/gnome.nix`. Não há como uma
variante ganhar um ajuste de hardware que a outra não tenha.

O hostname continua `laptop-lenovo` nas duas: é a mesma máquina, e só uma delas
está ativa por vez.

Para experimentar o GNOME **sem tocar no sistema instalado**, rode numa VM:

```bash
nixos-rebuild build-vm --flake .#laptop-gnome
./result/bin/run-laptop-lenovo-vm
```

O `hosts/laptop-lenovo/vm-variant.nix` existe só por causa disso: o disco da VM
é sintético, então o dispositivo LUKS do `hardware-configuration.nix` não existe
lá dentro e a VM pararia no initrd esperando uma senha. Esse arquivo zera o LUKS
e dá 4 GB de RAM à VM — nada disso afeta o sistema real.

Gostando, ative de verdade. Como um `boot` só troca a geração padrão, dá para
voltar ao Plasma escolhendo a geração anterior no menu de boot:

```bash
sudo nixos-rebuild boot --flake .#laptop-gnome && reboot
```

> Como o flake vive num diretório versionado, o Nix só enxerga arquivos
> rastreados pelo git. Depois de criar um arquivo novo, rode `git add` antes do
> rebuild, senão ele será ignorado silenciosamente.

## Estrutura

```
flake.nix                  entrypoint; inputs e as duas configurações
hosts/laptop-lenovo/
  default.nix              imports + o que é específico desta máquina
  hardware-configuration.nix   gerado pelo nixos-generate-config
  vm-variant.nix           ajustes válidos só no `build-vm`
modules/
  core/                    boot, locale, rede, configurações do Nix
  desktop/                 áudio, impressão, teclado, flatpak
                           + plasma.nix e gnome.nix (escolhidos no flake)
  hardware/                Intel (CPU/GPU), energia, memória, digital, disco
  programs/                pacotes e apps de sistema
  virtualisation/          Docker e libvirt/QEMU
users/
  jose.nix                 conta, grupos e pacotes do usuário
```

Regras que a estrutura segue:

- **Módulos não hardcodam usuário.** Grupos como `docker`, `libvirtd` e `kvm`
  são declarados só em `users/jose.nix`. Módulos declaram serviços.
- **Uma opção, um lugar.** `hardware.graphics` vive inteiro em
  `modules/hardware/intel.nix`, não espalhado entre arquivos.
- **O host só tem o que é do host:** hostname, `stateVersion` e a lista de
  imports.
- **`modules/desktop/default.nix` não importa desktop nenhum.** Só as partes
  agnósticas. Quem escolhe entre `plasma.nix` e `gnome.nix` é o `flake.nix` —
  é isso que mantém as duas variantes sem duplicação.

## Manutenção

Limpeza de store e gerações é automática (`modules/core/nix.nix`): GC semanal
descartando o que tem mais de 30 dias, mais deduplicação do store. O menu de
boot é limitado a 10 gerações em `modules/core/boot.nix` — sem esse limite a
partição EFI enche de kernels antigos e o rebuild falha.

Para limpar na hora:

```bash
sudo nix-collect-garbage --delete-older-than 30d
```

## Dual boot: relógio

O RTC é mantido em **UTC**. O Windows precisa ser ajustado uma única vez, num
PowerShell como administrador, senão mostra a hora errada e reescreve o RTC em
hora local:

```powershell
reg add "HKLM\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" /v RealTimeIsUniversal /t REG_DWORD /d 1 /f
```

> **Pendente.** Ainda não aplicado no Windows desta máquina.

## Dependências imperativas

O item de menu do Dolphin "Abrir Claude Code Aqui"
(`modules/programs/claude-code-servicemenu.nix`) depende de duas coisas que
**não** estão no Nix:

1. A imagem Docker `claude-code-cli:latest`, construída à mão.
2. O arquivo `~/.config/claude/api.env` exportando `ANTHROPIC_API_KEY` — fora
   do repositório de propósito.

Numa reinstalação a partir deste flake, os dois precisam ser recriados.
