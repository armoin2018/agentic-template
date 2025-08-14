# DigitalOcean Cloud Platform Instructions

## Tool Overview

- **Tool Name**: DigitalOcean
- **Version**: API v2, doctl CLI 1.100+, Terraform Provider 2.34+
- **Category**: Cloud Platform & Infrastructure
- **Purpose**: Developer-friendly cloud platform for deploying, managing, and scaling applications
- **Prerequisites**: DigitalOcean Account, API Token, CLI tools

## Installation & Setup

### DigitalOcean CLI (doctl) Installation

```bash
# macOS installation via Homebrew
brew install doctl

# Windows installation via Chocolatey
choco install doctl

# Linux installation (snap)
sudo snap install doctl

# Manual installation (all platforms)
curl -sL https://github.com/digitalocean/doctl/releases/download/v1.100.0/doctl-1.100.0-linux-amd64.tar.gz | tar -xzv
sudo mv doctl /usr/local/bin

# Verify installation
doctl version
```

### Authentication Setup

```bash
# Authenticate with API token
doctl auth init

# Alternative: Set environment variable
export DIGITALOCEAN_TOKEN="your_api_token_here"

# Verify authentication
doctl account get

# Switch between accounts/contexts
doctl auth switch --context personal
doctl auth switch --context work
```

### Initial Configuration

```bash
# List available regions
doctl compute region list

# List available sizes
doctl compute size list

# List available images
doctl compute image list --public

# Set default region
doctl compute region list
export DO_REGION="nyc1"  # or your preferred region
```

## Core Services and Operations

### Droplets (Virtual Machines)

```bash
# Create a new droplet
doctl compute droplet create my-server \
  --image ubuntu-22-04-x64 \
  --size s-1vcpu-1gb \
  --region nyc1 \
  --ssh-keys $(doctl compute ssh-key list --format ID --no-header | head -1)

# Create multiple droplets
doctl compute droplet create web-{1..3} \
  --image ubuntu-22-04-x64 \
  --size s-2vcpu-2gb \
  --region nyc1 \
  --ssh-keys $(doctl compute ssh-key list --format ID --no-header)

# List droplets
doctl compute droplet list

# Get droplet details
doctl compute droplet get <droplet-id>

# Power operations
doctl compute droplet-action power-off <droplet-id>
doctl compute droplet-action power-on <droplet-id>
doctl compute droplet-action reboot <droplet-id>

# Resize droplet
doctl compute droplet-action resize <droplet-id> --size s-2vcpu-4gb

# Create snapshot
doctl compute droplet-action snapshot <droplet-id> --snapshot-name "backup-$(date +%Y%m%d)"

# Delete droplet
doctl compute droplet delete <droplet-id>
```

### SSH Key Management

```bash
# Add SSH key
doctl compute ssh-key create my-key --public-key-file ~/.ssh/id_rsa.pub

# List SSH keys
doctl compute ssh-key list

# Get SSH key details
doctl compute ssh-key get <key-id>

# Update SSH key
doctl compute ssh-key update <key-id> --name "new-name"

# Delete SSH key
doctl compute ssh-key delete <key-id>
```

### Load Balancers

```bash
# Create load balancer
doctl compute load-balancer create \
  --name web-lb \
  --forwarding-rules entry_protocol:http,entry_port:80,target_protocol:http,target_port:80 \
  --health-check protocol:http,port:80,path:/health,check_interval_seconds:10 \
  --region nyc1

# Add droplets to load balancer
doctl compute load-balancer add-droplets <lb-id> --droplet-ids <droplet1-id>,<droplet2-id>

# List load balancers
doctl compute load-balancer list

# Get load balancer details
doctl compute load-balancer get <lb-id>

# Update load balancer
doctl compute load-balancer update <lb-id> \
  --forwarding-rules entry_protocol:https,entry_port:443,target_protocol:http,target_port:80,certificate_id:<cert-id>

# Delete load balancer
doctl compute load-balancer delete <lb-id>
```

### Block Storage (Volumes)

```bash
# Create volume
doctl compute volume create \
  --size 100GiB \
  --name data-volume \
  --region nyc1 \
  --fs-type ext4

# List volumes
doctl compute volume list

# Attach volume to droplet
doctl compute volume-action attach <volume-id> <droplet-id>

# Detach volume
doctl compute volume-action detach <volume-id>

# Resize volume
doctl compute volume-action resize <volume-id> --size 200

# Create volume snapshot
doctl compute volume-action snapshot <volume-id> --snapshot-name "volume-backup-$(date +%Y%m%d)"

# Delete volume
doctl compute volume delete <volume-id>
```

### Spaces (Object Storage)

```bash
# Create Spaces bucket
doctl compute space create my-bucket --region nyc3

# List spaces
doctl compute space list

# Upload file to space
aws s3 cp file.txt s3://my-bucket/file.txt --endpoint-url=https://nyc3.digitaloceanspaces.com

# Download file from space
aws s3 cp s3://my-bucket/file.txt ./downloaded-file.txt --endpoint-url=https://nyc3.digitaloceanspaces.com

# Set bucket CORS
doctl compute space cors set my-bucket --config cors-config.json

# Delete space
doctl compute space delete my-bucket
```

### Databases (Managed)

```bash
# Create managed database cluster
doctl databases create \
  --engine postgres \
  --name my-db \
  --size db-s-1vcpu-1gb \
  --region nyc1 \
  --version 15

# List database clusters
doctl databases list

# Get database connection details
doctl databases connection <db-id>

# Create database user
doctl databases user create <db-id> --username myuser

# Create database
doctl databases db create <db-id> --name mydatabase

# Create database backup
doctl databases backups list <db-id>

# Resize database cluster
doctl databases resize <db-id> --size db-s-2vcpu-4gb

# Delete database cluster
doctl databases delete <db-id>
```

## Kubernetes Integration

### DigitalOcean Kubernetes (DOKS)

```bash
# Create Kubernetes cluster
doctl kubernetes cluster create my-k8s-cluster \
  --region nyc1 \
  --size s-2vcpu-2gb \
  --count 3 \
  --auto-upgrade \
  --maintenance-window start=04:00,day=sunday

# List Kubernetes clusters
doctl kubernetes cluster list

# Get cluster credentials
doctl kubernetes cluster kubeconfig save my-k8s-cluster

# Get cluster details
doctl kubernetes cluster get my-k8s-cluster

# Add node pool
doctl kubernetes cluster node-pool create my-k8s-cluster \
  --name worker-pool \
  --size s-4vcpu-8gb \
  --count 2 \
  --auto-scale \
  --min-nodes 1 \
  --max-nodes 5

# Update cluster
doctl kubernetes cluster update my-k8s-cluster --auto-upgrade=true

# Delete cluster
doctl kubernetes cluster delete my-k8s-cluster
```

### Container Registry

```bash
# Create container registry
doctl registry create my-registry

# Get registry information
doctl registry get

# Login to registry
doctl registry login

# Tag and push image
docker tag my-app:latest registry.digitalocean.com/my-registry/my-app:latest
docker push registry.digitalocean.com/my-registry/my-app:latest

# List repositories
doctl registry repository list

# List repository tags
doctl registry repository list-tags my-app

# Delete repository
doctl registry repository delete my-registry/my-app

# Configure garbage collection
doctl registry garbage-collection start my-registry
```

## Infrastructure as Code

### Terraform Configuration

