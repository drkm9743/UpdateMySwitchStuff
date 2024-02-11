#!/bin/bash

source functions.sh

updated_sd="sd_files/"
sd_card="./"
tmp_dir="/tmp/switchmeup"
work_dir="$tmp_dir/_work"

mkdir -p $sd_card
mkdir -p $tmp_dir

cd $tmp_dir

rm -rf * # DEBUG

get_latest "Atmosphere-NX" "Atmosphere"
install_atmosphere "$updated_sd"

ls $tmp_dir


