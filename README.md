# Charts
This repo contains my helm charts. and how I'm using them.

## Stable
If the chart is in stable, I'm using it daily.

## incubator
In process charts.

## bin/release
Release script wrap helm to make it convention over configuration and run against whole cluster or namespace to keep everyting in sync.

## releases
An example of `release` script usage against minikube.

```bash
releases                                        # root releases directory for multiple kube cluster
releases/release-root-env.sh                    # env var file needed by `release` to detect root path & set global vars
releases/minikube                               # cluster context in kubectl
releases/minikube/default                       # namespace in cluster
releases/minikube/default/dhcp1                 # helm release name to diff/upgrade/...
releases/minikube/default/dhcp1/release-env.sh  # release env file to set chart location
releases/minikube/default/dhcp1/values.yaml     # value file to apply against chart in this release
releases/minikube/default/dhcp1/toto42.yaml     # another value file
```

```bash
cd minikube/default/dhcp1
release upgrade             # upgrade dhcp1 release on default namespace in minikube cluster
release diff                # run helm diff against release
release validate            # run kubeval & kube-score against release
release template            # run helm template against release

cd minikube/default
release upgrade             # upgrade all releases on default namepace in minikube cluster
release diff                # run helm diff against all release on default namespace
...

cd minikube
release upgrade             # upgrade all release in minikube cluster
...
```