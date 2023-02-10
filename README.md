# Build with MPLABX and XC32 Github Actions

This action will build a MPLAB X project.

It runs Ubuntu 20.04 and installs the following:

- MPLAB 5.45
- XC32 v3.01
- Harmony v2.02b
- Ruby (2.7.2)

## Inputs

### `project`

**Required** The path to the projec to build (relative to the repository). For example: 'firmware.X'.

### `configuration`

The configuration of the project to build. Defaults to `default`.

### `harmonyAppsFolder`

Harmony apps folder if you want to build inside apps for references

## Outputs

GH Outputs: None.
The finished built files are moved to /github/workspace/output, so they can be used in later steps in the same run.

## Example usage

Add the following `.github/workflows/build.yml` file to your project:

```yaml
name: Build
on: [push]

jobs:
  build:
    name: Build project
    runs-on: ubuntu-latest
    steps:
      - name: Download source
        uses: actions/checkout@v2

      - name: Build library
        uses: 360yieldcenter/ghactions-mplabx-xc32@master
        with:
          project: firmware.X
          configuration: default
          harmonyAppsFolder: some-firmware/firmware
```

## Thanks to
https://github.com/SOUNDBOKS/ghactions-mplabx-xc32/blob/master/README.md
