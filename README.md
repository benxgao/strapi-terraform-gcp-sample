# Strapi on GCP with Terraform

A production-ready infrastructure setup for deploying Strapi CMS on Google Cloud Platform using Terraform and CircleCI.

## 🚀 Quick Start

### Prerequisites

- Docker Desktop
- Node.js 18+
- Terraform 1.0+
- GCP Account
- CircleCI Account (for CI/CD)

### Local Development

```bash
# Clone the repository
git clone https://github.com/benxgao/strapi-terraform-gcp.git
cd strapi-terraform-gcp

# Start Strapi development server
cd strapi-server
docker-compose up --build
```

## 🏗 Infrastructure Setup

### Initial GCP Setup

```bash
# Initialize GCP infrastructure
cd terraform/environments/init
terraform init
terraform plan
terraform apply
```

### Staging Environment

```bash
# Deploy to staging
cd terraform/environments/staging
terraform init
terraform plan
terraform apply
```

## 🔄 CI/CD Pipeline

### Manual Deployment

```bash
# Deploy infrastructure changes
git checkout terraform-staging
git push

# Deploy Strapi application
git checkout strapi-staging
git push
```

### Automated Deployment

The project uses CircleCI for automated deployments:

- Infrastructure changes trigger on `terraform-staging` branch
- Application updates trigger on `strapi-staging` branch

## 📚 Documentation

- [Infrastructure Setup Guide](docs/terraform.md)
- [GCP Configuration](docs/gcp.md)
- [CI/CD Pipeline](docs/cicd.md)

## 🙏 Acknowledgments

This project is built upon the excellent work and guidance provided in the article:

- [Strapi Headless CMS + Google Cloud Run and PostgreSQL](https://medium.com/google-cloud/strapi-headless-cms-google-cloud-run-and-postgresql-6126b597b10c) by Prashant Sharma

The article provided the foundation for our GCP infrastructure setup, which we've extended with:

- Terraform Infrastructure as Code
- CircleCI Integration
- Production-ready configurations
- Automated deployment pipelines

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the Apache 2.0 License - see the [LICENSE](LICENSE) file for details.
