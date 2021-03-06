compartment_id="COMPARTMENT_OCID"
tenancy_id="OCI_TENANCY"
home_region="OCI_HOME_REGION"
region="OCI_REGION"
cluster_name="CLUSTER_NAME"

vcn_name="oke-vcn-CLUSTER_NAME"

create_bastion_host=false
create_bastion_service=false
create_operator=false
control_plane_type="public"
control_plane_allowed_cidrs=["0.0.0.0/0"]

label_prefix="oke"

node_pools = {
  pool1 = { shape = "WORKER_SHAPE", ocpus = 1, memory = 16, node_pool_size = 3, boot_volume_size = 50, label = {pool = "pool1" } }
}