# Custom stuff
source `brew --prefix git`/etc/bash_completion.d/git-completion.bash
export PGDATA=/usr/local/var/postgres
export PATH=$PATH:/usr/local/Cellar/python/2.7.1/bin:/usr/local/sbin
export NODE_PATH=/usr/local/lib/node

# Aliases

# Quick scp alias to my webhost
s () { scp $* billy@misfacio.com:/home/billy/sites/misfacio.com/$* ; }

# Colors
NONE="\[\033[0m\]"    # unsets color to term fg color
# regular colors
K="\[\033[0;30m\]"    # black
R="\[\033[0;31m\]"    # red
G="\[\033[0;32m\]"    # green
Y="\[\033[0;33m\]"    # yellow
B="\[\033[0;34m\]"    # blue
M="\[\033[0;35m\]"    # magenta
C="\[\033[0;36m\]"    # cyan
W="\[\033[0;37m\]"    # white

# emphasized (bolded) colors
EMK="\[\033[1;30m\]"
EMR="\[\033[1;31m\]"
EMG="\[\033[1;32m\]"
EMY="\[\033[1;33m\]"
EMB="\[\033[1;34m\]"
EMM="\[\033[1;35m\]"
EMC="\[\033[1;36m\]"
EMW="\[\033[1;37m\]"

# background colors
BGK="\[\033[40m\]"
BGR="\[\033[41m\]"
BGG="\[\033[42m\]"
BGY="\[\033[43m\]"
BGB="\[\033[44m\]"
BGM="\[\033[45m\]"
BGC="\[\033[46m\]"
BGW="\[\033[47m\]"

# prompt to display the current + parent directories
twolevelprompt='$([ "$PWD" != "${PWD%/*/*/*}" ] && echo "...${PWD##${PWD%/*/*}}" || echo "$PWD")'

# display the current virutal env
prompt_venv() {
    unset VIRTUAL_ENV_BASE
    local venv=`basename "$VIRTUAL_ENV"`

    if test $venv
    then
        VIRTUAL_ENV_BASE=" ${EMM}env:${C}$venv"
    fi
}

# display VCS info, requires vcprompt
prompt_vcs_info() {
    unset VCS_INFO
    if [ `vcprompt` ]
    then
        local vcs=`vcprompt -f "%n"`
        local branch=`vcprompt -f "%b"`
        local rev=`vcprompt -f "%r"`
        local uncommited=`vcprompt -f "%m"`

        VCS_INFO=" ${EMM}$vcs:${C}$rev ${EMM}branch:${C}$branch${EMR}$uncommited"
    fi
}

update_prompt() {
    if vcprompt &>/dev/null
    then 
        prompt_vcs_info
        prompt_venv
        PS1="\n${EMW}[${W}\u${EMW}@${W}\h ${EMM}pwd:${C}${twolevelprompt}${VIRTUAL_ENV_BASE}${VCS_INFO}${EMW}] \n${EMR}\$ ${W}"
    else
        PS1="\n${EMW}[${W}\u${EMW}@${W}\h ${EMM}pwd:${C}${twolevelprompt}${VIRTUAL_ENV_BASE}${EMW}] \n${EMR}\$ ${W}"
    fi

}
PROMPT_COMMAND=update_prompt
