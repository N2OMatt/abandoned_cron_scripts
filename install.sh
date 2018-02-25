#!/usr/bin/env sh
##~---------------------------------------------------------------------------##
##                        ____                       _   _                    ##
##                  _ __ |___ \ ___  _ __ ___   __ _| |_| |_                  ##
##                 | '_ \  __) / _ \| '_ ` _ \ / _` | __| __|                 ##
##                 | | | |/ __/ (_) | | | | | | (_| | |_| |_                  ##
##                 |_| |_|_____\___/|_| |_| |_|\__,_|\__|\__|                 ##
##                              www.n2omatt.com                               ##
##  File      : install.sh                                                    ##
##  Project   : TSP                                                           ##
##  Date      : Feb 25, 2018                                                  ##
##  License   : GPLv3                                                         ##
##  Author    : n2omatt <n2omatt@amazingcow.com>                              ##
##  Copyright : n2omatt - 2018                                                ##
##                                                                            ##
##  Description :                                                             ##
##                                                                            ##
##---------------------------------------------------------------------------~##

##----------------------------------------------------------------------------##
## Imports                                                                    ##
##----------------------------------------------------------------------------##
source /usr/local/src/acow_shellscript_utils.sh

##----------------------------------------------------------------------------##
## Vars                                                                       ##
##----------------------------------------------------------------------------##
INSTALL_DIR="/usr/local/bin/n2omatt_cron_scripts";

CRON_DIR="/var/spool/cron";
CRON_FILE="${CRON_DIR}/n2omatt";
TEMP_CRON_FILE="tmp_n2omatt";

CRON_LINES="
    0 * * * * | _INSTALL_DIR_/gitcheck_update_remotes.sh
";

set_error_handling;


##----------------------------------------------------------------------------##
## Script                                                                     ##
##----------------------------------------------------------------------------##
##------------------------------------------------------------------------------
## Install the script files.
echo "$(FG Creating install dir:) ($INSTALL_DIR)";
mkdir -p "$INSTALL_DIR";

echo "$(FG Copying scripts...)";
for FILE in $(ls ./src); do
    cp -v "./src/${FILE}" "$INSTALL_DIR";
done;


##------------------------------------------------------------------------------
## Install the cron tabs.
cat "$CRON_FILE" > "$TEMP_CRON_FILE";

center_text "-";
echo -e "$(FG Installing the cron tabs at:) ($CRON_FILE)";
echo "$CRON_LINES" | while IFS= read -r CRON_LINE; do
    ##--------------------------------------------------------------------------
    ## Empty line - Just continue.
    test -z "$CRON_LINE" && continue;

    ##--------------------------------------------------------------------------
    ## Make the install line include the install directory correctly.
    REPLACED_LINE=$(echo "$CRON_LINE" | sed s@_INSTALL_DIR_@$INSTALL_DIR@g);
    CLEAN_LINE=$(trim "$REPLACED_LINE");

    ##--------------------------------------------------------------------------
    ## Split the components to ease the search on the original cron file.
    SCRIPT_TIME=$(echo "$CLEAN_LINE" | cut -d"|" -f1);
    SCRIPT_PATH=$(trim $(echo "$CLEAN_LINE" | cut -d"|" -f2));

    echo "  -- $(FC Installing crontab for:) ($SCRIPT_PATH)"

    ##--------------------------------------------------------------------------
    ## Remove all lines that match with ones that we're installing.
    GREP_RESULT=$(grep "$SCRIPT_PATH" "$TEMP_CRON_FILE");
    if [ -n "$GREP_RESULT" ]; then
         echo "     $(FY Found:) ($SCRIPT_PATH) - $(BR Removing it.)";
         grep -v "$SCRIPT_PATH" "$TEMP_CRON_FILE" > "${TEMP_CRON_FILE}.grep";
         cp -f "${TEMP_CRON_FILE}.grep" "$TEMP_CRON_FILE";
    fi;

    ##--------------------------------------------------------------------------
    ## Add the new lines. -f is to prevent shell expansion of wildcards.
    set -f
    echo "$SCRIPT_TIME""$SCRIPT_PATH" >> "$TEMP_CRON_FILE";
    set +f
done;
center_text "-";

##------------------------------------------------------------------------------
## Show the final contrab contents...
center_text "$(FG Final crontab file)";
set -f
cat "$TEMP_CRON_FILE";
set +f
center_text "-";

##------------------------------------------------------------------------------
## Replace our temp file to the original crontab.
mv -f "$TEMP_CRON_FILE" "$CRON_FILE"

##------------------------------------------------------------------------------
## Remove the temp files.
rm -rf "$TEMP_CRON_FILE"  "${TEMP_CRON_FILE}.grep";

echo "Done..."