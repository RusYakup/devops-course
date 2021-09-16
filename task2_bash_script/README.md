

## Task description ##

Write a script that executes a one-line command:

``  sudo netstat -tunapl | awk '/firefox/ {print $5}' | cut -d: -f1 | sort | uniq -c | sort | tail -n5 | grep -oP '(\d+\.){3}\d+' | while read IP ; do whois $IP | awk -F':' '/^Organization/ {print $2}' ; done  ``

```
sudo
  netstat -tunapl |
    awk '/firefox/ {print $5}' |
      cut -d: -f1 |
        sort |
          uniq -c |
            sort |
              tail -n5 |
                grep -oP '(\d+\.){3}\d+' |
                  while read IP ;
                    do whois $IP |
                      awk -F':' '/^Organization/ {print $2}' ;
                  done
```                 
***

Download [bash_script.sh](./bash_script.sh)  script and run it. Specify process name or PID as the script argument.  Run this script as root .
## Requirements ##

- the script must accept PID or process name as argument
- the number of output lines must be adjusted by the user
- should be able to see other connection states (listening, established, wait)
- the script should display clear error messages
- the script should not depend on launch privileges, should display a warning



## Required option:
```  -p, --process       Specify process name or PID

  Available options:
  
 -h    Print help and exit
 -n    Set number of output lines, 5 by default
 -s    Choose connection state, all by default. Possible values: listen, established, time_wait, close_wait
 -f    WHOIS field to fetch, organization by default. Possible values: organization, domain
 
Usage example:

$(basename "${BASH_SOURCE[0]}") firefox
$(basename "${BASH_SOURCE[0]}") -n 10 -s established -f organization firefox 
