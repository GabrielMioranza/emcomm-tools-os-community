#!/bin/bash
# Author   : Gaston Gonzalez
# Date     : 4 November 2024
# Updated  : 3 December 2024
# Updated  : 12 March 2026 (added Brazil and United Kingdom support - GabrielMioranza)
# Purpose  : Downloads OSM .pbf file selected by user

# Location to store OSM .pbf files
PBF_MAP_DIR=/etc/skel/my-maps

[ ! -e ${PBF_MAP_DIR} ] && mkdir -v ${PBF_MAP_DIR}

# Step 1: Select country/region
COUNTRY=$(dialog --clear --menu "Select a country/region:" 14 55 5 \
  "us" "United States (state level)" \
  "br" "Brazil (region level)" \
  "uk" "United Kingdom (England/Scotland/Wales)" \
  3>&1 1>&2 2>&3)

exit_status=$?
tput sgr 0 && clear

if [ $exit_status -ne 0 ]; then
  et-log "No country selected. Skipping map download."
  exit 0
fi

# Step 2: Set variables based on country selection
if [ "${COUNTRY}" == "us" ]; then
  HTML=page_us.html
  URL=http://download.geofabrik.de/north-america/us.html
  GEOFABRIK_BASE="http://download.geofabrik.de/north-america"
  HREF_FILTER='href="us/'
  SUBDIR="us"
elif [ "${COUNTRY}" == "br" ]; then
  HTML=page_br.html
  URL=https://download.geofabrik.de/south-america/brazil.html
  GEOFABRIK_BASE="https://download.geofabrik.de/south-america"
  HREF_FILTER='href="brazil/'
  SUBDIR="brazil"
elif [ "${COUNTRY}" == "uk" ]; then
  HTML=page_uk.html
  URL=https://download.geofabrik.de/europe/great-britain.html
  GEOFABRIK_BASE="https://download.geofabrik.de/europe"
  HREF_FILTER='href="great-britain/'
  SUBDIR="great-britain"
fi

# Step 3: Download map listing page if not cached
if [ ! -e ${HTML} ]; then
  et-log "Downloading list of map files from ${URL}..."
  curl -s -L -f -o ${HTML} ${URL}

  if [ $? -ne 0 ]; then
    et-log "Can't download map list from ${URL}. Exiting..."
    exit 1
  fi
fi

et-log "Extracting .pbf file list..."

# Step 4: Parse available .pbf files from the listing page
options=()
while IFS= read -r region_html; do
    region_file=$(echo $region_html | sed -n 's|.*href="\([^"]*\.osm\.pbf\)".*|\1|p')
    region_url="${GEOFABRIK_BASE}/${region_file}"
    region_name=$(echo $region_file | sed "s|${SUBDIR}/||" | sed 's|-latest.osm.pbf||')
    options+=("$region_name" "$region_url")
done < <(grep "[.]pbf" ${HTML} | grep "${HREF_FILTER}" | sort)

# Step 5: Show selection menu
SELECTED_REGION=$(dialog --clear --menu "Select a map file:" 20 80 10 "${options[@]}" 3>&1 1>&2 2>&3)
exit_status=$?

tput sgr 0 && clear

if [ $exit_status -eq 0 ]; then
  download_file="${SELECTED_REGION}-latest.osm.pbf"
  download_url="${GEOFABRIK_BASE}/${SUBDIR}/${download_file}"

  if [ -e ${download_file} ]; then
    et-log "${download_file} already exists. Skipping download."
  else
    et-log "Downloading ${download_url}."
    curl -L -f -O ${download_url}
  fi

  if [ -e ${download_file} ]; then
    navit_osm_bin_file=$(echo ${download_file} | sed 's|pbf|bin|')
    navit_osm_bin_file_path="/etc/skel/.navit/maps/${navit_osm_bin_file}"
    et-log "Generating OSM map for Navit: ${navit_osm_bin_file_path}"
    maptool --protobuf -i ${download_file} ${navit_osm_bin_file_path}

    et-log "Moving OSM .pbf to ${PBF_MAP_DIR}"
    mv -v ${download_file} ${PBF_MAP_DIR}
  fi
fi
