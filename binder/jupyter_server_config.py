# RViz web: proxy the /rviz route to the noVNC/websockify server that
# start_rviz_web.sh starts on port 6080. Appended to
# /etc/jupyter/jupyter_server_config.py at build time.
c.ServerProxy.servers = {
    "rviz": {
        "port": 6080,
        "launcher_entry": {
            "title": "RViz",
            "path_info": "rviz/",
        },
    },
}
