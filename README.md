# Dotfiles & Configs

![Screenshot](.screenshot.png)
El fondo se descarga y se aplica automáticamente (se puede cambiar en .xsession)

# Widgets utilizados (de derecha a izquierda en la barra superior)
<ul>
<li>Clock</li>
<li>Layouts (cambia de layout al presioanr)</li>
<li>CheckUpdates (actualiza al presionar)</li>
<li>Volume (presionar para mute y scroll para ajustar)</li>
<li>moc (presionar para pausar, scroll para cambiar)</li>
<li>systray (muestra aplicaciones en segundo plano)</li>
</ul>

# Tutorial
Necesitarás git para ejecutar los siguientes comandos y adquirir toda la configuración.

```bash
git clone https://github.com/ghaerdi/dotfiles
cd dotfiles
sudo cp -R home/usuario/dotfiles home/usuario/
```
Los atajos se pueden configurar en el archivo home/usuario/.config/qtile/config.py <br/>
Las aplicaciones utilizadas en los atajos también se pueden modificar facilmente en las variables que han sido almacenadas.

# Paquetes necesarios para qtile y la interfaz
<ul>
<li>Xorg (gráficos)</li>
<li>interfaz para iniciar sesión (lightdm recomendado)</li>
<li>Qtile (gestor de ventanas)</li>
<li>Picom (transparencias)</li>
<li>Feh (fondo)</li>
<li>Alacritty (terminal de gpu)</li>
<li>Firefox (explorador)</li>
<li>nnn (gestor de archivos en terminal)</li>
<li>Rofi (barra de búsqueda y menú de aplicaciones)</li>
<li>Brightnessctl (luminosidad)</li>
<li>Redshift (calor para las noches)</li>
<li>Neofetch (logo de arch linux en terminal + información del sistema)</li>
<li>Htop (monitor de recursos)</li>
<li>alsa (volumen)</li>
<li>moc (música en terminal)</li>
<li>deepin-screenshot (screenshots)</li>
<li>Inconsolata (fuente para terminal)</li>
<li>noto-fonts (símbolos)</li>
</ul>

# Otros paquetes necesarios para Arch
<ul>
<li>Sudo (permisos)</li>
<li>networkmanager (ethernet y wifi)</li>
<li>Grub (bootloader)</li>
<li>Git (repositorios)</li>
<li>base-devel (AUR makepkg)</li>
<li>ntfs-3g (particiones)</li>
<li>polkit (particiones)</li>
<li>os-prober (mostrar otros sistemas operativos en grub)</li>
<li></li>
</ul>

# Atajos

## Ventanas

| Key                 | Action               |
|---------------------|----------------------|
| **mod + i**         | next window (up)     |
| **mod + k**         | next window (up)     |
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

## Aplicaciones

| Key                 | Action              |
|---------------------|---------------------|
| **mod + m**         | launch rofi         |
| **alt + tab**       | window nav (rofi)   |
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
