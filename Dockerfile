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
COPY ./ /usr/local/authing/
COPY ./nginx/ /etc/nginx/conf.d/
COPY ./entrypoint.sh /
WORKDIR /usr/local/authing
EXPOSE 80
VOLUME [ "/user/local/authing" ]
ENTRYPOINT [ "/entrypoint.sh"]

