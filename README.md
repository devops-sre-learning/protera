# protera


Phase 2 Homework Questions

 

Question 1 - Guidance Exercise (SAP Application in GCP):

 

Find the official GCP guidance that shows a standard directory structure for SAP HANA on GCP compute instance.

Find the official GCP guidance that shows a standard directory structure for SAP HANA on GCP and suggest what storage type option should be used for each directory.
Show one native backup option for HANA without public IPs and list the prerequisite network/IAM bits.
 

What to deliver

The document — title and link.
Why this doc — 2–4 bullets (e.g., primary source, last‑updated date, etc.).
How it fits our scenario — map each requirement.
 

----------------------------------------------------------------------------------------------------------------------------------------------------

 

Question 2 - Linux Control Scenario

 

Your company has adopted the CIS Benchmarks as its baseline security standard for Linux servers. You are asked to outline how you would apply and maintain these controls on a newly provisioned Linux VM (SLES 15 SP7).

 

What to do

Prepare a short document (2–3 pages, bullets are fine) that covers the following:

 

1. Initial Hardening Steps

Describe the CIS-aligned actions you would take on a new SLES VM, including:

User & Access Control: disabling root SSH, enforcing key-based authentication, etc.
Patching: updating the system.
Services: disabling or removing unused services.
Logging & Auditing: ensuring required logging is turned on
 

2. Verification & Compliance Checking

Explain how you would verify that the VM meets CIS controls:

Which Linux commands or configs you would check.
Just give a few relevant examples
How would you ensure CIS standards are met.
How could you reduce conflicts with applications during deployment.
 

3. Maintaining Compliance Over Time

Describe how you would keep the server in line with CIS standards, such as:

What options or tools could you keep systems compliant over time?
 

4. Exceptions & Practical Trade-Offs

CIS Benchmarks can be strict and sometimes impractical.

Provide one or two examples of a control that might be tuned or bypassed in a real production environment (e.g., disabling certain kernel modules, password rotation frequency).
Explain how you would document and justify exceptions.
 

Deliverables

A document (Markdown, PDF, or similar) with:
The hardening steps you’d take.
Commands/config examples (snippets).
How you’d verify compliance.
Your plan for long-term CIS compliance (Bonus).
Any assumptions you made.
 

If you have any constraints on gathering this information, please document and explain the where verifying this information was limited.

 

----------------------------------------------------------------------------------------------------------------------------------------------------

 

Question 3 - (Cloud-Agnostic IaC Exercise)

 

Infrastructure-as-Code Exercise: Public Cloud Web Application Stack (Terraform)

 

Requirements

Build a minimal, production-ish web stack in the public cloud of your choice (AWS, Azure, or GCP) using Terraform:

Virtual network with multiple subnets across at least two availability zones (or equivalent):
At least one private subnet for application instances and database.
At least one public subnet (or equivalent construct) for the load balancer.
Compute group (Linux) with an autoscaling or equivalent mechanism:
Minimum 2 instances across different zones.
No public IPs directly on the instances.
Bootstrap a simple HTTP service (e.g., Nginx/Flask/Node) via user data or startup script.
Secure access path:
No direct SSH from the internet.
Use the provider’s recommended secure access option (e.g., AWS SSM, Azure Bastion, GCP IAP).
Database service:
Managed relational database (PostgreSQL or MySQL), private network access only.
High-availability optional — call out your choice and why.
Security group/firewall rules must only allow access from the app instances.
Load balancer:
Public-facing HTTP load balancer listening on port 80 (TLS optional — note trade-offs if you skip).
Health checks so only healthy app nodes receive traffic.
Object storage:
Cloud object storage bucket for logs or artifacts.
Block public access and enable versioning.
Outbound connectivity:
Use a cloud NAT or equivalent to allow private instances to fetch updates.
Security & governance:
Least-privilege firewall/security groups.
IAM/service account with minimal required permissions.
Resource tagging/labels (e.g., Project, Env, Owner, CostCenter).
Variables & Outputs:
Variables for region, instance size, network CIDRs, DB tier.
Outputs for LB DNS, VPC ID, app group name, DB endpoint, bucket name.
 

What to deliver

A GitHub repo link to your Terraform code.
A README that explains:
Prereqs: Terraform version, auth setup, provider configuration.
How to run: example terraform init/plan/apply and sample variables.
Architecture overview: diagram + description of components.
Module layout: short description of each major module (networking, compute, lb, db, storage, security).
Expected output: sample Terraform outputs.
Design choices & trade-offs: e.g., HA DB or not, TLS or not, egress model.
 

If you need constraints (e.g., Free Tier), document any adjustments you make and why

 

Submission Options

Preferred: A GitHub repository link (public, or private with reviewer access).
A compressed archive (.zip or .tar.gz) containing the repo structure.
A shared folder link (Google Drive, OneDrive, Dropbox).
Separate Markdown/PDF documents for Questions 1 & 2, plus a repo/zip for Question 3.
(Optional) A short slide deck summarizing Questions 1 & 2, with code submitted via repo/zip.
