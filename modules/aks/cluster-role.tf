resource "kubernetes_cluster_role" "meshfed-metering" {
  metadata {
    name = "meshfed-metering"
    annotations = {
      "io.meshcloud/meshstack.metering-kubernetes.version" = "1.0"
    }
  }

  rule {
    api_groups = [""]
    resources  = ["pods", "persistentvolumeclaims"]
    verbs      = ["get", "list"]
  }
}

resource "kubernetes_cluster_role" "meshfed-service" {
  metadata {
    name = "meshfed-service"
    annotations = {
      "io.meshcloud/meshstack.replicator-kubernetes.version" = "1.0"
    }
  }

  rule {
    api_groups = [""]
    resources  = ["namespaces"]
    verbs      = ["get", "list","watch","create","delete","update"]
    
  }
    rule {
    api_groups = [""]
    resources  = ["resourcequotas","resourcequotas/status"]
    verbs      = ["get", "list","watch","create","delete","deletecollection","patch","update"]
   
  }
    rule {
    api_groups = [""]
    resources  = ["appliedclusterresourcequotas","clusterresourcequotas","clusterresourcequotas/status"]
    verbs      = ["get", "list","watch","create","delete","deletecollection","patch","update"]

  }
    rule {
    api_groups = ["","rbac.authorization.k8s.io"]
    resources  = ["roles","rolebindings","clusterroles","clusterrolebindings"]
    verbs      = ["get", "list","watch"]
   
  }
    rule {
    api_groups = ["","rbac.authorization.k8s.io"]
    resources  = ["rolebindings"]
    verbs      = ["create","delete","update"]
    
  }
    rule {
    api_groups = ["","rbac.authorization.k8s.io"]
    resources  = ["clusterroles"]
    verbs      = ["bind"]
    resource_names = ["admin","edit","view"]
  }
}

resource "kubernetes_cluster_role_binding" "meshfed-metering" {
  subject {
    kind = "ServiceAccount"
    name = "meshfed-metering"
    namespace =  kubernetes_namespace.meshcloud.metadata.0.name
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind = "ClusterRole"
    name = "meshfed-metering"
  }
  metadata {
    name = "meshfed-metering"
    annotations = {
      "io.meshcloud/meshstack.metering-kubernetes.version" = "1.0"
  }
}
}

resource "kubernetes_cluster_role_binding" "meshfed-service" {
  subject {
    kind = "ServiceAccount"
    name = "meshfed-service"
    namespace =  "${kubernetes_namespace.meshcloud.metadata.0.name}"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind = "ClusterRole"
    name = "meshfed-service"
  }
  metadata {
    name = "meshfed-service"
    annotations = {
      "io.meshcloud/meshstack.replicator-kubernetes.version" = "1.0"
  }
}
}