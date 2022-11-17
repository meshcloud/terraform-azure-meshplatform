resource "kubernetes_namespace" "meshcloud" {
  metadata {
    name = "meshcloud"
  }
}

resource "kubernetes_service_account" "meshfed_metering" {
  metadata {
    name = "meshfed-metering"
    namespace = kubernetes_namespace.meshcloud.metadata.0.name
    annotations = {
      "io.meshcloud/meshstack.metering-kubernetes.version" = "1.0"
    }
  }
  secret {
    name = "${kubernetes_secret.meshfed_metering_secret.metadata.0.name}"
  }
}

resource "kubernetes_secret" "meshfed_metering_secret" {
  metadata {
    name = "meshfed-metering"
  }
}


resource "kubernetes_service_account" "meshfed_service" {
  metadata {
    name = "meshfed-service"
    namespace = kubernetes_namespace.meshcloud.metadata.0.name
    annotations = {
      "io.meshcloud/meshstack.replicator-kubernetes.version" = "1.0"
    }
  }
  secret {
    name = "${kubernetes_secret.meshfed_service_secret.metadata.0.name}"
  }
}
resource "kubernetes_secret" "meshfed_service_secret" {
  metadata {
    name = "meshfed-service"
  }
}

