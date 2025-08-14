````instructions
# Kubernetes Container Orchestration Instructions

## Tool Overview
- **Tool Name**: Kubernetes (K8s)
- **Version**: 1.28+ (stable), 1.30+ (latest with enhanced features)
- **Category**: Container Orchestration
- **Purpose**: Production-grade container orchestration platform for automated deployment, scaling, and management
- **Prerequisites**: Docker or compatible container runtime, kubectl CLI, cluster access

## Installation & Setup
### kubectl CLI Installation
```bash
# macOS (Homebrew)
brew install kubectl

# Ubuntu/Debian
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Windows (Chocolatey)
choco install kubernetes-cli

# Windows (Scoop)
scoop install kubectl

# Using package managers
sudo apt-get update && sudo apt-get install -y apt-transport-https gnupg2 curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update && sudo apt-get install -y kubectl

# Verify installation
kubectl version --client
```

### Local Development Clusters
```bash
# Minikube installation and setup
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# Start local cluster
minikube start --driver=docker --cpus=4 --memory=8192
minikube status
minikube dashboard

# Kind (Kubernetes in Docker)
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
chmod +x ./kind && sudo mv ./kind /usr/local/bin/kind

# Create kind cluster
kind create cluster --config=kind-config.yaml
kind get clusters
kind delete cluster

# k3d (k3s in Docker)
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
k3d cluster create mycluster --port "8080:80@loadbalancer" --port "8443:443@loadbalancer"
k3d cluster list
```

### Cluster Configuration
```bash
# Configure kubectl context
kubectl config view
kubectl config get-contexts
kubectl config use-context minikube
kubectl config set-context --current --namespace=development

# Cluster information
kubectl cluster-info
kubectl get nodes
kubectl describe node <node-name>
kubectl top nodes  # Requires metrics-server
```

## Core Features

### Pod Management
- **Purpose**: Smallest deployable units containing one or more containers
- **Usage**: Run applications with shared storage and network
- **Example**:

```yaml
# pod.yaml - Basic Pod configuration
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
  labels:
    app: nginx
    version: v1
spec:
  containers:
  - name: nginx
    image: nginx:1.24-alpine
    ports:
    - containerPort: 80
      name: http
    resources:
      requests:
        memory: "64Mi"
        cpu: "250m"
      limits:
        memory: "128Mi"
        cpu: "500m"
    env:
    - name: ENVIRONMENT
      value: "production"
    volumeMounts:
    - name: nginx-config
      mountPath: /etc/nginx/nginx.conf
      subPath: nginx.conf
    livenessProbe:
      httpGet:
        path: /
        port: 80
      initialDelaySeconds: 30
      periodSeconds: 10
    readinessProbe:
      httpGet:
        path: /
        port: 80
      initialDelaySeconds: 5
      periodSeconds: 5
  volumes:
  - name: nginx-config
    configMap:
      name: nginx-config
  restartPolicy: Always
  nodeSelector:
    environment: production
```

### Deployment Management
- **Purpose**: Manage replica sets and rolling updates
- **Usage**: Deploy and scale applications declaratively
- **Example**:

```yaml
# deployment.yaml - Application deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
  namespace: production
  labels:
    app: web-app
    version: v1.0
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web-app
  template:
    metadata:
      labels:
        app: web-app
        version: v1.0
    spec:
      containers:
      - name: web-app
        image: myapp:v1.0
        ports:
        - containerPort: 3000
          name: http
        env:
        - name: NODE_ENV
          value: "production"
        - name: DB_HOST
          valueFrom:
            secretKeyRef:
              name: db-credentials
              key: host
        - name: DB_PASSWORD
          valueFrom:
            secretKeyRef:
              name: db-credentials
              key: password
        resources:
          requests:
            memory: "256Mi"
            cpu: "250m"
          limits:
            memory: "512Mi"
            cpu: "500m"
        livenessProbe:
          httpGet:
            path: /health
            port: 3000
          initialDelaySeconds: 60
          periodSeconds: 30
        readinessProbe:
          httpGet:
            path: /ready
            port: 3000
          initialDelaySeconds: 10
          periodSeconds: 5
        volumeMounts:
        - name: app-config
          mountPath: /app/config
          readOnly: true
      volumes:
      - name: app-config
        configMap:
          name: app-config
      imagePullSecrets:
      - name: registry-credentials
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1
      maxSurge: 1
```

