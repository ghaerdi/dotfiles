# Dotfiles
![Screenshot](.screenshot.png)
![Background](.background.jpg)
Dotfiles include the background, you can replace it with the same name (background[.jpg or .png]) or editing/adding something like this:
```bash
# ~/.xsession

feh --bg-scale your-wallpaper.jpg
```
<br/>
The repository include more backgrounds images in the Wallpaper folder.

# Tutorial

Alert: I recommend read and study all commands instead follow this guide step by step. Depending of your system (BIOS or UEFI) the installation change a little bit (I'm using a BIOS system). I will share different links to the ArchWiki documentation.

Another alert: This tutorial is in progress.

## Install Arch

Follow the [arch installation guide](https://wiki.archlinux.org/index.php/installation_guide) and don't reboot.

### After follow the arch installation guide and before rebooting

Install this next packages
```bash
pacman -S networkmanager sudo grub

# If you have intel processor:
pacman -S intel-ucode

# If you have amd processor:
pacman -S amd-ucode
```

#### Enable internet for next session

[NetworkManager](https://wiki.archlinux.org/index.php/NetworkManager) will connect your computer to network automatically after you have installed Arch, but for that you need enable it:
```bash
systemctl enable NetworkManager.service
```
That should be enough. Now if you reboot you will have internet.

#### Adding GRUB

[GRUB documentation](https://wiki.archlinux.org/index.php/GRUB#Installation)

```
grub-install --target=i386-pc /dev/sdX
grub-mkconfig -o /boot/grub/grub.cfg
```

#### Add a password for the root user

```bash
# After type and press enter the next command will requiere a password for root user
passwd
```

#### Add a user and a password for this new user

For more security is better use a personal session instead the root session. [Users and groups](https://wiki.archlinux.org/index.php/Users_and_groups)
```bash
# Create user
useradd -m username
passwd username

# Give permissions to the new user
usermod -aG wheel,storage,audio,video,disk,floopy,network username 
```
Wheel group is important for use the sudo command, but is not all.
For use sudo you need uncommend a line, like this:

```
# If you have installed vim
visudo
# If not, you can use nano whitout installing until you haven't rebooted
EDITOR=nano visudo

# ...
## Uncomment to allow members of group sudo to execute any command
%wheel ALL=(ALL) ALL
```

#### Reboot

That's all now you have internet, bootloader and a own user. Now you can reboot.

```
# Exit from chroot and reboot
exit
reboot
```

## Download dotfiles to your user directory

You will need git to run this:

```bash
git clone https://github.com/ghaerdi/dotfiles
cp -R home/usuario/dotfiles/. home/usuario/
```

## Themes

### Grub
Download [Stylish](https://www.pling.com/p/1009237) or [Tela](https://www.pling.com/p/1307852/) <br>
Run:

```bash
cd Downloads
tar -xf Stylsh.1080p.tar.xz
rm Stylsh.1080p.tar.xz
cd Stylish-1080p
./install.sh
# To make sure if the grub theme changed:
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### Cursor
Download [Vimix](https://www.pling.com/p/1358330) <br>
Run:

```bash
sudo pacman -S xcb-util-cursor # if you dont hava installed yet
cd Downloads
tar -xf 01-Vimix-cursors.tar.xz
mv Vimix-cursors /usr/share/icons
rm 01-Vimix-cursors.tar.xz
```

Edit `~/.gtkrc.2-0` and `~/.config/gtk3-0`

```bash
# ~/.gtkrc-2.0
gtk-cursor-theme-name = "Vimix-cursors"

# ~/.config/gtk-3.0/settings.ini
gtk-cursor-theme-name = Vimix-cursors
```
Or you can use Ixappearance instead of terminal commands

### GUI Theme and icons
Is the same thing as cursor theming.
Download a theme and run:
```bash
cd Downloads
tar -xf theme.tar.xz

# In case of GUI theme:
mv theme /usr/share/themes

# In case of icons theme
mv theme /usr/share/icons
```
Also you can use Ixappearance

# Packages

<table><tr>

<td valign="top" width="33%">

### Basic packages

- Sudo (permits for users)
- networkmanager (internet and wifi)
- intel-ucode or amd-ucode
- Grub (bootloader)
- Xorg (graphics)
- Git
- base-devel (AUR)
- Lightdm (login screen)
- pulseaudio (sound)

</td><td valign="top" width="34%">

### Packages for Qtile

- Qtile (tilling window manager)
- Konsole (terminal)
- Opera (browser)
- Ranger (terminal file explorer)
- Rofi (menu and search apps)
- Brightnessctl
- Redshift (color temperature)
- pulseaudio-alsa (sound)
- alsa-utils (terminal volume control)
- moc (terminal music player)
- deepin-screenshot (screenshot)
- xfce4-clipman (clipboard systray)
- FiraCode & UbuntuMono Nerd Fonts (font and symbols)

</td><td valign="top" width="33%">

### Optional packages

- ntfs-3g (partitions)
- polkit (partitions)
- os-prober (show windows OS in grub)
- Htop (task manager)
- Neofetch (logo + info system in terminal)
- Taskbook (task for terminal)
- Picom (transparency)
- Feh (background)
- yarn & npm
- Nautilos o thunar (file explorer GUI)
- network-manager-applet (NetworkManager systray)
- pavucontrol (volume control GUI)
- libnotify & notification-daemon (notifications)
- udiskie (automount)
- cbatticon (batery systray)
- volumeicon (volume systray)
- neovim (terminal file editor)
- xcb-util-cursor (cursor theme)
- lxappearance

</td></tr></table>
