<h1 align=center>INSTALLATION GUIDE</h1>

Here you will find all the information you will need for installing dependencies, widgets, and tools, as well as configuring the system.

---

##### Required repositories

```bash
# RPM Fusion
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Hyprland Utilities
sudo dnf copr enable solopasha/hyprland
```

### Required Dependencies


|    Program   |   Purpose   | Site |
| ------------ | ----------- | ---- |
| [copyq]() | clipboard manager | [🧩](https://hluk.github.io/CopyQ/) |
| [fastfetch]() | system info grabber | [🧩](https://github.com/fastfetch-cli/fastfetch) |
| [grim]() | screenshot grabber | [🧩](https://github.com/emersion/grim) |
| [hyprwm]() | window manager | [🧩](https://github.com/hyprwm/Hyprland) |
| [obsidian]() | note taking app | [🧩](https://obsidian.md/) |
| [joplin]() | alternative note taking app | [🧩](https://joplinapp.org/) |
| [kitty]() | terminal | [🧩](https://sw.kovidgoyal.net/kitty/) |
| [gimp]() | photo manipulator | [🧩](https://www.gimp.org/downloads/) |
| [nvim]() | text editor | [🧩](https://neovim.io/) |
| [rofi]() | application launcher | [🧩](https://github.com/davatorium/rofi) |
| [swaync]() | notification handler | [🧩](https://github.com/ErikReider/SwayNotificationCenter) |
| [wallust]() | color sourcing | [🧩](https://codeberg.org/explosion-mental/wallust) |
| [wlogout]() | logout manager | [🧩](https://github.com/ArtsyMacaw/wlogout) |
| [nwg-look]() | GTK theme manager | [🧩](https://nwg-piotr.github.io/nwg-shell/nwg-look.html) |


#### Install command

> **⚠️ Note:**  
> Refer to program-specific files to apply my configurations. You can also install them yourself to configure to your liking.

- *dnf* install
```bash

sudo dnf install 

```

</details>

> **⚠️ Note:**  
> Certain dependencies can be substituted (ie. *swaybg* for *hyprpaper* or *feh*), however it is discouraged.

<details>
	<summary>Optional Dependencies</summary>

>   Linked below are the official pages for all optional dependencies. Substituting these is fine. ***Click the name of the dependency to jump down the page to the install instructions.***

| Program | Purpose | Site |
| --- | --- | --- |
| [zed]() | alternative text editor | [🧩](https://zed.dev/) |
| [nm-applet]() | network manager | [🧩](https://wiki.archlinux.org/title/NetworkManager) |
| [pavucontrol]() | audio controller | [🧩](https://www.freedesktop.org/software/pulseaudio/pavucontrol/) |
| [blueman]() | bluetooth device manager | [🧩](https://wiki.archlinux.org/title/Blueman) |
| [btop]() | resource monitor | [🧩](https://www.tecmint.com/btop-system-monitoring-tool-for-linux/) |
| [htop]() | process viewer | [🧩](https://htop.dev/) |
| [cava]() | audio visualizer | [🧩](https://github.com/nerdnoise/cava) |
| [chafa]() | ASCII / ANSI art renderer | [🧩](https://hpjansson.org/chafa/) |
| [vifm]() | terminal based filebrowser | [🧩](https://vifm.info/) |
| [mpv]() | alternative video player | [🧩](https://mpv.io/) |
| [cmatrix]() | matrix terminal effect | [🧩](https://github.com/abishekvashok/cmatrix) |

</details>

---

### Installation

### Configuration