### Service Configuration
- **Purpose**: Expose applications and enable service discovery
- **Usage**: Provide stable networking for pods
- **Example**:

```yaml
# service.yaml - Service exposure
apiVersion: v1
kind: Service
metadata:
  name: web-app-service
  namespace: production
  labels:
    app: web-app
spec:
  selector:
    app: web-app
  ports:
  - name: http
    port: 80
    targetPort: 3000
    protocol: TCP
  type: ClusterIP

---
# Load balancer service
apiVersion: v1
kind: Service
metadata:
  name: web-app-lb
  namespace: production
spec:
  selector:
    app: web-app
  ports:
  - port: 80
    targetPort: 3000
  type: LoadBalancer

---
# NodePort service for development
apiVersion: v1
kind: Service
metadata:
  name: web-app-nodeport
  namespace: development
spec:
  selector:
    app: web-app
  ports:
  - port: 80
    targetPort: 3000
    nodePort: 30080
  type: NodePort
```

### Ingress Configuration
- **Purpose**: HTTP/HTTPS routing and load balancing
- **Usage**: Expose services to external traffic with advanced routing
- **Example**:

```yaml
# ingress.yaml - HTTP routing
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web-app-ingress
  namespace: production
  annotations:
    kubernetes.io/ingress.class: "nginx"
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
    nginx.ingress.kubernetes.io/rewrite-target: /
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    nginx.ingress.kubernetes.io/rate-limit: "100"
    nginx.ingress.kubernetes.io/rate-limit-window: "1m"
spec:
  tls:
  - hosts:
    - myapp.example.com
    - api.myapp.example.com
    secretName: myapp-tls
  rules:
  - host: myapp.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: web-app-service
            port:
              number: 80
      - path: /api
        pathType: Prefix
        backend:
          service:
            name: api-service
            port:
              number: 80
  - host: api.myapp.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: api-service
            port:
              number: 80
```

## Advanced Features

### ConfigMaps and Secrets
- **Purpose**: Manage configuration data and sensitive information
- **Usage**: Decouple configuration from container images
- **Example**:

```yaml
# configmap.yaml - Configuration management
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
  namespace: production
data:
  app.properties: |
    database.url=jdbc:postgresql://db:5432/myapp
    redis.url=redis://redis:6379
    logging.level=info
    feature.flags=true
  nginx.conf: |
    server {
        listen 80;
        server_name _;
        location / {
            proxy_pass http://backend:3000;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }
    }
  DATABASE_URL: "postgresql://db:5432/myapp"
  REDIS_URL: "redis://redis:6379"
  LOG_LEVEL: "info"

---
# secret.yaml - Sensitive data management
apiVersion: v1
kind: Secret
metadata:
  name: db-credentials
  namespace: production
type: Opaque
data:
  # Base64 encoded values
  username: cG9zdGdyZXM=  # postgres
  password: c3VwZXJzZWNyZXQ=  # supersecret
  host: ZGIucHJvZHVjdGlvbi5zdmMuY2x1c3Rlci5sb2NhbA==  # db.production.svc.cluster.local

---
# TLS Secret
apiVersion: v1
kind: Secret
metadata:
  name: myapp-tls
  namespace: production
type: kubernetes.io/tls
data:
  tls.crt: LS0tLS1CRUdJTi... # Base64 encoded certificate
  tls.key: LS0tLS1CRUdJTi... # Base64 encoded private key
```

### Persistent Volumes
- **Purpose**: Provide persistent storage for stateful applications
- **Usage**: Store data that persists beyond pod lifecycle
- **Example**:

