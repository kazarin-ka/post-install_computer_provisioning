## TODO : add Idempotency
#!/bin/bash
USERNAME="XXXXXX" # your name in system
DWLD_FOLDER="/tmp"
FULL_NAME="YYYYYY" # rout full name if you use it. for example in Git
EMAIL="aaaa@aaaaa.com"
VPN_SERVER_URL="https://aaa.bbb.com/auth-provider" # url to ssl vpn server

#=================================================
#               DELETE PROGRAMS
#=================================================
# search: apt-get search *packetname* | grep "i   " | cut -d " " -f 4

apt-get purge -y transmission-cli transmission-common transmission-gtk transmission-remote-cli
apt-get purge -y hexchat hexchat-common
apt-get purge -y librhythmbox-core9 rhythmbox rhythmbox-data rhythmbox-plugin-tray-icon rhythmbox-plugins
apt-get purge -y gir1.2-xplayer-1.0 gir1.2-xplayer-plparser-1.0 libxplayer-plparser18 libxplayer0
apt-get purge -y xplayer xplayer-common xplayer-dbg xplayer-plugins
apt-get purge -y pidgin pidgin-data pidgin-libnotify 
#apt-get purge -y libreoffice-*
apt-get purge -y tomboy banshee tilda
apt-get purge -y pix pix-data pix-dbg


#=================================================
#               ADD REPOSITORIES
#=================================================

## sublime text
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

## remmina
apt-add-repository ppa:remmina-ppa-team/remmina-next -y

## nvidia fresh drivers
 add-apt-repository ppa:graphics-drivers/ppa -y

## keepass2 + plugins 
apt-add-repository ppa:jtaylor/keepass -y
add-apt-repository ppa:dlech/keepass2-plugins -y

## veracrypt
add-apt-repository ppa:unit193/encryption -y

## umake - for ide
add-apt-repository ppa:ubuntu-desktop/ubuntu-make -y

## virtualbox
#wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
#echo "deb http://download.virtualbox.org/virtualbox/debian vivid contrib" >> /etc/apt/sources.list.d/virtualbox.list


##yandex disk and browser
echo "deb http://repo.yandex.ru/yandex-disk/deb/ stable main" | sudo tee -a /etc/apt/sources.list.d/yandex.list > /dev/null && wget http://repo.yandex.ru/yandex-disk/YANDEX-DISK-KEY.GPG -O- | sudo apt-key add - 
echo "deb [arch=amd64] http://repo.yandex.ru/yandex-browser/deb beta main" | sudo tee -a /etc/apt/sources.list.d/yandex.list > /dev/null && wget https://repo.yandex.ru/yandex-browser/YANDEX-BROWSER-KEY.GPG -O- | sudo apt-key add - 

# if you want in install virtualbox 5.2. see below vitualbox section to find "5.2" version installation command
#apt-get purge -y virtualbox*
#sh -c 'echo "deb http://download.virtualbox.org/virtualbox/debian xenial contrib" >> /etc/apt/sources.list'
#wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -

apt-get update

#=================================================
#               BASIC TOOLS
#=================================================
apt-get install -y mc htop gparted gufw tmux vim dia xournal deluge filezilla zenmap wireshark tcpdump elinks zim docky sysv-rc-conf
apt-get install -y p7zip p7zip-rar p7zip-full zip unzip
#apt-get install -y lshw-gtk lshw
apt-get install -y minicom

#=================================================
#               DEV TOOLS
#=================================================

## sublime text
apt-get install -y apt-transport-https
apt-get install -y sublime-text git 

## mysql
apt-get install -y mysql-workbench

## pycharm
# https://itsfoss.com/install-pycharm-ubuntu/
apt-get install -y ubuntu-make
# make relogin after insallation!
su - $USERNAME -c "umake ide pycharm"

#=================================================
#               REMOTE ACCESS
#=================================================

## remmina
apt-get install -y freerdp remmina-common remmina remmina-plugin-rdp remmina-plugin-gnome libfreerdp-plugins-standard remmina-plugin-nx  remmina-plugin-vnc remmina-plugin-xdmcp

## teamviewer
cd $DWLD_FOLDER
MACHINE_TYPE=`uname -m`
if [ ${MACHINE_TYPE} == 'x86_64' ]; then
  wget -O teamviewer.deb https://download.teamviewer.com/download/linux/teamviewer_amd64.deb
