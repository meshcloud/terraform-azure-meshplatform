data "kubernetes_service_account" "meshfed_service" {
    metadata {
      namespace = "meshcloud"
      name = "meshfed-service"
    }
}

data "kubernetes_secret" "meshfed_service_secret" {
  metadata {
    name = "${kubernetes_service_account.meshfed_service.default_secret_name}"
    namespace = "${kubernetes_service_account.meshfed_service.metadata.0.namespace}"
  }
    depends_on = [
    kubernetes_service_account.meshfed_service
  ]
}

output "meshfed_service_token" {
  sensitive = true
  value = data.kubernetes_secret.meshfed_service_secret
}

output "token" {
  sensitive = true
  value = "${data.kubernetes_secret.meshfed_service_secret.data["token"]}"
}

output "kubernete_service_account_meshfed_service" {
  value = kubernetes_service_account.meshfed_service
}