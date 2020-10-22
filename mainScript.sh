#!/bin/bash

option=0

echo "Welcome to the CVS!"

until [ "$option" -eq 5 ]; do

echo "1. Option 1"
echo "2. Option 2"
echo "3. Option 3"
echo "4. Option 4"
echo "5. Exit"

read -p "Choose an option: " option


case $option in
	1 ) echo "1"
	    ;;
	2 ) echo "2"
	    ;;
	3 ) echo "3"
	    ;;
	4 ) echo "4"
	    ;;
	5 ) echo "Thank you for using the system! Exiting now."
	    ;;

	* ) echo "Invalid choice. Please enter a number between 1 and 4."
esac
done