```hcl
# main.tf - DigitalOcean infrastructure
terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.34"
    }
  }
}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
}

# Variable for API token
variable "do_token" {
  description = "DigitalOcean API Token"
  type        = string
  sensitive   = true
}

# SSH Key resource
resource "digitalocean_ssh_key" "terraform" {
  name       = "terraform-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

# VPC Network
resource "digitalocean_vpc" "main" {
  name     = "main-vpc"
  region   = "nyc1"
  ip_range = "10.10.0.0/16"
}

# Droplet
resource "digitalocean_droplet" "web" {
  count              = 3
  image              = "ubuntu-22-04-x64"
  name               = "web-${count.index + 1}"
  region             = "nyc1"
  size               = "s-2vcpu-2gb"
  ssh_keys           = [digitalocean_ssh_key.terraform.fingerprint]
  vpc_uuid           = digitalocean_vpc.main.id
  monitoring         = true
  ipv6               = true

  user_data = templatefile("${path.module}/cloud-init.yaml", {
    ssh_key = digitalocean_ssh_key.terraform.public_key
  })

  tags = ["web", "production"]
}

# Load Balancer
resource "digitalocean_loadbalancer" "web" {
  name   = "web-lb"
  region = "nyc1"
  vpc_uuid = digitalocean_vpc.main.id

  forwarding_rule {
    entry_protocol  = "http"
    entry_port      = 80
    target_protocol = "http"
    target_port     = 80
  }

  forwarding_rule {
    entry_protocol  = "https"
    entry_port      = 443
    target_protocol = "http"
    target_port     = 80
    certificate_name = digitalocean_certificate.cert.name
  }

  healthcheck {
    protocol               = "http"
    port                   = 80
    path                   = "/health"
    check_interval_seconds = 10
    response_timeout_seconds = 5
    unhealthy_threshold    = 3
    healthy_threshold      = 2
  }

  droplet_ids = digitalocean_droplet.web[*].id
}

# SSL Certificate
resource "digitalocean_certificate" "cert" {
  name    = "web-cert"
  type    = "lets_encrypt"
  domains = ["example.com", "www.example.com"]
}

# Database
resource "digitalocean_database_cluster" "postgres" {
  name       = "postgres-cluster"
  engine     = "pg"
  version    = "15"
  size       = "db-s-1vcpu-1gb"
  region     = "nyc1"
  node_count = 1

  maintenance_window {
    day  = "sunday"
    hour = "04:00:00"
  }
}

resource "digitalocean_database_db" "app_db" {
  cluster_id = digitalocean_database_cluster.postgres.id
  name       = "app_database"
}

resource "digitalocean_database_user" "app_user" {
  cluster_id = digitalocean_database_cluster.postgres.id
  name       = "app_user"
}

# Block Storage
resource "digitalocean_volume" "data" {
  region      = "nyc1"
  name        = "data-volume"
  size        = 100
  description = "Application data volume"
}

resource "digitalocean_volume_attachment" "data" {
  droplet_id = digitalocean_droplet.web[0].id
  volume_id  = digitalocean_volume.data.id
}

# Spaces bucket
resource "digitalocean_spaces_bucket" "assets" {
  name   = "my-app-assets"
  region = "nyc3"
  acl    = "public-read"

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "POST", "PUT", "DELETE", "HEAD"]
    allowed_origins = ["*"]
    max_age_seconds = 3000
  }
}

# Kubernetes cluster
resource "digitalocean_kubernetes_cluster" "main" {
  name    = "main-cluster"
  region  = "nyc1"
  version = "1.28.2-do.0"
  vpc_uuid = digitalocean_vpc.main.id

  maintenance_policy {
    start_time = "04:00"
    day        = "sunday"
  }

  node_pool {
    name       = "default"
    size       = "s-2vcpu-2gb"
    node_count = 3
    auto_scale = true
    min_nodes  = 1
    max_nodes  = 5

    labels = {
      environment = "production"
    }

    taint {
      key    = "workloadKind"
      value  = "database"
      effect = "NoSchedule"
    }
  }
}

# Container Registry
resource "digitalocean_container_registry" "main" {
  name                   = "my-registry"
  subscription_tier_slug = "basic"
}

# Outputs
output "droplet_ips" {
  value = digitalocean_droplet.web[*].ipv4_address
}

output "load_balancer_ip" {
  value = digitalocean_loadbalancer.web.ip
}

output "database_host" {
  value = digitalocean_database_cluster.postgres.host
  sensitive = true
}

output "database_port" {
  value = digitalocean_database_cluster.postgres.port
}

output "kubernetes_endpoint" {
  value = digitalocean_kubernetes_cluster.main.endpoint
}
```

### Cloud-Init Configuration

```yaml
# cloud-init.yaml
#cloud-config
users:
  - name: deploy
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    shell: /bin/bash
    ssh_authorized_keys:
      - ${ssh_key}

packages:
  - nginx
  - docker.io
  - docker-compose
  - ufw
  - fail2ban
  - htop
  - git

package_update: true
package_upgrade: true

runcmd:
  # Configure firewall
  - ufw --force enable
  - ufw allow ssh
  - ufw allow http
  - ufw allow https

  # Start and enable services
  - systemctl start docker
  - systemctl enable docker
  - systemctl start nginx
  - systemctl enable nginx

  # Add deploy user to docker group
  - usermod -aG docker deploy

  # Configure nginx
  - |
    cat > /etc/nginx/sites-available/default << 'EOF'
    server {
        listen 80;
        server_name _;
        
        location /health {
            access_log off;
            return 200 "healthy\n";
            add_header Content-Type text/plain;
        }
        
        location / {
            proxy_pass http://localhost:3000;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
    EOF

  # Restart nginx
  - systemctl restart nginx

  # Create application directory
  - mkdir -p /opt/app
  - chown deploy:deploy /opt/app

write_files:
  - path: /opt/app/docker-compose.yml
    content: |
      version: '3.8'
      services:
        app:
          image: registry.digitalocean.com/my-registry/my-app:latest
          ports:
            - "3000:3000"
          environment:
            - NODE_ENV=production
            - DATABASE_URL=${database_url}
          restart: unless-stopped
          logging:
            driver: "json-file"
            options:
              max-size: "10m"
              max-file: "3"
    owner: deploy:deploy
    permissions: '0644'
```

