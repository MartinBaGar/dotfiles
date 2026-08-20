# Replace ls with eza
alias ls='eza --group-directories-first --icons=auto'

alias ll='eza -l --git --icons=auto'
alias la='eza -la --git --icons=auto'
alias lt='eza --tree --level=2 --icons=auto'

alias left='ls -t -1'
alias count='find . -type f | wc -l'
alias cpv='rsync -ah --info=progress2'

# Common shortcuts
alias l='eza -lh --group-directories-first --git --icons=auto'
alias tree='eza --tree --icons=auto'

alias pymol='QT_QPA_PLATFORM=xcb pymol'
