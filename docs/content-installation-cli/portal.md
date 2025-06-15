# Portal

## Prerequisites

- Source SDK Base 2007
- [Portal](https://store.steampowered.com/app/400/Portal/)

## Base content

### Install

```powershell
.\Portal.ps1 -Base
```

### Uninstall

```powershell
.\Portal.ps1 -Base -Uninstall
```

## Maps content

### Install

```powershell
.\Portal.ps1 -Maps
```

### Uninstall

```powershell
.\Portal.ps1 -Maps -Uninstall
```

## Localisation

<details>
  <summary><b>Supported Languages</b></summary>

| language | Decription | Required VPK |
|:--|:--|:--|
| french | French | portal_sound_vo_french_dir.vpk |
| german | German | portal_sound_vo_german_dir.vpk |
| russian | Russian | portal_sound_vo_russian_dir.vpk |
| spanish | Spanish | portal_sound_vo_spanish_dir.vpk |

</details>

### Install

```powershell
.\Portal.ps1 -Language <language>
```

### Uninstall

```powershell
.\Portal.ps1 -Language <language> -Uninstall
```

## All content

### Install

```powershell
.\Portal.ps1 -All
```

### Uninstall

```powershell
.\Portal.ps1 -All -Uninstall
```
