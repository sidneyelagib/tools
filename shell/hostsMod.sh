#!/bin/sh
# This script is to add or remove entries in and from the hosts file.

# PATH TO YOUR HOSTS FILE
ETC_HOSTS=/etc/hosts

# Hostname to add/remove.
HOSTLINE="$2 $3"

# Functions
removeline() {
  if [ -n "$(grep -E "^$HOSTLINE$" $ETC_HOSTS)" ]; then
    echo "$HOSTLINE Found in your $ETC_HOSTS, Removing now...";
    sudo sed -i '' "/^$HOSTLINE/d" $ETC_HOSTS
  else
    echo "$HOSTLINE was not found in your $ETC_HOSTS"
  fi
}

addline() {
  if [ -n "$(grep -E "^$HOSTLINE$" $ETC_HOSTS)" ]; then
    echo "$HOSTLINE Found in your $ETC_HOSTS";
  else
    echo "$HOSTLINE was not found in your $ETC_HOSTS, Adding now...";
    sudo -- sh -c -e "echo '$HOSTLINE' >> /etc/hosts";

    if [ -n "$(grep -E "^$HOSTLINE$" $ETC_HOSTS)" ]; then
      echo "$HOSTLINE was added successfully";
    else
      echo "Failed to Add $HOSTLINE, Try again!"
    fi

  fi
}

# Menu
case "$1" in
  add)
        addline
        ;;
  remove)
        removeline
        ;;

  *)
        echo "Usage: hostsMod COMMAND [args..]"
        echo
        echo "Utility for adding or removing entries in hosts file"
        echo
        echo "Commands:"
        echo "  add     hostsMod add [ip] [hostname]"
        echo "  remove  hostsMod remove [ip][hostname]"
        echo
        echo "Examples:"
        echo "  hostsMod add 127.0.0.1 localhost"
        echo "  hostsMod remove 127.0.0.1 localhost"
        exit 1
        ;;
esac

exit 0