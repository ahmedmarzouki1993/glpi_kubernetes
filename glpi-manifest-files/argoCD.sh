#/bin/bash
#start Minikube
echo "-------------------starting minikube---------------"
minikube start

#create argoCD namespace
echo "-------------------create argoCD namespace---------"
kubectl create namespace argocd || true

#Deploy ArgoCD into  the argoCD namespace
echo "----------------------Deploy ArgoCD  into argoCD namespace--------------"
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

#sleep 1 minute
echo "-------------------waiting 1 minute for pods to start---------"
sleep 1m

#change service type from clusterIp to NodePort
echo "-------------------change argoCD service type from clusterIp to NodePort ---------"
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort"}}'

#ArgoCD service URL
echo "-------------------GET ArgoCD service URL ---------"
minikube service -n argocd argocd-server --url

#ArgoCD pass
echo "-------------------GET ArgoCD admin password ---------"
echo "Username : admin"
kubectl -n argocd  secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d > argcd-init-pass.txt

