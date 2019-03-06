FROM gazebo:libgazebo8-xenial

# add ROS sources
RUN apt update && apt install -y openssh-server x11-apps mesa-utils vim llvm-dev sudo autoconf
RUN mkdir /var/run/sshd
RUN echo 'root:buttercups' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN grep "^X11UseLocalhost" /etc/ssh/sshd_config || echo "X11UseLocalhost no" >> /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

#Rebuild MESA with llvmpipe (from https://turbovnc.org/Documentation/Mesa)
RUN wget ftp://ftp.freedesktop.org/pub/mesa/mesa-18.3.1.tar.gz;\
    tar -zxvf mesa-18.3.1.tar.gz;\
    rm mesa-18.3.1.tar.gz;\
    cd mesa-18.3.1;\
    autoreconf -fiv;\
    ./configure --enable-glx=gallium-xlib --disable-dri --disable-egl --disable-gbm --with-gallium-drivers=swrast --prefix=$HOME/mesa;\
    make install

#set up locales
RUN apt install -y locales screen
RUN locale-gen en_GB.UTF-8 && locale-gen en_US.UTF-8

#INSTALL ADDITIONAL ROS PACKAGES BELOW HERE

#clear apt caches to reduce image size
RUN rm -rf /var/lib/apt/lists/*

#configure system to use new mesa
RUN cd ~ && echo "export LD_LIBRARY_PATH=/root/mesa/lib" > opengl.sh

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# Start and expose the SSH service
EXPOSE 22
RUN service ssh restart

RUN apt update && apt install -y \
    curl \
    sudo

RUN apt update && apt install -y \
    libsdformat4 \
    gazebo7 \
    gazebo7-plugin-base \
    libignition-math2 \
    libignition-math2-dev \
    libsdformat4-dev \
    libgazebo7 \
    libgazebo7-dev

RUN apt update && apt install -y \
    libjansson-dev \
    nodejs \
    npm \
    nodejs-legacy \
    libboost-dev \
    imagemagick \
    libtinyxml-dev \
    mercurial \
    cmake \
    build-essential

# Upgrade node
RUN curl -sL https://deb.nodesource.com/setup_11.x | sudo -E bash -
RUN sudo apt-get install -y nodejs



# clone gzweb
RUN cd ~; \
    hg clone https://bitbucket.org/osrf/gzweb; \
    cd ~/gzweb; \
    hg up gzweb_1.4.0; \
    source /usr/share/gazebo/setup.sh; \
    npm run deploy --- -m

# setup environment
EXPOSE 8080
EXPOSE 7681

# run gzserver and gzweb
COPY start_script.sh start_script.sh
CMD ./start_script.sh