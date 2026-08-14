# DAiSy Cable Rehang — Virtual Research Building demo

A browser-only demo of the DAiSy dual-arm robot rehanging a cable, built on
[CoraPlex](https://github.com/cram2/cognitive_robot_abstract_machine) (part of the CRAM
cognitive architecture) and running on the
[Semantic Digital Twin](https://github.com/cram2/cognitive_robot_abstract_machine).

[![Binder](https://binder.intel4coro.de/badge_logo.svg)](https://binder.intel4coro.de/v2/gh/J-Schaefer/vrb_demos/HEAD?urlpath=lab%2Ftree%2Fnotebooks%2Fdaisy_cable_demo.ipynb)

Click the badge — everything runs in your browser, nothing to install.

## What you get

When the container starts it launches two things:

- **RViz web** — RViz2 running on a headless display, streamed to the browser via
  noVNC. Open the **RViz** launcher entry (or *Launcher → RViz*) to watch the robot.
- **JupyterLab** — the `daisy_cable_demo` notebook is pre-loaded.

In the notebook, switch to the **CRAM** kernel, then press **Launch Demo**. The plan
(home the arms, grasp the cable, regrasp, rehang) runs in **simulation**: the DAiSy
robot, cable hanger and cable are built from the DAiSy URDF and the motions are executed
by Giskard with no real hardware.

## Running it locally

```bash
git clone --recursive https://github.com/J-Schaefer/vrb_demos.git
cd vrb_demos
docker compose -f binder/docker-compose.yml up --build
```

Then open:

- <http://localhost:8888> — JupyterLab (pick the **CRAM** kernel), and
- <http://localhost:6080/vnc_lite.html> — RViz web (direct noVNC access).
