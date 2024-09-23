#!/bin/bash

set -x

function get_port_forward_pid() {
    ps aux | grep "port-forward -n argocd svc/argocd-server" | grep --invert-match "grep" | awk '{print $2}'
}

function reestablish_port_forward() {
    kill -9 $(get_port_forward_pid)
    kubectl -n argocd port-forward svc/argocd-server 8080:443 &> /tmp/argoserver.log &

    while [[ $(cat /tmp/argoserver.log | wc -l) -eq 0 ]]; do
        echo waiting kubectl to establish port-forward...
        sleep 1
    done
    echo "=== Port-forward established. ==="
}

reestablish_port_forward

while true; do
    curl --max-time 5 -s -k http://localhost:8080/ &>/dev/null
    if [[ $? -ne 0 ]]; then
        echo "ArgoCD server is not responding. Tail of the log:"
        tail -n 10 /tmp/argoserver.log

        echo "Reestablishing port-forward..."
        > /tmp/argoserver.log
        reestablish_port_forward
    fi
    sleep 3
done
