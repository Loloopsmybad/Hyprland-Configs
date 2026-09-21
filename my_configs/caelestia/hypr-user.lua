-- Use hyprlock as lock screen: Super+L locks with hyprlock + video background
hl.bind("SUPER + L", hl.dsp.exec_cmd("pkill mpvpaper ; mpvpaper -l top -vs -o 'no-audio loop' '*' ~/Pictures/New\\ Folder/bg.mp4 -f ; sleep .5 ; hyprlock ; pkill mpvpaper"))
