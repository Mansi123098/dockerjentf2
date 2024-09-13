# Use the official Terraform image from HashiCorp
FROM hashicorp/terraform:latest

# Set the working directory inside the container
WORKDIR /workspace

# Copy your Terraform configuration files into the container
COPY . /workspace

# Default command to run when the container starts
ENTRYPOINT ["/bin/sh"]
