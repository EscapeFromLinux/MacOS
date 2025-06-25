#!/bin/bash

### read data from json
JSON_FILE="$HOME/Documents/notes.json"
if [[ ! -f "$JSON_FILE" ]]; then
    echo "there is no $JSON_FILE"
    exit 1
fi

eval "$(jq -r 'to_entries | .[] | "export \(.key)=\(.value[0])"' "$JSON_FILE")"

echo "Pc number: $pcn"
echo "AnyDesk ID: $anydesk_id"
echo "AnyDesk Password: $anydessk_pass"
echo "Modem Number: $modem_number"
echo "Username: $username"
echo "Local IP Address: $loc_ip_addresses"
echo "Email: $email"
echo "Gmail Password: $gmailpass"
echo "Apple Password: $applepass"
###

### set Mac hostnames
random_chars=$(openssl rand -base64 6 | tr -dc 'a-zA-Z' | cut -c1-4)
sudo scutil --set ComputerName "Mac$pcn$random_chars"
sudo scutil --set LocalHostName "Mac$pcn$random_chars"
sudo scutil --set HostName "Mac$pcn$random_chars"
###

### find active net int and set up it
if [ $pcn -gt 244 ]; then
	pcn_short=${pcn: -2}
else
    pcn_short=$pcn
fi
interface=$(ifconfig | awk '/192\.168\.0\./ {print prev} {prev=$1}' | head -n 1)
ip_address="192.168.0.$pcn_short"
dns_servers="192.168.0.1 8.8.8.8 4.4.4.4"
if ! ifconfig "$interface" &> /dev/null; then
	echo "ip int isnt fined"
	exit 1
fi

if ! ifconfig en6 | grep -q "status: active"; then
	echo "int not active"
	exit 1
fi

sudo ifconfig "$interface" $ip_address netmask 255.255.255.0

if ifconfig "$interface" | grep -q "$ip_address"; then
	echo "ip set: $ip_address"
else
	echo "ERROR ERROR ERROR: ip dont set"
fi

service_name=$(networksetup -listallhardwareports | awk -v interface="$interface" '$2 == interface {getline; print $2}')
dns_servers="172.0.0.1 8.8.8.8 4.4.4.4"
sudo networksetup -setdnsservers "$service_name" $dns_servers
###

### default script
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/$USER/.zprofile
eval "$(/opt/home-brew/bin/brew shellenv)"
mkdir /Applications/user; chflags hidden /Applications/user
mkdir ~/Desktop/Certifikates; mv /Applications/Dozer.app /Applications/user
touch ~/Desktop/Certifikates/SharedSecret.txt; touch ~/Desktop/AppCryptSitesList.txt
sudo pmset -a disablesleep 1
###

### download needed things
brew install wget
Brew install mas
brew install cocoapods
brew install keeper-password-manager
brew install --cask telegram
brew install --cask docker
brew install dockutil    
sudo gem install zeitwerk -v 2.6.18;
sudo gem install activesupport -v 6.1.7.10; sudo gem install drb -v 2.0.5; echo 'export
PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile; echo 'eval "$(rbenv init --no-rehash -)"' >> ~/.bash_profile;
brew install rbenv; sudo rbenv install 3.0.3; sudo rbenv global 3.0.3; source ~/.bash_profile; ruby -v; sudo gem install cocoapods
###

### download and install appcrypt
start=$(pwd)
cd /tmp/
wget https://download.cisdem.com/cisdem-appcrypt.dmg
hdiutil mount /tmp/cisdem-appcrypt.dmg
cp -R /Volumes/Cisdem\ AppCrypt/Cisdem\ AppCrypt.app /Applications/user/
mv /Applications/user/Cisdem\ AppCrypt.app /Applications/user/AppCrypt.app
hdiutil unmount /Volumes/Cisdem\ AppCrypt
cd $start
open /Applications/user/AppCrypt.app 
###

### download and install dozer
curl -L -o /tmp/Dozer.dmg https://github.com/Mortennn/Dozer/releases/download/v4.0.0/Dozer.4.0.0.dmg
hdiutil mount /tmp/Dozer.dmg
cp -R /Volumes/Dozer/Dozer.app /Applications/user/
hdiutil unmount /Volumes/Dozer
open /Applications/user/Dozer.app
defaults write com.Mortennn.Dozer launchAtLogin -bool true
defaults write com.Mortennn.Dozer automaticallyCheckForUpdates -bool true
defaults write com.Mortennn.Dozer hideStatusIconsAfterDelay -bool true
defaults write com.Mortennn.Dozer hideDelaySeconds -int 10
defaults write com.Mortennn.Dozer hideBothDozerIcons -bool true
defaults write com.Mortennn.Dozer enableRemoveIcon -bool true
killall Dozer && open /Applications/user/Dozer.app
###

### download and install unity
curl -L -o /tmp/UnityHub.dmg "https://public-cdn.cloud.unity3d.com/hub/prod/UnityHubSetup.dmg"
hdiutil mount /tmp/UnityHub.dmg
cp -R /Volumes/Unity\ Hub/Unity\ Hub.app /Applications/
hdiutil unmount /Volumes/Unity\ Hub
open /Applications/Unity\ Hub.app
###


### remove icons from dock
dockutil --remove 'Messages' || true
dockutil --remove 'Calendar' || true
dockutil --remove 'Photos' || true
dockutil --remove 'Reminders' || true
dockutil --remove 'TV' || true
dockutil --remove 'Music' || true
dockutil --remove 'Stocks' || true
dockutil --remove 'Pages' || true
dockutil --remove 'Numbers' || true
dockutil --remove 'Keynote' || true
dockutil --remove 'System Preferences' || true
dockutil --remove 'com.apple.systempreferences' --bundleid || true
dockutil --remove 'com.apple.messages' --bundleid || true
dockutil --remove 'com.apple.stocks' --bundleid || true
dockutil --remove 'com.apple.freeform' || true
dockutil --remove 'Contacts' || true
dockutil --remove 'Maps' || true
dockutil --remove 'FaceTime' || true
dockutil --remove 'Launchpad' || true
# add icons to dock
dockutil --add /Applications/Unity Hub.app
dockutil --add /System/Applications/Preview.app
dockutil --add /System/Applications/TextEdit.app
dockutil --add '/System/Applications/QuickTime Player.app'
dockutil --add /System/Applications/Utilities/Screenshot.app
dockutil --add '/Applications/Keeper Password Manager.app'
dockutil --add /Applications/Docker.app
#
killall Dock
###

### disable bluetooth
brew install bulletin
blueutil --power 0
###

### exec other parts
osascript wal.scpt
osascript safari.scpt
osascript sound.scpt
osascript modem.scpt
###

rm "$FILENAME"

rm ~/.zsh_history && touch ~/.zsh_history && exec $SHELL

