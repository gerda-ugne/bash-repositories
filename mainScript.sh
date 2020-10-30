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
			echo "[$(date +%d)/$(date +%m)/$(date +%Y) @ $(date +%T)] Repository created: $newrep" >> logfile.txt
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

		read -p "Enter your option: " accessOption

		case $accessOption in
		
		1 ) echo "Add files to the repository"
		
			newfile=null
			read -p "Name the file you wish to add: " newfile
			if [ -f $newfile ]; then
				echo -e "There is already a file in the repository named $newfile\n"
			else
				touch $newfile
				echo "[$(date +%d)/$(date +%m)/$(date +%Y) @ $(date +%T)] File added to repository: $newfile" >> logfile.txt
				echo "You have successfully created a file named $newfile"
			fi
      
		;;
		2 ) echo "Check out a file"
			filename=null
			read -p "Enter the name of the file you wish to check out:   " filename
			if [ -f $filename ]
			then
				{
				echo -e "File found! Navigating.\n"
				echo "[$(date +%d)/$(date +%m)/$(date +%Y) @ $(date +%T)] File checked out: $filename" >> logfile.txt 
	       
				touch $filename.copy
				touch uncommited.log
				
				cp $filename $filename.copy
				cp logfile.txt uncommittedlog.txt
				
				checkOption=null
				
				until [ checkOption -eq 0 ]; do
				
				case $checkOption in

		                	1 ) echo "1. Open"
					more $filename.copy
					echo "[$(date +%d)/$(date +%m)/$(date +%Y) @ $($) @ $(date +%T)] File opened out: $filename" >> uncommittedlog.txt

               			 	;;
				 
               			 	2 ) echo "2. Edit"
					nano  $filename.copy

					if cmp --silent --"$filename" "$filename.copy"; then
					echo "[$(date + %d)/$(date + %m)/%(date + %Y) @ $($) @ $(date + %T)] File edited: $filename" >> uncommittedlog.txt
                			fi
					;;


               				3 ) echo -e "3. Check in\n"
					echo diff $filename $filename.copy
					
					confirmation=NULL
					until [ $confirmation = YES || $confirmation = NO ]; do
					
					echo -e "Do you want to commit the changes (y\n)?\n"
					case $confirmation in
					
						y ) cp $copyoffile $filename
							cp uncommitedlog.txt logfile.txt
							
							echo "Changes committed."
							
						;;
						n ) echo "Changes unconfirmed." 
						;;
						* ) echo "Incorrect input"
					esac
					done
					;;

					0 ) echo "Returning."
				
					if cmp --silent --"$filename" "$filename.copy"; then {
				
					confirmation = NULL
					until[ $confirmation = YES || $confirmation = NO]; do
					
					echo "You have unsaved changes. They will be discarded if you leave. Are you sure you want to leave?(y/n) "
					
					case $confirmation in
					y )	echo "Confirmed - leaving unsaved.
					;;
					n )	continue
					;;
					*)	echo "Invalid input."
					
					esac
					done
					}
					
					fi
		       			;;
					
				
					* ) echo "Incorrect input"
				
				esac
				done
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

		echo "[$(date +%d)/$(date +%m)/$(date +%Y) @ $(date +%T)] Version rolled back." >> logfile.txt
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
