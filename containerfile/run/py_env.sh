set -o nounset
set -o errexit
set -o pipefail

NUM_CPUS=12
TMPDIR=/tmp
export DEBIAN_FRONTEND=noninteractive

# update apt
apt-get -qq update

# install nodejs and npm
apt-get -qq install nodejs npm

# google cloud sdk
apt-get -qq install apt-transport-https ca-certificates gnupg
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" > /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
apt-get -qq update
apt-get -qq install google-cloud-sdk google-cloud-sdk-app-engine-python google-cloud-sdk-app-engine-python-extras

# code-server
wget -qO - https://raw.githubusercontent.com/coder/code-server/main/install.sh | bash

# uv 
curl -LsSf https://astral.sh/uv/install.sh | sh

# Add uv to PATH
export PATH="/root/.local/bin:$PATH"

# Create a virtual environment
uv venv /opt/.venv --python 3.12.1

# Activate the virtual environment
source /opt/.venv/bin/activate

# Install common Python packages with uv
export PATH="$PATH:/root/.cargo/bin"
uv pip install pytest
uv pip install pandas numpy matplotlib seaborn
uv pip install requests
uv pip install python-dotenv
uv pip install ipykernel ipython
uv pip install google-api-python-client google-cloud-logging google-auth google-cloud-bigquery google-cloud-logging google-cloud-storage google-cloud-firestore db-dtypes
uv pip install python-rclone
uv pip install pre-commit

uv tool install ruff 
uv tool install cookiecutter

# cleanup
# update apt
apt-get -qq update

# cleanup
apt-get -qq autoremove
apt-get -qq clean