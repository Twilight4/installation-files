#!/usr/bin/env bash

run() {
    download-paclist
    download-yaylist
    install-yay
    install-apps
    create-directories
    install-dotfiles
    install-ghapps
}

download-paclist() {
    paclist_path="/tmp/paclist" 
    curl "https://raw.githubusercontent.com/Twilight4/arch-install/master/paclist" > "$paclist_path"

    echo $paclist_path
}

download-yaylist() {
    yaylist_path="/tmp/yaylist"
    curl "https://raw.githubusercontent.com/Twilight4/arch-install/master/yaylist" > "$yaylist_path"

    echo $yaylist_path
}

install-yay() {
    sudo pacman -Sy
    sudo pacman -S --noconfirm tar
    curl -O "https://aur.archlinux.org/cgit/aur.git/snapshot/yay.tar.gz" \
    && tar -xvf "yay.tar.gz" \
    && cd "yay" \
    && makepkg --noconfirm -si \
    && cd - \
    && rm -rf "yay" "yay.tar.gz" ;
}

install-apps() {
    sudo pacman -S --noconfirm $(cat /tmp/paclist)
    yay -S --noconfirm $(cat /tmp/yaylist)
        
    # Needed if system installed in VBox
    sudo systemctl enable vboxservice.service
    
    # zsh as default terminal for user
    sudo chsh -s "$(which zsh)" "twilight"
    
    # Needed if system installed in VMWare
    if [ "$(cat /tmp/paclist)" = "xf86-video-vmware" ]; then
        sudo systemctl enable vmtoolsd.service
        sudo systemctl enable vmware-vmblock-fuse.service
    fi
            
    ## For Docker
    #groupadd docker
    #gpasswd -a "$name" docker
    #sudo systemctl enable docker.service
}

create-directories() {
#sudo mkdir -p "/home/$(whoami)/{Document,Download,Video,workspace,Music}"
sudo mkdir -p "/opt/github/essentials"
sudo mkdir -p "/opt/wallpapers"
sudo mkdir -p "/usr/share/fonts/MesloLGM-NF"
sudo mkdir -p "/usr/share/fonts/rofi-fonts"
}

install-dotfiles() {
    DOTFILES="/tmp/dotfiles"
    if [ ! -d "$DOTFILES" ];
        then
            git clone --recurse-submodules "https://github.com/Twilight4/dotfiles" "$DOTFILES" >/dev/null
    fi
    
    sudo cp /tmp/dotfiles/.config/* /home/twilight/.config
    sudo echo 'export ZDOTDIR="$HOME"/.config/zsh' >> /etc/zsh/zshenv
    source "/home/twilight/.config/zsh/.zshenv"
    sudo rm -rf /usr/share/fonts/[71aceT]*
    sudo mv /tmp/dotfiles/fonts/MesloLGM-NF/* /usr/share/fonts/MesloLGM-NF/
    sudo mv /tmp/dotfiles/fonts/rofi-fonts/* /usr/share/fonts/rofi-fonts/
    sudo mv /tmp/dotfiles/wallpapers/* /opt/wallpapers
    sudo rm /home/twilight/.bash*
    sudo chmod 755 /home/twilight/.config/qtile/autostart.sh
    sudo chmod 755 /home/twilight/.config/polybar/launch.sh
    sudo chmod 755 /home/twilight/.config/polybar/polybar-scripts/*
    sudo chmod 755 /home/twilight/.config/rofi/applets/bin/*
    sudo chmod 755 /home/twilight/.config/rofi/applets/shared/theme.bash
    sudo chmod 755 /home/twilight/.config/rofi/launcher/launcher.sh
    sudo mv /home/twilight/.config/rofi/applets/bin/* /usr/bin/
    git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
    git config --global user.email "electrolight071@gmail.com"
    git config --global user.name "Twilight4"
}

install-ghapps() {
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
&& git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
"/opt/powerlevel10k"

# XDG ninja
[ ! -d "/home/$(whoami)/xdg-ninja" ] \
&& git clone https://github.com/b3nj5m1n/xdg-ninja \
"/home/twilight/xdg-ninja"

# tmux plugin manager
[ ! -d "$XDG_CONFIG_HOME/tmux/plugins/tpm" ] \
&& git clone --depth 1 https://github.com/tmux-plugins/tpm \
"/home/twilight/.config/tmux/plugins/tpm"

# neovim plugin manager
[ ! -d "$XDG_CONFIG_HOME/.local/share/nvim/site/pack/packer/start/packer.nvim" ] \
&& git clone https://github.com/wbthomason/packer.nvim \
"/home/twilight/.config/.local/share/nvim/site/pack/packer/start/packer.nvim"

echo 'reminders for myself:
- add ssh pub key to github
- once plugins gets installed for zsh type a command: mv /home/twilight/.config/zsh/zsh-completions.plugin.zsh home/twilight/.config/zsh/_zsh-completions.plugin.zsh
'

#reboot
}

run "$@"
