#macos-satu.sh MAC_USER_PASSWORD VNC_PASSWORD MAC_REALNAME

#disable spotlight indexing
sudo mdutil -i off -a

#Create new account
sudo dscl . -create /Users/admin
sudo dscl . -create /Users/admin UserShell /bin/bash
sudo dscl . -create /Users/admin RealName $3
sudo dscl . -create /Users/admin UniqueID 1001
sudo dscl . -create /Users/admin PrimaryGroupID 80
sudo dscl . -create /Users/admin NFSHomeDirectory /Users/admin
sudo dscl . -passwd /Users/admin $1
sudo dscl . -passwd /Users/admin $1
sudo createhomedir -c -u admin > /dev/null
sudo dscl . -append /Groups/admin GroupMembership username

#install tunnel
brew install --cask cloudflare/cloudflare/cloudflared

#configure tunnel and start it
nohup cloudflared tunnel --bastion &

#Enable VNC
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -allowAccessFor -allUsers -privs -all
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -clientopts -setvnclegacy -vnclegacy yes 

echo $2 | perl -we 'BEGIN { @k = unpack "C*", pack "H*", "1734516E8BA8C5E2FF1C39567390ADCA"}; $_ = <>; chomp; s/^(.{8}).*/$1/; @p = unpack "C*", $_; foreach (@k) { printf "%02X", $_ ^ (shift @p || 0) }; print "\n"' | sudo tee /Library/Preferences/com.apple.VNCSettings.txt

#Start VNC/reset changes
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -restart -agent -console
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate

cat nohup.out
