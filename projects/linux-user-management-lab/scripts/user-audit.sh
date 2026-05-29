cat > user-audit.sh <<'EOF'
#!/bin/bash

# ==================================================
# Linux User Management Lab - Audit Script
# ==================================================
# Purpose:
# This script checks the users, groups, permissions,
# and folder structure used in the Linux User
# Management Lab project.
# ==================================================

echo "===== Linux User Management Lab Audit ====="
echo "Generated: $(date)"
echo "Hostname: $(hostname)"
echo "Executed By: $(whoami)"
echo ""

echo "=== User Group Membership ==="
groups alice
groups bob
groups charlie

echo ""
echo "=== Department Directory Permissions ==="
ls -ld ../departments/*

echo ""
echo "=== Project Structure ==="
tree ..

echo ""
echo "Audit complete."
EOF