else
  wget -O teamviewer.deb https://download.teamviewer.com/download/linux/teamviewer_i386.deb
fi
dpkg -i teamviewer.deb
apt-get install -fy
rm teamviewer.deb

## pac
# note: check PaC version ( now it's 4.5.5.7 )
cd $DWLD_FOLDER
wget -O pac.deb http://sourceforge.net/projects/pacmanager/files/pac-4.0/pac-4.5.5.7-all.deb
dpkg -i pac.deb
apt-get install -fy
rm pac.deb

#=================================================
#               SECURE SOFTWARE
#=================================================

## veracrypt
apt-get install -y veracrypt

## keepassx
apt-get install -y keepassx

## keepass2 + plugins
#apt-get install -y keepass2 xsel:i386 xdotool
#apt-get install -y keepass2-plugin-application-indicator  keepass2-plugin-keeagent keepass2-plugin-keepasshttp keepass2-plugin-rpc
#change your home dir path
#mkdir /home/akella/.local/share/KeePass
#chown akella:akella /home/akella/.local/share/KeePass
#cd /home/akella/.local/share/KeePass
# note: check Keepass translation version ( now it's 2.30 )
#wget http://downloads.sourceforge.net/keepass/KeePass-2.30-Russian.zip
#unzip KeePass-2.30-Russian.zip
#rm KeePass-2.30-Russian.zip
#cd /home/akella

#=================================================
#               VPN SOFTWARE
#=================================================

apt-get install -y openconnect
cd $DWLD_FOLDER
wget http://git.infradead.org/users/dwmw2/vpnc-scripts.git/blob_plain/HEAD:/vpnc-script
mkdir /etc/vpnc
cp vpnc-script /etc/vpnc
chmod 755 /etc/vpnc/vpnc-script

echo alias work_vpn='"'"sudo LD_LIBRARY_PATH=/usr/local/lib openconnect --juniper --no-cert-check $VPN_SERVER_URL"'"' >> /home/$USERNAME/.bashrc

#=================================================
#               BYOD Security policy
#=================================================
# Disable mac randomization
touch /etc/NetworkManager/conf.d/90-disable-randomization.conf

cat <<EOF > /etc/NetworkManager/conf.d/90-disable-randomization.conf
[device-mac-randomization]
wifi.scan-rand-mac-address=no
 
[connection-mac-randomization]
ethernet.cloned-mac-address=permanent
wifi.cloned-mac-address=permanent
EOF

# Send hardware address to DHCP
echo "dhcp-client-identifier = hardware;" >> /etc/dhcp/dhclient.conf 

# Screen lock
gsettings set org.gnome.desktop.session idle-delay 300
gsettings set org.gnome.desktop.screensaver lock-delay 0

# Password complexity
apt-get install -y libpam-cracklib
sed -i 's/@include common-password/#@include common-password/' /etc/pam.d/passwd

#The following parameters help to enforce this policy: 
#    prompt 3 times for password in case of an error
#    8 characters minimum length (minlen option)
#    at least 2 characters should be different from old password when entering a new one (difok option)
#    at least 1 digit (dcredit option)
#    at least 1 uppercase (ucredit option)
#    at least 1 other character (ocredit option)
#    at least 1 lowercase (lcredit option)


cat <<EOF >> /etc/pam.d/passwd
#%PAM-1.0
password    required    pam_cracklib.so difok=2 minlen=8 dcredit=1 ucredit=1 ocredit=1 lcredit=1 retry=3
password    required    pam_unix.so sha512 shadow remember=5 use_authtok
#password   required    pam_unix.so sha512 shadow nullok
EOF


touch /etc/security/opasswd
chown root:root /etc/security/opasswd
chmod 600 /etc/security/opasswd

# Password age
sudo chage -I -1 -m 0 -M 60 $USERNAME

#=================================================
#               WEB BROWSERS
#=================================================
apt-get install -y chromium-browser chromium-browser-l10n
#apt-get install -y pepperflashplugin-nonfree
#update-pepperflashplugin-nonfree --install

#apt-get install -y thunderbird thunderbird-locale-ru 
#apt-get install -y firefox firefox-locale-ru

# yandex bowser
#apt-get install -y yandex-browser-beta
# plugins ????


#=================================================
#               MESSANGERS
#=================================================

## skype
apt-get install -y skypeforlinux

