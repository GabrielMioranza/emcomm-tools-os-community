# EmComm Tools OS Community

> Fork with Ubuntu 24.04 LTS compatibility and Brazil map support.
> Original project: [thetechprepper/emcomm-tools-os-community](https://github.com/thetechprepper/emcomm-tools-os-community) — Documentation: [community.emcommtools.com](https://community.emcommtools.com)

EmComm Tools OS Community (ETC) is a Linux distribution built on Ubuntu for emergency communications using amateur radio digital modes.

---

## Changes in this fork

| Script | Change |
|---|---|
| `install-base.sh` | Auto-detects JDK version (21 on 24.04, 20 as fallback); `steghide` is optional |
| `install-python.sh` | Falls back to Python 3 on Ubuntu 24.04+ (Python 2 not available) |
| `install-js8call.sh` | Handles Qt5 `t64` package renames from 24.04 time_t migration |
| `install-navit.sh` | Handles `libcanberra-gtk-dev` rename; recovers from partial installs |
| `download-osm-maps.sh` | Added Brazil map support (Geofabrik South America regions) |

---

## Requirements

- Ubuntu **22.10** (original) or **24.04 LTS** (this fork)
- Sudo/root access
- Internet connection (several GB of packages will be downloaded)
- ~20 GB of free disk space

---

## Installation

### 1. Download

```bash
wget https://github.com/GabrielMioranza/emcomm-tools-os-community/archive/refs/heads/main.tar.gz
```

### 2. Extract

```bash
tar -xzf main.tar.gz
```

### 3. Enter the scripts directory

```bash
cd emcomm-tools-os-community-main/scripts
```

### 4. Run the installer

```bash
sudo ./install.sh
```

The installer will take **30 minutes to over an hour** depending on your machine and internet speed. During the process, it will prompt you to:

- Select a country and region to download an offline OSM map (**Brazil is supported**)
- Optionally download an offline Wikipedia snapshot (only if `ET_EXPERT` env var is set)

---

## What gets installed

| Category | Tools |
|---|---|
| Digital modes | JS8Call, Fldigi, ARDOP |
| Rig control | Hamlib (rigctld), CAT |
| Packet radio | Dire Wolf, YAAC, Chattervox, QtTermTCP |
| Winlink email | Pat Winlink |
| GPS / time sync | gpsd, chrony |
| SDR | rtl-sdr, dump1090 (ADS-B) |
| Offline maps | Navit, OpenStreetMap (OSM), mbtileserver |
| HF propagation | VOACAP |
| GIS tools | mbutil, mbtileserver, Python GIS stack |
| Runtime | Wine (Windows app support), Java 21, Python 3 |

---

## Downloading Brazilian maps

During installation, when the map selection screen appears:

1. Select **Brazil (region level)**
2. Choose one of the available regions:
   - `norte` — Amazon, Pará, etc.
   - `nordeste` — Bahia, Ceará, Pernambuco, etc.
   - `centro-oeste` — Mato Grosso, Goiás, DF, etc.
   - `sudeste` — São Paulo, Rio de Janeiro, Minas Gerais, etc.
   - `sul` — Paraná, Santa Catarina, Rio Grande do Sul

The selected region will be downloaded from [Geofabrik](https://download.geofabrik.de/south-america/brazil.html), converted to Navit `.bin` format, and stored in `~/.navit/maps/`.

> **Note:** A full region file (e.g. sudeste) can be 500 MB–1.5 GB. Conversion via `maptool` may take 10–30 minutes.

---

## Troubleshooting

**Script fails mid-install**
Re-run `sudo ./install.sh` — most sub-scripts skip steps already completed (downloaded files are cached in `/opt/dist`).

**JS8Call won't launch after install**
Run `apt-get -f install -y` as root to resolve any leftover Qt5 dependency conflicts from the Ubuntu 20.04-targeted `.deb`.

**`et-log` command not found**
The `bootstrap.sh` script must run first. This happens automatically via `install.sh`. If running a sub-script in isolation, run `sudo ./bootstrap.sh` first.

**navit packages fail**
On Ubuntu 24.04, some navit sub-packages may not be available. The installer handles this gracefully — navit core and `maptool` should still be installed.

---

## License

See [LICENSE](LICENSE). Original work by Gaston Gonzalez / [The Tech Prepper](https://community.emcommtools.com).
