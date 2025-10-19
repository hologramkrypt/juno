# <div align="center">JUNO</div>

### <div align="center">🚧 THIS IS UNDER MAINTENANCE 🚧</div>

This repository contains the **core files** for my daily driver laptop.  
Currently running *Fedora Workstation 42* with *Hyprland* — subject to change.  
These are the main applications I use to create my desktop environment.

---

## <div align="center">Index</div>

<div align="center">

[⚙️ Installation](INSTALL.md) • [🖼️ Assets](ASSETS.md) • [📝 To-Do](#to-do) • [📜 Attributions](#attributions)

</div>

### *Intro*

The main idea is to have a functional, no-nonsense daily driver capable of aiding me in my daily work.  
This runs in tandem[^1] with my PC, which has its own dedicated repo for parity.  
Everything here is configured for my **ASUS ZenBook**. Specifics below.

> I do most of my coding and work on my laptop, so lots of commits.  
> The **JUNO** repo will be an ongoing project.

<details>
<summary>My system specs</summary>

| Hardware | Specification |
|-----------|----------------|
| CPU | Intel Core i7-8565U  4.60 GHz |
| GPU | Intel UHD Integrated Graphics |
| Memory | 16 GB |
| Storage | 1 TB |
| WM | Hyprland |
| Distro | Fedora 42 |
| Shell | Bash |
| Display | 1920×1080 @ 60 Hz |

</details>

---

### *Installation*

> **⚠️ Note:**  
> After downloading, you *must* modify relative config paths for *images, wallpapers, icons,* etc.  
> Not everything works out of the box yet.

**Clone repository:**

    git clone https://github.com/hologramkrypt/juno.git
    cd juno

**Configuration notes:**  
Detailed setup instructions are in [Installation README](INSTALLATION.md).  
Avoid substituting dependencies; the base repo structure is intentional.  
Info on wallpapers, icons, etc. is in [Assets README](ASSETS.md).

---

### *To-Do*

- [ ] Installation walkthrough  
- [ ] Wallust integration throughout applications  
- [ ] Connectivity between programs  
- [ ] Theming  
- [ ] GitHub beautification  

---

### *Attributions*

Inspired in part by [JaKooLit's Hyprland Dots](https://github.com/JaKooLit/Hyprland-Dots).  
Thanks also to [ThePrimeagen](https://github.com/ThePrimeagen) for Nvim configuration inspiration.

<p align="center">
    Built in the graveyard // <strong>hologramkrypt</strong> \\ |  saturni
</p>

[^1]: Both systems share configurations (e.g., same Nvim setup) for cross-device parity.
