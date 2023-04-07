# -------------------------------------------------------------- Variables --- #

# Note that you also need to change project name in the backend
project_name = "kubernetes"

network_cidr = "172.16.1.0/24"

controller_number      = 1
controller_volume_size = 25
controller_flavor      = "kubernetes.controller"


worker_number      = 1
worker_volume_size = 75
worker_flavor      = "kubernetes.worker"

