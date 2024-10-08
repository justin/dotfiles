-- AppleScript to connect to a remote computer and copy files
use AppleScript version "2.4" -- Yosemite (10.10) or later
use scripting additions

on run
	-- Set the timeout value in seconds
	set mountTimeout to 30
	
	try
		set remoteMachine to getRemoteMachineName()
	on error errMsg
		return -- Exit the script if an invalid machine is detected
	end try
	
	set networkShare to "justinwilliams"
	set sourcePath to POSIX path of ((path to home folder as text) & "Library:Application Support:Sports Interactive:Football Manager 2024:games")
	set destinationPath to "/Volumes/" & networkShare & "/Library/Application Support/Sports Interactive/Football Manager 2024/games"
	
	-- Check if the network share is already mounted
	if not (mountedVolume(networkShare)) then
		try
			-- Attempt to mount the network share with the specified timeout
			with timeout of mountTimeout seconds
				mount volume "smb://" & remoteMachine & "/" & networkShare
			end timeout
		on error errMsg
			-- If mounting fails, display an error alert and exit
			display alert "Connection Error" message "Failed to connect to " & networkShare & " on " & remoteMachine & " within " & mountTimeout & " seconds. Error: " & errMsg
			return -- Exit the script
		end try
	end if
	
	-- Check if the source folder exists
	tell application "System Events"
		if not (exists folder sourcePath) then
			display alert "Source Folder Error" message "The source folder does not exist: " & sourcePath
			return -- Exit the script
		end if
	end tell
	
	-- Attempt to copy files using cp command
	try
		do shell script "cp -R " & quoted form of sourcePath & "/* " & quoted form of destinationPath
		
		-- If successful, post a notification
		display notification "Files successfully copied to " & networkShare with title "Backup Complete"
	on error errMsg
		-- If copying fails, display an error alert
		display alert "File Copy Error" message "Failed to copy files. Error: " & errMsg
	end try
end run

-- Function to determine the remote machine name
on getRemoteMachineName()
	set currentMachineName to do shell script "scutil --get ComputerName"
	
	if currentMachineName is "Studio" then
		return "mbp"
	else if currentMachineName is "mbp" then
		return "Studio"
	else
		display alert "Invalid Machine" message "This script is designed to run on either 'Studio' or 'mbp'. Current machine: " & currentMachineName
		error "Invalid machine" -- Throw an error to stop the script
	end if
end getRemoteMachineName

-- Function to check if a volume is already mounted
on mountedVolume(volumeName)
	tell application "System Events"
		return exists disk volumeName
	end tell
end mountedVolume
