#!/bin/bash

set -x

kill -9 $(ps aux | grep "server 8080" | head -1 | awk '{print $2}')
kubectl -n argocd port-forward svc/argocd-server 8080:443 &> /tmp/argoserver.log &
pid=$!

while [[ $(cat /tmp/argoserver.log | wc -l) -eq 0 ]]; do
    echo wait...
    sleep 3
done

while true; do
    sleep 3
    curl --max-time 15 -s http://localhost:8080/ &>/dev/null
    if [[ $? -ne 0 ]]; then
        cat /tmp/argoserver.log
        kill -9 $(ps aux | grep "server 8080" | head -1 | awk '{print $2}')

        rm -f /tmp/argoserver.log
        kubectl -n argocd port-forward svc/argocd-server 8080:443 &> /tmp/argoserver.log &

        while [[ $(cat /tmp/argoserver.log | wc -l) -eq 0 ]]; do
            echo wait...
            sleep 3
        done
    fi
done