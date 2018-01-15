| #!/bin/bash
USERNAME="XXXXXX"
DWLD_FOLDER="/tmp"

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


apt-get update

#=================================================
#               BASIC TOOLS
#=================================================
apt-get install -y mc htop gparted gufw tmux vim dia xournal deluge filezilla zenmap wireshark tcpdump elinks zim docky sysv-rc-conf
apt-get install -y p7zip p7zip-rar p7zip-full zip unzip
#apt-get install -y lshw-gtk lshw
apt-get install -y git minicom

#=================================================
#               DEV TOOLS
#=================================================

## sublime text
apt-get install -y apt-transport-https
apt-get install -y sublime-text

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
#               WEB BROWSERS
#=================================================
apt-get install -y chromium-browser chromium-browser-l10n
#apt-get install -y pepperflashplugin-nonfree
#update-pepperflashplugin-nonfree --install

#apt-get install -y thunderbird thunderbird-locale-ru 
#apt-get install -y firefox firefox-locale-ru

# yandex bowser
apt-get install -y yandex-browser-beta
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



exit 0
