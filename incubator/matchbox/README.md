
# dnsmasq-matchbox

This chart is a fully featured PXE server that can boot & install servers.
Servers rootfs installed come from docker images.

It contains :

- dnsmasq dhcp server set up for PXE
- matchbox set up based on chart values
- script to automatically prepare archlinux iso as PXE boot
- script to trigger install & configure servers based on charts values
- script to download docker images rootfs as installation filesystem

## Test it

```bash
minikube start --cpus 2 --memory 3192
minikube stop
```

stop it and add an internal network card.
Start it again, and add an IP address to this card :

```bash
minikube ssh
...
sudo ip addr add 192.168.50.254/24 dev eth2
```

Create a new VM with a internal network card in the same name.