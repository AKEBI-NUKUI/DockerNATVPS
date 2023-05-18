FROM debian:latest

# Update&Install
RUN apt-get update \
    && apt-get install -y openssh-server curl \
    && ssh-keygen -A \
    && apt-get install -y curl wget sudo python \
    && wget https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl.py -O /bin/systemctl \
    && sudo chmod a+x /bin/systemctl \
    && echo 'kill 1' >> /usr/bin/reboot \
    && chmod +x /usr/bin/reboot \
    && echo 'root:{{ROOT_PASSWORD}}' | chpasswd \
    && sed -i 's/^#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/^PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/#PermitEmptyPasswords no/PermitEmptyPasswords yes/' /etc/ssh/sshd_config \
    && sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config \
    && echo "ClientAliveInterval 60" >> /etc/ssh/sshd_config \
    && echo "ClientAliveCountMax 3" >> /etc/ssh/sshd_config \
    && mkdir /run/sshd

# StartSSH
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
