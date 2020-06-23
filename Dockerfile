FROM jupyter/minimal-notebook:04f7f60d34a6

ENV ACL2_VER=8.3 ACL2_PAR=1 LISP=sbcl ACL2_KERNEL_VER=0.1.1

USER root
WORKDIR /home/jovyan/work
RUN apt-get update && apt-get install -y $LISP && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN wget -q -O- https://github.com/acl2/acl2/archive/${ACL2_VER}.tar.gz | tar -zxf - \
    && make -C "${PWD}/acl2-${ACL2_VER}" -j 4 LISP=${LISP} ACL2_PAR=${ACL2_PAR} \
    && if [ "${ACL2_PAR}" == "1" ]; then \
         ACL2="${PWD}/acl2-${ACL2_VER}/saved_acl2p"; \
       else \
         ACL2="${PWD}/acl2-${ACL2_VER}/saved_acl2"; \
       fi \
    && make -C "${PWD}/acl2-${ACL2_VER}/books" -j 4 basic ACL2="${ACL2}" USE_QUICKLISP=0 \
    && ln -s "${ACL2}" /usr/local/bin/acl2

USER jovyan
WORKDIR /home/jovyan
RUN pip3 install --no-cache acl2-kernel==${ACL2_KERNEL_VER} && python3 -m acl2_kernel.install
