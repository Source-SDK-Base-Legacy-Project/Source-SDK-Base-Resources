# BUILDING

## Supported Platforms

See [supported platforms](README.md#Supported-Platforms).

## Prerequisites

Everything listed in [built with](README.md#Built-With) with the same version, or higher.

## Configuring CMake

1. The following variables must be configured.

   - `DEV_SHARED_FOLDER`: Content install location in development mode. e.g.

     ```text
     C:\Users\<USER>\Desktop\shared_folder
     ```

2. Click *Configure*

## Building Source SDK Base Resources installers

1. Go to *Installer* directory
2. Open a command prompt (`cmd`)
3. Run the following scripts:

   Only 2006 :

   ```bat
   build_2006_installers.bat
   ```

   Only 2007 :

   ```bat
   build_2007_installers.bat
   ```

   Full :

   ```bat
   build_full_installers.bat
   ```

   All (Only 2006, Only 2007, Full) :

   ```bat
   build_all.bat
   ```

## Building SourceContentInstaller installers

1. Go to *Installer\SourceContentInstaller* directory
2. Open a command prompt (`cmd`)
3. Run the following scripts:

   Only 2006 :

   ```bat
   build_2006_installers.bat
   ```

   Only 2007 :

   ```bat
   build_2007_installers.bat
   ```

   Full :

   ```bat
   build_full_installers.bat
   ```

   All (Only 2006, Only 2007, Full) :

   ```bat
   build_all.bat
   ```
