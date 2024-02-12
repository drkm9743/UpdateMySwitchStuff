

<img src="logo.jpeg" height="300px" />
<br>

# SwitchMeUp
This is a bash script that update Atmoshpere, hekate, patches and the software that I use with the latest available.
The basic package contains Atmosphere, hekate and wht for my usage is mandatory, the in the `addons.yml` are defined the github urls that are pulled and updated.

> NOTE: there is no support for any other sources then GitHub, some basic package stuff that is not on GitHub is manually coded case by case. I will add it if I will need it in the future.

> ⚠️ WARNING: this is a prersonal script that I'm sharing, I will not be responsible for any issue that can cause.

### There are already some tools that do this even more prettier, why this?
Because they usually use some AIO packages that I don't like, moreover I couldn't find one that could deliver my own selection, something was always missing.

## Dependencies

### Ubuntu
```bash
apt install jq rsync curl wget
```

## Usage
Just call this script passing the sd card location (where the folder atmosphere, switch are).
Probably you should be logged in into your GitHub account.
```bash
./switchmeup "/sd/card/location"
```

## Feature request
Can you add `THAT SOFTWARE` ?
> Short answer: No, this is a curated list of software that I am using, I don't accept requests.

Can I propose a new software or feature?
> Yes, you can create a PR if you wish and we can talk about further implementations, but I won't do it for you.

## TODO
I will do a pipeline that will release, as a GitHub release, the updated files as a package to extract in your SD.