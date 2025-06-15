# Development

## Prerequisites

- [Supported platforms](../README.md#Supported-Platforms)
- Everything listed in [built with](../README.md#Built-With) with the same version, or higher.

## Setup

### 1. Clone the repository

```text
git clone https://github.com/Source-SDK-Base-Legacy-Project/Source-SDK-Base-Resources.git
```

### 2. Configure CMake

1. The following variables must be configured.

   - `DEV_SHARED_FOLDER`: Content install location in development mode. e.g.

     ```text
     C:\Users\<USER>\Desktop\shared_folder
     ```

2. Click *Configure*

## Running content installation scripts

1. Go to *scripts* directory
2. Open a PowerShell prompt (`powershell.exe`)
3. Run any [content installation script](content-installation-cli.md)

## Building

- [Building Source SDK Base Resources installers](BUILDING.md#building-source-sdk-base-resources-installers)
- [Building SourceContentInstaller installers](BUILDING.md#building-sourcecontentinstaller-installers)

## Testing

- [Running tests](TESTING.md#running-tests)
- [Running Code Coverage](TESTING.md#running-code-coverage)
