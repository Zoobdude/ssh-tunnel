# SSH Tunnel Docker Container

I wanted to expose a local service on my RPI to the internet using an ssh tunnel to a VPS.

Although I could have used a systemd service to bring up autossh every time the pi was started, being a little obsessed with containerising everything, I wanted to run it with Docker.

I looked to see if there were any containers that already did what I wanted and came across hundreds, including:

- https://hub.docker.com/r/jnovack/autossh/
- https://hub.docker.com/r/jessefugitt/docker-autossh

However, none of these compiled auto-ssh themselves. I wanted to be able to run this container on any of my Raspberry Pis without worrying about the architecture.

Also many hadn't been rebuilt with an updated base image for years meaning the ssh client in use would be very very outdated.

I am building containers for Docker Hub for all architectures I use via GH Actions. I intend to trigger this action once a month (via a cron job) to build a new container with an updated base image. This will ensure the ssh client in use does not become majorly outdated.

If there is an architecture you would like me to build for, please make an issue or PR. You can always build the Dockerfile yourself of course.

# Set-up

1. Clone the repo - `git clone https://github.com/Zoobdude/ssh-tunnel`
2. Enter into the `config` dir
3. Populate the `private_key` file with your ssh private key
4. Ensure this private key file is not owned by the root user and set the permissions to 400 with `chmod 400`
5. Fill in all the placeholders wrapped in {BRACES} (ensure the {} are removed):
   - `Hostname`: The IP address of the destination machine.
   - `User`: The username for the SSH connection.
   - `RemoteForward`: Specify the remote port (the port on the remote machine) first, followed by the local port (the port on the local machine you want to expose). You can specify multiple `RemoteForward` entries for different ports.
   - `ServerAliveInterval`: The interval (in seconds) between keep-alive messages sent to the server to maintain the connection during inactivity.
   - `ServerAliveCountMax`: The maximum number of keep-alive messages sent without a response before terminating the connection.
6. Navigate out of the config dir
7. If filenames and the hostname given in the ssh config (`SSH-Tunnel`) have been unchanged no ENV variables will need to be changed in the docker-compose.
8. Bring the tunnel up with `docker compose up -d`
