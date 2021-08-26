# acl2-kernel [![PyPI](https://img.shields.io/pypi/v/acl2-kernel)](https://pypi.org/project/acl2-kernel/) [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/tani/acl2-kernel/master?filepath=Example.ipynb)

Jupyter Kernel for ACL2

## What is Jupyter and ACL2?

> Project Jupyter exists to develop open-source software, open-standards, and services for interactive computing across dozens of programming languages. (https://jupyter.org/)

> ACL2 is a logic and programming language in which you can model computer systems, together with a tool to help you prove properties of those models. "ACL2" denotes "A Computational Logic for Applicative Common Lisp". (http://www.cs.utexas.edu/users/moore/acl2/)

## Usage

We follow to the standard jupyter kernel installation. So, you will install the kernel by `pip` command,
and will call the installation command like,

```sh
$ pip3 install jupyter acl2-kernel
$ python3 -m acl2_kernel.install
$ jupyter notebook
```

You also can see the deep usage by `python3 -m acl2_kernel.install --help`.

### Docker 

In some case, you might want to run the kernel in the Docker containers.
This repository contains Dockerfile example. You can build example image by the following command.

```
$ docker build . -t acl2
```

To run the container, you would type the command like

```
$ docker run --rm -p 8888:8888 acl2 jupyter notebook --ip='0.0.0.0'
```

A running example is available in the `example/` directory.
You can try it on [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/tani/acl2-kernel/master?filepath=Example.ipynb).

## Related Projects

- [Jupyter](https://jupyter.org/) - Softwares for interactive computing
- [ACL2](http://www.cs.utexas.edu/users/moore/acl2/) - Theorem prover based on Common Lisp

## License

This project is released under the BSD 3-clause license.

Copyright (c) 2020, TANIGUCHI Masaya All rights reserved.

We borrow code from the following projects.

- Egison Kernel; Copyright (c) 2017, Satoshi Egi and contributors All rights reserved.
- Bash Kernel; Copyright (c) 2015, Thomas Kluyver and contributors All rights reserved.
