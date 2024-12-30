### https://www.jenkins.io/doc/book/installing/docker/
### https://docs.docker.com/engine/install/debian/
### https://github.com/jenkinsci/docker/#preinstalling-plugins

FROM jenkins/jenkins:lts-jdk21
USER root

### This would be nice, but it also skips creating '/var/jenkins_home/secrets/initialAdminPassword'
### TODO: Generate admin password in advance --> template it into jenkins.yml
# ### https://github.com/jenkinsci/configuration-as-code-plugin/issues/393
# ENV JAVA_OPTS "-Djenkins.install.runSetupWizard=false ${JAVA_OPTS:-}"

RUN apt update \
    && apt install -y ca-certificates curl \
    && install -m 0755 -d /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc \
    && chmod a+r /etc/apt/keyrings/docker.asc \
    && echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
        | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt update \
    && apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin \
    && usermod -aG docker jenkins

USER jenkins
COPY --chown=jenkins:jenkins plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt
