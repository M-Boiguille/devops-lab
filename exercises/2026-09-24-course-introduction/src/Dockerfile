FROM ubuntu:22.04

RUN apt-get update && apt-get install -y --no-install-recommends \
  openssh-server vim git curl ufw sudo wget -y \
  && rm -rf /var/lib/apt/lists/*.

RUN groupadd dummy_sudo && \
  useradd -m -s /bin/bash exercise -g dummy_sudo && \
  mkdir -p /home/exercise/.ssh && \
  chmod 700 /home/exercise/.ssh

RUN echo '%dummy_sudo ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/dummy_sudo && \
  chmod 0440 /etc/sudoers.d/dummy_sudo && \
  visudo -cf /etc/sudoers.d/dummy_sudo

COPY ./ssh/chaos.sh /

COPY ./ssh/dummy_ssh_key.pub /home/exercise/.ssh/authorized_keys

RUN chown -R exercise:dummy_sudo /home/exercise/.ssh/ && \
  chmod 600 /home/exercise/.ssh/authorized_keys &&  mkdir -p /run/sshd

RUN mkdir -p /home/exercise/lfcs-notes/

EXPOSE 22

CMD ["/bin/bash", "-c", "/chaos.sh"]
