````instructions
# AWS (Amazon Web Services) Instructions

## Tool Overview
- **Tool Name**: AWS CLI and AWS SDK
- **Version**: AWS CLI v2.15+, SDK varies by language
- **Category**: Cloud Platform & Infrastructure
- **Purpose**: Complete cloud computing platform for hosting, storage, compute, AI/ML, and 200+ services
- **Prerequisites**: AWS Account, AWS CLI, appropriate IAM permissions

## Installation & Setup
### AWS CLI Installation
```bash
# macOS (Homebrew)
brew install awscli

# Windows (using installer)
msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi

# Linux (using installer)
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Verify installation
aws --version
```

### Authentication & Configuration
```bash
# Configure AWS credentials (interactive)
aws configure

# Set specific profile
aws configure --profile production

# Configure using environment variables
export AWS_ACCESS_KEY_ID=your_access_key
export AWS_SECRET_ACCESS_KEY=your_secret_key
export AWS_DEFAULT_REGION=us-east-1

# Using AWS SSO (recommended for organizations)
aws configure sso
aws sso login --profile my-profile
```

### Project Integration
```bash
# Initialize AWS CDK project
npm install -g aws-cdk
cdk init app --language typescript

# Initialize Serverless Framework
npm install -g serverless
serverless create --template aws-nodejs-typescript

# Initialize SAM project
sam init
```

## Configuration
### AWS Configuration Files
```ini
# ~/.aws/credentials
[default]
aws_access_key_id = YOUR_ACCESS_KEY
aws_secret_access_key = YOUR_SECRET_KEY

[production]
aws_access_key_id = PROD_ACCESS_KEY
aws_secret_access_key = PROD_SECRET_KEY
```

```ini
# ~/.aws/config
[default]
region = us-east-1
output = json

[profile production]
region = us-west-2
output = table
```

### Environment Variables
```bash
# Authentication
export AWS_ACCESS_KEY_ID=your_access_key
export AWS_SECRET_ACCESS_KEY=your_secret_key
export AWS_SESSION_TOKEN=your_session_token  # For temporary credentials

# Configuration
export AWS_DEFAULT_REGION=us-east-1
export AWS_PROFILE=production
export AWS_CONFIG_FILE=/path/to/config
export AWS_SHARED_CREDENTIALS_FILE=/path/to/credentials
```

## Core AWS Services

### EC2 (Elastic Compute Cloud)
- **Purpose**: Virtual servers in the cloud for compute workloads
- **Usage**: Web applications, batch processing, microservices
- **Example**:
```bash
# Launch EC2 instance
aws ec2 run-instances \
    --image-id ami-0abcdef1234567890 \
    --count 1 \
    --instance-type t3.micro \
    --key-name MyKeyPair \
    --security-group-ids sg-903004f8 \
    --subnet-id subnet-6e7f829e

# List instances
aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId,State.Name,PublicIpAddress]'

# Stop instance
aws ec2 stop-instances --instance-ids i-1234567890abcdef0
```

### S3 (Simple Storage Service)
- **Purpose**: Object storage for files, backups, static websites, and data lakes
- **Usage**: Static website hosting, data archival, content distribution
- **Example**:
```bash
# Create bucket
aws s3 mb s3://my-unique-bucket-name --region us-east-1

# Upload file
aws s3 cp local-file.txt s3://my-bucket/path/to/file.txt

# Sync directory
aws s3 sync ./local-folder s3://my-bucket/remote-folder --delete

# List objects
aws s3 ls s3://my-bucket --recursive

# Set bucket policy for static website
aws s3api put-bucket-policy --bucket my-bucket --policy file://bucket-policy.json
```

### Lambda (Serverless Computing)
- **Purpose**: Run code without provisioning servers, event-driven execution
- **Usage**: API backends, data processing, automation, microservices
- **Example**:
```bash
# Create function
aws lambda create-function \
    --function-name MyFunction \
    --runtime nodejs18.x \
    --role arn:aws:iam::123456789012:role/lambda-role \
    --handler index.handler \
    --zip-file fileb://function.zip

# Invoke function
aws lambda invoke \
    --function-name MyFunction \
    --payload '{"key": "value"}' \
    response.json

# Update function code
aws lambda update-function-code \
    --function-name MyFunction \
    --zip-file fileb://new-function.zip
```

