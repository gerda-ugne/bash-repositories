#!/bin/bash

option=-1

echo "Welcome to the CVS!"

until [ "$option" -eq 0 ]; do

echo -e "\n1. Create a new repository"
echo "2. Access a repository"
echo "3. Option 3"
echo "4. Option 4"
echo -e  "0. Exit\n"

read -p "Choose an option: " option


case $option in
	1 ) echo -e "1. Creating a new repository...\n"
		newrep=null

		while [ 1 ]
		do

		read -p "Enter a new name for your repository: " newrep
		if [ -d "$newrep" ]; then

		echo -e "There is already a repository with the given name. Please try again. \n"
		else 
			mkdir $newrep
			cd $newrep; touch logfile.txt; 
			echo "Repository created: $(date)" >> logfile.txt
			cd ..
			echo "You have successfully created a repository named $newrep"
			break

		fi
		done
	    ;;
	2 ) echo "2.Accessing a repository..."

		repname=null
		read -p "Enter the name of the repository you wish to access...:   " repname
		if [ -d $repname ]; then
		echo -e "Repository found! Navigating.\n"
		cd $repname

		ls -l

		accessOption=-1

		until [ "$accessOption" -eq 0 ]; do
		echo -e "\nChoose one of the options: \n"
		echo "1. Add files to the repository"
		echo "2. Check out a file"
		echo "3. View the files in the repository"
		echo "4. View the log file"
		echo "5. Compile the project using its source code"
		echo "6. Rollback to a previous version"
		echo "7. Archive management"
		echo "0. Return"

		read -p "Enter your option:" accessOption

		case $accessOption in
		
		1 ) echo "Add files to the repository"


		echo "File added to repository: $(date)" >> logfile.txt #needs to add the name of the file 
		;;
		2 ) echo "Check out a file"
			filename=null
			read -p "Enter the name of the file you wish to check out:   " filename
			if [ -f $filename ]
			then
				{
				echo -e "File found! Navigating.\n"
				nano $filename
				echo "File checked out: $filename $(date)" >> logfile.txt 
				}
			else echo "File not found"
			fi
		;;
		3 ) echo -e  "Showing the contents..\n"
			ls -l
			echo -e "\n"
		;;
		4 ) echo "View the log file"
			echo
			cat logfile.txt
		;;
		5 ) echo "Compile the project using its source code"

		;;
		6 ) echo "Rollback to a previous version"

		echo "Version rolled back: $(date)" >> logfile.txt
		;;
		7 ) echo "Archive management"
		;;
		0 ) echo "Return"
		;;
		* ) echo "Invalid input. Please try again."

		esac
		
		done

		else echo "Repository not found. Please try again"

		fi
	    ;;
	3 ) echo "3"
	    ;;
	4 ) echo "4"
	    ;;
	0 ) echo "Thank you for using the system! Exiting now."
	    ;;

	* ) echo -e "Invalid choice. Please enter a valid number. \n"
esac
done
