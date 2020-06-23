# acl2-kernel

Jupyter Kernel for ACL2

## What is Jupyter and ACL2?

> Project Jupyter exists to develop open-source software, open-standards, and services for interactive computing across dozens of programming languages. (https://jupyter.org/)

> ACL2 is a logic and programming language in which you can model computer systems, together with a tool to help you prove properties of those models. "ACL2" denotes "A Computational Logic for Applicative Common Lisp". (http://www.cs.utexas.edu/users/moore/acl2/)

## Usage

```sh
$ pip3 install jupyter acl2-kernel
$ python3 -m acl2_kernel.install
$ jupyter noteboook
```

A running example is available in the `example/` directory.

## Related Projects

- [Jupyter](https://jupyter.org/) - Softwares for interactive computing
- [ACL2](http://www.cs.utexas.edu/users/moore/acl2/) - Theorem prover based on Common Lisp

## License

This project is released under the BSD 3-clause license.

Copyright (c) 2020, TANIGUCHI Masaya All rights reserved.

We borrow code from the following projects.

- Egison Kernel; Copyright (c) 2017, Satoshi Egi and contributors All rights reserved.
- Bash Kernel; Copyright (c) 2015, Thomas Kluyver and contributors All rights reserved.
