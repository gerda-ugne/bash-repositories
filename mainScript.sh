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
	1 ) echo "1. Creating a new repository..."
		newrep=null

		while [ 1 ]
		do

		read -p "Enter a new name for your repository: " newrep
		if [ -d "$newrep" ]; then

		echo "There is already a repository with the given name. Please try again."
		else 
			mkdir $newrep
			echo "You have successfully created a repository named $newrep"
			break

		fi
		done
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
