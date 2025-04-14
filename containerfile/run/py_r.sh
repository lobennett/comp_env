set -o nounset
set -o errexit
set -o pipefail

NUM_CPUS=12
TMPDIR=/tmp
export DEBIAN_FRONTEND=noninteractive

# update apt
apt-get -qq update
apt-get -qq install wget gpg lsb-release

# Install R 
wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | gpg --dearmor -o /usr/share/keyrings/r-project.gpg
echo "deb [signed-by=/usr/share/keyrings/r-project.gpg] https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/" | tee /etc/apt/sources.list.d/r-project.list
apt-get -qq update
apt-get -qq install --no-install-recommends r-base r-base-dev

# install nodejs and npm
# apt-get -qq install nodejs npm

# google cloud sdk
# apt-get -qq install apt-transport-https ca-certificates gnupg
# echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" > /etc/apt/sources.list.d/google-cloud-sdk.list
# curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
# apt-get -qq update
# apt-get -qq install google-cloud-sdk google-cloud-sdk-app-engine-python google-cloud-sdk-app-engine-python-extras

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
uv pip install python-rclone
uv pip install pre-commit

# Neuroimaging packages
uv pip install nilearn
uv pip install rpy2

# cleanup
# update apt
apt-get -qq update

# cleanup
apt-get -qq autoremove
apt-get -qq clean

# Create R library directory and set permissions
mkdir -p /usr/local/lib/R/site-library
chmod -R 777 /usr/local/lib/R/site-library

# Install basic R packages as root
R --no-save << EOF
install.packages('psych', repos='https://cloud.r-project.org/')
install.packages('ggplot2', repos='https://cloud.r-project.org/')
install.packages('paran', repos='https://cloud.r-project.org/')
EOF

# You can also add useful aliases to the bashrc
echo "alias c='clear'" >> ~/.bashrc