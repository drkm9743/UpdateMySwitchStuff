<!-- Logo -->
<img src="logo.jpeg" height="300px" />
<br>

# SwitchMeUp

SwitchMeUp is a bash script designed to update Atmosphere, hekate, patches, and other software at the latest available versions. The basic package includes Atmosphere, hekate, and other components (mandatory for my usage), the in the `addons.yml` are defined the GitHub urls that are pulled and updated.

> ⚠️ **WARNING:** This script is intended for personal use and is shared as-is. I am not responsible for any issues that may arise from its usage.

### Why SwitchMeUp?

Despite the existence of other tools for similar purposes, SwitchMeUp offers the flexibility to select and update specific software components according to personal preferences. Unlike all-in-one packages, SwitchMeUp allows for a curated and customizable selection of software and provide a backup of the updated files without any action.

## Dependencies

### Ubuntu

Ensure the following dependencies are installed:

```bash
apt install jq rsync curl wget realpath

```

## Usage
Simply execute the script and provide the location of the SD card where the required folders (e.g., atmosphere, switch) are located. Ensure you are logged into your GitHub account for access to the repositories.
```bash
./switchmeup "/sd/card/location"
```

## What can I fid in the Release section?
There you can find an already prepared package, basically the pipeline runs the script in the runner and provide you the ready package, if you wish to just download it or you don't want to execute the script from your computer.
This of course is up to you to install and make a backup.

## Feature request
Can you add `THAT SOFTWARE` ?
> In short, no. SwitchMeUp maintains a curated list of software that I personally use. I do not accept requests for additional software.

Can I propose a new software or feature?
> Yes, you can create a pull request (PR) with your suggestions. We can discuss further implementations, but please note that I will not implement it for you.

## Contribution
If you would like to contribute by adding something, but you're not sure if it would be merged, it can be discussed in the 'Discussions' here on GitHub.

## TODO
 - Enhance the pipeline to trigger when Atmosphere or hekate has been updated updated (+ patches)
 - Enhance the pipeline to trigger when one of the components in `addons.yml` are updated
 - Add a `--pipeline` argument to skip all the user prompts
 - Add a `--force-clean` argument to delete (back up) sensible folders before moving the files, useful to fix some issues
