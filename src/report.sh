##~---------------------------------------------------------------------------##
##                        ____                       _   _                    ##
##                  _ __ |___ \ ___  _ __ ___   __ _| |_| |_                  ##
##                 | '_ \  __) / _ \| '_ ` _ \ / _` | __| __|                 ##
##                 | | | |/ __/ (_) | | | | | | (_| | |_| |_                  ##
##                 |_| |_|_____\___/|_| |_| |_|\__,_|\__|\__|                 ##
##                              www.n2omatt.com                               ##
##  File      : report.sh                                                     ##
##  Project   :                                                               ##
##  Date      : Feb 27, 2018                                                  ##
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
## Functions                                                                  ##
##----------------------------------------------------------------------------##
get_report_file_path()
{
    local PROGRAM_NAME="$1";

    local CURR_DATE=$(date +"%Y_%m_%d_%H_%M_%S");
    local USER_HOME="$(get_user_home n2omatt)";
    local REPORT_DIR="$USER_HOME/.cron_scripts/$PROGRAM_NAME";
    local REPORT_FILE="$REPORT_DIR/$CURR_DATE";

    ##--------------------------------------------------------------------------
    ## Create the report directory - We want it tidy.
    mkdir -p "$REPORT_DIR";

    ##--------------------------------------------------------------------------
    ## Create the report file.
    touch "$REPORT_FILE";

    echo "$REPORT_FILE";
}