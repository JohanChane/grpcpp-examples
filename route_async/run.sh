#!/bin/sh

#set -e
#set -x

script_dir=$(dirname "$(readlink -f "$0")")
cd $script_dir

function kill_processes {
  local process_pattern="$1"

  if [ -z $process_pattern ]; then
    return
  fi
  
  server_pids=$(pgrep -f "$process_pattern")
  if [ -n "$server_pids" ]; then
    kill -9 $server_pids
  fi
}

# ## Run
# To ensure the server is not running.
srv_proc_pattern='\./build/server/server$'
kill_processes "$srv_proc_pattern"

echo "Run server..."
./build/server/server &
sleep 1s && echo "Run client..." && ./build/client/client

sleep 1s
kill_processes "$srv_proc_pattern"
pgrep -la -f "$srv_proc_pattern"
