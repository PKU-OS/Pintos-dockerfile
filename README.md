# Docker for Pintos
The easiest way to deploy cross-platform development environment for Pintos.

## How to use
Your TA has built a docker image which contains all the toolchain to compile, run and debug Pintos.

First, you need to install docker on your laptop. Go to the [docker download page](https://www.docker.com/get-started) for help. 

Then pull the image and run it, just type the command below into your favourite shell (you can run `docker run --help` to find out what this command mean in detail):

```
docker run -it pkuflyingpig/pintos bash
```

This image is about 3GB (it contains a full Ubuntu18.04), so it may take sometime at its first run.

If all goes well, you will enter a bash shell. You can use `ls` or `pwd` to play around and you will find there is a `toolchain` directory which contains all the dependencies and your home directory is `/home/PKUOS`. Now you own a tiny Ubuntu OS inside your host computer, and you can shut it down easily by `Ctrl+d`. You can check that it has exited by running `docker ps -a`.

## How to run Pintos
Now change back to your host computer, git clone the Pintos repository by running:

```
git clone git@github.com:PKU-OS/pintos.git
```

Then run the docker image again but this time mount your `path/to/pintos` into the container.

```
docker run -it --rm --name pintos --mount type=bind,source=path/to/pintos/on/your/host/machine,target=/home/PKUOS/pintos pkuflyingpig/pintos bash
```
p.s. `--rm` tells docker to delete the container after running, and `--name pintos` names the container as `pintos`, this will be helpful in the debugging part.

This time when you `ls`, you will find there is a new directory called `pintos` under your home directory in the container.

Now here comes the exciting part:

```
cd pintos/src/threads/
make
cd build
pintos --
```

Bomb! If you see something like

```
Pintos hda1
Loading............
Kernel command line:
Pintos booting with 3,968 kB RAM...
367 pages available in kernel pool.
367 pages available in user pool.
Calibrating timer...  32,716,800 loops/s.
Boot complete.
```

Your Pintos has been booted successfully, congratulations :)

Throughout this semester, you can modify your Pintos source code in your host machine with your favourite IDE and run/debug/test your Pintos in the container.

## How to debug Pintos
If you have read the `Test and Debug` part in the Documentation, you may find that you need two terminals to debug the Pintos. This part teaches you how do this in Docker.

First run the Pintos container as usual in one terminal follow the command in the above section.

Then run the commands below 

```
cd pintos/src/threads/
pintos --gdb
```

Now open a new terminal and run 

```
docker exec -it pintos bash
```

You may remember in the above example you run your Pintos container and name it as `pintos`, then here you just exec a bash shell in your `pintos` container. 

Now you can run

```
cd pintos/src/threads/build
pintos-gdb kernel.o
```

and debug your Pintos as the Documentation says.

If you don't understand what these commands are doing, please read the Documentation first carefully.









