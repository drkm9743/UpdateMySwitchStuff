#!/bin/bash

source functions.sh

sd_card="./sdcard"
tmp_dir="/tmp/switchmeup"
updated_sd="$tmp_dir/sd_files/"
work_dir="$tmp_dir/_work"
addons=$(read_addons "addons.yml")
backup_folder="backup_$(date +'%d%m%y%H%M')"

mkdir -p $sd_card
mkdir -p $tmp_dir
mkdir -p $backup_folder

cd $tmp_dir

echo "Cleaning up temp dir"
rm -rf *

install_basic_pack
install_sigpatches
install_lockpick

while IFS= read -r url; do
    # Call the install_addon function with the current URL
    # Extracting username and project name from GitHub URL if applicable
    echo "Working $url"
    if [[ $url == *"github.com"* ]]; then  # Changed $1 to $url
        user=$(echo "$url" | awk -F'/' '{print $(NF-1)}')
        project=$(echo "$url" | awk -F'/' '{print $NF}')
        install_addon "$user" "$project"
    else
        echo "ERROR: $url is not a github link"
    fi
done <<< "$addons"

# Cleanup
# un-needed languages (for me)
rm -rf $updated_sd/switch/DBI_ptbr.nro $updated_sd/switch/DBI_ru.nro

rsync -av --backup --backup-dir="$backup_folder" "$updated_sd/" "$sd_card/"