```yaml
# persistent-volume.yaml - Storage management
apiVersion: v1
kind: PersistentVolume
metadata:
  name: postgres-pv
spec:
  capacity:
    storage: 10Gi
  accessModes:
  - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: fast-ssd
  hostPath:
    path: /data/postgres

---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: postgres-pvc
  namespace: production
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
  storageClassName: fast-ssd

---
# StatefulSet with persistent storage
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: postgres
  namespace: production
spec:
  serviceName: postgres
  replicas: 1
  selector:
    matchLabels:
      app: postgres
  template:
    metadata:
      labels:
        app: postgres
    spec:
      containers:
      - name: postgres
        image: postgres:15-alpine
        env:
        - name: POSTGRES_DB
          value: "myapp"
        - name: POSTGRES_USER
          valueFrom:
            secretKeyRef:
              name: db-credentials
              key: username
        - name: POSTGRES_PASSWORD
          valueFrom:
            secretKeyRef:
              name: db-credentials
              key: password
        ports:
        - containerPort: 5432
        volumeMounts:
        - name: postgres-storage
          mountPath: /var/lib/postgresql/data
        resources:
          requests:
            memory: "512Mi"
            cpu: "250m"
          limits:
            memory: "1Gi"
            cpu: "500m"
  volumeClaimTemplates:
  - metadata:
      name: postgres-storage
    spec:
      accessModes: ["ReadWriteOnce"]
      storageClassName: fast-ssd
      resources:
        requests:
          storage: 10Gi
```

### Horizontal Pod Autoscaling
- **Purpose**: Automatically scale pods based on resource usage
- **Usage**: Handle variable workload demands
- **Example**:

```yaml
# hpa.yaml - Horizontal Pod Autoscaler
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: web-app-hpa
  namespace: production
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: web-app
  minReplicas: 3
  maxReplicas: 20
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 80
  - type: Pods
    pods:
      metric:
        name: custom_metric
      target:
        type: AverageValue
        averageValue: "30"
  behavior:
    scaleDown:
      stabilizationWindowSeconds: 300
      policies:
      - type: Percent
        value: 10
        periodSeconds: 60
    scaleUp:
      stabilizationWindowSeconds: 0
      policies:
      - type: Percent
        value: 100
        periodSeconds: 15
      - type: Pods
        value: 4
        periodSeconds: 15
      selectPolicy: Max
```

### RBAC (Role-Based Access Control)
- **Purpose**: Control access to Kubernetes resources
- **Usage**: Implement security policies and user permissions
- **Example**:

```yaml
# rbac.yaml - Access control
apiVersion: v1
kind: ServiceAccount
metadata:
  name: web-app-service-account
  namespace: production

---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: production
  name: web-app-role
rules:
- apiGroups: [""]
  resources: ["pods", "services", "configmaps", "secrets"]
  verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]
- apiGroups: ["apps"]
  resources: ["deployments", "replicasets"]
  verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]

---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: web-app-rolebinding
  namespace: production
subjects:
- kind: ServiceAccount
  name: web-app-service-account
  namespace: production
roleRef:
  kind: Role
  name: web-app-role
  apiGroup: rbac.authorization.k8s.io

---
# ClusterRole for cluster-wide permissions
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: monitoring-cluster-role
rules:
- apiGroups: [""]
  resources: ["nodes", "nodes/proxy", "services", "endpoints", "pods"]
  verbs: ["get", "list", "watch"]
- apiGroups: ["extensions"]
  resources: ["ingresses"]
  verbs: ["get", "list", "watch"]

---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: monitoring-cluster-rolebinding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: monitoring-cluster-role
subjects:
- kind: ServiceAccount
  name: monitoring-service-account
  namespace: monitoring
```

## Common Commands

### Resource Management
```bash
# Apply configurations
kubectl apply -f deployment.yaml
kubectl apply -f .
kubectl apply -k kustomization/
kubectl apply -f https://raw.githubusercontent.com/user/repo/main/k8s.yaml

# Get resources
kubectl get pods
kubectl get pods -o wide
kubectl get pods --show-labels
kubectl get pods -l app=web-app
kubectl get all -n production
kubectl get events --sort-by=.metadata.creationTimestamp

# Describe resources
kubectl describe pod pod-name
kubectl describe deployment web-app
kubectl describe service web-app-service
kubectl describe node node-name

# Delete resources
kubectl delete pod pod-name
kubectl delete deployment web-app
kubectl delete -f deployment.yaml
kubectl delete all -l app=web-app

# Scale resources
kubectl scale deployment web-app --replicas=5
kubectl autoscale deployment web-app --min=2 --max=10 --cpu-percent=70
```

