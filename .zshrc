# Allows for marking and jumping to directories deep in the filesystem.
# Taken from Jeroen Janssens's article "Quickly navigate your filesystem from the command-line"
# URL:        http://jeroenjanssens.com/2013/08/16/quickly-navigate-your-filesystem-from-the-command-line.html
# Discussion: https://news.ycombinator.com/item?id=6229001
export MARKPATH=$HOME/.marks
function jump {
    cd -P $MARKPATH/$1 2> /dev/null || echo "No such mark: $1"
}
function mark {
    mkdir -p $MARKPATH; ln -s $(pwd) $MARKPATH/$1
}
function unmark {
    rm -i $MARKPATH/$1
}
function marks {
    \ls -l $MARKPATH | tail -n +2 | sed 's/  / /g' | cut -d' ' -f9- | awk -F ' -> ' '{printf "%-10s -> %s\n", $1, $2}'
}
function _jump {
    local cur=${COMP_WORDS[COMP_CWORD]}
    local marks=$(find $MARKPATH -type l | awk -F '/' '{print $NF}')
    COMPREPLY=($(compgen -W '${marks[@]}' -- "$cur"))
    return 0
}
function _completemarks {
  reply=($(ls $MARKPATH))
}
compctl -K _completemarks jump
compctl -K _completemarks unmark


# Onport command
# This command will tell you the applications running on a specific port.
function onport() {
    sudo lsof -i :$1
}


# Set the title on the current window.
function title {
    echo -ne "\e]1;$1\a"
}
