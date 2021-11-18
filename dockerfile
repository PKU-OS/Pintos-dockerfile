FROM ubuntu:18.04
LABEL maintainer=zhongyinmin@pku.edu.cn

# home directory
ENV HOME /home/PKUOS

# install prerequisite packages
RUN apt-get update && apt-get -y install build-essential automake git libncurses5-dev texinfo

WORKDIR ${HOME}
RUN git clone https://github.com/PKU-OS/pintos.git

# build toolchain
ENV SWD=/home/PKUOS/toolchain
RUN mkdir -p $SWD 

# install qemu
RUN apt-get update && apt-get install -y qemu

# build Bochs from source
RUN apt-get install -y libx11-dev libxrandr-dev wget
ENV PINTOS_ROOT=/home/PKUOS/pintos
RUN cd ${PINTOS_ROOT} && src/misc/bochs-2.6.2-build.sh $SWD/x86_64

# build pintos utility tools
ENV dest=$SWD/x86_64
RUN cd $PINTOS_ROOT/src/utils &&\
    make &&\
    cp backtrace pintos Pintos.pm pintos-gdb pintos-set-cmdline pintos-mkdisk setitimer-helper squish-pty squish-unix $dest/bin &&\
    mkdir $dest/misc &&\
    cp ../misc/gdb-macros $dest/misc

# install cgdb
RUN apt-get install -y cgdb

# build toolchain
RUN cd $PINTOS_ROOT && src/misc/toolchain-build.sh $SWD

# add toolchain into path
RUN echo PATH=/home/PKUOS/toolchain/x86_64/bin:$PATH >> ~/.bashrc

# remove the pintos dir
RUN rm -rf /home/PKUOS/pintos

# docker will end executing immediatedly without this
CMD ["sleep", "infinity"]


