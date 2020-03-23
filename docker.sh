#!/bin/sh
echo "add docker repo"
tee /etc/yum.repos.d/docker.repo <<-'EOF'
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/$releasever/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF
echo "------------"
echo "update yum"
yum update -y
echo "------------"
echo "install docker-engine"
yum install -y docker-engine
echo "------------"
echo "install easy_install"
wget -q http://peak.telecommunity.com/dist/ez_setup.py
python ez_setup.py
echo "------------"
echo "install pip"
easy_install pip
echo "------------"
echo "install docker-compose"
pip install docker-compose
echo "------------"
echo "enable docker"
systemctl enable docker.service
sed '12c ExecStart=/usr/bin/dockerd --graph=/data/docker' /lib/systemd/system/docker.service
echo "------------"
echo "start docker"
systemctl daemon-reload
systemctl start docker