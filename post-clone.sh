#!/bin/bash
set -e

echo ">>> [1/4] Running apt update..."
sudo apt update
echo ">>> [1/4] apt update done."

echo ">>> [2/4] Installing python3-vcstool..."
sudo apt install python3-vcstool
echo ">>> [2/4] python3-vcstool installed."

echo ">>> [3/4] Importing repos from pushvibes_experiments_dvrk.repos into src..."
mkdir -p src
vcs import src < pushvibes_experiments_dvrk.repos
echo ">>> [3/4] vcs import done."

echo ">>> [4/4] Running colcon build..."
colcon build
echo ">>> [4/4] colcon build done."

echo ">>> post-clone.sh finished successfully."
