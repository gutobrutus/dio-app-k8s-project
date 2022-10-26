#!/bin/bash

if [ -z "$1" ] && [ -z "$2" ]
then
    echo "Erro: Deve ser informado a tag para as imagens..."
    echo "Exemplo: ./sript.sh 1.0.0 1.0.00"
    exit 1
fi

echo "[+] Build das imagens"

docker image build -t gutofunny/db-dio:v$1 database/.
docker image build -t gutofunny/app-dio:v$2 backend/.

echo "[+] Realizando o push das imagens"

docker image push gutofunny/db-dio:v$1
docker image push gutofunny/db-dio:latest
docker image push gutofunny/app-dio:v$2
docker image push gutofunny/app-dio:latest

echo "[+] Criando o PVC no cluster k8s"

kubectl apply -f manifests/pvc-db.yml

echo "[+] Criando os services no cluster k8s"

kubectl apply -f manifests/svc-app.yml
kubectl apply -f manifests/svc-db.yml

echo "[+] Aplicando os deployments no cluster k8s"

kubectl apply -f manifests/deployment-app.yml
kubectl apply -f manifests/deployment-db.yml