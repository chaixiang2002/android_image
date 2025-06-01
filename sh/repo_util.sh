#! /bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $SCRIPT_DIR/../util/uitl.sh

ROOT_DIR(){
    echo "$( cd "$SCRIPT_DIR/.." && pwd )" 
}