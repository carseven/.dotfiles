---
title: NuPhy Air60 V2 setup
description: Load the repository's VIA definition and custom layout into the NuPhy Air60 V2.
---

This guide loads the NuPhy Air60 V2 VIA definition and keymap stored in this repository.
Use a supported browser and connect the keyboard before opening VIA.

## Load the VIA definition

1. Open [VIA](https://usevia.app/).
2. Connect the NuPhy Air60 V2.
3. Open **Settings** and enable **Show Design tab**.

   ![VIA settings with the Design tab enabled](./images/enable-design-tab.png)

4. Open the **Design** tab and load [`nuphy-air60-v2-via.json`](https://github.com/carseven/.dotfiles/blob/main/doc/keyboards/nuphy-air60v2/nuphy-air60-v2-via.json).

   ![VIA Design tab with the keyboard definition loaded](./images/load-keyboard-via-config.png)

## Load the custom keymap

1. Open the **Configure** tab.
2. Load [`nuphy_air60_v2.layout.json`](https://github.com/carseven/.dotfiles/blob/main/doc/keyboards/nuphy-air60v2/nuphy_air60_v2.layout.json) as the keyboard layout.

   ![VIA layout configuration controls](./images/layout-save-tab.png)

   ![VIA control for loading a layout configuration](./images/load-keyboard-layout-config.png)

3. Review the keys in VIA before using the keyboard. Loading a layout changes the keyboard mapping.
4. If you change the layout, save the updated JSON file in your fork so you can restore it later.

   ![VIA control for saving the layout configuration](./images/save-keyboard-layout-config.png)
