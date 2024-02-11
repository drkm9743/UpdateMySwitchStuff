#!/bin/bash

get_latest() {
  OWNER="$1"
  REPO="$2"

  mkdir -p _work
  cd _work

  API_URL="https://api.github.com/repos/$OWNER/$REPO/releases/latest"

  echo "Fetching latest release from $OWNER/$REPO..."
  release_data=$(curl -L \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    "$API_URL")

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


install_atmosphere() {

    local install_path="$1"

    echo "Installing atmosphere in $(realpath $install_path)" # DEBUG

    mkdir -p "$install_path/payloads"
    rsync -PrlD --mkpath --remove-source-files "$work_dir/fusee.bin" "$install_path/payloads"
    ls -lah $install_path
    rsync -PrlD --mkpath --remove-source-files "$work_dir/atmosphere"*/ "$install_path"


}
