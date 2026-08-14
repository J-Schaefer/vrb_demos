#!/bin/bash

# Start RViz web (headless RViz + noVNC) before JupyterLab comes up, so the
# robot visualization is ready as soon as the user opens the browser.
if [ -x /usr/local/bin/start_rviz_web.sh ]; then
    /usr/local/bin/start_rviz_web.sh >/tmp/start_rviz_web.log 2>&1 &
fi

# The following line will allow the binderhub start Jupyterlab, should be at the end of the entrypoint.
exec "$@"
