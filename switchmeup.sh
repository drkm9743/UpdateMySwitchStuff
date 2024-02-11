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

rm -rf * # DEBUG

get_latest "Atmosphere-NX" "Atmosphere"
install_atmosphere
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