### Pod Operations
```bash
# Execute commands in pods
kubectl exec -it pod-name -- /bin/bash
kubectl exec -it pod-name -c container-name -- /bin/sh
kubectl exec pod-name -- ls -la /app

# Port forwarding
kubectl port-forward pod/pod-name 8080:80
kubectl port-forward service/web-app-service 8080:80
kubectl port-forward deployment/web-app 8080:3000

# Logs
kubectl logs pod-name
kubectl logs -f pod-name  # Follow logs
kubectl logs pod-name -c container-name
kubectl logs -l app=web-app --tail=100
kubectl logs deployment/web-app --since=1h

# Copy files
kubectl cp pod-name:/path/to/file ./local-file
kubectl cp ./local-file pod-name:/path/to/file
kubectl cp pod-name:/app/logs ./logs -c container-name
```

### Debugging and Troubleshooting
```bash
# Resource status
kubectl get pods --field-selector=status.phase=Failed
kubectl get events --field-selector type=Warning
kubectl top pods
kubectl top nodes

# Debug pods
kubectl describe pod pod-name
kubectl get pod pod-name -o yaml
kubectl get pod pod-name -o jsonpath='{.status.phase}'

# Network debugging
kubectl run debug-pod --image=nicolaka/netshoot -it --rm
kubectl exec -it debug-pod -- nslookup kubernetes.default
kubectl exec -it debug-pod -- curl -I http://web-app-service

# Resource quotas and limits
kubectl describe resourcequota
kubectl describe limitrange
kubectl describe node node-name
```

## Application Deployment Patterns

### Blue-Green Deployment
```yaml
# blue-green-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app-blue
  labels:
    app: web-app
    version: blue
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web-app
      version: blue
  template:
    metadata:
      labels:
        app: web-app
        version: blue
    spec:
      containers:
      - name: web-app
        image: myapp:v1.0
        ports:
        - containerPort: 3000

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app-green
  labels:
    app: web-app
    version: green
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web-app
      version: green
  template:
    metadata:
      labels:
        app: web-app
        version: green
    spec:
      containers:
      - name: web-app
        image: myapp:v2.0
        ports:
        - containerPort: 3000

---
# Service switches between blue and green
apiVersion: v1
kind: Service
metadata:
  name: web-app-service
spec:
  selector:
    app: web-app
    version: blue  # Change to 'green' to switch
  ports:
  - port: 80
    targetPort: 3000
```

### Canary Deployment
```yaml
# canary-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app-stable
  labels:
    app: web-app
    version: stable
spec:
  replicas: 9
  selector:
    matchLabels:
      app: web-app
      version: stable
  template:
    metadata:
      labels:
        app: web-app
        version: stable
    spec:
      containers:
      - name: web-app
        image: myapp:v1.0

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app-canary
  labels:
    app: web-app
    version: canary
spec:
  replicas: 1  # 10% traffic
  selector:
    matchLabels:
      app: web-app
      version: canary
  template:
    metadata:
      labels:
        app: web-app
        version: canary
    spec:
      containers:
      - name: web-app
        image: myapp:v2.0

---
# Service routes to both versions
apiVersion: v1
kind: Service
metadata:
  name: web-app-service
spec:
  selector:
    app: web-app  # Routes to both stable and canary
  ports:
  - port: 80
    targetPort: 3000
```

### Rolling Update Strategy
```yaml
# rolling-update.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
spec:
  replicas: 10
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 2  # Max 2 pods down during update
      maxSurge: 2        # Max 2 extra pods during update
  selector:
    matchLabels:
      app: web-app
  template:
    metadata:
      labels:
        app: web-app
    spec:
      containers:
      - name: web-app
        image: myapp:v2.0
        readinessProbe:
          httpGet:
            path: /health
            port: 3000
          initialDelaySeconds: 10
          periodSeconds: 5
        livenessProbe:
          httpGet:
            path: /health
            port: 3000
          initialDelaySeconds: 30
          periodSeconds: 10
```

## Monitoring and Observability

