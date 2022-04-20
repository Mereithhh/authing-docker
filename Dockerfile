# authing 开发环境 docker 镜像构建
# 4. 正常开发
FROM ubuntu:18.04
WORKDIR /usr/local/authing
ENV TZ=Asia/shanghai
COPY zoneinfo /usr/share/
COPY nvm/ /root/.nvm/
SHELL ["/bin/bash","-c"]
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \ 
    rm -rf /bin/sh && ln -s /bin/bash /bin/sh && \ 
    echo "Asia/Shanghai" > /etc/timezone && \
    sed -i s@/ports.ubuntu.com/@/mirrors.tuna.tsinghua.edu.cn/@g /etc/apt/sources.list && \
    apt-get update && apt-get install -y git curl vim tmux net-tools gcc python make g++ python2.7 nginx openssh-server &&  \
    echo 'export NVM_DIR="/root/.nvm"' >> /root/.bashrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" ' >> /root/.bashrc && \
    echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> /root/.bashrc && \
    source /root/.bashrc && \
    export NVM_DIR="/root/.nvm" && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  && \
    nvm install v14.17.6 && nvm alias system v14.17.6 && nvm alias system v14.17.6 && \
    npm config set registry https://registry.npm.taobao.org &&   \
    npm install -g yarn --registry=https://registry.npm.taobao.org && \
    yarn config set registry https://registry.npm.taobao.org -g && \
    yarn config set sass_binary_site http://cdn.npm.taobao.org/dist/node-sass -g 
RUN mkdir /var/run/sshd
RUN echo 'root:root' |chpasswd
RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

RUN mkdir /root/.ssh

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 22 80
COPY ./ /usr/local/authing/
COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf
COPY ./entrypoint.sh /
WORKDIR /usr/local/authing
VOLUME [ "/user/local/authing" ]
CMD    ["/usr/sbin/sshd", "-D"]

