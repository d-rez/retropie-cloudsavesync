# @ d-rez 2019
# https://github.com/d-rez/retropie-cloudsavesync

# Uses https://github.com/mhtrinh/Dropbox-Uploader.git (as a git clone dependency)

# Configurable paths
backupdir="/home/pi/scripts/cloudsave"
romdir="/home/pi/RetroPie/roms"
savearchive="retropie_save_backup.tar.gz"
uploaderpath="/home/pi/src/Dropbox-Uploader"
apikeypath="/home/pi/.dropbox_uploader"

extensions="*.srm *.sav *.stat* *.fs *.nv *.bsv *.rtc"

# colours!
RED='\033[0;31m'
GRN='\033[0;32m'
YLW='\033[1;33m'
NC='\033[0m' # No Colour

if [ ! -d $uploaderpath ]; then
    echo -e "${GRN}Running initial setup...${NC}"
    git clone --depth 1 https://github.com/mhtrinh/Dropbox-Uploader.git $uploaderpath
fi
if [ ! -s $apikeypath ]; then
    $uploaderpath/dropbox_uploader.sh
    if [ ! -s $apikeypath ]; then
        echo -e "${RED}ERROR: API key check failed. Try running the script again?${NC}"
        exit 1
    fi
fi

# Cleanup if something went wrong + ignore errors if nothing gets deleted
rm -rf $backupdir/roms 2>&1 > /dev/null
mkdir -p $backupdir/roms
rm -f $backupdir/$savearchive 2>&1 > /dev/null

echo -e "${GRN}Downloading cloud saves...${NC}"
log=$($uploaderpath/dropbox_uploader.sh download /$savearchive $backupdir 2>&1)

# build dynamic extension list for sync
for ext in $extensions; do
    ext_list="$ext_list --include '$ext'"
done

if [ -f "$backupdir/$savearchive" ]; then
    echo -e "${GRN}Existing cloud save archive found, unpacking and syncing${NC}"
    tar -xzf $backupdir/$savearchive -C $backupdir

    # Sync files that are newer from the extracted backup to this retropie
    args="-atvWru --include '*/' $ext_list --exclude '*' $backupdir/roms/ $romdir/"
    eval rsync $args
else
    echo -e "${YLW}Either no existing cloud save archive found or there was an error. See log below:${NC}"
    echo "$log"
fi

echo -e "${GRN}Syncing local saves to backup...${NC}"
# Sync files that are newer from this retropie to the extracted backup
args="-atvWru --include '*/' $ext_list --exclude '*' $romdir/ $backupdir/roms/"
eval rsync $args

echo -e "${GRN}Compressing and syncing...${NC}"
# Compress the updated backup
tar -czf $backupdir/$savearchive -C $backupdir roms

$uploaderpath/dropbox_uploader.sh upload $backupdir/$savearchive /

echo -e "${GRN}All tasks completed!${NC}"

# Cleanup temp files
rm -rf $backupdir/roms
rm -f $backupdir/$savearchive

sleep 3
