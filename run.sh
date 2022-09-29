kubectl delete ns argocd
kubectl delete -f controller.yaml
kubectl create ns argocd
kubectl apply -k terraform-generate/kustomize-core-install -n argocd
IMG=quay.io/jsawaya/argocd-tf-controller:latest make deploy-file
kubectl apply -f controller.yaml
kubectl config set-context --current --namespace=argocd
kubectl apply -f secret.yaml -n argocd
kubectl apply -f examples/kube-namespace/role.yaml -n argocd
sleep 10
argocd app create terraform-test --repo https://github.com/josephsawaya/terraform-test.git --path manifests --dest-server https://kubernetes.default.svc --dest-namespace argocd --config-management-plugin argocd-terraform-generator
sleep 10
argocd app sync terraform-test
