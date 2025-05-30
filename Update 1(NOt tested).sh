#!/bin/bash
set -euo

# ─── Configuration ─────────────────────────────────────────────────────────────
LOG_DIR="/var/log/daily-update"
LOCK_FILE="/var/run/daily-system-update.lock"
TIMESTAMP="$(date +'%Y-%m-%d_%H%M')"
LOG_FILE="$LOG_DIR/update_$TIMESTAMP.log"

ESSENTIAL_PACKAGES="git wget curl"
EXCLUDED_LOGS="dpkg.log"    # logs you don’t want removed
# ──────────────────────────────────────────────────────────────────────────────

# Ensure log directory exists
mkdir -p "$LOG_DIR"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "=== Daily System Update started at $(date) ==="

# Acquire lock (prevent concurrent runs)
if [ -e "$LOCK_FILE" ] && kill -0 "$(cat $LOCK_FILE)" 2>/dev/null; then
  echo "Another update is in progress (PID $(cat $LOCK_FILE)). Exiting."
  exit 1
fi
echo $$ > "$LOCK_FILE"

# Helper: cleanup on exit
function finish {
  rm -f "$LOCK_FILE"
  echo "=== Finished at $(date) ==="
}
trap finish EXIT

# ─── 1) System update & upgrade ───────────────────────────────────────────────
echo "--- apt update & upgrade ---"
apt update -y
apt upgrade -y
apt full-upgrade -y

# ─── 2) Snap refresh ───────────────────────────────────────────────────────────
if command -v snap &>/dev/null; then
  echo "--- snap refresh ---"
  snap refresh
fi

# ─── 3) Fix broken installs ───────────────────────────────────────────────────
echo "--- Repairing broken packages if any ---"
apt --fix-broken install -y
dpkg --configure -a

# ─── 4) Clean up apt caches ────────────────────────────────────────────────────
echo "--- Cleaning apt cache ---"
apt autoclean -y
apt autoremove -y

# ─── 5) Optional security-only updates via unattended-upgrades ──────────────────
if dpkg -l | grep -q unattended-upgrades; then
  echo "--- Running unattended-upgrades (security) ---"
  unattended-upgrade -v
fi

# ─── 6) Install essential packages if missing ─────────────────────────────────
echo "--- Ensuring essential packages are installed ---"
for pkg in $ESSENTIAL_PACKAGES[@]; do
  if ! dpkg -s "$pkg" &>/dev/null; then
    echo "Installing $pkg..."
    apt install -y "$pkg"
  fi
done

# ─── 7) Truncate old logs (keep latest 7 days) ─────────────────────────────────
echo "--- Rotating/truncating logs older than 7 days ---"
find "$LOG_DIR" -type f -mtime +7 -print -delete

# ─── 8) Clear /tmp safely ──────────────────────────────────────────────────────
echo "--- Cleaning /tmp ---"
find /tmp -mindepth 1 -maxdepth 1 -mtime +1 -print -exec rm -rf {} \;

# ─── 9) Greeting ───────────────────────────────────────────────────────────────
hour=$(date +'%H')
if [ "$hour" -ge 12 ]; then
  echo "Good Afternoon! Script by Kartik."
else
  echo "Good Morning! Script by Kartik."
fi
