#!/bin/bash
# Launch "RViz web" at container start: a headless X display running RViz2,
# streamed to the browser through x11vnc + noVNC (websockify).
#
# RViz renders with Mesa's software rasterizer (llvmpipe), so no GPU is
# required. The whole pipeline runs as the notebook user, which keeps it
# compatible with both docker-compose and BinderHub.

REPO_DIR="${REPO_DIR:-$HOME/vrb-cable-demo}"
RViz_DISPLAY="${RViz_DISPLAY:-:99}"
RViz_GEOMETRY="${RViz_GEOMETRY:-1280x800x24}"
VNC_PORT="${RViz_VNC_PORT:-5900}"
WEB_PORT="${RViz_WEB_PORT:-6080}"
RViz_CONFIG="${RViz_CONFIG:-${REPO_DIR}/binder/config.rviz}"

# Match the ROS middleware settings used by the CRAM kernel so RViz can
# discover the nodes started by the demo.
export ROS_DOMAIN_ID="${ROS_DOMAIN_ID:-0}"
export RMW_IMPLEMENTATION="${RMW_IMPLEMENTATION:-rmw_fastrtps_cpp}"
export ROS_AUTOMATIC_DISCOVERY_RANGE="${ROS_AUTOMATIC_DISCOVERY_RANGE:-LOCALHOST}"

source "${ROS_PATH:-/opt/ros/jazzy}/setup.bash"
if [ -f "${REPO_DIR}/ros2_ws/install/setup.bash" ]; then
    source "${REPO_DIR}/ros2_ws/install/setup.bash"
fi

export DISPLAY="${RViz_DISPLAY}"
export LIBGL_ALWAYS_SOFTWARE=1
export GALLIUM_DRIVER=llvmpipe

# 1. Virtual X display with software OpenGL.
Xvfb "${RViz_DISPLAY}" -screen 0 "${RViz_GEOMETRY}" \
    +extension GLX +extension RENDER -nolisten tcp &
sleep 2

# 2. RViz showing the daisy cable demo world.
if [ ! -f "${RViz_CONFIG}" ]; then
  echo "start_rviz_web: WARNING — config not found at '${RViz_CONFIG}'; rviz2 will fall back to its package default (Displays sidebar visible, TF enabled)." >&2
else
  echo "start_rviz_web: loading RViz config '${RViz_CONFIG}'"
fi
rviz2 -d "${RViz_CONFIG}" &

# 3. Expose the display over VNC.
x11vnc -display "${RViz_DISPLAY}" -forever -shared \
    -rfbport "${VNC_PORT}" -nopw -quiet &

# 4. Serve noVNC and bridge websockets to the VNC server.
/usr/bin/websockify --web /usr/share/novnc/ "${WEB_PORT}" "localhost:${VNC_PORT}" &

wait
