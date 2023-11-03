#!/bin/bash

# Disable NVIDIA persistence daemon
nvidia-smi -pm 0

# Enable VM network
virsh net-start default

# Stop display manager
systemctl stop display-manager

# Start VM
virsh start win11