### Prometheus Monitoring
```yaml
# prometheus-config.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: prometheus-config
  namespace: monitoring
data:
  prometheus.yml: |
    global:
      scrape_interval: 15s
    scrape_configs:
    - job_name: 'kubernetes-pods'
      kubernetes_sd_configs:
      - role: pod
      relabel_configs:
      - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
        action: keep
        regex: true
      - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_path]
        action: replace
        target_label: __metrics_path__
        regex: (.+)

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: prometheus
  namespace: monitoring
spec:
  replicas: 1
  selector:
    matchLabels:
      app: prometheus
  template:
    metadata:
      labels:
        app: prometheus
    spec:
      containers:
      - name: prometheus
        image: prom/prometheus:v2.45.0
        args:
          - '--config.file=/etc/prometheus/prometheus.yml'
          - '--storage.tsdb.path=/prometheus/'
          - '--web.console.libraries=/etc/prometheus/console_libraries'
          - '--web.console.templates=/etc/prometheus/consoles'
          - '--web.enable-lifecycle'
        ports:
        - containerPort: 9090
        volumeMounts:
        - name: prometheus-config
          mountPath: /etc/prometheus
        - name: prometheus-storage
          mountPath: /prometheus
      volumes:
      - name: prometheus-config
        configMap:
          name: prometheus-config
      - name: prometheus-storage
        emptyDir: {}
```

### Application Metrics
```yaml
# app-with-metrics.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web-app
  template:
    metadata:
      labels:
        app: web-app
      annotations:
        prometheus.io/scrape: "true"
        prometheus.io/port: "3000"
        prometheus.io/path: "/metrics"
    spec:
      containers:
      - name: web-app
        image: myapp:v1.0
        ports:
        - containerPort: 3000
          name: http
        env:
        - name: METRICS_ENABLED
          value: "true"
        resources:
          requests:
            memory: "256Mi"
            cpu: "250m"
          limits:
            memory: "512Mi"
            cpu: "500m"
```

## Security Best Practices

### Network Policies
```yaml
# network-policy.yaml - Network segmentation
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: web-app-network-policy
  namespace: production
spec:
  podSelector:
    matchLabels:
      app: web-app
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          name: ingress-nginx
    - podSelector:
        matchLabels:
          app: nginx-ingress
    ports:
    - protocol: TCP
      port: 3000
  egress:
  - to:
    - podSelector:
        matchLabels:
          app: database
    ports:
    - protocol: TCP
      port: 5432
  - to: []  # Allow DNS
    ports:
    - protocol: UDP
      port: 53
```

### Pod Security Standards
```yaml
# pod-security.yaml
apiVersion: v1
kind: Pod
metadata:
  name: secure-pod
spec:
  securityContext:
    runAsNonRoot: true
    runAsUser: 1001
    runAsGroup: 1001
    fsGroup: 1001
    seccompProfile:
      type: RuntimeDefault
  containers:
  - name: app
    image: myapp:v1.0
    securityContext:
      allowPrivilegeEscalation: false
      readOnlyRootFilesystem: true
      runAsNonRoot: true
      runAsUser: 1001
      capabilities:
        drop:
        - ALL
        add:
        - NET_BIND_SERVICE
    resources:
      requests:
        memory: "256Mi"
        cpu: "250m"
      limits:
        memory: "512Mi"
        cpu: "500m"
    volumeMounts:
    - name: tmp
      mountPath: /tmp
    - name: cache
      mountPath: /app/cache
  volumes:
  - name: tmp
    emptyDir: {}
  - name: cache
    emptyDir: {}
```

### Secrets Management
```bash
# Create secrets from command line
kubectl create secret generic db-credentials \
  --from-literal=username=postgres \
  --from-literal=password=supersecret \
  --namespace=production

# Create TLS secret
kubectl create secret tls myapp-tls \
  --cert=tls.crt \
  --key=tls.key \
  --namespace=production

# Create Docker registry secret
kubectl create secret docker-registry registry-credentials \
  --docker-server=registry.example.com \
  --docker-username=user \
  --docker-password=password \
  --docker-email=user@example.com

# Use sealed secrets for GitOps
kubeseal --format=yaml < secret.yaml > sealed-secret.yaml
```

## CI/CD Integration

### GitOps with ArgoCD
```yaml
# application.yaml - ArgoCD application
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: web-app
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/company/k8s-manifests
    targetRevision: HEAD
    path: web-app
  destination:
    server: https://kubernetes.default.svc
    namespace: production
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
    - CreateNamespace=true
    retry:
      limit: 5
      backoff:
        duration: 5s
        factor: 2
        maxDuration: 3m
```

