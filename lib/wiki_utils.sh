#!/bin/bash
source ${SCRIPT_DIR}/config/wiki_config

source ${SCRIPT_DIR}/lib/file_utils.sh

set_wiki_sitenotice()
{
  local text=$1
  local regex="^\$wgSiteNotice.*$"

  replace_line_in_file "${regex}" "\$wgSiteNotice = '${text}';" "${MEDIAWIKI_LOCAL_SETTINGS_FILE}"
}
