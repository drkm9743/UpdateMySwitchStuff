#!/bin/bash

source functions.sh

updated_sd="sd_files/"
sd_card="./"
tmp_dir="/tmp/switchmeup"
work_dir="$tmp_dir/_work"
addons=$(read_addons "addons.yml")

mkdir -p $sd_card
mkdir -p $tmp_dir

cd $tmp_dir

echo "Cleaning up temp dir"
rm -rf *

install_basic_pack
install_sigpatches
rm -rf $work_dir

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

ls $tmp_dir

# TODO
# Install Lockpick: https://vps.suchmeme.nl/git/mudkip/Lockpick_RCM/releases/download/v1.9.11/Lockpick_RCM.bin
# copy all the files on sd card moving the older files into a bakcup folder with the date

# Cleanup
# un-needed languages (for me)
rm -rf $updated_sd/switch/DBI_ptbr.nro $updated_sd/switch/DBI_ru.nro