## telegram
cd $DWLD_FOLDER
#wget -O - https://telegram.org/dl/desktop/linux > tsetup.tar.xz
wget -O tsetup.tar.xz https://telegram.org/dl/desktop/linux
tar -xJf tsetup.tar.xz
installdir="/home/$USERNAME/.apps/telegram"
appsfolder="/home/$USERNAME/.apps/"
if [ ! -d $appsfolder ]; then
    mkdir "/home/$USERNAME/.apps/"
fi

mv Telegram $installdir
rm tsetup.tar.xz
chown -R $USERNAME:$USERNAME $installdir
su - $USERNAME -c "nohup $installdir/Telegram &" > /dev/null
TELEGRAM_PID=$(ps -auxw | grep telegram  | cut -d " " -f 4 | head -n 1)
sleep 5
kill $TELEGRAM_PID

##rambox
cd $DWLD_FOLDER
MACHINE_TYPE=`uname -m`
if [ ${MACHINE_TYPE} == 'x86_64' ]; then
  wget -O rambox.deb https://github.com/saenzramiro/rambox/releases/download/0.5.13/Rambox_0.5.13-x64.deb
  #wget -O rabmox.appimage https://github.com/saenzramiro/rambox/releases/download/0.5.13/Rambox-0.5.13-x64.AppImage
else
  echo "no rambox release for x86..."
fi
dpkg -i rambox.deb
apt-get install -fy
rm rambox.deb

#=================================================
#               VIDEO SOFTWARE
#=================================================
apt-get install -y cheese kazam openshot

#=================================================
#                   OFFICE
#=================================================
## wps office
cd $DWLD_FOLDER
MACHINE_TYPE=`uname -m`
if [ ${MACHINE_TYPE} == 'x86_64' ]; then
  wget -O wps-office.deb http://kdl1.cache.wps.com/ksodl/download/linux/a21//wps-office_10.1.0.5707~a21_amd64.deb
else
  wget -O wps-office.deb http://kdl1.cache.wps.com/ksodl/download/linux/a21//wps-office_10.1.0.5707~a21_i386.deb
fi

dpkg -i wps-office.deb
apt-get install  -fy
rm wps-office.deb 

# fix error with fonts
mkdir /usr/share/fonts/kingsoft
cd /usr/share/fonts/kingsoft
git clone https://github.com/udoyen/wps-fonts.git
chown -R $USERNAME:$USERNAME /usr/share/fonts/kingsoft
chmod -R o+rw,g+rw /usr/share/fonts/kingsoft
# install microsoft fonts
apt-get install -y msttcorefonts 

#=================================================
#                   CLOUD
#=================================================

# dropbox
apt-get install -y dropbox nemo-dropbox

# yandex disk
apt-get install -y yandex-disk
# run "yandex-disk setup" in the end

#=================================================
#               VIRTUALIZATIONS
#=================================================

#virtual box + vagrnat + add vagrant boxes
apt-get install -y virtualbox

# if you want ot install virtualbox 5.2
#apt-get install -y  virtualbox-5.2


cd $DWLD_FOLDER
MACHINE_TYPE=`uname -m`
if [ ${MACHINE_TYPE} == 'x86_64' ]; then
  wget -O vagrant.deb https://releases.hashicorp.com/vagrant/2.0.1/vagrant_2.0.1_x86_64.deb
else
  wget -O vagrant.deb https://releases.hashicorp.com/vagrant/2.0.1/vagrant_2.0.1_i686.deb
fi
dpkg -i vagrant.deb
apt-get install  -fy
rm vagrant.deb
# add bosex
vagrant box add ubuntu/xenial64
vagrant box add debian/jessie64 
vagrant box add centos/7

chown -R $USERNAME:$USERNAME /home/$USERNAME/.vagrant.d/

# update all system
apt-get upgrade -y


#=================================================
#                   SYSTEM TUNING
#=================================================
# enable passwordless for our user
echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" | tee -a /etc/sudoers
# disable ipv6
sh -c 'echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6'
echo "net.ipv6.conf.all.disable_ipv6 = 1" | tee -a /etc/sysctl.conf

# disable system services
# see active services: systemctl -a -t service | grep " active"
systemctl disable apparmor
#systemctl disable cups-browsed
#systemctl disable cups


#=================================================
#                   GIT CONFIG
#=================================================
# enable passwordless for our user
su - $USERNAME -c 'git config --global user.name "$FULL_NAME"'
su - $USERNAME -c "git config --global user.email $EMAIL"


reboot

exit 0
