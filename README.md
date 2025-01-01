# homelab_jenkins
<!-- Scripts to install Jenkins from a Proxmox host, as well as configure Jenkins
to run pipelines from other repos

This repo has two purposes:
- To create a functional Jenkins LXC container from a fresh Proxmox host
- To prepare the above Jenkins container to run pipelines from other repos -->

A single script to prepare a Jenkins LXC container on top of Proxmox.

This Jenkins instance will be fully configured, and ready for you to deploy
all other services from its GUI.

Pipelines are defined in the `config_as_code/job_dsl_pipelines` directory.


### Step 1 - Deploy Jenkins

From a Proxmox host, clone the repo and run the install script

    $ git clone https://github.com/jason-galea/homelab_jenkins.git

    $ cd homelab_jenkins

    $ ./scripts/create_jenkins_lxc.sh


This will create a new LXC container & install Jenkins

The script will also display the URL & default admin password,
which is required for the next step



### Step 2 - Log in to Jenkins

Navigate to the URL, and log in with username `admin` and the password from
the above step.

You will be show the "Getting Started" screen, but you can safely skip the
entire thing as all plugins are pre-installed.



### Step 3 - Enjoy your pipelines!

Congrats!

Now you're logged into your very own Jenkins instance, and all of your favourite
pipelines have been prepared just as you configured them in `config_as_code/job_dsl_pipelines`!

