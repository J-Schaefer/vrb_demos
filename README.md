# From URDF to a Semantic Digital Twin

Hands-on tutorial for the IJCAI 2026 workshop, built on the
[Semantic Digital Twin](https://github.com/cram2/cognitive_robot_abstract_machine) (part of the
CRAM cognitive architecture).

[![Binder](https://binder.intel4coro.de/badge_logo.svg)](https://binder.intel4coro.de/v2/gh/yxzhan/ijcai_2026_workshop/HEAD?urlpath=lab%2Ftree%2Fnotebooks%2Ffrom_urdf_to_semantic_world.ipynb)

Click the badge — everything runs in your browser, nothing to install.

## What this tutorial is about

A URDF tells a robot **where** every link is. It does not tell the robot **what** any of them is.
"Open the drawer" is not a question a URDF can answer.

In 90 minutes you take a plain apartment URDF and turn it into a world a robot can reason about:

0. **Setup** — launch the environment, select the `CRAM` kernel.
1. **What URDF can and cannot tell a robot** — load the apartment and watch two reasonable
   heuristics both return 25 drawers, disagree about which 25, and both be wrong.
2. **Saying what things are** — build a dresser out of typed semantic annotations
   (`Drawer`, `Handle`, `Slider`) and pull one of its drawers open.
3. **Not annotating by hand** — let the `WorldReasoner` find the drawers itself, then make it
   explain, in English, why it thinks they are drawers.
4. **Asking questions** — query the annotated apartment with the Entity Query Language.
5. **Teaching the reasoner** — the shipped rules define a drawer as something with a handle, so
   they find 19 of the apartment's 23. Find the four they miss, work out why, and write the
   Ripple-Down rule that fixes it.

Exercises check themselves as you go; worked answers are in `notebooks/solutions.ipynb`.

## Prerequisites

You should be comfortable with Python and have seen a URDF before (links, joints, meshes). No
prior knowledge of CRAM, ontologies, or rule-based reasoning is assumed.

If you want the URDF refresher first, the predecessor of this tutorial is
[EASE Fall School 2024 — Creating an Environment URDF](https://github.com/IntEL4CoRo/ease_fall_school_2024).

## Running it locally

```bash
git clone --recursive https://github.com/yxzhan/ijcai_2026_workshop.git
cd ijcai_2026_workshop
docker compose -f binder/docker-compose.yml up --build
```

Then open <http://localhost:8888> and pick the **CRAM** kernel.

## Where to go next

The Semantic Digital Twin ships a full Jupyter Book — 17 worked examples, concept chapters, and
self-assessment quizzes — under `cognitive_robot_abstract_machine/semantic_digital_twin/doc/`.
