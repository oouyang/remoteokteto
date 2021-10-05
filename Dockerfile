FROM debian

ENV DEBIAN_FRONTEND=noninteractive

RUN   apt update && \
      apt-get install -y openssh-server firefox-esr mate-system-monitor nginx npm git lxde tightvncserver wget jq htop screen tmux && \
      wget https://github.com/novnc/noVNC/archive/refs/tags/v1.2.0.tar.gz && \
      tar -xvf v1.2.0.tar.gz && \
      mkdir  /root/.vnc /run/sshd && \
      ssh-keygen -A && \
      useradd alpine && \
      echo alpine:changeme | chpasswd && \
      echo changeme | vncpasswd -f > /root/.vnc/passwd && \
      chmod 600 /root/.vnc/passwd && \
      cp /noVNC-1.2.0/vnc.html /noVNC-1.2.0/index.html && \
      echo -e '\
            wstunnel -s 0.0.0.0:8989 \n\
            echo alpine:${PW:-changeme} | chpasswd \n\
            echo root:${PW:-changeme} | chpasswd \n\
            echo ${PW:-changeme} | vncpasswd -f > /root/.vnc/passwd \n\
            cd /root\n\      
            su root -l -c "vncserver :2000"  \n\
            cd /noVNC-1.2.0 \n\
            /usr/sbin/sshd -D & \n\
            ./utils/launch.sh  --vnc localhost:7900 --listen 80\
' > /luo.sh && \
      chmod 755 /luo.sh
      
EXPOSE 80

CMD  /luo.sh
