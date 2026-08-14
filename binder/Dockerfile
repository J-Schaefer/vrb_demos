# Dockerfile of the base image: https://github.com/IntEL4CoRo/jupyter-ros2
FROM intel4coro/jupyter-ros2:jazzy-py3.12

# Install UV (builds the giskard venv below)
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
#===========================================================#

# VSCode extension to view the simulation desktop from code-server
RUN curl -LO https://github.com/yxzhan/vscode_remote_desktop/releases/download/v0.1.0/vscode-remote-desktop-0.1.0.vsix && \
    code-server --install-extension vscode-remote-desktop-0.1.0.vsix && \
    rm vscode-remote-desktop-0.1.0.vsix

# Python packages for the jupyter env (rarely changes).
USER ${NB_USER}
COPY --chown=${NB_USER}:users binder/requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

ENV REPO_DIR=${HOME}/vrb-cable-demo
RUN mkdir -p ${REPO_DIR}
COPY --chown=${NB_USER}:users cognitive_robot_abstract_machine ${REPO_DIR}/cognitive_robot_abstract_machine
RUN git config --global --add safe.directory ${REPO_DIR}/cognitive_robot_abstract_machine

RUN cd ${REPO_DIR}/cognitive_robot_abstract_machine && \
    ~/.local/bin/uv sync && \
    .venv/bin/pip install nest_asyncio argcomplete usd-core ipywidgets

RUN sudo apt-get update && \
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends git-lfs && \
    git lfs install && \
    OVERLAY_WS=${REPO_DIR}/ros2_ws \
        bash ${REPO_DIR}/cognitive_robot_abstract_machine/.github/docker/setup_ros_workspace.sh && \
    sudo rm -rf /var/lib/apt/lists/*

# Headless RViz-in-the-browser stack: Xvfb (software GL), x11vnc, noVNC.
RUN sudo apt-get update && \
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        xvfb x11vnc novnc && \
    sudo rm -rf /var/lib/apt/lists/*

COPY --chown=${NB_USER}:users binder/cram_python_wrapper.sh /home/jovyan/.local/bin/cram_python_wrapper.sh
RUN chmod +x /home/jovyan/.local/bin/cram_python_wrapper.sh
RUN mkdir -p /opt/conda/share/jupyter/kernels/cram
COPY --chown=${NB_USER}:users binder/cram-kernel.json /opt/conda/share/jupyter/kernels/cram/kernel.json
COPY --chown=${NB_USER}:users binder/start_rviz_web.sh /usr/local/bin/start_rviz_web.sh
COPY --chown=${NB_USER}:users binder/novnc/index.html /usr/share/novnc/index.html
COPY --chown=${NB_USER}:users binder ${REPO_DIR}/binder
COPY --chown=${NB_USER}:users notebooks ${REPO_DIR}/notebooks

# Register the RViz web proxy route with jupyter-server-proxy.
COPY --chown=${NB_USER}:users binder/jupyter_server_config.py /tmp/jupyter_server_config_rviz.py
RUN sudo sh -c 'cat /tmp/jupyter_server_config_rviz.py >> /etc/jupyter/jupyter_server_config.py' && \
    rm /tmp/jupyter_server_config_rviz.py

RUN git config --global --add safe.directory ${REPO_DIR}

# Set Jupyterlab default directory
WORKDIR ${REPO_DIR}

# Set VSCODE default directory
ENV CODE_WORKING_DIRECTORY=${REPO_DIR}

# The entrypoint of the docker image
COPY --chown=${NB_USER}:users binder/entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
