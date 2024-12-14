c() {
    if [[ -n $1 ]]; then
        dir=~/Code/$1
    else
        dir=$(find ~/Code -maxdepth 1 -mindepth 1 -type d | fzf)
    fi
    tmux new-session -A -c $dir -s $(basename $dir)
}
