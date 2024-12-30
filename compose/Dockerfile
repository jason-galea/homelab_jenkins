### https://www.jenkins.io/doc/book/installing/docker/
### https://docs.docker.com/engine/install/debian/

FROM jenkins/jenkins:2.479.2-jdk21
USER root

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
    && apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

USER jenkins
# RUN jenkins-plugin-cli --plugins "blueocean docker-workflow configuration-as-code"
# RUN jenkins-plugin-cli --plugins \
#     blueocean \
#     blueocean-bitbucket-pipeline \
#     blueocean-events \
#     blueocean-github-pipeline \
#     blueocean-git-pipeline \
#     blueocean-pipeline-api-impl \
#     blueocean-pipeline-editor \
#     blueocean-rest-impl \
#     docker-plugin \
#     configuration-as-code \
#     favorite \
#     github \
#     github-branch-source \
#     token-macro \
#     matrix-auth
ADD ./plugins.txt ~/plugins.txt
RUN jenkins-plugin-cli --plugin-file ~/plugins.txt