### GitHub Actions Deployment
```yaml
# .github/workflows/deploy.yml
name: Deploy to Kubernetes

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4

    - name: Setup kubectl
      uses: azure/setup-kubectl@v3
      with:
        version: 'v1.28.0'

    - name: Configure AWS credentials
      uses: aws-actions/configure-aws-credentials@v2
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: us-west-2

    - name: Update kubeconfig
      run: aws eks update-kubeconfig --name production-cluster

    - name: Deploy to Kubernetes
      run: |
        kubectl apply -f k8s/
        kubectl rollout status deployment/web-app -n production
        kubectl get services -n production
```

## Troubleshooting

### Common Issues & Solutions

**Issue**: Pods stuck in Pending state
**Cause**: Insufficient resources or scheduling constraints
**Solution**:
```bash
# Check node resources
kubectl describe nodes
kubectl top nodes

# Check pod events
kubectl describe pod pod-name
kubectl get events --field-selector involvedObject.name=pod-name

# Check resource quotas
kubectl describe resourcequota -n namespace
```

**Issue**: Service not accessible
**Cause**: Incorrect selectors or network policies
**Solution**:
```bash
# Check service endpoints
kubectl get endpoints service-name
kubectl describe service service-name

# Test connectivity
kubectl run debug --image=nicolaka/netshoot -it --rm
# Inside debug pod:
nslookup service-name
curl http://service-name:port
```

**Issue**: Image pull errors
**Cause**: Registry authentication or image availability
**Solution**:
```bash
# Check image pull secrets
kubectl get secrets
kubectl describe secret registry-credentials

# Test image availability
docker pull image:tag

# Check pod events
kubectl describe pod pod-name
```

### Performance Troubleshooting
```bash
# Resource usage
kubectl top pods --sort-by=cpu
kubectl top pods --sort-by=memory
kubectl describe node node-name

# Application performance
kubectl exec -it pod-name -- top
kubectl exec -it pod-name -- ps aux
kubectl logs pod-name --tail=100

# Network performance
kubectl exec -it pod-name -- netstat -tulpn
kubectl exec -it pod-name -- ss -tulpn
```

## Best Practices

### Resource Management
- Always set resource requests and limits
- Use horizontal pod autoscaling for variable workloads
- Implement proper health checks (liveness and readiness probes)
- Use node affinity and anti-affinity for optimal placement
- Monitor resource usage and adjust as needed

### Security Guidelines
- Run containers as non-root users
- Use read-only root filesystems when possible
- Implement network policies for traffic segmentation
- Use secrets for sensitive data, never hardcode
- Regularly update base images and dependencies
- Enable audit logging and monitoring

### Operational Excellence
- Use namespaces for environment separation
- Implement proper labeling and annotation strategies
- Use GitOps for declarative configuration management
- Maintain backup and disaster recovery procedures
- Implement comprehensive monitoring and alerting
- Document deployment procedures and troubleshooting guides

### Development Workflow
- Use local development clusters (minikube, kind, k3d)
- Implement proper CI/CD pipelines
- Use staging environments that mirror production
- Practice infrastructure as code principles
- Implement automated testing for manifests
- Use tools like Helm or Kustomize for templating

## Useful Resources
- **Official Documentation**: https://kubernetes.io/docs/
- **kubectl Cheat Sheet**: https://kubernetes.io/docs/reference/kubectl/cheatsheet/
- **API Reference**: https://kubernetes.io/docs/reference/kubernetes-api/
- **Best Practices**: https://kubernetes.io/docs/concepts/configuration/overview/
- **Troubleshooting Guide**: https://kubernetes.io/docs/tasks/debug-application-cluster/

## Tool-Specific Guidelines

### Version Compatibility
- **Kubernetes**: 1.28+ for latest features and security updates
- **kubectl**: Match or one minor version difference from cluster
- **Container Runtime**: containerd 1.6+ or Docker 24.0+

### Integration Patterns
- Use with Helm for package management
- Integrate with service mesh (Istio, Linkerd) for advanced networking
- Combine with monitoring tools (Prometheus, Grafana) for observability
- Use with GitOps tools (ArgoCD, Flux) for deployment automation
- Leverage with policy engines (OPA Gatekeeper) for compliance
````
