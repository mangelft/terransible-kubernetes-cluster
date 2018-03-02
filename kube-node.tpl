CONTEXT = [
  NETWORK = "YES",
  SSH_PUBLIC_KEY = "$$USER[SSH_PUBLIC_KEY]",
  SET_HOSTNAME="kube-node"
]
CPU = "1"
DISK = [
  IMAGE_ID = "4" ]
GRAPHICS = [
  LISTEN = "0.0.0.0",
  TYPE = "VNC" ]
INPUTS_ORDER = ""
LOGO = "images/logos/centos.png"
MEMORY = "1024"
MEMORY_UNIT_COST = "MB"
NIC = [
  NETWORK = "default",
  NETWORK_UNAME = "oneadmin" ]
OS = [
  ARCH = "x86_64",
  BOOT = "" ]


