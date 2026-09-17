# Enterprise Azure Infrastructure (Hub-and-Spoke Architecture)

[![Terraform](https://img.shields.io/badge/IaC-Terraform_v1.5+-623CE4?logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Azure](https://img.shields.io/badge/Cloud-Microsoft_Azure-0078D4?logo=microsoft-azure&logoColor=white)](https://azure.microsoft.com/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Author](https://img.shields.io/badge/Author-Aakash_Trivedi-gold)](https://aakashtrivedi-01.github.io/Cloud_portfolio_Aakash/)

## What This Repository Is

This project provides production-ready Infrastructure as Code (IaC) written in Terraform that provisions a zero-trust **Hub-and-Spoke Network Architecture** on Microsoft Azure. 

Instead of deploying flat networks where workloads are exposed to the public internet, this design centralizes security enforcement, insulates application tiers, routes all egress through stateful inspection, and manages secrets and observability under a unified governance plane.

---

## Architecture Diagram

```mermaid
flowchart TD
    subgraph Internet["Public Internet"]
        Users["External Clients / Browsers"]
    end

    subgraph HubVNet["Hub Virtual Network (10.0.0.0/16)"]
        direction TB
        subgraph Perimeter["Perimeter Security"]
            AFW["Azure Firewall (10.0.1.4)<br/>Stateful Packet & App Inspection"]
            Bastion["Azure Bastion Host<br/>Secure TLS Jumpbox (No Public IPs)"]
            Gateway["VPN / ExpressRoute GatewaySubnet<br/>On-Premises Hybrid Connectivity"]
        end
    end

    subgraph SpokeVNet["Workload Spoke Virtual Network (10.1.0.0/16)"]
        direction TB
        subgraph WebTier["Web / Ingress Tier (10.1.1.0/24)"]
            AGW["Application Gateway (WAF v2)<br/>SSL Termination & OWASP Protection"]
        end

        subgraph AppTier["Application Tier (10.1.2.0/24)"]
            AppVMs["Business Logic / APIs<br/>NSG: Restricted to Web Tier Only"]
        end

        subgraph DataTier["Database Tier (10.1.3.0/24)"]
            DB["SQL / PostgreSQL Workload<br/>NSG: Zero-Trust (App Tier Only)"]
        end
    end

    subgraph SharedServices["Central Governance & Auditing"]
        KV["Azure Key Vault<br/>RBAC & Secrets Management"]
        LAW["Log Analytics Workspace<br/>Centralized Audit Logging"]
    end

    %% Flow Connections
    Users -->|HTTPS:443| AGW
    AGW -->|Inspected Ingress| AppVMs
    AppVMs -->|Port 1433/5432| DB

    %% Routing
    AppVMs -.->|UDR 0.0.0.0/0 Egress| AFW
    DB -.->|UDR 0.0.0.0/0 Egress| AFW
    AFW -->|Filtered Outbound| Internet

    %% Peering
    HubVNet <=====>|Bidirectional VNet Peering| SpokeVNet
    SpokeVNet -.->|Diagnostics & Auditing| LAW
    HubVNet -.->|Diagnostics & Auditing| LAW