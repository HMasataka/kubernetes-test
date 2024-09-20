# Kubernetes

## Create Cluster

```bash
gcloud container clusters create k8s-cluster \
    --cluster-version 1.26.5-gke.1200 \
    --zone us-central1-a \
    --num-nodes 3 \
    --machine-type n1-standard-4 \
    --enable-network-policy \
    --enable-vertical-pod-autoscaling
```

```bash
kind create cluster --config kind.yml
```

## test

```bash
conftest test --policy ./policy ./*.yaml
```

## Reference

[Rego メモ](https://gist.github.com/guitarrapc/8705b2644763cd8732796671d5a8581d)
