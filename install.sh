#!/bin/sh

yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine \
                  docker-selinux


yum install -y yum-utils
yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

yum install -y docker-ce


sudo curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
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

systemctl daemon-reload
systemctl restart docker

