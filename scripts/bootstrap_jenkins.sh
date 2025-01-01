#!/usr/bin/bash

HOME="/root/homelab_jenkins"

echo -e "\n==> [LXC] DEBUG"
echo "id = $(id)"
echo "pwd = $(pwd)"
echo "HOME = $HOME"


###################################################################
### Prep OS
echo -e "\n==> [LXC] Set locales"
sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen
locale-gen

### https://docs.docker.com/engine/install/debian/
echo -e "\n==> [LXC] Install docker"
# apt update ### This just happened in the other script
apt install -y ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin


###################################################################
### Prepare files for launch
echo -e "\n==> [LXC] Generate SSH key to connect agents"
KEYS_DIR="$HOME/jenkins_agent_keys"
if [ ! -f "$KEYS_DIR/id_rsa" ]; then
    mkdir $KEYS_DIR
    ssh-keygen -t rsa -b 4096 -f "$KEYS_DIR/id_rsa" -N ""
    chmod 600 "$KEYS_DIR/id_rsa"
    chmod 644 "$KEYS_DIR/id_rsa.pub"
else
    echo -e "\n==> [LXC] SSH keys already exist. Skipping key generation."
fi

echo -e "\n==> [LXC] Template Jenkins config file"
JENKINS_CONFIG=$HOME/config_as_code/jenkins.yml
cp $HOME/templates/jenkins.template.yml $JENKINS_CONFIG

sed -i "s|__JENKINS_IP__|$(hostname -i)|g" $JENKINS_CONFIG
PRIV_KEY=$(grep -v 'OPENSSH PRIVATE KEY' $HOME/jenkins_agent_keys/id_rsa | xargs echo | sed 's|\ ||g')
# echo "PRIV_KEY=$PRIV_KEY"
sed -i "s|__SSH_CRED_PRIVATE_KEY__|$PRIV_KEY|g" $JENKINS_CONFIG



###################################################################
### Launch
echo -e "\n==> [LXC] Docker compose pull"
docker compose pull

echo -e "\n==> [LXC] Docker compose build"
docker compose build

echo -e "\n==> [LXC] Docker compose up"
docker compose up -d

URL="http://$(hostname -i):8080"
echo -e "\n==> [LXC] Success! Your new Jenkins instance should be available at $URL"

echo -e "\n==> [LXC] Sleeping 5 seconds while Jenkins starts..."
sleep 5

echo -e "\n==> [LXC] Show initial admin password"
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
