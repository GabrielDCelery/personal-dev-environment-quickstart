# What is this repository for?

To be able to quickly set up a working development environment on a new machine.

## How to run it?

1. Have git and homebrew installed on your machine

2. Install ansible using homebrew

```sh
homebrew install ansible
```

3. Clone the repository somewhere on your local machine

4. Create a vars.yaml file in the root directory of the project.

```
user: <your username> # Run whoami or id on your machine to get the value 
github_email: your GitHub email
github_name: your GitHub name
```

5. Run ansible to deploy the development environment

```sh
ansible-playbook local.yaml
```
