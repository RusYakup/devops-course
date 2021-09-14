!#/bin/bash

num_lines=5
state=''
whois_field=''
process=''


if [[ "$(whoami)" != root ]]; then
    echo "WARNING: you don't have root privileges."
fi



while getopts num_lines:state:process:field flag
do
    case "${flag}" in
        num_lines) num_lines=${OPTARG};;
        state) state=${OPTARG};;
        process) process=${OPTARG};;
        field) whois_field=${OPTARG}
    esac
done

if [[ $process == "" ]]; then
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



get_ip_from_netstat()
get_organization_by_ip()
