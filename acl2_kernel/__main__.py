from ipykernel.kernelapp import IPKernelApp
from .kernel import ACL2Kernel
IPKernelApp.launch_instance(kernel_class=ACL2Kernel)