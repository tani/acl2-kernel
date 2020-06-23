FROM jupyter/minimal-notebook:04f7f60d34a6

# ACL2

ENV ACL2_VER=8.3 LISP=sbcl

USER root
RUN apt-get update && apt-get install -y ${LISP} && apt-get clean && rm -rf /var/lib/apt/lists/*

USER jovyan
WORKDIR /home/jovyan/work
RUN wget -q -O- https://github.com/acl2/acl2/archive/${ACL2_VER}.tar.gz | tar -zxf - \
    && make -C "${PWD}/acl2-${ACL2_VER}" -j 4 LISP=${LISP} ACL2_PAR=1 \
    && make -C "${PWD}/acl2-${ACL2_VER}/books" -j 4 basic ACL2="${PWD}/acl2-${ACL2_VER}/saved_acl2p" USE_QUICKLISP=0

# ACL2 Kernel

ENV ACL2_KERNEL_VER=0.2.2
RUN pip3 install --no-cache acl2-kernel==${ACL2_KERNEL_VER} \
    && python3 -m acl2_kernel.install --acl2="${PWD}/acl2-${ACL2_VER}/saved_acl2p"

# Notebook

WORKDIR /home/jovyan
COPY Example.ipynb Example.ipynb
