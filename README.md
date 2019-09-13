# retropie-cloudsavesync
 A script that syncs your saves with Dropbox, both ways

# Usage
 Simply run the script (after adjusting variables if you want to) and it will pull required repos and run you through the setup
 
 On your retropie, either pull the full repo and copy the script into `~RetroPie/retropiemenu` (or whatever category you use for scripts) or simply run:
 
    wget https://raw.githubusercontent.com/d-rez/retropie-cloudsavesync/master/cloud_save_sync.sh -O "/home/pi/RetroPie/retropiemenu/Cloud Save Sync.sh"
    chmod +x "/home/pi/RetroPie/retropiemenu/Cloud Save Sync.sh"
    bash "/home/pi/RetroPie/retropiemenu/Cloud Save Sync.sh"
    
Go through the setup steps, configure your Dropbox Dev API and that's it

Restart emulationstation for the menu entry to appear for future syncs
