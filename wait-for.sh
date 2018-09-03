#!/usr/bin/env bash
# Use this pure bash script to test if a given file is ready for exact options

cmdname=$(basename $0)

echoerr() {if [[$QUIET -ne 1]]; then echo }


usage()
{
    cat << USAGE >&2
Usage:
    $cmdname [-x] [-r] [-w] [-d] [-u] [-t timeout] [-f filename]

    -x | --execute          Wait for the path to become executable
    -r | --read             Wait for the path to become readable
    -w | --write            Wait for the path to become writable
    -d | --directory        Wait for the path to become a directory
    -u | --user             The user to run access checks for (NOT the user ID)
    -t TIMEOUT | --timeout = TIMEOUT
                            Timeout in seconds
    -f FILENAME | --filename = FILENAME        
                            The file name to be waited
USAGE 
    exit 1
}

wait_for()
{
    if [[ $TIMEOUT -gt 0 ]]; then
        echoerr "$cmdname: Waiting $TIMEOUT seconds for $FILENAME"
    else
        echoerr "$cmdname: Waiting for $FILENAME without timeout"
    fi

    start_ts = $(date+%s)
    while :
    do
        if [[-e FILENAME]]; then
            result = 0
            end_ts = $(date+%s)
            echoerr "$cmdname : $FILENMAE is ready after $((start_ts - end_ts)) seconds"
            break;
        fi
        sleep 1
    done
    return $result
}

is_satisfactory()
{
    
}

wait_for_wrapper()
{
    # In order to support SIGINT during timeout: http://unix.stackexchange.com/a/57692
    if [[ $QUIET -eq 1 ]]; then
        timeout $BUSYTIMEFLAG $TIMEOUT $0 --quiet --child --host=$HOST --port=$PORT --timeout=$TIMEOUT &
    else
        timeout $BUSYTIMEFLAG $TIMEOUT $0 --child --host=$HOST --port=$PORT --timeout=$TIMEOUT &
    fi
    PID=$!
    trap "kill -INT -$PID" INT
    wait $PID
    RESULT=$?
    if [[ $RESULT -ne 0 ]]; then
        echoerr "$cmdname: timeout occurred after waiting $TIMEOUT seconds for $HOST:$PORT"
    fi
    return $RESULT
}

while [[ $# -gt 0]]
do
    case "$1" in 
    -x)
    EXECUTE = 1
    shift 1
    ;;
    -r)
    READ = 1
    shift 1
    ;;
    -r)
    WRITE = 1
    shift 1
    ;;
    esac
done

# check to see if timeout is from busybox?
TIMEOUT_PATH=$(realpath $(which timeout))
if [[ $TIMEOUT_PATH =~ "busybox" ]]; then
        ISBUSY=1
        BUSYTIMEFLAG="-t"
else
        ISBUSY=0
        BUSYTIMEFLAG=""
fi

if [["$FILENAME" == ""]]; then
    echoerr "ERROR: you have to provide the file name."
    usage
fi


wait_for
RESULT=$?
exit $RESULT


