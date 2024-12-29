# homelab_jenkins
Scripts to install Jenkins from a Proxmox host, as well as configure Jenkins to run pipelines from other repos

This repo has two purposes:
- To create a functional Jenkins LXC container from a fresh Proxmox host
- To prepare the above Jenkins container to run pipelines from other repos



### Steps

From a Proxmox host, clone the repo and run the install script

    $ git clone https://github.com/jason-galea/homelab_jenkins.git

    $ cd homelab_jenkins

    $ ./create_jenkins_lxc.sh


This will create a new LXC container, install Jenkins, and direct you to the URL.
