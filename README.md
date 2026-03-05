# Intro

This is currently just a dockerized, usable cura application, that can be connected to using a browser or VNC.

# Features

- Settings and extensions persist, even after an update of cura
- Web UI available under [localhost:5800](http://localhost:5800) with any browser
- VNC remote connection available under [localhost:5900](http://localhost:5900)
- Works on hosts without a GPU
  - tested on a NAS server with a 5600x and no GPU

# Goal

The goal is automating the slicing process, so files can be put in an `/input` folder and automatically processed versions land in an `/ouput` folder.

The GUI is there, so the user can modify all settings and install extensions to achieve more automation.  
The initial motivation to create this project was cura's incompetence in persisting my user-settings.  
You update cura, settings are gone. You swtich to a new pc, settings gone. You log in to your account, no settings sync.  

# Notes

- Cura version `5.7.0` has a flaw and fails to slice anything, use latest `5.6.0` package instead

# Setup

## Docker container

### Linux

```shell
docker run -d \
  --name doganm95-cura-evolved \
  -e USER_ID=$(id -u) \
  -e GROUP_ID=$(id -g) \
  -p 5800:5800 \
  -p 5900:5900 \
  -v "<desired_data_folder>:/config/xdg/data" \
  -v "<desired_config_folder>:/config/xdg/config" \
  -v "<desired_stl_input_folder>:/app/input" \
  -v "<desired_gcode_output_folder>:/app/output:rw" \
  ghcr.io/doganm95/cura-evolved:latest
```
### WIndows

```powershell
docker run -d `
  --name doganm95-cura-evolved `
  -p 5800:5800 `
  -p 5900:5900 `
  -v "<desired_data_folder>:/config/xdg/data" `
  -v "<desired_config_folder>:/config/xdg/config" `
  -v "<desired_stl_input_folder>:/app/input" `
  -v "<desired_gcode_output_folder>:/app/output:rw" `
  ghcr.io/doganm95/cura-evolved:latest
```

## Versioning

The docker images are versioned by Cura's current tag, e.g. `5.6.0` followed by the current workflow run of this repository, which increases by 1, every time a change in the code happens.
Thus, the version `5.6.0-213` indicates, that the image runs cura `5.6.0` with repository/code changes of run `213` made here.

## Migration

Having cura installed on a personal windows/linux machine, the settings and profiles should be copyable from e.g. `Appdata/Roaming/Cura/5.6/...` to the folders mounted as volumes, to carry over the existing settings to the container.

## Troubleshooting
- **Cura fails to save the gcode into the output folder**
  - Navigate to the output folder on the host system
  - On **Windows**, open folder Properties, go to security tab and allow everything for Everyone and root, save
  - On **Linux**, doing a `sudo chmod 775 ./output` should do the trick
