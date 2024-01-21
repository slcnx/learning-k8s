# default app
kubectl apply -f deploy-demoap-v1_0.yaml 
kubectl apply -f 01-ingress-demoapp.yaml 
curl 192.168.10.6:30859 -H host:demoapp.magedu.com



# add new version
kubectl apply -f deploy-demoap-v1_1.yaml 


## for header
kubectl apply -f 02-canary-by-header.yaml 

kubectl get pod 


curl 192.168.10.6:30859 -H host:demoapp.magedu.com -H 'X-Canary: always'
curl 192.168.10.6:30859 -H host:demoapp.magedu.com -H 'X-Canary: never'
kubectl delete -f 02-canary-by-header.yaml 


## for header value
kubectl apply -f 03-canary-by-header-value.yaml 
curl 192.168.10.6:30859 -H host:demoapp.magedu.com -H 'IsVIP: false'
curl 192.168.10.6:30859 -H host:demoapp.magedu.com -H 'IsVIP: fals1'


kubectl delete -f 03-canary-by-header-value.yaml 


## for header pattern
kubectl apply -f 04-canary-by-header-pattern.yaml 
curl 192.168.10.6:30859 -H host:demoapp.magedu.com -H 'Username: 123'
curl 192.168.10.6:30859 -H host:demoapp.magedu.com -H 'Username: vip_1'

kubectl delete -f 04-canary-by-header-pattern.yaml 


# for weight
kubectl apply -f 05-canary-by-weight.yaml 
while true; do curl 192.168.10.6:30859 -H host:demoapp.magedu.com ; done



kubectl delete -f 05-canary-by-weight.yaml 

## for cookie
kubectl apply -f 06-canary-by-cookie.yaml 
curl 192.168.10.6:30859 -H host:demoapp.magedu.com -b vip_user=true
curl 192.168.10.6:30859 -H host:demoapp.magedu.com -b vip_user=always
