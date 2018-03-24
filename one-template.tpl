CONTEXT = [
  NETWORK = "YES",
  SSH_PUBLIC_KEY = "$$USER[SSH_PUBLIC_KEY]",
  SET_HOSTNAME="$$NAME",
  USERNAME = "$$UNAME"
]
CPU = "0.25"
DISK = [
  IMAGE_ID = "6" ]
GRAPHICS = [
  LISTEN = "0.0.0.0",
  TYPE = "VNC" ]
INPUTS_ORDER = ""
LOGO = "images/logos/debian.png"
MEMORY = "1024"
MEMORY_UNIT_COST = "MB"
NIC = [
  NETWORK = "default",
  NETWORK_UNAME = "oneadmin" ]
OS = [
  ARCH = "x86_64",
  BOOT = "" ]


