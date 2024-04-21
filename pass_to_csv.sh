#!/bin/bash

PASSWORD_STORE_DIR=${PASSWORD_STORE_DIR:-"$HOME/.password-store"}
PASSWORD_FILE="${PASSWORD_FILE:-"passwords.csv"}"

echo_if_not_empty(){
			if [[ "${1}" == "" ]]
			then
				echo "\"\""
			else
				echo "${1}"
			fi
}

main(){
	rm -f "${PASSWORD_FILE}"

	find "$PASSWORD_STORE_DIR" | grep -e "\.gpg$" | sed "s/\.gpg$//g" | sed "s#${PASSWORD_STORE_DIR}/##g" | while read -r entry
	do
		{
			entry_content=$(pass show "${entry}")
			# Title
			echo "${entry}" | sed 's/^/"/g' | sed 's/$/"/g';
			username=$(echo "${entry_content}" | grep "login: " | sed 's/login: //g'| sed 's/^/"/g' | sed 's/$/"/g';)
			echo_if_not_empty "$username"
			# Password
			echo "${entry_content}" | head -n1 |  sed 's/\\/\\\\/g' | sed 's/"/\\"/g' | sed 's/^/"/g' | sed 's/$/"/g';
			notes=$(echo "${entry_content}" | tail -n +2 | grep -v 'url:' | grep -v 'totp' | grep -v 'login:' | paste -d' ' -s | sed 's/^/"/g' | sed 's/$/"/g';)
			echo_if_not_empty "$notes"
			url=$(echo "${entry_content}" | grep "url: " | sed 's/url: //g'| sed 's/^/"/g' | sed 's/$/"/g';)
			echo_if_not_empty "$url"
			totp=$(echo "${entry_content}" | grep 'totp'| sed 's/^/"/g' | sed 's/$/"/g';)
			echo_if_not_empty "$totp"
		} | paste -d',' -s >> "${PASSWORD_FILE}"
	done
}

main

echo "\" and \\ in passwords are escaped with a backslash."
