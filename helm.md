# helm

## Initialize Helm

```bash
# You should only need to do this on a new cluster that does not have the Tiller pod installed
helm init
```

Helm will rely on the Tiller pod being installed, you can reference [Installing Tiller](https://github.com/helm/helm/blob/master/docs/install.md#installing-tiller) for that.

## install drupal
```bash
# I'll be using `--name blackbne` here, change this to whatever name you want to give this helm install/release
helm install --name blackbne stable/drupal
```

