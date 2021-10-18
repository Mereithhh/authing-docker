# authing 开发环境 docker 镜像构建
# 1. 按需修改 ENV 下的用户名，密码，邮箱
# 2. docker build -t authing-dev:latest .
# 3. docker run -it -p 3000:3000 -v ./authing-dev:/usr/local/authing --name authing-dev authing-dev:latest /bin/bash -c "/root/run.sh"
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
    apt-get update && apt-get install -y git curl vim tmux net-tools gcc python make g++ &&  \
    echo 'export NVM_DIR="/root/.nvm"' >> /root/.bashrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" ' >> /root/.bashrc && \
    echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> /root/.bashrc && \
    source /root/.bashrc && \
    export NVM_DIR="/root/.nvm" && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  && \
    nvm install v14.17.6 && nvm alias system v14.17.6 && nvm alias system v14.17.6 && \
    npm config set registry https://registry.npm.taobao.org &&   \
    npm install -g yarn --registry=https://registry.npm.taobao.org && \
    yarn config set registry https://registry.npm.taobao.org -g && \
    yarn config set sass_binary_site http://cdn.npm.taobao.org/dist/node-sass -g && \
    apt install -y redis-server && service redis-server start && \
    apt install -y postgresql postgresql-contrib && \
    pg_ctlcluster 10 main start && \
    apt install python2.7 g++ -y && \
    curl -fsSL https://code-server.dev/install.sh | sh && \
    mkdir -p /root/.config/code-server/ && \
    echo "bind-addr: 0.0.0.0:2333" > /root/.config/code-server/config.yaml && \
    echo "auth: password" > /root/.config/code-server/config.yaml && \
    echo "password: admin" > /root/.config/code-server/config.yaml && \
    echo "cert: false" > /root/.config/code-server/config.yaml 
COPY ./ /usr/local/authing/
COPY ./nginx/ /etc/nginx/conf.d/
USER postgres
RUN pg_ctlcluster 10 main start &&  psql --command "CREATE USER authing WITH SUPERUSER PASSWORD 'authing123';" && \
    cd /var/lib/postgresql && createdb -O authing authing-server && \
    echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/10/main/pg_hba.conf && \
    echo "listen_addresses='*'" >> /etc/postgresql/10/main/postgresql.conf
USER root
COPY ./entrypoint.sh /
WORKDIR /usr/local/authing-dev
EXPOSE 80
VOLUME [ "/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql", "/user/local/authing" ]
ENTRYPOINT [ "/entrypoint.sh"]