### RDS (Relational Database Service)
- **Purpose**: Managed relational databases (MySQL, PostgreSQL, Aurora, etc.)
- **Usage**: Web applications, data warehousing, analytics
- **Example**:
```bash
# Create database instance
aws rds create-db-instance \
    --db-instance-identifier mydb \
    --db-instance-class db.t3.micro \
    --engine postgres \
    --master-username admin \
    --master-user-password mypassword \
    --allocated-storage 20

# List databases
aws rds describe-db-instances --query 'DBInstances[*].[DBInstanceIdentifier,DBInstanceStatus,Endpoint.Address]'

# Create snapshot
aws rds create-db-snapshot \
    --db-instance-identifier mydb \
    --db-snapshot-identifier mydb-snapshot-$(date +%Y%m%d)
```

## Common Commands
```bash
# Authentication and configuration
aws configure                              # Set up credentials and region
aws sts get-caller-identity               # Verify current user/role
aws configure list                        # Show current configuration

# EC2 operations
aws ec2 describe-instances                # List all instances
aws ec2 describe-images --owners self     # List your AMIs
aws ec2 describe-security-groups          # List security groups
aws ec2 describe-key-pairs                # List key pairs

# S3 operations
aws s3 ls                                 # List all buckets
aws s3 ls s3://bucket-name                # List objects in bucket
aws s3 cp file.txt s3://bucket/           # Upload file
aws s3 sync ./folder s3://bucket/folder   # Sync directory

# Lambda operations
aws lambda list-functions                 # List all functions
aws lambda get-function --function-name name  # Get function details
aws lambda list-event-source-mappings    # List event sources

# CloudFormation operations
aws cloudformation list-stacks            # List all stacks
aws cloudformation describe-stacks --stack-name name  # Stack details
aws cloudformation validate-template --template-body file://template.yaml

# IAM operations
aws iam list-users                        # List IAM users
aws iam list-roles                        # List IAM roles
aws iam list-policies --scope Local       # List custom policies
```

## Infrastructure as Code

### AWS CloudFormation
```yaml
# template.yaml
AWSTemplateFormatVersion: '2010-09-09'
Description: 'Basic web application infrastructure'

Parameters:
  InstanceType:
    Type: String
    Default: t3.micro
    AllowedValues: [t3.micro, t3.small, t3.medium]

Resources:
  WebServerInstance:
    Type: AWS::EC2::Instance
    Properties:
      ImageId: ami-0abcdef1234567890
      InstanceType: !Ref InstanceType
      SecurityGroups:
        - !Ref WebServerSecurityGroup
      UserData:
        Fn::Base64: !Sub |
          #!/bin/bash
          yum update -y
          yum install -y httpd
          systemctl start httpd

  WebServerSecurityGroup:
    Type: AWS::EC2::SecurityGroup
    Properties:
      GroupDescription: Enable HTTP access
      SecurityGroupIngress:
        - IpProtocol: tcp
          FromPort: 80
          ToPort: 80
          CidrIp: 0.0.0.0/0

Outputs:
  WebsiteURL:
    Description: URL of the website
    Value: !Sub 'http://${WebServerInstance.PublicDnsName}'
```

