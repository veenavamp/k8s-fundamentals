# Kubernetes Configmap & Secrets

## Relevant Documentation

- ConfigMaps : https://kubernetes.io/docs/concepts/configuration/configmap/
- Secrets    : https://kubernetes.io/docs/concepts/configuration/secret/




## Concepts

### Create a ConfigMap.

```
 vi my-configmap.yml
``` 
``` yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: my-configmap
data:
  key1: Hello, world!
  key2: |
    Test
    multiple lines
    more lines
```
```
 kubectl create -f my-configmap.yml
``` 

