#!/bin/bash
export SCRIPT_DIR=$( cd "$( dirname "$0" )" && pwd )
source ${SCRIPT_DIR}/lib/minecraft_server_control.sh
source ${SCRIPT_DIR}/lib/discord_utils.sh

print_vote_reminder()
{
  tellraw_in_minecraft "" ""
  tellraw_in_minecraft "Do you like our server? Vote for us on these server lists!" "light_purple" ""
  tellraw_in_minecraft "https://www.minecartrapidtransit.net/server-voting-lists" "green" "" "https://www.minecartrapidtransit.net/server-voting-lists"
  tellraw_in_minecraft "" ""

  send_message_to_discord ":ballot_box: **Do you like our server? Vote for us on these server lists!** :ballot_box:" "Vote Reminder"
  send_message_to_discord ":ballot_box: **https://www.minecartrapidtransit.net/server-voting-lists** :ballot_box:" "Vote Reminder"
}

print_vote_reminder
