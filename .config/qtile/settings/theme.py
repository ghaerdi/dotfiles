# THEME
from os import listdir
from os import path
import subprocess
import json

# Set theme
theme = "material-darker-colorized" # only if available in ~/.config/qtile/themes

qtile_path = path.join(path.expanduser("~"), ".config", "qtile")
theme_path = path.join(qtile_path, "themes", theme)

# map color name to hex values
with open(path.join(theme_path, "colors.json")) as f:
    colors = json.load(f)

img = {}

# map image name to its path
img_path = path.join(theme_path, "img")
for i in listdir(img_path):
    img[i.split(".")[0]] = path.join(img_path, i)
