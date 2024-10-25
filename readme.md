# VTI Final Project

This repository contains the final project for the VTI course, which is divided into two main parts: `application` and `infra`.

## Project Structure

- **application**: This directory contains the application code written primarily in Python and HTML.
- **infra**: This directory contains infrastructure configurations written primarily in HCL.

## Getting Started

### Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- [Python](https://www.python.org/downloads/)

### Installation

1. Clone the repository:
   ```sh
   git clone https://github.com/dercode2298/vti-final.git
   cd vti-final
   ```
2. Define .tfvar in infra
    ```
    db_username = "xxx"
    db_password = "xxx"
    s3_bucket_name = "xxx"
    ecr_repository_name = "xxx"
    eks_cluster_name = "xxx"
    db_name="xxx"
    ```
3. Apply Terraform 
    ```sh
    terraform init
    ```
    ```sh
    terraform plan -var-file=path/filename.tfvar
    ```
    ```sh
    terraform apply -var-file=path/filename.tfvar --auto-approve
    ```
