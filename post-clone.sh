#!/bin/bash
set -e

echo ">>> [1/7] Running apt update..."
sudo apt update
echo ">>> [1/7] apt update done."

echo ">>> [2/7] Installing python3-vcstool and python3-rosdep..."
sudo apt install python3-vcstool python3-rosdep
echo ">>> [2/7] python3-vcstool and python3-rosdep installed."

echo ">>> [3/7] Importing repos from pushvibes_experiments_dvrk.repos into src..."
mkdir -p src
vcs import src < pushvibes_experiments_dvrk.repos
echo ">>> [3/7] vcs import done."

echo ">>> [4/7] Adding COLCON_IGNORE to non-ROS repos in src..."
for d in src/*/; do
    if [ ! -f "$d/package.xml" ]; then
        touch "$d/COLCON_IGNORE"
        echo "    ignored $d"
    fi
done
echo ">>> [4/7] COLCON_IGNORE step done."

echo ">>> [5/7] Initializing rosdep (skipped if already initialized)..."
if [ ! -f /etc/ros/rosdep/sources.list.d/20-default.list ]; then
    sudo rosdep init
fi
echo ">>> [5/7] rosdep init done."

echo ">>> [6/7] Updating rosdep and installing ROS package dependencies..."
rosdep update
rosdep install --from-paths src --ignore-src -y --rosdistro "${ROS_DISTRO:-jazzy}"
echo ">>> [6/7] rosdep install done."

echo ">>> [7/7] Running colcon build..."
colcon build
echo ">>> [7/7] colcon build done."

echo ">>> post-clone.sh finished successfully."
