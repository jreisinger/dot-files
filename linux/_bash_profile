# If ~/.bash_profile exists ~/.profile is not read. I want it to be read.
if [ -r "$HOME/.profile" ]; then
    . "$HOME/.profile"
fi

# bash function to backup files
# Usage: backup <file-to-backup>
function backup () {
    newname=$1.`date +%Y%m%d.%H%M.bak`;
    mv $1 $newname;
    echo "Backed up $1 to $newname.";
    cp -p $newname $1;
}

# Attach existing screen session if possible
screen -q -ls > /dev/null 2>&1
EV=$?
if [[ $EV -eq 9 ]]; then
    # No screen session
    screen
elif [[ $EV -eq 10 ]]; then
    echo "Running but not attachable screen session(s)"
elif [[ $EV -ge 11 ]]; then
    # 1 (or more) usable sesssions
    screen -d -r
fi