### AWS CDK (TypeScript)
```typescript
import * as cdk from 'aws-cdk-lib';
import * as ec2 from 'aws-cdk-lib/aws-ec2';
import * as iam from 'aws-cdk-lib/aws-iam';

export class WebAppStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    // Create VPC
    const vpc = new ec2.Vpc(this, 'WebAppVPC', {
      maxAzs: 2,
      natGateways: 1,
    });

    // Create security group
    const webSG = new ec2.SecurityGroup(this, 'WebServerSG', {
      vpc,
      description: 'Security group for web servers',
    });

    webSG.addIngressRule(
      ec2.Peer.anyIpv4(),
      ec2.Port.tcp(80),
      'Allow HTTP traffic'
    );

    // Create EC2 instance
    const webServer = new ec2.Instance(this, 'WebServer', {
      vpc,
      instanceType: ec2.InstanceType.of(
        ec2.InstanceClass.T3,
        ec2.InstanceSize.MICRO
      ),
      machineImage: ec2.MachineImage.latestAmazonLinux(),
      securityGroup: webSG,
      userData: ec2.UserData.forLinux(),
    });

    // Add user data script
    webServer.addUserData(
      'yum update -y',
      'yum install -y httpd',
      'systemctl start httpd',
      'systemctl enable httpd'
    );
  }
}
```

## Serverless Development

### AWS SAM Template
```yaml
# template.yaml
AWSTemplateFormatVersion: '2010-09-09'
Transform: AWS::Serverless-2016-10-31
Description: Serverless web application

Globals:
  Function:
    Runtime: nodejs18.x
    Timeout: 30
    Environment:
      Variables:
        TABLE_NAME: !Ref UserTable

Resources:
  # API Gateway
  ApiGateway:
    Type: AWS::Serverless::Api
    Properties:
      StageName: prod
      Cors:
        AllowMethods: "'*'"
        AllowHeaders: "'*'"
        AllowOrigin: "'*'"

  # Lambda Functions
  GetUsersFunction:
    Type: AWS::Serverless::Function
    Properties:
      CodeUri: src/
      Handler: users.getUsers
      Events:
        Api:
          Type: Api
          Properties:
            RestApiId: !Ref ApiGateway
            Path: /users
            Method: GET

  CreateUserFunction:
    Type: AWS::Serverless::Function
    Properties:
      CodeUri: src/
      Handler: users.createUser
      Events:
        Api:
          Type: Api
          Properties:
            RestApiId: !Ref ApiGateway
            Path: /users
            Method: POST

  # DynamoDB Table
  UserTable:
    Type: AWS::DynamoDB::Table
    Properties:
      BillingMode: PAY_PER_REQUEST
      AttributeDefinitions:
        - AttributeName: userId
          AttributeType: S
      KeySchema:
        - AttributeName: userId
          KeyType: HASH

Outputs:
  ApiUrl:
    Description: API Gateway endpoint URL
    Value: !Sub "https://${ApiGateway}.execute-api.${AWS::Region}.amazonaws.com/prod/"
```

### Lambda Function Example
```javascript
// src/users.js
const AWS = require('aws-sdk');
const dynamodb = new AWS.DynamoDB.DocumentClient();

exports.getUsers = async (event) => {
    try {
        const result = await dynamodb.scan({
            TableName: process.env.TABLE_NAME
        }).promise();

        return {
            statusCode: 200,
            headers: {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            body: JSON.stringify(result.Items)
        };
    } catch (error) {
        return {
            statusCode: 500,
            body: JSON.stringify({ error: error.message })
        };
    }
};

exports.createUser = async (event) => {
    try {
        const user = JSON.parse(event.body);

        await dynamodb.put({
            TableName: process.env.TABLE_NAME,
            Item: {
                userId: user.id,
                name: user.name,
                email: user.email,
                createdAt: new Date().toISOString()
            }
        }).promise();

        return {
            statusCode: 201,
            headers: {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            body: JSON.stringify({ message: 'User created successfully' })
        };
    } catch (error) {
        return {
            statusCode: 500,
            body: JSON.stringify({ error: error.message })
        };
    }
};
```

## Security Best Practices

### IAM Policies and Roles
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": [
        "arn:aws:s3:::my-app-bucket/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:Query",
        "dynamodb:Scan"
      ],
      "Resource": [
        "arn:aws:dynamodb:us-east-1:123456789012:table/MyTable"
      ]
    }
  ]
}
```

### Security Checklist
- ✅ Use IAM roles instead of access keys when possible
- ✅ Enable MFA for AWS account root user
- ✅ Apply principle of least privilege to IAM policies
- ✅ Enable CloudTrail for audit logging
- ✅ Use VPC for network isolation
- ✅ Enable encryption at rest and in transit
- ✅ Regularly rotate access keys
- ✅ Use AWS Config for compliance monitoring

## Common Issues & Solutions

### Authentication Issues
**Problem**: "Unable to locate credentials" error
**Solution**: Configure AWS credentials properly
```bash
# Check current credentials
aws sts get-caller-identity

