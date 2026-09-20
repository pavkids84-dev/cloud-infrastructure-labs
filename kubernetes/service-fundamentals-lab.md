# Service Fundamentals Lab

## Overview

This lab covers Kubernetes Service concepts and how Kubernetes provides stable network access to dynamic Pods.

Pods are temporary workloads. Pod IP addresses can change when Pods are recreated, so Kubernetes provides Service objects to expose applications through stable networking endpoints.

This lab covers:

- Service concept
- Service and Pod relationship
- Label Selector
- Endpoint Controller
- Service Types
- ClusterIP
- NodePort
- LoadBalancer
- ExternalName
- Service troubleshooting workflow


---

# 1. Kubernetes Service Concept

## Why Service is Required

Pod IP addresses are not permanent.

Example:

```
Pod
 |
 | deleted
 ↓
New Pod created
 |
 ↓
New IP assigned
```

Directly connecting clients to Pod IPs is unreliable.

Kubernetes Service provides:

- Stable virtual IP
- Stable DNS name
- Traffic forwarding to Pods
- Load distribution between Pods


Architecture:

```
Client

   ↓

Service

   ↓

Label Selector

   ↓

Pod Group

   ↓

Container
```


---

# 2. Service and Pod Relationship

Service does not select Pods by IP address.

Service uses Labels.

Example Pod:

```yaml
metadata:
  labels:
    app: nginx
```

Service selector:

```yaml
selector:
  app: nginx
```

Relationship:

```
Service

selector:
 app=nginx


        ↓


Pod

label:
 app=nginx
```


If Pod IP changes:

```
Old Pod
10.0.0.10

        ↓

Pod recreated

        ↓

New Pod
10.0.0.20
```

Service connection remains available because the Label remains unchanged.


---

# 3. Service YAML Structure

Example:

```yaml
apiVersion: v1
kind: Service

metadata:
  name: nginx-service

spec:
  selector:
    app: nginx

  ports:
  - port: 80
    targetPort: 8080
```


## apiVersion

Defines Kubernetes API version.

Example:

```yaml
apiVersion: v1
```


## kind

Defines Kubernetes Object type.

Example:

```yaml
kind: Service
```


## metadata

Defines Service information.

Example:

```yaml
metadata:
  name: nginx-service
```


## selector

Defines target Pods.

Example:

```yaml
selector:
  app: nginx
```


## ports

Defines network forwarding.

Example:

```yaml
ports:
- port: 80
  targetPort: 8080
```


Traffic flow:

```
Client

 ↓

Service Port 80

 ↓

Target Port 8080

 ↓

Container
```


---

# 4. Endpoint Controller

Service does not directly store Pod IP information.

Endpoint Controller creates Endpoint objects.

Flow:

```
Service Created

        ↓

Endpoint Controller

        ↓

Find Matching Pods

        ↓

Create Endpoint Object

        ↓

Traffic Forwarding
```


Example:

Pods:

```
10.0.0.10:8080

10.0.0.11:8080
```


Endpoint:

```
Service Backend

10.0.0.10:8080

10.0.0.11:8080
```


---

# 5. Service Types

Kubernetes provides four main Service types.

```
ClusterIP

NodePort

LoadBalancer

ExternalName
```


---

# 6. ClusterIP

ClusterIP is the default Service type.


Architecture:

```
Pod

 ↓

ClusterIP Service

 ↓

Backend Pod
```


Characteristics:

- Internal cluster communication
- Default Service type
- Not accessible from outside cluster


Example:

```
Frontend Pod

        ↓

Backend Service

        ↓

Backend Pod
```


Common usage:

- Microservice communication
- Internal API communication


---

# 7. NodePort

NodePort exposes Service through a port on Kubernetes Nodes.


Architecture:

```
External Client

        ↓

Node IP:NodePort

        ↓

Service

        ↓

Pod
```


Example:

```yaml
type: NodePort
```


Characteristics:

- External access through Node IP
- Default port range is 30000-32767
- Common in development environments


Example:

```
http://NodeIP:30080
```


---

# 8. LoadBalancer

LoadBalancer exposes Service using an external cloud load balancer.


Architecture:

```
Internet

 ↓

Cloud Load Balancer

 ↓

Kubernetes Service

 ↓

Pod
```


Common environments:

- AWS ELB
- Azure Load Balancer
- Google Cloud Load Balancer


Characteristics:

- External user access
- Cloud provider integration required


---

# 9. ExternalName

ExternalName maps a Service name to an external DNS name.


Example:

```yaml
type: ExternalName

externalName:
  database.example.com
```


Usage:

```
Application

 ↓

Kubernetes Service Name

 ↓

External Database
```


---

# 10. Creating Service

## Using kubectl expose

Example:

```bash
kubectl expose deployment nginx \
--port=80 \
--target-port=8080
```


Flow:

```
Deployment

 ↓

Service Created

 ↓

Selector Generated

 ↓

Pod Connection
```


---

# 11. Checking Service

## List Services

```bash
kubectl get svc
```


Example output:

```
NAME             TYPE        CLUSTER-IP

nginx-service    ClusterIP   10.96.0.10
```


---

## Describe Service

```bash
kubectl describe svc nginx-service
```


Check:

- Selector
- Port
- Endpoint


---

## Check Endpoint

```bash
kubectl get endpoints
```


Example:

```
NAME

nginx-service

ENDPOINTS

10.0.0.10:8080
10.0.0.11:8080
```


If Endpoint is empty:

Possible causes:

- Wrong selector
- Pod label mismatch
- Pod not Ready


---

# 12. Service DNS

Kubernetes automatically creates DNS records.

Format:

```
service-name.namespace.svc.cluster.local
```


Example:

```
mysql.database.svc.cluster.local
```


Communication:

```
Application Pod

        ↓

Service DNS

        ↓

Backend Pod
```


---

# 13. Service Troubleshooting

Recommended order:

## 1. Check Service

```bash
kubectl get svc
```


## 2. Check Service Configuration

```bash
kubectl describe svc <service-name>
```


## 3. Check Endpoint

```bash
kubectl get endpoints
```


## 4. Check Pod Labels

```bash
kubectl get pod --show-labels
```


Common issues:

| Problem | Cause |
|---|---|
| No Endpoint | Selector mismatch |
| Connection Failed | Wrong targetPort |
| Pod unavailable | Readiness failure |
| DNS failure | Service name issue |


---

# 14. Service Object Relationship

Complete architecture:

```
Deployment

      ↓

ReplicaSet

      ↓

Pod

      ↓

Label

      ↓

Service Selector

      ↓

Endpoint

      ↓

Client Traffic
```


---

# 15. What I Learned

## Service provides stable access to dynamic Pods

Pods are temporary resources.

Service provides:

- Stable IP
- Stable DNS
- Traffic routing


## Label is the connection point

Service does not know Pod IP directly.

It uses:

```
Service Selector

        ↓

Pod Label
```


## Endpoint represents backend Pods

Endpoint Controller maintains:

- Pod IP
- Container Port


## Service Types

```
ClusterIP

Internal communication


NodePort

Node based external access


LoadBalancer

Cloud external access


ExternalName

External service mapping
```


---

# Evidence Policy

This document describes Kubernetes Service concepts and commands.

Actual execution results, IP addresses, Endpoint values, and cluster states should be added only after performing the commands in a real Kubernetes environment.
