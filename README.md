# Dotfiles & Configs

![Screenshot](.screenshot.png)
![Background](.background.jpg)
Dotfiles include the background, you can replace it with the same name (background[.jpg or .png]) or editing/adding something like this:
```bash
# ~/.xsession

feh --bg-scale your-wallpaper.jpg
```
<br/>
The repository include more backgrounds images in the Wallpaper folder.

# Download dotfiles to your user directory

You will need git to run this:

```bash
git clone https://github.com/ghaerdi/dotfiles
cp -R home/usuario/dotfiles/. home/usuario/
```

# Packages

<table><tr>

<td valign="top" width="33%">

### Basic packages

- Sudo (permits for users)
- networkmanager (internet and wifi)
- intel-ucode o amd-ucode
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

# Themes

## Grub
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

## Cursor
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
Or you can use Ixappearance
