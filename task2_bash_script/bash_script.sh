!#/bin/bash

num_lines=5
state=''
whois_field=''
process='NULL'
help='NULL'


if [[ "$(whoami)" != root ]]; then
    echo "WARNING: you don't have root privileges."
fi


usage() {
  cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") [-h] [-v] [-n 5] [-s] [-f organization] process
This script shows WHOIS information of a specified program (process or PID) current connections.
Required option:
-p, --process       Specify process name or PID
Available options:
-h    Print help and exit
-n    Set number of output lines, 5 by default
-s    Choose connection state, all by default. Possible values: listen, established, time_wait, close_wait
-f    WHOIS field to fetch, organization by default. Possible values: organization, domain
Usage example:
$(basename "${BASH_SOURCE[0]}") firefox
$(basename "${BASH_SOURCE[0]}") -n 10 -s established -f organization firefox
EOF
  exit
}


while getopts l:s:p:f:h flag
do
    case "${flag}" in
        l) num_lines=${OPTARG};;
        s) state=${OPTARG};;
        p) process=${OPTARG};;
        f) whois_field=${OPTARG};;
        h) help=${OPTARG};;
    esac
done

if [[ help != "NULL" ]]; then
    usage
fi

if [[ $process == "NULL" ]]; then
    echo "ERROR: you must set process name or pid."
    exit 1
fi


get_ip_from_netstat() {
  ip_addresses="$(netstat -tunapl)"
  if [[ $ip_addresses =~ $state ]]; then
    ip_addresses=$(echo "$ip_addresses" | grep "$state" | awk '/'"$process"/' {print $5}')
    if [[ ! -z "$ip_addresses" ]]; then
      ip_addresses=$(echo "$ip_addresses" | cut -d: -f1 | sort | uniq -c | sort | tail -n"$num_lines" | grep -oP '(\d+\.){3}\d+')
      if [[ -z "$ip_addresses" ]]; then
        echo "Could not parse any IP addresses"
        exit 0
      fi
    else
      echo "Connections with process${process} not found"
      exit 0
    fi
  else
    echo "Connections with state ${state} not found"
    exit 0
  fi
  return 0
}


get_organization_by_ip() {
  for i in $ip_addresses
  do
    whois_output="whois ${i}"
    if [[ "$whois_field" | tr [A-Z] [a-z]=="organization" ]]; then
      whois_result="$(echo "$whois_result" | awk -F':' '/^Organization:|^org:|^Org:/ {print $2}' | tr -s ' ' | uniq)"
      if [[ -z "$result" ]]; then
        echo "$i - Organization not found"
      else
        echo "$i - $whois_result"
      fi

    elif [[ "$whois_field" | tr [A-Z] [a-z]=="domain" ]]; then
      whois_result="$(echo "$whois_result" | awk -F':' '/^Domain name:|^Domain Name:|^domain:/ {print $2}' | tr -s ' ' | uniq)"
      if [[ -z "$result" ]]; then
        echo "$i - Domain not found"
      else
        echo "$i - $whois_result"
      fi
    fi
  done
  return 0
}


get_ip_from_netstat
get_organization_by_ip