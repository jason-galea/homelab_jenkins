#!/usr/bin/bash


# HOME="/root/homelab_jenkins"
HOME="$(pwd)"
# IP=$(hostname -i | xargs)
IP=$(hostname -I | xargs)

# echo -e "\n==> [LXC] DEBUG"
# echo "id = $(id)"
# echo "pwd = $(pwd)"
# echo "HOME = $HOME"
# echo "IP = $IP"


###################################################################
### Prepare jenkins.yml
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
JENKINS_CONFIG_DIR=$HOME/config_as_code/jenkins_config
JENKINS_CONFIG_SECRETS_DIR=$JENKINS_CONFIG_DIR/secrets
JENKINS_CONFIG_YML=$JENKINS_CONFIG_DIR/jenkins.yml
if [ ! -f $JENKINS_CONFIG_DIR ]; then
    mkdir -p $JENKINS_CONFIG_SECRETS_DIR
fi
# cp $HOME/templates/jenkins-dind.template.yml $JENKINS_CONFIG
cp $HOME/templates/jenkins.template.yml $JENKINS_CONFIG_YML

### SSH keys for agents
sed -i "s|__JENKINS_IP__|$IP|g" $JENKINS_CONFIG_YML
PRIV_KEY=$(grep -v 'OPENSSH PRIVATE KEY' $HOME/jenkins_agent_keys/id_rsa | xargs echo | sed 's|\ ||g')
# echo "PRIV_KEY=$PRIV_KEY"
sed -i "s|__SSH_CRED_PRIVATE_KEY__|$PRIV_KEY|g" $JENKINS_CONFIG_YML


###################################################################
### Prepare github PAT
echo -e "\n==> [LXC] Copy github PAT to secrets dir"
cp $HOME/secrets/jenkins_github_pat $JENKINS_CONFIG_SECRETS_DIR/jenkins_github_pat

###################################################################
### Launch
echo -e "\n==> [LXC] Docker compose pull"
docker compose pull

echo -e "\n==> [LXC] Docker compose build"
docker compose build

echo -e "\n==> [LXC] Docker compose up"
docker compose up -d

### TODO: verify container healthy?

# echo -e "\n==> [LXC] Sleeping 5 seconds while Jenkins starts..."
# sleep 5

### TODO: Loop to check if file exists first
echo -e "\n==> [LXC] Wait for Jenkins to start..."
while true; do

    if [ $(docker exec jenkins ls /var/jenkins_home/secrets/ 2> /dev/null | grep initialAdminPassword | wc -l) != 0 ]; then
        echo -e "\n==> [LXC] Show initial admin password"
        docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
        break
    fi

    echo -e "==> [LXC] Jenkins not yet ready, waiting 3 seconds..."
    sleep 3

done

URL="http://$IP:8080"
echo -e "\n==> [LXC] Success! Your new Jenkins instance should be available at $URL"
