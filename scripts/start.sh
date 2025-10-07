#!/usr/bin/env bash
set -euo pipefail

# Output
echo "Starting Jupyter server..."

# If JUPYTER_PASSWORD is set, create a password-protected server.
# Otherwise Jupyter will use its default token auth.
if [[ -n "${JUPYTER_PASSWORD:-}" ]]; then
  HASHED=$(python - <<'PY'
from notebook.auth import passwd
import os
print(passwd(os.environ["JUPYTER_PASSWORD"]))
PY
)
  mkdir -p /home/app/.jupyter
  cat > /home/app/.jupyter/jupyter_server_config.py <<CFG
c = get_config()
c.ServerApp.password = u"${HASHED}"
c.ServerApp.ip = "0.0.0.0"
c.ServerApp.open_browser = False
c.ServerApp.port = 8888
CFG
else
  mkdir -p /home/app/.jupyter
  cat > /home/app/.jupyter/jupyter_server_config.py <<CFG
c = get_config()
c.ServerApp.ip = "0.0.0.0"
c.ServerApp.open_browser = False
c.ServerApp.port = 8888
CFG
fi

# Workspace lives here (already workdir)
mkdir -p /workspace

exec jupyter lab --notebook-dir=/workspace  --allow-root  --ip=0.0.0.0 --port=8888 --no-browser --ServerApp.token='' --ServerApp.password='' --ServerApp.allow_origin='*'