<br>
<div align="center">
    <h1>Linux Dotfiles</h1>
    <h3>My Desktop Configuration</h3>
</div>
<br>

<img src="./screenshots/showcase.gif" alt="Showcase">

## 🎨 Choosing a Theme

You can execute the script `set_theme.sh [num]` to manually set a theme, where `1` == 🌄 gruvbox, `2` == 🏙️ everforest and `3` == 🌆 dracula. Alternatively, you can set up a cronjob with environment variables to change the theme based on the time of the day. Example:

```bash
0 7,14,19 * * * $HOME/path/to/script/set_theme.sh  # This will change the theme everyday at 7:00, 14:00 and 19:00. Remember to set up env vars.
```

## 🖇️ Dependencies

You can read about the packages I use on the [wiki](https://github.com/edu-flores/linux-dotfiles/wiki). To easily set up the dotfiles you can run `link_files.sh` to make the necessary symlinks.

## ⌨️ Bindings

Show application launcher
```bash
bindsym $mod+space exec rofi -show drun
```

Show opened windows
```bash
bindsym Mod1+Tab exec rofi -show window
```

Launch snipping tool
```bash
bindsym Print exec flameshot gui
```