## Application Deployment

### Docker Deployment

```bash
# Build and push application
docker build -t my-app:latest .
docker tag my-app:latest registry.digitalocean.com/my-registry/my-app:latest

# Login to registry
doctl registry login

# Push image
docker push registry.digitalocean.com/my-registry/my-app:latest

# Deploy to droplet
ssh deploy@droplet-ip
cd /opt/app
docker-compose pull
docker-compose up -d
```

### Kubernetes Deployment

```yaml
# k8s/namespace.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: production
---
# k8s/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
  namespace: production
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
        - name: my-app
          image: registry.digitalocean.com/my-registry/my-app:latest
          ports:
            - containerPort: 3000
          env:
            - name: NODE_ENV
              value: 'production'
            - name: DATABASE_URL
              valueFrom:
                secretKeyRef:
                  name: app-secrets
                  key: database-url
          resources:
            requests:
              memory: '256Mi'
              cpu: '250m'
            limits:
              memory: '512Mi'
              cpu: '500m'
          livenessProbe:
            httpGet:
              path: /health
              port: 3000
            initialDelaySeconds: 30
            periodSeconds: 10
          readinessProbe:
            httpGet:
              path: /ready
              port: 3000
            initialDelaySeconds: 5
            periodSeconds: 5
---
apiVersion: v1
kind: Service
metadata:
  name: my-app-service
  namespace: production
spec:
  selector:
    app: my-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 3000
  type: ClusterIP
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-app-ingress
  namespace: production
  annotations:
    kubernetes.io/ingress.class: 'nginx'
    cert-manager.io/cluster-issuer: 'letsencrypt-prod'
    nginx.ingress.kubernetes.io/ssl-redirect: 'true'
spec:
  tls:
    - hosts:
        - my-app.example.com
      secretName: my-app-tls
  rules:
    - host: my-app.example.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: my-app-service
                port:
                  number: 80
```

### App Platform Deployment

```yaml
# .do/app.yaml
name: my-web-app
services:
  - name: web
    source_dir: /
    github:
      repo: your-username/your-repo
      branch: main
      deploy_on_push: true
    run_command: npm start
    environment_slug: node-js
    instance_count: 1
    instance_size_slug: basic-xxs
    routes:
      - path: /
    health_check:
      http_path: /health
    envs:
      - key: NODE_ENV
        value: production
      - key: DATABASE_URL
        type: SECRET
        value: ${postgres.DATABASE_URL}

  - name: worker
    source_dir: /
    github:
      repo: your-username/your-repo
      branch: main
    run_command: npm run worker
    environment_slug: node-js
    instance_count: 1
    instance_size_slug: basic-xxs
    envs:
      - key: NODE_ENV
        value: production
      - key: REDIS_URL
        type: SECRET
        value: ${redis.DATABASE_URL}

databases:
  - name: postgres
    engine: PG
    version: '15'
    size: db-s-dev-database
    num_nodes: 1

  - name: redis
    engine: REDIS
    version: '7'
    size: db-s-dev-database
    num_nodes: 1

static_sites:
  - name: frontend
    source_dir: dist
    github:
      repo: your-username/frontend-repo
      branch: main
      deploy_on_push: true
    build_command: npm run build
    environment_slug: node-js
    routes:
      - path: /
    envs:
      - key: API_URL
        value: ${web.PUBLIC_URL}
```

## Monitoring and Logging

### Monitoring Setup

```bash
# Enable monitoring for droplets
doctl compute droplet create my-server \
  --image ubuntu-22-04-x64 \
  --size s-1vcpu-1gb \
  --region nyc1 \
  --monitoring \
  --ssh-keys $(doctl compute ssh-key list --format ID --no-header)

# View monitoring metrics
doctl monitoring alert policy list
doctl monitoring alert policy get <policy-id>

# Create alert policy
doctl monitoring alert policy create \
  --type v1/insights/droplet/cpu \
  --description "High CPU Alert" \
  --compare GreaterThan \
  --value 80 \
  --window 5m \
  --entities <droplet-id>
```

