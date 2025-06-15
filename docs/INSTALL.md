# Installation

## Installing Source SDK Base Resources

### 1. Go to [Releases](https://github.com/Source-SDK-Base-Legacy-Project/Source-SDK-Base-Resources/releases)

### 2. Choose the installation type

There are 3 install types of Source SDK Base Resources:

| Type | Used for | Requires |
| --- | --- | --- |
| Only 2006 | Patching only Source SDK Base 2006 | Source SDK Base 2006 |
| Only 2007 | Patching only Source SDK Base 2007 | Source SDK Base 2006 and 2007 |
| Full | Patching both Source SDK Base 2006 and 2007 | Source SDK Base 2006 and 2007 |

### 3. Download the tool

### 4. Install Wizard

Run the installer and follow the steps.

#### Step 1: License

You need to accept the license.

#### Step 2: Select Install location

Select where *Source SDK Base Resources* will be installed.

#### Step 3: Select Shared folder

Select where all shared content will be installed.

#### Step 4: Choose Components to install

Choose which component(s) to install.

**Source Content Installer**: Select this option if you want to [install content using GUI](content-installation-gui.md).

> **Note:** The installer automatically detects installed Source games.
>
> **Note:** Some components require specific Source games to be installed. Move your cursor over a component to see what's required.  
>
> **Note:** If you see grayed components, it means you don't have the required game(s) installed.

#### Step 5: Installation

Wait until the installation is complete. Then, click *Close*.

> **Note:** If you chose <i>Only 2007</i> installation type, you can uninstall Source SDK Base 2006.

### 5. Install Source Content

#### install content using GUI

See [Installing content using GUI](content-installation-gui.md)

#### Install content using CLI

1. Launch PowerShell in **Administrator mode**
2. Go to your *Source SDK Base Resources* install location:

   ```powershell
   cd "<Install Location>/scripts"
   ```

3. Run any [content installation script](content-installation-cli.md)

## Uninstalling Source SDK Base Resources

1. Go to your *Source SDK Base Resources* install location.
2. Run *Uninstall.exe*
3. Follow the uninstall steps.

### Uninstall Wizard

#### Step 1: Uninstall location

Click *Next*.

#### Step 2: Components

Choose which component(s) to uninstall.

**Shared folder**: Select this option if you want to delete the shared folder.
