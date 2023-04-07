# ------------------------------------------------------------- Aggregates --- #

resource "openstack_compute_aggregate_v2" "aggregate_node_2" {
  name = "eu-west-3a"
  zone = "eu-west-3a"
  hosts = [
    "openstack-node2",
  ]
}

resource "openstack_compute_aggregate_v2" "aggregate_node_3" {
  name = "eu-west-3b"
  zone = "eu-west-3b"
  hosts = [
    "openstack-node3",
  ]
}
