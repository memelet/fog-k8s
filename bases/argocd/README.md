Open the UI:
```shell
xdg-open http://argocd.${K3D_HOST}:${K3D_PORT_TRAEFIK_WEB}
```


(Note, the default for this project is to disable authentication for ArgoCD.)

Get the admin password:
```shell
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode; echo
```

Copy the admin password to the clipboard:
```shell
echo $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode) | xclip -sel clip
```


