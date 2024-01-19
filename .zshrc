# .zshrc based on grml zshrc and Arch Linux ZSH wiki page with additional options

# Command completion
autoload -Uz compinit
compinit

# and with arrow-key driven interface
zstyle ':completion:*' menu select

# and autocompletion of privileged environments (i.e. sudo)
zstyle ':completion::complete:*' gain-privileges 1

# Key bindings
# First, set emacs style command line edit
bindkey -e

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"

# setup key accordingly
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"       beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"        end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"     overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}"  backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"     delete-char
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"         up-line-or-history
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"       down-line-or-history
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"       backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"      forward-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"     beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"   end-of-buffer-or-history
[[ -n "${key[Shift-Tab]}" ]] && bindkey -- "${key[Shift-Tab]}"  reverse-menu-complete

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start { echoti smkx }
	function zle_application_mode_stop { echoti rmkx }
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

# History
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000

# History search
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

[[ -n "${key[Up]}"   ]] && bindkey -- "${key[Up]}"   up-line-or-beginning-search
[[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" down-line-or-beginning-search

# Shift, Alt, Ctrl and Meta modifiers
key[Control-Left]="${terminfo[kLFT5]}"
key[Control-Right]="${terminfo[kRIT5]}"

[[ -n "${key[Control-Left]}"  ]] && bindkey -- "${key[Control-Left]}"  backward-word
[[ -n "${key[Control-Right]}" ]] && bindkey -- "${key[Control-Right]}" forward-word

# Prompt & termial title
# Update terminal title if current working dir changed
chpwd() {
  [[ -t 1 ]] || return
  case $TERM in
  xterm*)
    print -Pn "\033]0;%n@%m:%2~\007"
    ;;
  screen*)
    print -Pn "\033k%n@%m:%2~\033\\"
    ;;
  esac
}

# Stolen from grml zshrc
PROMPT="%B%F{red}%(?..%? )%f%b%B%F{blue}%n%f%b@%m %B%40<..<%2~%<< %b%# "

# Remembering recent directories
# Dirstack
autoload -Uz add-zsh-hook

DIRSTACKFILE="$HOME/.zdirs"
if [[ -f "$DIRSTACKFILE" ]] && (( ${#dirstack} == 0 )); then
	dirstack=("${(@f)"$(< "$DIRSTACKFILE")"}")
	[[ -d "${dirstack[1]}" ]] && cd -- "${dirstack[1]}"
fi
chpwd_dirstack() {
	print -l -- "$PWD" "${(u)dirstack[@]}" > "$DIRSTACKFILE"
}
add-zsh-hook -Uz chpwd chpwd_dirstack

DIRSTACKSIZE='20'

setopt AUTO_PUSHD PUSHD_SILENT PUSHD_TO_HOME

## Remove duplicate entries
setopt PUSHD_IGNORE_DUPS

## This reverts the +/- operators.
setopt PUSHD_MINUS

# Help command
autoload -Uz run-help
(( ${+aliases[run-help]} )) && unalias run-help
alias help=run-help

autoload -Uz run-help-git run-help-ip run-help-openssl run-help-p4 run-help-sudo run-help-svk run-help-svn

# Persistent rehash
zstyle ':completion:*' rehash true

# /dev/tcp equivalent: ztcp
zmodload zsh/net/tcp

# Custom settings and aliasses
export GPG_TTY=$(tty)
export LIBVIRT_DEFAULT_URI="qemu:///system"
alias -g '...'='../..'
alias -g '....'='../../..'
alias -g G=" | grep"
alias -g L=" | less"
alias -g C=' | wc -l'
alias -g H=' | head'
alias -g T=' | tail'
alias -g N=' &> /dev/null'
alias -g SL=' | sort | less'
alias -g S=' | sort'
alias -g SU=' | sort -u'
alias vmm="$HOME/dev/vmm/vmm"
