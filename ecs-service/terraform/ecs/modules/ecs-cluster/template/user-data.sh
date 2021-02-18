# ECS config
{
  echo "ECS_CLUSTER=${cluster_id}"
} >> /etc/ecs/ecs.config
start ecs
echo "### End of user-data ###"