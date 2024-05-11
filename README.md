# LGF_PauseMenu
Simple Pause menu for various Frameworks

<div style="padding: 0 25%;">
    <h3 align="center">Supported Languages</h3>
    <hr style="border-radius: 50px;">
    <p align="center">
        <img src="https://img.shields.io/badge/EN-English-012169">
        <img src="https://img.shields.io/badge/FR-Français-ce1127">
        <img src="https://img.shields.io/badge/DE-Deutsch-ffce00">
    </p>
</div>

## Framework
- LegacyFramework
- ESX
- QB-core

## Dependency
- [OX LIB](https://github.com/overextended/ox_lib) 

## ShowCase
![image](https://github.com/ENT510/LGF_PauseMenu/assets/145626625/ddc78258-439f-41a6-8649-42011c1de1e9)

<hr style="border-radius: 50%; margin: 0 25px;">

## Configuration Files:
- General Configuration: `Convars`
    - Set Server Name, Discord Invite, Language, Debug Mode

```cfg
    setr pausemenu:language en
    setr pausemenu:discordInvite "https://discord.gg/wd5PszPA2p"
    setr pausemenu:serverName "Legacy Framework"
    setr pausemenu:debug "false"
    setr pausemenu:logoutReason "Sei uscito dal gioco"
```

- Translations: `locales/*.json`
    - Follow the given structure, if not you <b>will</b> get errors
