#
# Build ACL2-kernel package
#
FROM python:3
RUN pip install --no-cache poetry
WORKDIR /work
COPY ./ /work/
RUN ls /work/ && poetry build

#
# Build Jupyter environment
#
FROM jupyter/minimal-notebook:04f7f60d34a6

# ACL2

ENV ACL2_VER=8.4 LISP=sbcl

USER root
RUN apt-get update && apt-get install -y ${LISP} && apt-get clean && rm -rf /var/lib/apt/lists/*

USER jovyan
WORKDIR /home/jovyan/work
RUN wget -q -O- https://github.com/acl2/acl2/archive/${ACL2_VER}.tar.gz | tar -zxf - \
    && make -C "${PWD}/acl2-${ACL2_VER}" -j 2 LISP=${LISP}

# ACL2 Kernel

COPY --from=0 /work/dist/acl2_kernel-*.whl .
RUN pip install --no-cache ./acl2_kernel-*.whl \
    && rm ./acl2_kernel-*.whl \
    && python3 -m acl2_kernel.install --acl2="${PWD}/acl2-${ACL2_VER}/saved_acl2"

# Notebook

WORKDIR /home/jovyan
COPY Example.ipynb Example.ipynb
