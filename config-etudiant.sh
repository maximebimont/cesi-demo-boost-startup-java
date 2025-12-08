#!/usr/bin/env bash

# IMPORTANT: Remplacez X par VOTRE numéro (exemple: 3 si vous êtes étudiant n°3)
STUDENT_NUMBER=6

echo "Configuration pour l'étudiant n°${STUDENT_NUMBER}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Backup des fichiers originaux
cp k8s/appli/appli.yaml k8s/appli/appli.yaml.bak
cp k8s/argocd-crds/argocd-appli-demo-java.yaml k8s/argocd-crds/argocd-appli-demo-java.yaml.bak

# Remplacement dans appli.yaml
sed -i.tmp "s/cesi1/cesi${STUDENT_NUMBER}/g" k8s/appli/appli.yaml
rm -f k8s/appli/appli.yaml.tmp

# Remplacement dans l'application ArgoCD
# Le nom de l'application devient cesiX-demo-java
sed -i.tmp "s/name: ema-demo-java$/name: cesi${STUDENT_NUMBER}-demo-java/g" k8s/argocd-crds/argocd-appli-demo-java.yaml
sed -i.tmp "s/namespace: cesi1/namespace: cesi${STUDENT_NUMBER}/g" k8s/argocd-crds/argocd-appli-demo-java.yaml
rm -f k8s/argocd-crds/argocd-appli-demo-java.yaml.tmp

# Vérification
echo ""
echo "✅ Vérification de la configuration :"
echo ""
echo "📂 Namespace Kubernetes :"
grep "name: cesi" k8s/appli/appli.yaml | head -1
echo ""
echo "🌐 Domaine Ingress :"
grep "host: cesi" k8s/appli/appli.yaml
echo ""
echo "🎯 Application ArgoCD :"
grep "name: cesi.*-demo-java" k8s/argocd-crds/argocd-appli-demo-java.yaml | head -1
echo ""
echo "📍 Namespace destination :"
grep "namespace: cesi" k8s/argocd-crds/argocd-appli-demo-java.yaml
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Commit des changements
git add k8s/appli/appli.yaml k8s/argocd-crds/argocd-appli-demo-java.yaml
git commit -m "config: personnalisation pour étudiant ${STUDENT_NUMBER}"
git push origin main

echo ""
echo "✅ Configuration terminée et poussée vers Git!"
echo ""