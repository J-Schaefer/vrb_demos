#!/bin/bash

# CRAM venv python wrapper: sources the ROS 2 environment and the ros2_ws
# workspace overlay before exec'ing the venv interpreter, so a jupyter kernel
# (or any script) using it gets the full ROS environment regardless of how the
# parent process was started.

# Resolve the demo checkout from the authoritative REPO_DIR (baked into the
# image via ENV) rather than $HOME, whose value depends on the runtime user
# (docker-compose runs as root, BinderHub as the notebook user). Export it so
# the notebook's setup cell sees the same path via os.environ["REPO_DIR"].
REPO_DIR="${REPO_DIR:-/home/jovyan/vrb-cable-demo}"
export REPO_DIR

source "${ROS_PATH:-/opt/ros/jazzy}/setup.bash"
if [ -f "${REPO_DIR}/ros2_ws/install/setup.bash" ]; then
    source "${REPO_DIR}/ros2_ws/install/setup.bash"
fi

# Match the simulation's ROS middleware settings
export ROS_DOMAIN_ID="${ROS_DOMAIN_ID:-0}"
export RMW_IMPLEMENTATION="${RMW_IMPLEMENTATION:-rmw_fastrtps_cpp}"
export ROS_AUTOMATIC_DISCOVERY_RANGE="${ROS_AUTOMATIC_DISCOVERY_RANGE:-LOCALHOST}"

exec "${REPO_DIR}/cognitive_robot_abstract_machine/.venv/bin/python" "$@"
