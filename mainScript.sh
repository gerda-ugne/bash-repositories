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
			cd $newrep; touch logfile.txt; mkdir .backup-files;
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
				mkdir .backup-files/"$newfile-copies"
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
				touch uncommittedlog.txt
				
				cp $filename $filename.copy
				cp logfile.txt uncommittedlog.txt
				
				checkOption=-1
				until [ "$checkOption" -eq 0 ]; do
				
				echo
				echo "1. Open the file"
				echo "2. Edit the file"
				echo "3. Check-in"
				echo "0. Return"
				echo
				
				read -p "Choose an option: " checkOption
				
				case $checkOption in

		                	1 ) echo "1. Open"
					more $filename.copy
					echo "[$(date +%d)/$(date +%m)/$(date +%Y) @ $(date +%T)] File opened out: $filename" >> uncommittedlog.txt

               			 	;;
				 
               			 	2 ) echo "2. Edit"
					nano  $filename.copy

					if cmp --silent --"$filename" "$filename.copy"; then
					echo "[$(date +%d)/$(date +%m)/$(date +%Y) @ $(date +%T)] File edited: $filename" >> uncommittedlog.txt
                			fi
					;;


               				3 ) echo -e "3. Check in\n"
					diff $filename $filename.copy

					confirmation=NULL

					until [[ "$confirmation" == "y" || "$confirmation" == "n" ]]; do
						read -p "Do you want to commit the changes (y\n?)" confirmation
						case $confirmation in
							y ) echo "[$(date +%d)/$(date +%m)/$(date +%Y) @ $(date +%T)] File checked in: $filename" >> uncommittedlog.txt
								cp $filename .backup-files/"$filename-copies"/"$filename-$(date +%T)"
								cp $filename.copy $filename
								cp uncommittedlog.txt logfile.txt

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
				
					confirmation = null
					until [ $confirmation = y || $confirmation = n ]; do
					
					read -p "Do you want to commit the changes (y\n?)" confirmation
					case $confirmation in
					y )	echo "Confirmed - leaving unsaved."
					;;
					n )	continue
					;;
					*)	echo "Invalid input."
					esac
					done
					}
					
					fi
					rm $filename.copy
					rm uncommittedlog.txt
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
		

			filename=null
			read -p "Enter the name of the file you wish to rollback:   " filename
			if [ -f $filename ]
			then
				{
					cd .backup-files/"$filename-copies"
					option=-1
					until [ "$option" -eq 0 ]; do
					{
						ls -l
						echo "1. See differences between files"
						echo "2. Choose version to rollback"
						echo "0. Exit"

						read -p "Choose an option: " option
						case $option in
						1 )	diffFileName=null
							read -p "Enter the name of file to compare:   " diffFileName
							if [ -f $diffFileName ] 
							then
								{
									diff ../../"$filename" $diffFileName
								}
							else 
								echo "File not found."
							fi
						;;
						2 )	versionName=null
							read -p "Enter the version file name:   " versionName
							if [ -f $versionName ] 
							then
								{
									cp $versionName ../../"$filename"
									echo "[$(date +%d)/$(date +%m)/$(date +%Y) @ $(date +%T)] File version rolled back: $filename" >> ../../logfile.txt
									echo "Version successfully rolled back!"
								}
							else 
								echo "File not found."
							fi
						;;
						0 )	continue
						;;
						*)	echo "Invalid input."
						esac
					}
					done

					cd ..
					cd ..
				}
			else
				{
					echo "File not found."
				}
			fi
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
