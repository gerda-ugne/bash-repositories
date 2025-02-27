#!/bin/bash

option=-1

echo "Welcome to the VCS!"

until [ "$option" -eq 0 ] 2>/dev/null ; do

echo -e "\n1. Create a new repository"
echo "2. Access a repository"
echo "3. Display the repositories"
echo -e  "0. Exit\n"

read -r -p "Choose an option: " option


case $option in
	1 ) echo -e "1. Creating a new repository...\n"
		newrep=null

		while true
		do

		read -r -p "Enter a new name for your repository: " newrep
		if [ -d "$newrep" ]; then

		echo -e "There is already a repository with the given name. Please try again. \n"
		else 
			mkdir "$newrep"
			
			
			chmod +t "$newrep"
			sudo chgrp bash "$newrep"
			sudo chmod u=rwx,g=rwx,o-rwx "$newrep"
			
			cd "$newrep" || return; touch logfile.txt; mkdir .backup-files; mkdir .archived;
			
			echo "[$(date +%d)/$(date +%m)/$(date +%Y) @ $(date +%T)] Repository created: $newrep" >> logfile.txt
			cd .. 
			echo "You have successfully created a repository named $newrep"
			break

		fi
		done
	    ;;
	2 ) echo "2.Accessing a repository..."

		repname=null
		read -r -p "Enter the name of the repository you wish to access...:   " repname
		if [ -d "$repname" ]; then
		echo -e "Repository found! Navigating.\n"
		cd "$repname" || return

		ls -l

		accessOption=-1

		until [ "$accessOption" -eq 0 ] 2>/dev/null; do
		echo -e "\nChoose one of the options: \n"
		echo "1. Add files to the repository"
		echo "2. Check out a file"
		echo "3. View the files in the repository"
		echo "4. View the log file"
		echo "5. Compile the project using its source code"
		echo "6. Rollback to a previous version"
		echo "7. Archive management"
		echo "0. Return"

		read -r -p "Enter your option: " accessOption
		case $accessOption in
		
		1 ) echo "Add files to the repository"
		
			newfile=null
			read -r -p "Name the file you wish to add: " newfile
			if [ -f "$newfile" ]; then
				echo -e "There is already a file in the repository named $newfile\n"
			else
				touch "$newfile"
				mkdir .backup-files/"$newfile-copies"
				
				echo "[$(date +%d)/$(date +%m)/$(date +%Y) @ $(date +%T)] File added to repository: $newfile" >> logfile.txt
				echo "You have successfully created a file named $newfile"
			fi
      
		;;
		2 ) echo "Check out a file"
			filename=null
			read -r -p "Enter the name of the file you wish to check out:   " filename
			if [ -f "$filename" ]
			then
				{
				echo -e "File found! Navigating.\n"
				echo "[$(date +%d)/$(date +%m)/$(date +%Y) @ $(date +%T)] File checked out: $filename" >> logfile.txt 
	       
				touch "$filename.copy"
				touch uncommittedlog.txt
				
				cp "$filename" "$filename.copy"
				cp logfile.txt uncommittedlog.txt
				
				checkOption=-1
				until [ "$checkOption" -eq 0 ] 2>/dev/null ; do
				
				echo
				echo "1. Open the file"
				echo "2. Edit the file"
				echo "3. Check-in"
				echo "0. Return"
				echo
				
				read -r -p "Choose an option: " checkOption
				
				case $checkOption in

		                	1 ) echo -e "Opening the file...\n"
					
					if [ -s "$filename.copy" ]; then
					
					less "$filename.copy"
					echo "[$(date +%d)/$(date +%m)/$(date +%Y) @ $(date +%T)] File opened: $filename" >> uncommittedlog.txt
					
					
					else
					echo "Nothing to show. The file is empty."
					
					fi
               			 	;;
				 
               			 	2 ) echo -e "Opening external editor... \n"
					nano  "$filename.copy"


					if diff -s "$filename" "$filename.copy" &>/dev/null ; then
						true
					else
						echo "Changes recorded succesfully."
						echo "[$(date +%d)/$(date +%m)/$(date +%Y) @ $(date +%T)] File edited: $filename" >> uncommittedlog.txt
                			fi
					;;


               				3 ) echo -e "Checking in...\n"
					
					echo -e "Commiting changes:\n"

					confirmation=NULL

					until [ "$confirmation" == "y" ] || [ "$confirmation" == "n" ]; do
						read -r -p "Do you want to commit the changes (y\n?)" confirmation
						case $confirmation in
							y ) 
								choice=NULL
								until [ "$choice" == "y" ] || [ "$choice" == "n" ]; do
									comment=""
									read -r -p "Do you want to leave a comment (y\n?)" choice
									case $choice in
										y ) 
											read -r -p "Write a comment: " comment
											echo -e "[$(date +%d)/$(date +%m)/$(date +%Y) @ $(date +%T)] File checked in: $filename\n User comment: $comment" >> uncommittedlog.txt
										;;
										n ) echo "Comment left blank"
											echo -e "[$(date +%d)/$(date +%m)/$(date +%Y) @ $(date +%T)] File checked in: $filename" >> uncommittedlog.txt
										;;
										* ) echo "Incorrect input"
									esac
								done
								cp "$filename" .backup-files/"$filename-copies/$filename-$(date +%T)"
								cp "$filename.copy" "$filename"
								cp "uncommittedlog.txt" "logfile.txt"

								echo "Changes committed."
							;;
							n ) echo "Changes unconfirmed." 
							;;
							* ) echo "Incorrect input"
						esac
					done
					;;

					0 ) echo "Returning."
					
					diff -s "$filename" "$filename.copy" &>/dev/null

					if [ $? -eq 1 ]; then {
				
					confirmation=null
					until [ $confirmation = y ] || [ $confirmation = n ]; do
					
						read -r -p "Do you want to commit the changes (y\n?)" confirmation
						case $confirmation in
							y )	echo "Confirmed - saving file"
								choice=NULL
								until [ "$choice" == "y" ] || [ "$choice" == "n" ]; do
									comment=""
									read -r -p "Do you want to leave a comment (y\n?)" choice
									case $choice in
										y ) 
											read -r -p "Write a comment: " comment
											echo -e "[$(date +%d)/$(date +%m)/$(date +%Y) @ $(date +%T)] File checked in: $filename\n User comment: $comment" >> uncommittedlog.txt
										;;
										n ) echo "Comment left blank"
											echo -e "[$(date +%d)/$(date +%m)/$(date +%Y) @ $(date +%T)] File checked in: $filename" >> uncommittedlog.txt
										;;
										* ) echo "Incorrect input"
									esac
								done
								cp "$filename" .backup-files/"$filename-copies/$filename-$(date +%T)"
								cp "$filename.copy" "$filename"
								cp "uncommittedlog.txt" "logfile.txt"
								echo "Changes committed."
								continue
							;;
							n ) continue
							;;
							*)	echo "Invalid input."
						esac
					done
					}
					
					fi
					rm "$filename.copy"
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
			more logfile.txt
		;;
		5 ) echo "Compile the project using its source code"

		if [ -d source ]; then
		rm -r source
		fi
		echo -e "\nLooking for a source file.."
		sourceExists=$(ls -dq *.tar.gz | wc -l 2>/dev/null)

		if [ "$sourceExists" -eq 0 ] 2>/dev/null ; then
			echo "No tar with a .tar.gz extension file. Unable to proceed."
		elif [ "$sourceExists" -eq 1 ] 2>/dev/null ; then
			source=$(ls -dq *.tar.gz)
			mkdir source
			tar -zxvf "$source" -C source
			cd source || exit

			if ./configure 2>/dev/null; then
			make
			else
				echo "No configuration file found. Cannot proceed."
				cd ..
				rm -r source
			fi
		else
			echo "There are more than one source files. Please keep only one."
		fi
				;;
		6 ) echo "Rollback to a previous version"
		

			filename=null
			read -r -p "Enter the name of the file you wish to rollback:   " filename
			if [ -f "$filename" ]
			then
				{
					cd .backup-files/"$filename-copies" || exit
					if [ -z "$(ls -A)" ]; then
					   echo "No backups found for the file specified."
					else

					option=-1
					until [ "$option" -eq 0 ] 2>/dev/null ; do
					{
						find ./ -printf "%f \n" 
						echo
						echo "1. See differences between files"
						echo "2. Choose version to rollback"
						echo "0. Exit"

						read -r -p "Choose an option: " option
						case $option in
						1 )	diffFileName=null
							read -r -p "Enter the name of file to compare:   " diffFileName
							if [ -f "$diffFileName" ] 
							then
								{
									diff ../../"$filename" "$diffFileName"
								}
							else 
								echo "File not found."
							fi
						;;
						2 )	versionName=null
							read -r -p "Enter the version file name:   " versionName
							if [ -f "$versionName" ] 
							then
								{
									cp "$versionName" ../../"$filename"
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
					
					fi
				}
			else
				{
					echo "File not found."
				}
			fi
		;;
		7 ) echo "Archive management"
				
				checkOption=-1
			
				until [ "$checkOption" -eq 0 ] 2>/dev/null ; do
				
				echo
				echo "1. Archive the project into .tar.gz"
				echo "2. Access the latest archive"
				echo "0. Return"
				echo
				
				read -r -p "Choose an option: " checkOption
				
				case $checkOption in
				
				1 ) echo -e "\nArchiving the project..."
				if tar -czvf "archive_$repname.tar.gz" "../$repname" . 2>/dev/null; then
				echo "Repository archived successfully!"
				fi
				
				;;
				
				2 ) echo -e "\nAccessing the latest archive..."
				
				if [ -f "archive_$repname.tar.gz" ] 2>/dev/null ; then
				
				tar -xzvf "archive_$repname.tar.gz" -C ".archived" 2>/dev/null
				cd .archived || return
				
				echo -e "List of files in the archive: \n"
				ls -l
				
				input=-1
				innerinput=-1
				
				until [ "$input" -eq 0 ] 2>/dev/null ; do
				
					echo -e "\n1. Preview a file"
					echo "0. Return"
				        
				        read -r -p "Choose an option:" input
					case $input in
				
					1 )   
						i=1
					        OIFS="$IFS"
                                                IFS=$'\n'
                                                
						for f in *
						do
							if [ "$f" == "$repname" ]; then continue; fi
							echo "$i. $f"
							file[i]=$f
							i=$(( i + 1 ))
						done
						
						IFS="$OIFS"
						
						read -r -p "Choose which file to preview:" innerinput
						
						echo "You're previewing file ${file[$innerinput]}"
					
						more "${file[$innerinput]}"
				
						
					;;
					0) echo "Returning."	
					rm -r .archived/*
					continue
					;;
					
					*) echo "Invalid input."
					
					esac
				done
				
				else
				echo "No previous archive found."
				fi
				
				;;	
				0 ) echo "Return"
				    continue
				    ;;
				* ) echo "Invalid input."
				esac
				done
			
					;;
		0 ) echo "Return"
			cd ..
		;;
		* ) echo "Invalid input. Please try again."
		esac
		
		done

		else echo "Repository not found. Please try again"

		fi
	    ;;
	    
	3 ) echo -e "Displaying the contents..\n"
	
	    if [ "$(ls -A)" ]; then
   		  ls -l
	    else
	    
            echo "No repositories present." 
	    
            fi
	
	    ;;

	0 ) echo "Thank you for using the system! Exiting now."
	    ;;

	* ) echo -e "Invalid choice. Please enter a valid number. \n"
esac
done
