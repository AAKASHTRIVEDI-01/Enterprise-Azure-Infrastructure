# ==============================================================================
# Enterprise Azure Infrastructure - Deployment Helper Script
# Runs Terraform formatting, validation, planning, and guided application.
# ==============================================================================

param(
    [switch]$AutoApprove = $false,
    [string]$VarFile = "terraform.tfvars"
)

$ErrorActionPreference = "Stop"

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  Enterprise Azure Infrastructure Deployment Pipeline" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

# Navigate to terraform directory
$TerraformDir = Join-Path $PSScriptRoot "..\terraform"
Push-Location $TerraformDir

try {
    # 1. Check Azure CLI Login
    Write-Host "`n[1/5] Verifying Azure Authentication..." -ForegroundColor Yellow
    $account = az account show 2>$null | ConvertFrom-Json
    if (-not $account) {
        Write-Host "Please login to Azure using 'az login' before running this script." -ForegroundColor Red
        exit 1
    }
    Write-Host "Authenticated as: $($account.user.name) on Subscription: $($account.name)" -ForegroundColor Green

    # 2. Terraform Init
    Write-Host "`n[2/5] Initializing Terraform Modules & Providers..." -ForegroundColor Yellow
    terraform init

    # 3. Format & Validate
    Write-Host "`n[3/5] Validating Terraform Code Syntax & Standards..." -ForegroundColor Yellow
    terraform fmt -check
    terraform validate

    # 4. Terraform Plan
    Write-Host "`n[4/5] Generating Execution Plan..." -ForegroundColor Yellow
    if (Test-Path $VarFile) {
        terraform plan -var-file=$VarFile -out=tfplan
    } else {
        Write-Host "Note: $VarFile not found. Using default variable values or interactive prompts." -ForegroundColor DarkGray
        terraform plan -out=tfplan
    }

    # 5. Terraform Apply
    Write-Host "`n[5/5] Ready to Deploy." -ForegroundColor Yellow
    if ($AutoApprove) {
        terraform apply tfplan
    } else {
        $confirmation = Read-Host "Do you want to apply this execution plan? (yes/no)"
        if ($confirmation -eq 'yes') {
            terraform apply tfplan
            Write-Host "`n[SUCCESS] Enterprise Azure Infrastructure deployed successfully!" -ForegroundColor Green
        } else {
            Write-Host "`nDeployment cancelled by user. Execution plan discarded." -ForegroundColor Yellow
        }
    }
}
finally {
    if (Test-Path "tfplan") {
        Remove-Item "tfplan" -Force
    }
    Pop-Location
}
