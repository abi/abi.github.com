##!/bin/bash

quit ()
{
    echo QUIT
    for i in 0 1
    do
        echo Killing ${proc_names[i]}
        kill -9 ${proc_pids[i]}
    done
    exit 0
}

trap "quit" SIGINT SIGTERM SIGKILL


proc_names=( jekyll compass )
proc_cmds=( 'jekyll --server --auto' 'compass watch -c tools/config.rb .')
              
for i in 0 1
do
    echo Starting ${proc_cmds[i]}
    echo ${proc_cmds[i]}
    
    if [ $i -eq 1 ]
    then
        ${proc_cmds[i]}
    else
        echo $i
        ${proc_cmds[i]} &
    fi
    
    proc_pids[i]=$!
done

# The right way to do this is to keep this process alive, just doing nothing so it can receive signals

echo ${proc_pids[*]}