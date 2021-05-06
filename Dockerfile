FROM jupyter/minimal-notebook:04f7f60d34a6

# ACL2

USER root
RUN apt-get update && apt-get install -y acl2 && apt-get clean && rm -rf /var/lib/apt/lists/*
USER jovyan

# ACL2 Kernel

ENV ACL2_KERNEL_VER=0.2.2
RUN pip3 install --no-cache acl2-kernel==${ACL2_KERNEL_VER} \
    && python3 -m acl2_kernel.install

# Notebook

WORKDIR /home/jovyan
COPY Example.ipynb Example.ipynb
