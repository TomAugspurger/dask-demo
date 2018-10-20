# General config
cluster_name ?= dask-cluster
name ?= $(cluster_name)
config ?= values.yaml
cluster_admin ?= taugspurger@anaconda.com

# GCP settings
project_id ?= dask-demo-182016
zone ?= us-central1-b
num_nodes ?= 3
machine_type ?= n1-standard-4

cluster:
	gcloud container clusters create $(cluster_name) \
	    --num-nodes=$(num_nodes) \
	    --machine-type=$(machine_type) \
	    --zone=$(zone) \
	    --enable-autorepair \
	    --enable-autoscaling --min-nodes=0 --max-nodes=10

helm:
	kubectl create clusterrolebinding cluster-admin-binding --clusterrole=cluster-admin --user=$(cluster_admin)
	kubectl --namespace kube-system create sa tiller
	kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
	helm init --service-account tiller
	kubectl --namespace=kube-system patch deployment tiller-deploy --type=json --patch='[{"op": "add", "path": "/spec/template/spec/containers/0/command", "value": ["/tiller", "--listen=localhost:44134"]}]'
	helm repo update

dask:
	helm install stable/dask \
		-f $(config) \
		--name=$(name) \
		--namespace=$(name)

upgrade:
	helm upgrade $(name) helm-chart/dask \
		-f $(config)

print-ip:
	@echo jupyterlab: http://$$(kubectl get svc --namespace $(name) $(name)-jupyter -o jsonpath='{.status.loadBalancer.ingress[0].ip}'):80
	@echo scheduler : tcp://$$(kubectl get svc --namespace $(name) $(name)-scheduler -o jsonpath='{.status.loadBalancer.ingress[0].ip}'):8786
	@echo dashboard : http://$$(kubectl get svc --namespace $(name) $(name)-scheduler -o jsonpath='{.status.loadBalancer.ingress[0].ip}'):80/status

delete-helm:
	helm delete $(name) --purge
	kubectl delete namespace $(name)

delete-cluster:
	gcloud container clusters delete $(cluster_name) --zone=$(zone)
