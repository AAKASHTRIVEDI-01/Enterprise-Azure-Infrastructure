# ==============================================================================
# Enterprise Azure Infrastructure - Safe Resource Teardown Script
# Safely tears down all cloud infrastructure to prevent ongoing billing.
# ==============================================================================

param(
    [switch]$Force = $false
)

$ErrorActionPreference = "Stop"

Write-Host "==========================================================" -ForegroundColor Red
Write-Host "  Enterprise Azure Infrastructure - Teardown / Cleanup" -ForegroundColor Red
Write-Host "==========================================================" -ForegroundColor Red

$TerraformDir = Join-Path $PSScriptRoot "..\terraform"
Push-Location $TerraformDir

try {
    # Check Azure CLI Login
    $account = az account show 2>$null | ConvertFrom-Json
    if (-not $account) {
        Write-Host "Please login to Azure using 'az login' before running this script." -ForegroundColor Red
        exit 1
    }

    Write-Host "Target Subscription: $($account.name) ($($account.id))" -ForegroundColor Yellow

    if (-not $Force) {
        $confirm = Read-Host "WARNING: This will DESTROY all resources in this architecture. Type 'DESTROY' to proceed"
        if ($confirm -ne 'DESTROY') {
            Write-Host "Teardown aborted by user." -ForegroundColor Green
            exit 0
        }
    }

    Write-Host "`nInitiating Terraform Destroy..." -ForegroundColor Yellow
    terraform destroy -auto-approve
    Write-Host "`n[SUCCESS] All infrastructure resources destroyed cleanly. No further charges will occur." -ForegroundColor Green
}
finally {
    Pop-Location
}
