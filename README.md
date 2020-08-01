# Dotfiles & Configs

![Screenshot](.screenshot.png)
![Background](.background.jpg)
El fondo se descarga y aplica automáticamente, se puede reemplazar el archivo con otro utilizando el mismo nombre (formato .jpg o .png).


# Tutorial
Necesitarás git para ejecutar los siguientes comandos y adquirir toda la configuración.

```bash
git clone https://github.com/ghaerdi/dotfiles
sudo cp -R home/usuario/dotfiles/. home/usuario/
```
Los atajos se pueden configurar en el archivo home/usuario/.config/qtile/config.py.
<br/>
Las aplicaciones asignados en qtile también se pueden modificar facilmente en el mismo archivo.

<table><tr>

<td valign="top" width="33%">

### Paquetes qtile e interfaz
* Xorg (gráficos)
* Inicio de sesión (lightdm)
* Qtile (gestor de ventanas)
* Picom (transparencias)
* Feh (fondo)
* Alacritty (terminal)
* Firefox (explorador)
* nnn (gestor de archivos)
* Rofi (menú y busqueda de apps)
* Brightnessctl (luminosidad)
* Redshift (calor)
* Neofetch (logo + información del sistema en terminal)
* Htop (monitor de recursos)
* alsa (volumen)
* moc (música en terminal)
* deepin-screenshot (screenshots)
* Inconsolata (fuente)
* noto-fonts (símbolos)

</td><td valign="top" width="34%">

### Paquetes Arch
* Sudo (permisos)
* networkmanager
* Grub (bootloader)
* Git (repositorios)
* base-devel (AUR)
* ntfs-3g (particiones)
* polkit (particiones)
* os-prober (mostrar otros sistemas operativos en grub)
</td><td valign="top" width="33%">

### Widgets utilizados

* Clock
* Layouts (cambia al presionar)
* CheckUpdates (actualiza al presionar)
* Volume (mute al presionar y scroll para ajustar)
* moc (presionar para pausar, scroll para cambiar)
* systray (muestra aplicaciones en segundo plano)

</td></tr></table>

# Atajos

<table><tr><td valign="top" width="50%">

### Ventanas

| Key                 | Action               |
|---------------------|----------------------|
| **mod + i**         | next window (up)     |
| **mod + k**         | next window (down)   |
| **mod + j**         | next window (left)   |
| **mod + l**         | next window (right)  |
| **mod + shift + i** | move window up       |
| **mod + shift + k** | move window down     |
| **mod + shift + j** | move window left     |
| **mod + shift + l** | move window right    |
| **mod + ctrl + l**  | increase window size |
| **mod + ctrl + j**  | decrease window size |
| **mod + shift + f** | toggle floating      |
| **mod + tab**       | change layout        |
| **mod + w**         | kill window          |
| **mod + ctrl + r**  | restart qtile        |
| **mod + ctrl + q**  | quit qtile           |

</td><td valign="top" width="50%">

### Aplicaciones

| Key                 | Action              |
|---------------------|---------------------|
| **mod + m**         | launch rofi         |
| **mod + b**         | launch browser      |
| **mod + f**         | launch file manager |
| **mod + return**    | launch terminal     |
| **mod + r**         | redshift            |
| **mod + s**         | screenshot          |
| **mod + F6**        | -brighness          |
| **mod + F5**        | +brighness          |
| **mod + F10**       | mute sound          |
| **mod + F11**       | volume -5%          |
| **mod + F12**       | volume +5%          |

</td></tr></table>
