# nixos-config

Configuração NixOS declarativa, baseada em Flakes.

| | |
|---|---|
| Host | `laptop-lenovo` |
| Canal | `nixos-unstable` |
| Desktop | KDE Plasma 6 (Wayland) + SDDM |
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

> Como o flake vive num diretório versionado, o Nix só enxerga arquivos
> rastreados pelo git. Depois de criar um arquivo novo, rode `git add` antes do
> rebuild, senão ele será ignorado silenciosamente.

## Estrutura

```
flake.nix                  entrypoint; declara os inputs e o host
hosts/laptop-lenovo/
  default.nix              imports + o que é específico desta máquina
  hardware-configuration.nix   gerado pelo nixos-generate-config
modules/
  core/                    boot, locale, rede, configurações do Nix
  desktop/                 Plasma, áudio, impressão, teclado, flatpak
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

## Manutenção

Limpeza de store e gerações é automática (`modules/core/nix.nix`): GC semanal
descartando o que tem mais de 30 dias, mais deduplicação do store. O menu de
boot é limitado a 10 gerações em `modules/core/boot.nix` — sem esse limite a
partição EFI enche de kernels antigos e o rebuild falha.

Para limpar na hora:

```bash
sudo nix-collect-garbage --delete-older-than 30d
```

## Dependências imperativas

O item de menu do Dolphin "Abrir Claude Code Aqui"
(`modules/programs/claude-code-servicemenu.nix`) depende de duas coisas que
**não** estão no Nix:

1. A imagem Docker `claude-code-cli:latest`, construída à mão.
2. O arquivo `~/.config/claude/api.env` exportando `ANTHROPIC_API_KEY` — fora
   do repositório de propósito.

Numa reinstalação a partir deste flake, os dois precisam ser recriados.
