#!/usr/bin/bash

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

echo -e "\n==> [LXC] Docker compose pull"
docker compose pull

echo -e "\n==> [LXC] Docker compose build"
docker compose build

echo -e "\n==> [LXC] Docker compose up"
docker compose up -d

URL="http://$(hostname -i):8080"
echo -e "\n==> [LXC] Success! Your new Jenkins instance should be available at $URL"

echo -e "\n==> [LXC] Show initial admin password"
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword

