<h1 align=center>JUNO</h1>


<h4 align=center>🚧THIS IS UNDER MAITENANCE 🚧</h4>

<h1 align=center>Index</h1>

[🏠 JUNO](README.md) | [⚙️ Installation](github/INSTALL.md) | [🖼️ Assets](github/ASSETS.md) | [📝 To-Do](#to-do) | [📜 Attributions](#attributions)

---

This is a repo containing the **core files** for my daily driver laptop. I'm currently running *Fedora Workstation 42* with *Hyprland*, however this is subject to change. These are the main applications I use to create my desktop environment.



### *INTRO*

The main idea of this is to be a functional, no nonsense daily driver capable of aiding me in my daily work. This is meant to run in tandem[^1] with my PC, which has its own dedicated repo for parity. Everything in this repo is built and configured for my **ASUS ZenBook.** Specifics can be found below. 

<p1>
It should go without mentioning that I do most of my coding and work on my laptop, so lots of commits.
</p1>

Because of this, the **JUNO** repo will be an ongoing project.



<details>
	<summary>My system specs</summary>

|             Hardware	        |          Specification                                      |
|                 ------               |                ------                                             |
|                 CPU	            |             Intel Core i7-8565U  4.60 GHz        |
|                 GPU	            |             Intel UHD Integrated Graphics        |
|              Memory	        |              16 GB                                             |
|              Storage	            |               1 TB                                              |
|                 WM	            |            Hyprland                                          |          
|               Distro	            |            Fedora 42                                         |
|                Shell               |              Bash                                               |          
|              Display	            |           1920x1080  @ 60fps                         |

</details>

---

### *INSTALLATION*

> **⚠️ Note:**  
> After downloading, you *must* modify the relative config files to point to your own directories for *images, wallpapers, icons,* etc. Not everything works right out of the box right now.

###### Clone repository

```bash

git clone https://github.com/hologramkrypt/juno.git
cd juno

```

### Notes on configuring the system

I have provided in depth information for installing and configuring the system within [the Installation README](github/INSTALL.md). I have also provided alternatives, however substituting dependencies is highly discouraged. I would advise against changing much form the base repository structure.

Information on what I use for my wallpapers, icons, etc can be found in the [assets README](github/ASSETS.md)

---

### *TO-DO*

- [ ] Installation walkthrough
- [ ] Wallust integration throughout applications
- [ ] Connectivity between programs
- [ ] Theming
- [ ] Github beautification

---

### *ATTRIBUTIONS*

This build was inspired in part by [JaKooLit's Hyprland Dots](https://github.com/JaKooLit/Hyprland-Dots), which I found to be a very sturdy framework to build upon. I also would like to give credit to [ThePrimeagen](https://github.com/ThePrimeagen), who's Nvim config I largely based my own config on.


[^1]: I try to make both of these systems work together as much as possible. For example, I use the same Nvim config on both.
