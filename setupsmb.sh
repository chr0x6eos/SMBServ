#!/bin/bash

# Simple script to start a SMB-Server running in docker
# Date: 11/2020
# Author: Chr0x6eOs (https://github.com/chr0x6eos)
# Github-Link: https://github.com/chr0x6eos/SMBServ

####################
#     VARIABLES    #
####################
FILES="$(pwd)" # If no other files specified, use this folder
VERBOSE="FALSE" # Verbosity
START_SH="FALSE" # Start bash shell in docker-container


####################
#     FUNCTIONS    #
####################
function info { # Print info
  echo -e "
#####################
# Simple \e[93mSMB-Server\e[39m #
#    By \e[91mChr0x6eOs\e[39m   #
#####################

Github: https://github.com/chr0x6eos/SMBServ

About:
A simple SMB-server running in docker.
By default current directory will be served.
"
}

function usage { # Print usage
  echo -e "
Usage: $0 [arguments]

-h  ... Help:        Print this help message
-v  ... Verbose:     Print detailed status messages
-fl ... Files-list:  Specify a list of files (specified as a file) that should be served via SMB
-f  ... File:        Specify a single file to be served via SMB
-d  ... Directory:   Specify a single directory to be served via SMB
-sh ... Shell:       Launch a bash-shell in the docker-container, once it is setup
"
}

function log { # Log messages
  # Success and Errors will always be logged
  if [[ "$2" -eq -1 ]] # Error: Red color
   then
    echo -e "\e[91m[-]\e[39m $1"
    exit -1
  elif [[ "$2" -eq 1 ]] # Success: Green color
   then
     echo -e "\e[92m[+]\e[39m $1"
  fi

  if [[ "$VERBOSE" == "TRUE" ]] # Log if verbose is true
   then
     if [[ "$2" -eq 0 ]] # Ok: Blue color
      then
        echo -e "\e[34m[*]\e[39m $1"
      elif [[ "$2" -eq 2 ]] # Info: Yellow color
       then
         echo -e "\e[93m[~]\e[39m $1"
      fi
  fi
}

function log_if_error { # Logs an error if last execution failed
  if [[ "$?" -ne 0 ]]
   then
     if [[ -z "$1" ]]
      then
        log "Error occurred! Exiting..." -1
      else
        log "$1" -1 # Log with message
     fi
     exit -1 # Exit with errors
  fi
}


####################
#     MAIN-CODE    #
####################
info # Print info

# Validate input parameters
for (( i=0; i<="$#"; i++))
 do
   if [[ "${!i}" == "-h" ]] # Print help
    then
       usage
       exit 0
   elif [[ "${!i}" == "-v" ]] # Set verbosity
    then
        VERBOSE="TRUE"
        log "Verbosity set!" 0
   elif [[ "${!i}" == "-fl" ]] # Specify file-list to be served
    then
       next_arg=$(($i+1)) # Get argument after "-fl"
       if [[ ! -z "$next_arg" ]] && [[ -f "${!next_arg}" ]] # Check if next parameter is set and a file
        then
           log "Loading files from config-file: ${!next_arg}..." 0
           #echo `ls -d /usr/share/windows-binaries/*` >> "${!next_arg}" # Add /usr/share/windows-binaries/*
           FILES=$(cat "${!next_arg}") # Read config file and use all specified files
           log "Loaded following files to serve:\n$FILES" 1
        else
           log "No valid file for option -fl specified!" -1
       fi
   elif [[ "${!i}" == "-f" ]] # Specify file to be served
      then
        next_arg=$(($i+1)) # Get argument after "-f"
        if [[ ! -z "$next_arg" ]] && [[ -f "${!next_arg}" ]] # Check if next parameter is set and a file
         then
            log "The file ${!next_arg} will be served via SMB!" 1
            FILES="${!next_arg}" # Set file to be served via smb
         else
            log "No valid file for option -f specified!" -1
        fi
   elif [[ "${!i}" == "-d" ]] # Specify directory to be served
      then
         next_arg=$(($i+1)) # Get argument after "-d"
         if [[ ! -z "$next_arg" ]] && [[ -d "${!next_arg}" ]] # Check if next parameter is set and a file
          then
             log "The directory ${!next_arg} will be served via SMB!" 1
             FILES="${!next_arg}" # Set file to be served via smb
          else
             log "No valid directory for option -d specified!" -1
         fi
   elif [[ "${!i}" == "-sh" ]] # Start bash shell in container
    then
       START_SH="TRUE"
   fi
 done

# Check if docker is running
docker ps 1>/dev/null 2>/dev/null
if [[ "$?" -ne 0 ]]
 then
   log "Docker service currently not running! Starting now..." 2
   service docker start
   log_if_error "Could not start docker service!"
fi

# Check if a smb-container is already running
CONTAINER=$(docker ps -f ancestor=dperson/samba -q)
log_if_error "Could not verify if a container is already running!"

# If container is already running, stop the container
if [ ! -z "$CONTAINER" ]
 then
    log "A smb-server container (ID: $CONTAINER) is already running! Stopping this container now..." 2
    docker stop "$CONTAINER" 1>/dev/null # Stop if there is always an container running
    log_if_error "Could not stop container!"
    docker rm "$CONTAINER" 1>/dev/null # Kill the running container
    log_if_error "Could not kill container!"
fi

# Start smb-server container
docker run -it -p 139:139 -p 445:445 -d dperson/samba -p -s "share;/mnt/smb;yes;no;yes" 1>/dev/null
log_if_error "Could not start docker-container!"

# Get container ID
CONTAINER=$(docker ps -f ancestor=dperson/samba -q)
log_if_error "Could not verify if docker-container is running!"
log "Smb-server (ID: $CONTAINER) started!" 1

# Copy wanted files to container
for FILE in $FILES
 do
     log "Copying $FILE to $CONTAINER:/mnt/smb/ ..." 0
     docker cp -L "$FILE" "$CONTAINER":/mnt/smb/ 1>/dev/null # Copy files to /mnt/smb in the container
     log_if_error "Could not copy $FILE to container!"
 done

log "DONE! :) Container (ID: $CONTAINER) is now running and serving..." 1

# Check if a shell in the docker-container should be started
if [[ "$START_SH" == "TRUE" ]]
 then
    log "Launching bash-shell in docker-container..." 1
    echo ""
    docker exec -it "$CONTAINER" bash # Run bash in the docker container for testing
    log_if_error "Could not start bash-shell in docker-container!"
else
    # Get all local IPs and print smb-share-links
    IPs="$(ifconfig | grep 'inet ' | cut -d ' ' -f10)"
    echo "Your files are available at:"
    for IP in $IPs
     do
       echo "  \\\\$IP\\share\\" # Print smb-share-link
     done
 fi

exit 0 # Exit with no errors