# Reconfigure if needed
aws configure

# Use specific profile
export AWS_PROFILE=production
```

### Permission Denied Errors
**Problem**: Access denied when calling AWS services
**Solution**: Check IAM permissions and policies
```bash
# Check current user/role
aws sts get-caller-identity

# List attached policies
aws iam list-attached-user-policies --user-name username
aws iam list-attached-role-policies --role-name rolename

# Test specific permissions
aws iam simulate-principal-policy \
    --policy-source-arn arn:aws:iam::123456789012:user/username \
    --action-names s3:GetObject \
    --resource-arns arn:aws:s3:::bucket-name/*
```

### Service Limits
**Problem**: Reaching AWS service limits
**Solution**: Request limit increases through AWS Support
```bash
# Check current limits
aws service-quotas list-service-quotas --service-code ec2
aws service-quotas get-service-quota --service-code ec2 --quota-code L-1216C47A

# Request quota increase (requires support case)
aws support create-case --subject "EC2 instance limit increase"
```

## Performance Optimization

### Cost Optimization
- Use Reserved Instances for predictable workloads
- Implement auto-scaling for variable workloads
- Use Spot Instances for fault-tolerant workloads
- Right-size instances based on CloudWatch metrics
- Use S3 Intelligent-Tiering for storage optimization
- Enable AWS Cost Explorer and billing alerts

### Monitoring and Observability
```bash
# CloudWatch metrics
aws cloudwatch get-metric-statistics \
    --namespace AWS/EC2 \
    --metric-name CPUUtilization \
    --dimensions Name=InstanceId,Value=i-1234567890abcdef0 \
    --statistics Average \
    --start-time $(date -d '1 hour ago' -u +%Y-%m-%dT%H:%M:%S) \
    --end-time $(date -u +%Y-%m-%dT%H:%M:%S) \
    --period 300

# X-Ray tracing for Lambda
aws xray get-trace-summaries \
    --time-range-type TimeRangeByStartTime \
    --start-time $(date -d '1 hour ago' +%s) \
    --end-time $(date +%s)
```

## AWS SDK Integration

### Node.js SDK v3
```javascript
import { S3Client, PutObjectCommand, GetObjectCommand } from "@aws-sdk/client-s3";
import { DynamoDBClient, PutItemCommand, GetItemCommand } from "@aws-sdk/client-dynamodb";

// Initialize clients
const s3Client = new S3Client({ region: "us-east-1" });
const dynamoClient = new DynamoDBClient({ region: "us-east-1" });

// S3 operations
export async function uploadFile(bucketName, key, body) {
    const command = new PutObjectCommand({
        Bucket: bucketName,
        Key: key,
        Body: body,
        ContentType: 'application/json'
    });

    return await s3Client.send(command);
}

export async function downloadFile(bucketName, key) {
    const command = new GetObjectCommand({
        Bucket: bucketName,
        Key: key
    });

    const response = await s3Client.send(command);
    return response.Body;
}

// DynamoDB operations
export async function saveUser(user) {
    const command = new PutItemCommand({
        TableName: 'Users',
        Item: {
            id: { S: user.id },
            name: { S: user.name },
            email: { S: user.email }
        }
    });

    return await dynamoClient.send(command);
}
```

### Python Boto3
```python
import boto3
from botocore.exceptions import ClientError

# Initialize clients
s3_client = boto3.client('s3')
dynamodb = boto3.resource('dynamodb')

def upload_file(bucket_name, object_key, file_path):
    """Upload a file to S3 bucket"""
    try:
        s3_client.upload_file(file_path, bucket_name, object_key)
        return True
    except ClientError as e:
        print(f"Error uploading file: {e}")
        return False

def save_user(table_name, user_data):
    """Save user to DynamoDB"""
    try:
        table = dynamodb.Table(table_name)
        response = table.put_item(Item=user_data)
        return response
    except ClientError as e:
        print(f"Error saving user: {e}")
        raise
```

## Useful Resources
- **Official Documentation**: https://docs.aws.amazon.com/
- **AWS CLI Reference**: https://docs.aws.amazon.com/cli/
- **AWS SDK Documentation**: https://aws.amazon.com/developer/tools/
- **AWS Architecture Center**: https://aws.amazon.com/architecture/
- **AWS Well-Architected Framework**: https://aws.amazon.com/architecture/well-architected/
- **AWS Cost Calculator**: https://calculator.aws/
- **AWS Service Status**: https://status.aws.amazon.com/

## Service-Specific Guidelines

### Compute Services
- **EC2**: Use appropriate instance types, implement auto-scaling
- **Lambda**: Optimize memory allocation, use provisioned concurrency for latency-sensitive apps
- **ECS/EKS**: Use task definitions, implement proper logging and monitoring

### Storage Services
- **S3**: Use appropriate storage classes, implement lifecycle policies
- **EBS**: Choose appropriate volume types, implement snapshots
- **EFS**: Use for shared file storage across multiple instances

### Database Services
- **RDS**: Use Multi-AZ for high availability, implement automated backups
- **DynamoDB**: Design efficient partition keys, use Global Secondary Indexes appropriately
- **Aurora**: Use for high-performance applications, implement read replicas

### Networking
- **VPC**: Implement proper subnetting, use NAT gateways for private subnets
- **CloudFront**: Use for content delivery, implement caching strategies
- **Route 53**: Use for DNS management, implement health checks

## Version Compatibility
- **AWS CLI**: v2.15+ (recommended), v1.x deprecated
- **Node.js SDK**: v3.x (latest), v2.x maintenance mode
- **Python SDK**: boto3 1.26+, botocore 1.29+
- **Java SDK**: v2.x for new projects, v1.x legacy support
- **Platform Support**: Windows, macOS, Linux

## Troubleshooting

### Debug Mode
```bash
# Enable AWS CLI debug output
aws --debug s3 ls

# Set log level for SDK (Node.js)
export AWS_LOG_LEVEL=debug

# Python logging
import logging
boto3.set_stream_logger('botocore', logging.DEBUG)
```

### Common Error Messages
- **Error**: `The security token included in the request is invalid`
  **Cause**: Expired credentials or incorrect region
  **Solution**: Refresh credentials and verify region settings

- **Error**: `An error occurred (AccessDenied) when calling the PutObject operation`
  **Cause**: Insufficient S3 permissions
  **Solution**: Check bucket policies and IAM permissions

- **Error**: `Could not connect to the endpoint URL`
  **Cause**: Incorrect region or endpoint configuration
  **Solution**: Verify region settings and network connectivity
````

1. **Setup**: [Initial setup steps]
2. **Development**: [How to use during development]
3. **Testing**: [Integration with testing process]
4. **Pre-commit**: [Pre-commit hooks or checks]
5. **CI/CD**: [Continuous integration usage]

### Automation Scripts

```bash
# Package.json scripts (if applicable)
{
  "scripts": {
    "[script-name]": "[tool] [command]",
    "[workflow-script]": "[tool] [workflow-command]"
  }
}
```

### Git Hooks Integration

```bash
# Pre-commit hook example
#!/bin/sh
[tool] [validation-command]
```

## Best Practices

### Configuration Best Practices

- [Best practice 1 with explanation]
- [Best practice 2 with explanation]
- [Best practice 3 with explanation]

### Usage Patterns

- [Pattern 1: When and how to use]
- [Pattern 2: When and how to use]
- [Pattern 3: When and how to use]

### Performance Optimization

- [Optimization tip 1]
- [Optimization tip 2]
- [Optimization tip 3]

## Common Use Cases

### [Use Case 1]

**Scenario**: [Description of the scenario]
**Implementation**:

```bash
[tool] [specific-commands]
```

**Expected Result**: [What should happen]

### [Use Case 2]

**Scenario**: [Description of the scenario]
**Implementation**:

```bash
[tool] [specific-commands]
```

**Expected Result**: [What should happen]

### [Use Case 3]

**Scenario**: [Description of the scenario]
**Implementation**:

```bash
[tool] [specific-commands]
```

**Expected Result**: [What should happen]

## Integration with Other Tools

### [Related Tool 1]

- **Integration Purpose**: [Why integrate]
- **Setup**: [How to configure integration]
- **Usage**: [How they work together]

### [Related Tool 2]

- **Integration Purpose**: [Why integrate]
- **Setup**: [How to configure integration]
- **Usage**: [How they work together]

## Troubleshooting

### Common Issues

#### [Issue 1]

**Problem**: [Description of the problem]
**Symptoms**: [How to identify this issue]
**Solution**: [Step-by-step fix]

#### [Issue 2]

**Problem**: [Description of the problem]
**Symptoms**: [How to identify this issue]
**Solution**: [Step-by-step fix]

#### [Issue 3]

**Problem**: [Description of the problem]
**Symptoms**: [How to identify this issue]
**Solution**: [Step-by-step fix]

### Debug Mode

```bash
# Enable verbose/debug output
[tool] --verbose [command]
[tool] --debug [command]

# Log analysis
[tool] logs
[tool] status --detailed
```

### Performance Issues

- [Performance issue 1 and solution]
- [Performance issue 2 and solution]
- [Performance issue 3 and solution]

## Security Considerations

### Security Best Practices

- [Security practice 1]
- [Security practice 2]
- [Security practice 3]

### Sensitive Data Handling

- [How the tool handles secrets]
- [Configuration for secure usage]
- [Best practices for credentials]

### Network Security

- [Network-related security considerations]
- [Proxy and firewall configurations]
- [Certificate and SSL handling]

## Advanced Configuration

### Custom Plugins/Extensions

```[config-format]
# Plugin configuration
[plugin-config-example]
```

### Scripting and Automation

```bash
# Advanced scripting examples
[automation-script-example]
```

### Performance Tuning

```[config-format]
# Performance optimization settings
[performance-config-example]
```

## Version Management

### Version Compatibility

- **Tool Version**: [Version requirements]
- **Node.js**: [If applicable]
- **Python**: [If applicable]
- **OS Support**: [Supported operating systems]

### Migration Guides

- **From [Old Version]**: [Migration steps]
- **Breaking Changes**: [Important changes to note]
- **Deprecation Notices**: [Features being deprecated]

## Useful Resources

- **Official Documentation**: [URL]
- **GitHub Repository**: [URL]
- **Community Resources**: [URLs]
- **Tutorials**: [URLs]
- **Plugin/Extension Registry**: [URL]
- **Stack Overflow Tag**: [Tag name]

## Tool-Specific Guidelines

### Code Organization

- [How the tool affects code structure]
- [File organization recommendations]
- [Naming conventions]

### Maintenance

- [Regular maintenance tasks]
- [Update procedures]
- [Cleanup and optimization]

## Examples and Templates

### Basic Example

```[language]
// Example usage in context
[practical-example]
```

### Advanced Example

```[language]
// Advanced usage pattern
[advanced-example]
```

### Template Files

```[format]
# Template configuration
[template-example]
```

## AI Assistant Guidelines

When helping with [Tool Name]:

1. **Always suggest the most current stable version**
2. **Provide working configuration examples**
3. **Include error handling in scripts**
4. **Mention security implications when relevant**
5. **Suggest integration with development workflow**
6. **Provide troubleshooting steps for common issues**
7. **Include performance considerations**
8. **Reference official documentation**

### Code Generation Rules

- Generate configurations that follow tool best practices
- Include comments explaining important settings
- Provide multiple options when appropriate
- Include validation and error checking
- Follow the project's existing patterns and conventions

```

```
