locals {
  manifests = length(var.app_manifest_paths) > 0 ? var.app_manifest_paths : (
    var.app_manifest_path != "" ? [var.app_manifest_path] : []
  )
}

resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  version          = "5.31.0"
  create_namespace = true
}

resource "kubernetes_manifest" "app" {
  for_each  = toset(local.manifests)
  manifest  = yamldecode(file(each.value))
  depends_on = [helm_release.argocd]
}