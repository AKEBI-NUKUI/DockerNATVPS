FROM alpine:latest

# Update&Install
RUN apk update \
    && apk add --no-cache openssh \
    && ssh-keygen -A \
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
