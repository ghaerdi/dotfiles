[My Qtile config](https://github.com/ghaerdi/Qtile-config)

# Dotfiles
Dotfiles include a background, you can replace it with the same name (background[.jpg or .png]) or editing/adding something like this:
```bash
# ~/.xsession

feh --bg-scale your-wallpaper.jpg
```
<br/>
The repository include more backgrounds images in the Wallpaper folder.

# Tutorial

Alert: This tutorial is make for personal uses. If you want follow this tutorial I recommend read and study all commands instead follow this guide step by step. Depending of your system (BIOS or UEFI) the installation change a little bit (I'm using a BIOS system). I will share different links to the ArchWiki documentation.

## Install Arch

Follow the [arch installation guide](https://wiki.archlinux.org/index.php/installation_guide) and don't reboot.

### After follow the arch installation guide.

Install this next packages
```bash
pacman -S networkmanager sudo grub

# If you have intel processor:
pacman -S intel-ucode

# If you have amd processor:
pacman -S amd-ucode
```
Read about [Network Manager](https://wiki.archlinux.org/index.php/NetworkManager)
Read about [Microcode](https://wiki.archlinux.org/index.php/Microcode)

#### Enable internet for next session

[NetworkManager](https://wiki.archlinux.org/index.php/NetworkManager) will connect your computer to ethernet automatically after you have installed Arch, but for that you need enable it:
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
cp -r home/user/dotfiles/. home/user/
```

# Packages

<table><tr>

<td valign="top" width="50%">

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

</td><td valign="top" width="50%">

### Optional packages

- ntfs-3g (partitions)
- polkit (partitions)
- os-prober (show windows OS in grub)
- Htop (task manager)
- Neofetch (logo + info system in terminal)
- Taskbook (task for terminal)
- Picom (transparency)
- Feh (background)
- network-manager-applet (NetworkManager systray)
- pavucontrol (volume control GUI)
- libnotify & notification-daemon (notifications)
- udiskie (automount)
- cbatticon (batery systray)
- volumeicon (volume systray)
- xcb-util-cursor (cursor theme)
- lxappearance (theme manager)

</td></tr></table>

# Themes

- Grub: [Stylish](https://www.pling.com/p/1009237) or [Tela](https://www.pling.com/p/1307852/)
- Lightdm [lightdm-webkit2-greeter](https://www.archlinux.org/packages/community/x86_64/lightdm-webkit2-greeter/) and [lightdm-webkit-theme-aether](https://aur.archlinux.org/packages/lightdm-webkit-theme-aether/)
- GUI: [Qogir](https://www.gnome-look.org/p/1230631/)
- Icons: [Tela circle](https://www.gnome-look.org/p/1359276/)
- Cursor: [Vimix](https://www.pling.com/p/1358330)
