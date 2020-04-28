#!/bin/sh

echo "remove old docker "
yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine


echo "add docker repo"
tee /etc/yum.repos.d/docker.repo <<-'EOF'
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/$releasever/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF


echo "install docker-engine"
yum install -y docker-engine


echo "install docker-compose"
curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://f2d495ac.m.daocloud.io
chmod +x /usr/local/bin/docker-compose


systemctl enable docker.service
systemctl start docker

mkdir -p /etc/docker/
tee /etc/docker/daemon.json <<-'EOF'
{
    "registry-mirrors": [
        "https://docker.mirrors.ustc.edu.cn",
        "http://f1361db2.m.daocloud.io",
        "https://registry.docker-cn.com",
        "https://hub-mirror.c.163.com",
        "https://mirror.ccs.tencentyun.com"
    ]
}
EOF

echo "reStart docker"
systemctl daemon-reload

