# Pull base image.
FROM ubuntu:trusty

MAINTAINER Tristan Salles

RUN apt-get update -y

RUN apt-get install -y git python-pip python-dev libzmq3 libzmq3-dev pkg-config libfreetype6-dev libpng3 llvm-3.6 libedit-dev

RUN pip install -U setuptools
RUN pip install -U pip  # fixes AssertionError in Ubuntu pip
RUN pip install enum34
RUN LLVM_CONFIG=llvm-config-3.6 pip install llvmlite==0.8.0
RUN pip install jupyter markupsafe zmq singledispatch backports_abc certifi jsonschema path.py matplotlib 
RUN pip install traits sortedcontainers
RUN pip install matplotlib --upgrade
RUN pip install six --upgrade
RUN pip install scipy

ENV TINI_VERSION v0.8.4
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/local/bin/tini
RUN chmod +x /usr/local/bin/tini

RUN mkdir /workspace
RUN mkdir /build

# launch notebook
WORKDIR /build
RUN git clone https://github.com/tristan-salles/exGEOS3102.git

WORKDIR /workspace
RUN cp -av /build/exGEOS3102/* /workspace/
RUN rm -rf /workspace/solution

EXPOSE 8888
ENTRYPOINT ["/usr/local/bin/tini", "--"]

CMD jupyter notebook --ip=0.0.0.0 --no-browser \
    --NotebookApp.token='' --allow-root --NotebookApp.iopub_data_rate_limit=1.0e10
