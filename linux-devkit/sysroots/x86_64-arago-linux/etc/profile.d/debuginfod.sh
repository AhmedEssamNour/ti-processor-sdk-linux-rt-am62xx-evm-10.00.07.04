# $HOME/.profile* or similar files may first set $DEBUGINFOD_URLS.
# If $DEBUGINFOD_URLS is not set there, we set it from system *.url files.
# $HOME/.*rc or similar files may then amend $DEBUGINFOD_URLS.
# See also [man debuginfod-client-config] for other environment variables
# such as $DEBUGINFOD_MAXSIZE, $DEBUGINFOD_MAXTIME, $DEBUGINFOD_PROGRESS.

if [ -z "$DEBUGINFOD_URLS" ]; then
    prefix="/home/aessam/ti-processor-sdk-linux-rt-am62xx-evm-10.00.07.04/linux-devkit/sysroots/x86_64-arago-linux/usr"
    DEBUGINFOD_URLS=$(cat /dev/null "/home/aessam/ti-processor-sdk-linux-rt-am62xx-evm-10.00.07.04/linux-devkit/sysroots/x86_64-arago-linux/etc/debuginfod"/*.urls 2>/dev/null | tr '\n' ' ')
    [ -n "$DEBUGINFOD_URLS" ] && export DEBUGINFOD_URLS || unset DEBUGINFOD_URLS
    unset prefix
fi
