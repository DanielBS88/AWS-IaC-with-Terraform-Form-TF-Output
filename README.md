AWS IaC with Terraform: Form TF Output
Lab Description
The primary objective of this lab is to create a foundational network stack for your virtual infrastructure in AWS using Terraform. This includes setting up a customized Virtual Private Cloud (VPC), public subnets in multiple availability zones, an internet gateway, and a routing table to manage traffic flow. Additionally, a critical focus of this lab is to generate and configure outputs in an outputs.tf file to ensure that essential resource identifiers and configurations are easily retrievable.

Common Task Requirements
•	Do not define the backend in the configuration; Terraform will use the local backend by default.
•	Avoid the usage of the local-exec provisioner.
•	The use of the prevent_destroy lifecycle attribute is prohibited.
•	Use versions.tf to define the required versions of Terraform and its providers.
•	Define the Terraform required_version as >= 1.5.7.
•	All variables must include valid descriptions and type definitions, and they should only be defined in variables.tf.
•	Resource names provided in tasks should be defined via variables or generated dynamically/concatenated (e.g., in locals using Terraform functions). Avoid hardcoding in resource definitions or using the default property for variables.
•	Configure all non-sensitive input parameter values in terraform.tfvars.
•	Outputs must include valid descriptions and should only be defined in outputs.tf.
•	Ensure TF configuration is clean and correctly formatted. Use the terraform fmt command to rewrite Terraform configuration files into canonical format and style.


ask Resources
•	AWS VPC (Virtual Private Cloud) - A logically isolated network in the AWS cloud that provides control over your virtual networking environment.
•	Public Subnets - Subnets within a VPC that allow resources to access the internet through an Internet Gateway.
•	Internet Gateway - A highly available, horizontally scaled component that provides internet access for resources located in public subnets.
•	Routing Table - Defines rules for directing network traffic, both internally within the VPC and externally to the internet.
•	AWS Region (us-east-1) - A distinct geographic area with multiple Availability Zones for deploying resources.

Objectives
1.	File setup:
- Create the following Terraform files: main.tf, variables.tf, vpc.tf, and outputs.tf.
2.	Provider and Backend Configuration:
- In main.tf, define the backend settings and AWS provider configuration.
3.	Define Variables:
- Use the variables.tf file to declare all the variables required in vpc.tf, ensuring modularity and reusability.
4.	VPC and Subnets:
- In vpc.tf, create a VPC with the name cmtr-k5vl9gpq-01-vpc and CIDR block 10.10.0.0/16.
- Define three public subnets within the VPC, each in a different Availability Zone:
o	cmtr-k5vl9gpq-01-subnet-public-a in Availability Zone us-east-1a with CIDR 10.10.1.0/24.
o	cmtr-k5vl9gpq-01-subnet-public-b in Availability Zone us-east-1b with CIDR 10.10.3.0/24.
o	cmtr-k5vl9gpq-01-subnet-public-c in Availability Zone us-east-1c with CIDR 10.10.5.0/24.
5.	Internet Gateway:
- Create an Internet Gateway named cmtr-k5vl9gpq-01-igw and attach it to the VPC.
6.	Routing Table:
- Configure a routing table named cmtr-k5vl9gpq-01-rt to route internet-bound traffic from the public subnets through the Internet Gateway.
7.	Outputs Configuration:
- Create an outputs.tf file.
- Define the following outputs in outputs.tf to capture and display resource details upon deployment:
o	vpc_id: The unique identifier of the VPC.
o	vpc_cidr: The CIDR block associated with the VPC.
o	public_subnet_ids: A set of IDs for all public subnets.
o	public_subnet_cidr_block: A set of CIDR's block for all public subnets.
o	public_subnet_availability_zone: A set of AZ's for all public subnets.
o	internet_gateway_id: The unique identifier of the Internet Gateway.
o	routing_table_id: The unique identifier of the routing table.
8.	Terraform Workflow:
- Run terraform init to initialize the backend and provider configurations.
- Run terraform fmt to check and enforce standard code formatting.
- Use terraform validate to ensure the configuration is valid.
- Execute terraform plan to preview the resources that will be created.
- Deploy the network stack and generate the output values by running terraform apply.
9.	Verify Outputs:
- Check the console output after applying the configuration to confirm the presence of all required outputs.


Task Verification – Walk me through to check the validation below.
10.	AWS Console Validation:
- Use the AWS Management Console to ensure the VPC, subnets, internet gateway, and routing table have been created and configured correctly.
- Verify that the Terraform console output contains all the specified outputs (vpc_id, vpc_cidr, public_subnet_ids, internet_gateway_id, and routing_table_id).
- Ensure that the outputs.tf file provides a structured, readable reference to all critical resources created in this lab.
