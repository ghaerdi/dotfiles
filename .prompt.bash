COMMANDS=("uwufetch" "neofetch --pixterm ~/.config/neofetch/yae.jpg" "colorscript -e panes" "colorscript -e blocks1" "colorscript -e spectrum" "colorscript -e bars")
$(shuf -n1 -e "${COMMANDS[@]}")
