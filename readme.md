# Centrc FastForge Reference Application (dotnet/React/SQL)
Centric's FastForge platform is our opionated framework for starting certain classes of cloud-hosted web and mobile applications based on a mainstream framework. The projects in this repository are based on the dotnet framework with a React user interface and Microsoft SQL Server.

## Directory Structure
* **Root** - contains files useable or using data from the varous projects. There are four projects (outlined below) that contain the source for the major components of this software, API, Testing, Infrastructure, and DevOps
* **api** - dotnet core API consumed by the webapp
* **webapp** - React single-page web application
* **e2e** - contains the  end-to-end functional testing framework and a starter set of tests.
* **tf-infrastructure** - Terraform scripts to build the various cloud-based environments.
* **pipelines-azure-devops** - Azure DevOps build-pipeline .yml files
* **github/workflows** - GitHub Actions workflows .yml files

## Prerequisites
1. **Complete the FastForge Foundation Steps**
	> Visit the [Centric Consulting FastForge-Foundation GitHub Repository](https://github.com/centricconsulting/FastForge-Foundation) to complete the appropriate steps. <
	> *NOTE: The prerequisites and steps outlined in the FastForge Foundation Steps must be completed prior to these deployment steps.*

## Prerequisite Installations
* Docker (Desktop)
* dotnet core

If enhanced Azure Infrastructure management is desired: 
* Code Editor installed 
* Terraform package installed
* GIT installed
* Azure PowerShell Modules installed

## GitHub Deployment Step 1: Build, Stage & Test the API/WebApp
Once the steps outlined in the [FastForge Foundation Repository](https://github.com/centricconsulting/FastForge-Foundation) have been followed, the following tasks can be performed to deploy FastForge:
1. [This repository](https://github.com/centricconsulting/FastForge-ReferenceApp-dotnet) should already be generated within your Organization’s GitHub
2. Navigate to the ```Settings``` tab within your Organization’s GitHub main page and create ```Secrets``` needed in order to connect to the previously provisioned ```Azure Container Registry```. The variable information can be found under the ```Access Keys``` section of the ```Azure Container Registry```
    1. **REGISTRY_LOGIN_SERVER**: Name of Container Registry created in [FastForge Foundation Repository steps](https://github.com/centricconsulting/FastForge-Foundation/blob/main/tf-GitHub/readme.md).azurecr.io. (Example: exampleCR123.azurecr.io)
    2. **REGISTRY_USERNAME**: Chosen Username
    3. **REGISTRY_PASSWORD**: Chosen Password (Be sure to adjust this variable if the password is refreshed on the Container Registry)
3. Once the above ```Secrets``` values are created, the [first workflow](https://github.com/centricconsulting/FastForge-ReferenceApp-dotnet/blob/main/.github/workflows/BuildTestStage-apiWebApp.yml) can run:
    1. Navigate to the ```Actions``` tab within your Organization’s GitHub main page and select the ```BuildTestStage-apiWebApp (run 1st)``` workflow, and select “Run workflow” on the right-hand side

## GitHub Deployment Step 2: Deploy Application Infrastructure
After the Public GitHub Repository is created and the workflow associated to the .yml file (```BuildTestStage-apiWebApp.yml```) successfully runs, the following steps can occur to deploy the needed Azure Infrastructure for a specified cloud environment:
1. Five additional secrets need to be created:
    1. **AZURE_CREDENTIALS**: [Process of creation](https://github.com/Azure/login#configure-deployment-credentials)
    2. **CLIENT_ID**: Client ID of Azure crednetials in the **AZURE_CREDENTIALS** 
    3. **CLIENT_SECRET**: Client Secret of Azure crednetials in the **AZURE_CREDENTIALS** 
    4. **SUBSCRIPTION_ID**: Subscription ID associated to the Azure Subscription
    5. **TENANT_ID**: Tenant ID of Azure crednetials in the **AZURE_CREDENTIALS** 
2. [**OPTIONAL**] Within GitHub Public Repositories, ```Environments``` (Settings > Environments > New environment) can be created to place manual approvals for infrastructure changes when the terraform workflow runs. The name of the ```Environment``` should reflect the environment being built. Line #70 - #71 in the ```Infrastructure.yml``` file can be uncommented to reflect the name of the ```Environment``` created. (*NOTE: this step is available for Public repositories by default, but requires a GitHub Enterprise license for Private repositories*
    1. If the ```Environment``` is created, select to add up to 6 resources that will approve infrastructure deployments. This step will force manual intervention to occur between the “Terraform Plan” and “Terraform Apply” stages within the workflow.
3. Update the ```terraform.tfvars``` file for the appropriate environment (```/tf-infrastructure/dev-env```) with the required values for deployment
4. Open the ```Infrastructure.yml``` file and adjust the “env” variables to reflect where the tfstate file will be located for the Terraform managed resources:
    1. **resourceGroup**: Name of the ```Resource Group``` created in the [Prerequisites](#Prerequisites) step #5
    2. **storageAccountName**: Name of the ```Storage Account``` created in the [Prerequisites](#Prerequisites) step #5
    3. **storageContainerName**: Name of the ```Container``` created in the [Prerequisites](#Prerequisites) step #5
    4. **storageKey**: Name of the ```.tfstate``` file. Must be in ```<name>.tfstate``` format. It is best practice to have the name reflect the environment
5. Save/commit all changes and follow the process outlined in the [previous section](#'GitHub Deployment Step 1: Build, Stage & Test the API/WebApp'), but select the [second workflow](https://github.com/centricconsulting/FastForge-ReferenceApp-dotnet/blob/main/.github/workflows/Infrastructure.yml)```Dev-infrastructure (run 2nd)``` to run

## GitHub Deployment Step 3: Deploy Environment API/WebApp
The last step in the build of FastForge is the deployment of each environment’s API and WebApp. The following steps are required to complete the deployment:
1. Use the ```env``` section within the .yml file (```Deploy-apiWebApp.yml```) to store the following variable:
    1. **apiAppName**: Name of app service created in the [previous section](#GitHub Deployment Step 1: Build, Stage & Test the API/WebApp) step #3 (defined in the ```terraform.tfvars``` file) 
2. Save/commit all changes in the .yml file
3. Navigate to the ```Settings``` tab within your Organization’s GitHub main page and create the last ```secret``` needed in order to connect to the storage account that was provisioned in the [previous section](#Start-Building-Azure-Infrastructure-for-an-Environment)
    1. **AZURE_STORAGE_ACCOUNT_CS**: Connection String for the created Storage Account that was part of the [previous section](#Start-Building-Azure-Infrastructure-for-an-Environment) terraform scripts deployment
4. Navigate to the ```Actions``` tab within your Organization’s GitHub main page and select the [third workflow](https://github.com/centricconsulting/FastForge-ReferenceApp-dotnet/blob/main/.github/workflows/DEV-deploy-apiWebApp.yml) ```<env>-deploy-apiWebApp.yml``` to run
    1. After running the workflow, the API/WEbAPp will be built fo the designated environment
5. When needed, repeat the above steps to deploy the API/WebApp for each subsequent environment. The [previous section](#GitHub Deployment Step 1: Build, Stage & Test the API/WebApp) must occur first for each environment in order to have the resources required to deploy the API/WebApp associated with this section

## How to Get Started with an Azure DevOps Repository 
Once the steps outlined in the [FastForge Foundation Repository](https://github.com/centricconsulting/FastForge-Foundation/blob/main/tf-DevOps/readme.md) have been followed, the following tasks can be performed to deploy FastForge:
1. Within Azure DevOps, create a service connection for the ```Azure Container Registry``` that was provisioned as part of Step 1

Within Azure DevOps, create a service connection for the “Azure Container Registry” that was provisioned as part of Step 1
Within Azure DevOps, navigate to the “Files” section under “Repos” and verify that the cloned repository from the Centric GitHub is now uploaded to the Azure DevOps Repo:
https://github.com/centricconsulting/FastForge-ReferenceApp-dotnet.git 
Edit, “buildteststage-apiWebApp-variables.yml” (/pipelines-azure-devops/buildteststage-apiWebApp/) and adjust the following field to match the Azure DevOps value:
containerRegistryServiceConnection: <Name of service connection for the Docker Registry>
Once the above variable value is updated, the first pipeline can run: 
Within Azure DevOps, navigate to the “Pipelines” section under “Pipelines” and select the first pipeline to run “BuildTestStage-apiWebApp (run 1st)”
Select the “Run Pipeline” option on the page to run the first pipeline
