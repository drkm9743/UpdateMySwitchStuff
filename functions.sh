#!/bin/bash

get_latest() {

  # This bash function fetches the latest release or pre-release assets from a GitHub repository and downloads them.
  # It handles various file types by extracting ".zip" files with `unzip`, ".tar.gz" files with `tar`, and retains other file types as is.

  OWNER="$1"
  REPO="$2"

  mkdir -p "$work_dir"
  cd "$work_dir"

  API_URL="https://api.github.com/repos/$OWNER/$REPO/releases/latest"
  PRE_RELEASE_URL="https://api.github.com/repos/$OWNER/$REPO/releases"

  echo "Fetching latest release from $OWNER/$REPO..."
  release_data=$(curl -sL \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    "$API_URL")

  # Check if a release was found
  if echo "$release_data" | jq -e .tag_name > /dev/null; then
    echo "Latest release found."
    echo "$release_data" | jq .
  else
    echo "No latest release found, checking for pre-releases..."
    release_data=$(curl -sL \
      -H "Accept: application/vnd.github+json" \
      "$PRE_RELEASE_URL" | jq '[.[] | select(.prerelease == true)] | first')
    
    # Check if a pre-release was found
    if echo "$release_data" | jq -e .tag_name > /dev/null; then
      echo "Latest pre-release found."
      echo "$release_data" | jq .
    else
      echo "No pre-releases found."
    fi
  fi

  if [[ ! "$release_data" || "$release_data" == "Not Found" ]]; then
    echo "Error fetching release data. Please check the repository and user name."
    exit 1
  fi

  assets_urls=$(echo "$release_data" | jq -r '.assets[] | .browser_download_url')

  if [[ -z "$assets_urls" ]]; then
    echo "No assets to download."
    exit 1
  fi

  echo "Downloading assets..."
  for url in $assets_urls; do
    echo "Downloading: $url"
    filename=$(basename "$url")
    wget "$url" -O "$filename"

    # Determine the file type and extract accordingly
    if [[ "$filename" == *.zip ]]; then
      echo "Extracting $filename..."
      dirname="${filename%.*}"
      mkdir -p "$dirname"
      unzip -d "$dirname" "$filename"
      echo "Extraction complete. Deleting the archive..."
      rm "$filename"
    elif [[ "$filename" == *.tar.gz ]]; then
      echo "Extracting $filename..."
      dirname="${filename%.*}"
      dirname="${dirname%.*}" # Remove .tar part as well
      mkdir -p "$dirname"
      tar -xzf "$filename" -C "$dirname"
      echo "Extraction complete. Deleting the archive..."
      rm "$filename"
    else
      echo "Retained $filename."
    fi
  done

  echo "All specified assets have been downloaded and processed."

  cd -
}

install_basic_pack() {

    local install_path="$updated_sd"

    echo "Installing Atmosphere in $(realpath $install_path)"
    get_latest "Atmosphere-NX" "Atmosphere"
    mkdir -p "$install_path/payloads"
    rsync -PrlD --mkpath --remove-source-files "$work_dir/fusee.bin" "$install_path/payloads"
    rsync -PrlD --mkpath --remove-source-files "$work_dir/atmosphere"*/ "$install_path"
    rm -rf $work_dir

    echo "Installing hekate + Nyx in $(realpath $install_path)"
    get_latest "CTCaer" "hekate"
    rsync -PrlD --mkpath --remove-source-files "$work_dir/hekate"*"/hekate"*".bin" "$install_path/payloads"
    rsync -PrlD --mkpath --remove-source-files "$work_dir/hekate"*/ "$install_path"
    rm -rf $work_dir

}

install_sigpatches() {

  local install_path="$updated_sd"
  echo "Installing SigPatches in $(realpath $install_path)"

  mkdir -p $work_dir
  cd $work_dir

  # Fetch the webpage content and extract the sigpatches URL
  sigpatches_url=$(curl -s "https://sigmapatches.su/" | grep -oP 'href="/sigpatches\.zip\?\K[^"]+(?=")')

  # Check if the URL is found
  if [ -n "$sigpatches_url" ]; then
      echo "Found sigpatches URL: https://sigmapatches.su/sigpatches.zip?$sigpatches_url"
      
      # Download the sigpatches file
      wget "https://sigmapatches.su/sigpatches.zip?$sigpatches_url" -O sigpatches.zip

      echo "Extracting SigPatches..."
      dirname=sigpatches
      mkdir -p "$dirname"
      unzip -d "$dirname" sigpatches.zip
      echo "Extraction complete. Deleting the archive..."
      rm sigpatches.zip
  else
      echo "Error: Sigpatches URL not found."
      read -p "Are you sure you want to continue? [N/y] " choice
      case "$choice" in 
        y|Y ) echo "Continuing...";;
        * ) echo "Exiting..."; exit 0;;
      esac
  fi

  rsync -PrlD --mkpath --remove-source-files "$work_dir/sigpatches/"*/ "$install_path"

  cd -
  rm -rf $work_dir

}

read_addons() {
    # Using grep to find lines starting with "  - url:" and then using awk to extract the URL part
    urls=$(grep '^\s*-\s*url:' "$1" | awk '{print $3}')
    echo "$urls"
}

install_addon() {

  echo "Installing $1/$2"

  get_latest "$1" "$2"

  nro_folder="$updated_sd/switch"
  mkdir -p $nro_folder

  # Check for any .nro files in the specified working directory
  nro_files=$(find "$work_dir" -type f -name "*.nro")

  if [[ -n $nro_files ]]; then
      echo ".nro files found, moving them to $nro_folder"
      # Move all .nro files to the specified FOLDER
      find "$work_dir" -type f -name "*.nro" -exec mv {} "$nro_folder" \;
  else
      # If no .nro files are found, proceed to search for the "atmosphere" folder
      atmosphere_folder=$(find "$work_dir" -type d -name "atmosphere" -print -quit)
      if [[ -z $atmosphere_folder ]]; then
          atmosphere_folder=$(find "$work_dir" -type d -name "switch" -print -quit)
      fi
      if [[ -n $atmosphere_folder || -n $switch_folder ]]; then
          echo "Atmosphere or switch folder found at: $atmosphere_folder"
          base_folder="$(realpath "$atmosphere_folder/..")"
          echo "Moving the contents of $base_folder into $updated_sd"
          rsync -PrlD --mkpath --remove-source-files "$base_folder/"* "$updated_sd"
      else
          echo "No atmosphere folder found in the specified directory or any subdirectories."
          echo "FAILURE: no nro files or atmosphere folder found, $1/$2 cannot be installed."
      fi
  fi

  rm -rf $work_dir
}
