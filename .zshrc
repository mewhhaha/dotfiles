export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH="$(yarn global bin):$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH" 
export ZSH="/home/pato/.oh-my-zsh"

ZSH_THEME="robbyrussell"
ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )


export NVM_LAZY_LOAD=true
export NVM_AUTO_USE=true

plugins=(git zoxide zsh-nvm)


source $ZSH/oh-my-zsh.sh

alias vim="nvim"
alias vi="nvim"

export DOCKER_BUILDKIT=1

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/pato/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/home/pato/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/pato/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/pato/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

# uninstall by removing these lines
[[ -f ~/.config/tabtab/__tabtab.zsh ]] && . ~/.config/tabtab/__tabtab.zsh || true


# Helper functions
function preq () {
	BRANCH=$(git branch | grep \* | cut -d ' ' -f2)
	REPO=$(basename `git rev-parse --show-toplevel`)
	xdg-open "https://dev.azure.com/skfdc/REP-SW/_git/${REPO}/pullrequestcreate?sourceRef=${BRANCH}&targetRef=master"
}

function mm () {
	git pull && git merge origin/master
}

function master () {
	git checkout master && git pull
}

function bb () {
	git checkout @{-1} 
}
