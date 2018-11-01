FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04

# 设置环境变量
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:/lib/x86_64-linux-gnu:/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH PATH=/usr/local/cuda-9.0/bin:$PATH

# 简化apt-get install 和 pip 命令
RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && \
    APT_INSTALL="apt-get install -y --no-install-recommends" && \
    PIP_INSTALL="python -m pip --no-cache-dir install --upgrade -i https://pypi.tuna.tsinghua.edu.cn/simple" && \
# 删除缓存
    rm -rf /var/lib/apt/lists/* \
           /etc/apt/sources.list.d/cuda.list \
           /etc/apt/sources.list.d/nvidia-ml.list && \
# 更新列表
    apt-get update 

# ==============================================================================
# tool
# ------------------------------------------------------------------------------
RUN  APT_INSTALL="apt-get install -y --no-install-recommends" && \ 
       $APT_INSTALL \
       ca-certificates \
       cmake \
       wget \
       git \
       vim \
       zip \
       openssh-client \
       openssh-server \
       python-tk 

# ==============================================================================
# python
# ------------------------------------------------------------------------------
RUN  APT_INSTALL="apt-get install -y --no-install-recommends" && \ 
     $APT_INSTALL \
       software-properties-common && \
       add-apt-repository ppa:deadsnakes/ppa && \
       apt-get update && \
     $APT_INSTALL \
       python3.6 \
       python3.6-dev && \
       wget -O ~/get-pip.py https://bootstrap.pypa.io/get-pip.py && \
  python3.6 ~/get-pip.py && \
  ln -s /usr/bin/python3.6 /usr/local/bin/python3 && \
  ln -s /usr/bin/python3.6 /usr/local/bin/python && \
  PIP_INSTALL="python -m pip --no-cache-dir install --upgrade -i https://pypi.tuna.tsinghua.edu.cn/simple" && \  
  $PIP_INSTALL \
        setuptools \
        && \
  $PIP_INSTALL \
        numpy \
        h5py \
        scipy \
        pandas \
        scikit-learn \
        matplotlib \
        Cython \
        visdom \
        dominate \
        opencv-python \
        tensorflow-gpu==1.8 \
        jupyter \
        && \
# ==============================================================================
# clean
# ------------------------------------------------------------------------------
        ldconfig && \
        apt-get clean && \
        apt-get autoremove && \
        rm -rf /var/lib/apt/lists/* /tmp/* ~/*

EXPOSE 6006
