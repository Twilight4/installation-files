curl -O "https://aur.archlinux.org/cgit/aur.git/snapshot/yay.tar.gz" \
&& tar -xvf "yay.tar.gz" \
&& cd "yay" \
&& makepkg --noconfirm -si \
&& cd - \
&& rm -rf "yay" "yay.tar.gz" ;

sudo pacman -S --noconfirm $(cat /tmp/paclist)
yay -S --noconfirm $(cat /tmp/yaylist)
        
# Needed if system installed in VBox
sudo systemctl enable vboxservice.service
    
# zsh as default terminal for user
sudo chsh -s "$(which zsh)" "$name"
            
# Enable the systemd service NetworkManager.
sudo systemctl enable NetworkManager.service

## For Docker
#groupadd docker
#gpasswd -a "$name" docker
#systemctl enable docker.service

DOTFILES="/tmp/"
if [ ! -d "$DOTFILES" ];
  then
    git clone --recurse-submodules "https://github.com/Twilight4/dotfiles" "$DOTFILES" >/dev/null
fi
    
    sudo echo 'export ZDOTDIR="$HOME"/.config/zsh' >> /etc/zsh/zshenv
    sudo mv "/tmp/dotfiles/.config/*" /home/$(whoami)/
    source "/home/$(whoami)/.config/zsh/.zshenv"
    sudo mv "/tmp/dotfiles/fonts/MesloLGS-NF/*" /usr/share/fonts/MesloLGS-NF
    sudo mv "/tmp/dotfiles/fonts/rofi-fonts/*" /usr/share/fonts/rofi-fonts
    sudo mv "/tmp/dotfiles/wallpapers/*" /opt/wallpapers
    rm ~/.bash*
    sudo rm -rf /usr/share/fonts/[71aceT]*
    chmod 755 "$XDG_CONFIG_HOME/qtile/autostart.sh"
    chmod 755 "$XDG_CONFIG_HOME/polybar/launch.sh"
    chmod 755 "$XDG_CONFIG_HOME/polybar/polybar-scripts/*"
    chmod 755 "$XDG_CONFIG_HOME/rofi/applets/bin/*"
    chmod 755 "$XDG_CONFIG_HOME/rofi/applets/shared/theme.bash"
    chmod 755 "$XDG_CONFIG_HOME/rofi/launchers/launcher.sh"
    sudo mv "/tmp/dotfiles/rofi/applets/bin/*" /usr/bin/
    mv "$ZDOTDIR/zsh-completions.plugin.zsh" "$ZDOTDIR/_zsh-completions.plugin.zsh"
    git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
    git config --global user.email "electrolight071@gmail.com"
    git config --global user.name "Twilight4"


GHAPPS="/opt/github/essentials"
if [ ! -d "$GHAPPS" ];
  then
  git clone "https://github.com/shlomif/lynx-browser"
  git clone "https://github.com/chubin/cheat.sh"
  git clone "https://github.com/smallhadroncollider/taskell"
  git clone "https://github.com/christoomey/vim-tmux-navigator"
  git clone "https://github.com/Swordfish90/cool-retro-term"
fi

# powerlevel10k
[ ! -d "/opt/powerlevel10k" ] \
&& --depth=1 https://github.com/romkatv/powerlevel10k.git \
"/opt/powerlevel10k"

# XDG ninja
[ ! -d "/home/$(whoami)/xdg-ninja" ] \
&& git clone https://github.com/b3nj5m1n/xdg-ninja \
"/home/$(whoami)/xdg-ninja"

# tmux plugin manager
[ ! -d "$XDG_CONFIG_HOME/tmux/plugins/tpm" ] \
&& git clone --depth 1 https://github.com/tmux-plugins/tpm \
"$XDG_CONFIG_HOME/tmux/plugins/tpm"

# neovim plugin manager
[ ! -d "$XDG_CONFIG_HOME/.local/share/nvim/site/pack/packer/start/packer.nvim" ] \
&& git clone https://github.com/wbthomason/packer.nvim \
"$XDG_CONFIG_HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"
}

echo 'reminders for myself:
- add ssh pub key to github
'
