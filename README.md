# :desktop_computer: 42Heilbronn :de:

<p align="center">
  <img src="https://github.com/Tilek12/42-project-badges/blob/main/badges/inceptione.png">
</p>

<h1 align="center">
  Project - Inception :whale:
  <h2 align="center">
    :white_check_mark: 100/100
  </h2>
</h1>

## :clipboard: Project info: [subject](https://github.com/Tilek12/42HN-inception/blob/master/.git_docs/subject_inception.pdf)

## :cd: Operating System

This project was tested on **Virtual Machine** with **Debian 11** :cyclone:

## :green_circle: Mandatory Part

This project involves setting up a small infrastructure composed of different services under specific rules. The whole project has to be done in a virtual machine. You must use Docker Compose.

Each Docker image must have the same name as its corresponding service.

Each service has to run in a dedicated container.

For performance reasons, the containers must be built from either the penultimate stable version of Alpine or Debian. The choice is yours.

You also have to write your own **Dockerfiles**, one per service. The **Dockerfiles** must be called in your **docker-compose.yml** by your **Makefile**.
This means you must build the Docker images for your project yourself. It is then forbid- den to pull ready-made Docker images or use services such as DockerHub (Alpine/Debian being excluded from this rule).
You then have to set up:
- A Docker container that contains NGINX with TLSv1.2 or TLSv1.3 only.
- A Docker container that contains WordPress with php-fpm (it must be installed and configured) only, without nginx.
- A Docker container that contains only MariaDB, without nginx.
- A volume that contains your WordPress database.
- A second volume that contains your WordPress website files.
- A **docker-network** that establishes the connection between your containers.

Your containers must restart automatically in case of a crash.

:exclamation: **`
A Docker container is not a virtual machine. Thus, it is not recommended to use any hacky patches based on ’tail -f’ and similar methods when trying to run it. 
Read about how daemons work and whether it’s a good idea to use them or not.
`**


:warning: **`
Of course, using network: host or --link or links: is forbidden. The network line must be present in your docker-compose.yml file. Your containers must not be started with a command running an infinite loop. 
Thus, this also applies to any command used as entrypoint, or used in entrypoint scripts. The following are a few prohibited hacky patches: tail -f, bash, sleep infinity, while true.
`**

- In your WordPress database, there must be two users, one of them being the admin- istrator. The administrator’s username must not contain ’admin’, ’Admin’, ’administrator’, or ’Administrator’ (e.g., admin, administrator, Administrator, admin-123, etc.).

:exclamation: **`
Your volumes will be available in the /home/login/data folder of the host machine using Docker. Of course, you have to replace the login with yours.
`**

To simplify the process, you must configure your domain name to point to your local IP address.

This domain name must be **login.42.fr**. Again, you must use your own login.
For example, if your login is ’wil’, **wil.42.fr** will redirect to the IP address pointing to Wil’s website.

:warning: **`
The latest tag is prohibited.
Passwords must not be present in your Dockerfiles.
The use of environment variables is mandatory.
It is also strongly recommended to use a .env file to store environment variables and to use the Docker secrets to store any confidential information.
Your NGINX container must be the sole entry point into your infrastructure, accessible only via port 443, using the TLSv1.2 or TLSv1.3 protocol.
`**

Here is an example diagram of the expected result:

<p align="center">
  <img src="https://github.com/Tilek12/42HN-inception/blob/master/.git_docs/scheme.png">
</p>

Below is an example of the expected directory structure:

<p align="center">
  <img src="https://github.com/Tilek12/42HN-inception/blob/master/.git_docs/structure.png">
</p>

:warning: **`
For obvious security reasons, any credentials, API keys, passwords, etc., must be saved locally in various ways / files and ignored by git. Publicly stored credentials will lead you directly to a failure of the project.
`**

:exclamation: **`
You can store your variables (as a domain name) in an environment variable file like .env
`**


---


## :gear: Additional Settings

It's needed to add confidential information to start this project:

- Create **"secrets"** directory in the project directory. It includes **.txt** files with passwords to each user in MariaDB database and WordPress.

<p align="center">
  <img src="https://github.com/Tilek12/42HN-inception/blob/master/.git_docs/secrets.png">
</p>

- Create **.env** file in the same directory with docker-compose.yml file. There must be variable, neccessary to make settings for Docker related files to each service.

<p align="center">
  <img src="https://github.com/Tilek12/42HN-inception/blob/master/.git_docs/env.png">
</p>

For example:
```
# Basic configuration
LOGIN=login
DOMAIN_NAME=${LOGIN}.example.com
VOLUME_PATH="/home/${LOGIN}/data"

# Database credentials
MYSQL_USER=user
MYSQL_DATABASE=wordpress

# WordPress credentials
WP_DB_HOST=mariadb
WP_DB_USER=${MYSQL_USER}
WP_DB_NAME=${MYSQL_DATABASE}
WP_TITLE="Title of web page"
WP_REGULAR_USER=regular_user
WP_REGULAR_EMAIL=regular_user@example.com
WP_ADMIN=super_user
WP_ADMIN_EMAIL=super_user@example.com
```
