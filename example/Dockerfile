FROM jupyter/minimal-notebook:04f7f60
USER root
RUN autp-get update && apt-get install -y acl2 acl2-books && apt-get apt-get clean && rm -rf /var/lib/apt/lists/*
USER jovyan
RUN pip3 install acl2-kernel && python3 -m acl2_kernel.install
