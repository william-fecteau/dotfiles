#/bin/sh

echo "==============================================Performing updates=============================================="
sudo apt-get update -y && sudo apt-get upgrade -y

echo "==============================================Installing packages============================================="
xargs -a packages.txt sudo apt-get install -y

echo "==============================================Stowing dotfiles============================================="
stow zshrc vimrc tmux fonts

echo "==============================================Installing tmux============================================="
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
	echo "Cloning tpm"
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
	echo "TPM already cloned"
fi
. ~/.tmux/plugins/tpm/bin/install_plugins

echo "==============================================Installing oh-my-zsh============================================="
if [ ! -d "$HOME/.oh-my-zsh" ]; then
	echo "Cloning oh-my-zsh with plugins"
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
	rm $HOME/.zshrc
	mv $HOME/.zshrc.pre-oh-my-zsh $HOME/.zshrc

	# Plugins
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions	
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
	git clone https://github.com/agkozak/zsh-z ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-z
else
	echo "oh-my-zsh already cloned, assuming its properly installed"
fi

echo "==============================================Updating fonts============================================="
fc-cache -f -v

echo "==============================================Installing Alacritty============================================="
if command -v alacritty &> /dev/null; then
	echo "Alacritty already installed"
else
	echo "Installing rust and Alacritty"
	curl https://sh.rustup.rs -sSf | sh -s -- -y
	source ~/.bashrc
	cargo install alacritty

	# Setting alacritty as default shell: https://gist.github.com/aanari/08ca93d84e57faad275c7f74a23975e6?permalink_comment_id=3822304
	sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator $(which alacritty) 50
	sudo update-alternatives --config x-terminal-emulator
fi

echo "==============================================Installing pyenv============================================="
if [ ! -d "$HOME/.pyenv" ]; then
	echo "Cloning pyenv and pyenv-virtualenv"
	curl -fsSL https://pyenv.run | bash
	git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv
else
	echo "Pyenv already installed"
fi


echo "==============================================Installing lazygit============================================="
if command -v lazygit &> /dev/null; then
	echo "Lazygit is already installed"
else
	LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
	curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
	tar xf lazygit.tar.gz lazygit
	sudo install lazygit -D -t /usr/local/bin/
	rm lazygit*
fi

echo "Now restart change your default shell to zsh and restart your computer!"