### Log Management

```bash
# Install logging agent on droplet
curl -sSL https://repos.insights.digitalocean.com/install.sh | sudo bash

# Configure log shipping
sudo tee /etc/td-agent-bit/td-agent-bit.conf << 'EOF'
[SERVICE]
    Flush         5
    Daemon        off
    Log_Level     info
    Parsers_File  parsers.conf

[INPUT]
    Name              tail
    Path              /var/log/nginx/access.log
    Parser            nginx
    Tag               nginx.access

[INPUT]
    Name              tail
    Path              /var/log/nginx/error.log
    Tag               nginx.error

[OUTPUT]
    Name              forward
    Match             *
    Host              logs.digitalocean.com
    Port              514
    tls               on
    tls.verify        on
EOF

sudo systemctl restart td-agent-bit
```

## Security and Best Practices

### Security Configuration

```bash
# Enable firewalls on droplets
doctl compute firewall create \
  --name web-firewall \
  --inbound-rules protocol:tcp,ports:22,sources:load_balancer \
  --inbound-rules protocol:tcp,ports:80,sources:0.0.0.0/0,::/0 \
  --inbound-rules protocol:tcp,ports:443,sources:0.0.0.0/0,::/0 \
  --outbound-rules protocol:tcp,ports:all,destinations:0.0.0.0/0,::/0

# Apply firewall to droplets
doctl compute firewall add-droplets web-firewall --droplet-ids <droplet-id>

# Configure automatic security updates
ssh root@droplet-ip 'echo "unattended-upgrades unattended-upgrades/enable_auto_updates boolean true" | debconf-set-selections'
ssh root@droplet-ip 'apt-get update && apt-get install -y unattended-upgrades'
```

### Backup Strategy

```bash
# Create automated snapshots
doctl compute droplet-action snapshot <droplet-id> --snapshot-name "daily-backup-$(date +%Y%m%d)"

# Volume snapshots
doctl compute volume-action snapshot <volume-id> --snapshot-name "volume-backup-$(date +%Y%m%d)"

# Database backups
doctl databases backups list <db-id>

# Spaces backup script
#!/bin/bash
# backup-to-spaces.sh
DATE=$(date +%Y%m%d)
BACKUP_NAME="backup-$DATE.tar.gz"

# Create backup
tar czf $BACKUP_NAME /opt/app

# Upload to Spaces
aws s3 cp $BACKUP_NAME s3://my-backups/$BACKUP_NAME \
  --endpoint-url=https://nyc3.digitaloceanspaces.com

# Cleanup old backups (keep last 7 days)
aws s3 ls s3://my-backups/ --endpoint-url=https://nyc3.digitaloceanspaces.com | \
  head -n -7 | awk '{print $4}' | \
  xargs -I {} aws s3 rm s3://my-backups/{} --endpoint-url=https://nyc3.digitaloceanspaces.com

rm $BACKUP_NAME
```

### CI/CD Integration

```yaml
# .github/workflows/deploy.yml
name: Deploy to DigitalOcean

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Install doctl
        uses: digitalocean/action-doctl@v2
        with:
          token: ${{ secrets.DIGITALOCEAN_ACCESS_TOKEN }}

      - name: Build container image
        run: |
          docker build -t registry.digitalocean.com/my-registry/my-app:${{ github.sha }} .
          docker tag registry.digitalocean.com/my-registry/my-app:${{ github.sha }} registry.digitalocean.com/my-registry/my-app:latest

      - name: Log in to DigitalOcean Container Registry
        run: doctl registry login --expiry-seconds 1200

      - name: Push image to DigitalOcean Container Registry
        run: |
          docker push registry.digitalocean.com/my-registry/my-app:${{ github.sha }}
          docker push registry.digitalocean.com/my-registry/my-app:latest

      - name: Update deployment
        run: |
          doctl kubernetes cluster kubeconfig save --expiry-seconds 600 my-k8s-cluster
          kubectl set image deployment/my-app my-app=registry.digitalocean.com/my-registry/my-app:${{ github.sha }} -n production
          kubectl rollout status deployment/my-app -n production
```

This comprehensive DigitalOcean guide covers everything from basic droplet management to advanced Kubernetes deployments, providing a complete reference for using DigitalOcean's cloud platform effectively.
