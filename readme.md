# Centrc FastForge Reference Application (dotnet/React/SQL)
Centric's FastForge platform is our opionated framework for starting certain classes of cloud-hosted web and mobile applications based on a mainstream framework. The projects in this repository are based on the dotnet framework with a React user interface and Microsoft SQL Server.

## Directory Structure
* **Root** - contains files useable or using data from the varous projects. There are four projects (outlined below) that contain the source for the major components of this software, API, Testing, Infrastructure, and DevOps
* **api** - dotnet core API consumed by the webapp
* **webapp** - React single-page web application
* **e2e** - contains the  end-to-end functional testing framework and a starter set of tests.
* **tf-infrastructure** - Terraform scripts to build the various cloud-based development, test, and production environments.
* **pipelines-azure-devops** - Azure DevOps build-pipeline .yml files
* **github/workflows** - GitHub Actions workflows for automated deployments

## General Prerequisites
1. Create/Re-Use Microsoft Azure Subscription
    1. The Azure Subscription will host all the required Infrastructure needed for FastForge
2. Create/Re-Use a GitHub Organization
    1. GitHub will be used as the primary code repository and will manage the workflow for automation of deployment
3. Customize the App Dev Process Template for the Organization to be consistent with Centric's Right Site approach
    1. A key component of Centric's Right Site model is determining appropriate locations for our Client’s project, files and folders that manage the FastForge deployment
    2. Create an inherited process derived from the existing Agile Template
    3. Name the process and remember the name to be used later in the process
4. Determine early on whether the FastForge Repository will be private or public
    1. Public repositories provide the option to use “Environments” for free, whereas a Private repository requires GitHub Enterprise
5. Establish a shared container within the Azure Subscription for the Terraform ```.tfstate``` file by creating the following in Azure: 
    1. **Resource Group**
    2. **Storage Account**
    3. **Container within the Storage Account**

## Prerequisite Installations
* Docker (Desktop)
* dotnet core

If enhanced Azure Infrastructure management is desired: 
* Code Editor installed 
* Terraform package installed
* GIT installed
* Azure PowerShell Modules installed

## How to Get Started with a Public GitHub Repository 
Once the steps outlined in the [FastForge Foundation Repository](https://github.com/centricconsulting/FastForge-Foundation/blob/main/tf-GitHub/readme.md) have been followed, the following tasks can be performed to deploy FastForge:
1. Fork [this repository](https://github.com/centricconsulting/FastForge-ReferenceApp-dotnet) into your Organization’s GitHub
2. If not already completed, navigate to the ```Actions``` tab within your Organization’s GitHub main page and enable workflows for your repository
3. Navigate to the ```Settings``` tab within your Organization’s GitHub main page and create ```Secrets``` needed in order to connect to the previously provisioned ```Azure Container Registry```. The variable information can be found under the ```Access Keys``` section of the ```Azure Container Registry```
    1. **REGISTRY_LOGIN_SERVER**: Name of Container Registry created in [FastForge Foundation Repository steps](https://github.com/centricconsulting/FastForge-Foundation/blob/main/tf-GitHub/readme.md).azurecr.io. (Example: exampleCR123.azurecr.io)
    2. **REGISTRY_USERNAME**: Chosen Username
    3. **REGISTRY_PASSWORD**: Chosen Password (Be sure to adjust this variable if the password is refreshed on the Container Registry)
4. Once the above ```Secrets``` values are created, the [first workflow](https://github.com/centricconsulting/FastForge-ReferenceApp-dotnet/blob/main/.github/workflows/BuildTestStage-apiWebApp.yml) can run:
    1. Open the ```BuildTestStage-apiWebApp.yml``` file and ensure the ref path within the .yml file is pointing to the “main” branch if applicable
    2. Navigate to the ```Actions``` tab within your Organization’s GitHub main page and select the ```BuildTestStage-apiWebApp (run 1st)``` workflow, and select “Run workflow” on the right-hand side

## Start Building Azure Infrastructure for an Environment 
After the Public GitHub Repository is created and the workflow associated to the .yml file (```BuildTestStage-apiWebApp.yml```) successfully runs, the following steps can occur to deploy the needed Azure Infrastructure for a specified cloud environment:
1. Five additional secrets need to be created:
    1. **AZURE_CREDENTIALS**: [Process of creation](https://github.com/Azure/login#configure-deployment-credentials)
    2. **CLIENT_ID**: Client ID of Azure crednetials in the **AZURE_CREDENTIALS** ```Secrets```
    3. **CLIENT_SECRET**: Client Secret of Azure crednetials in the **AZURE_CREDENTIALS** ```Secrets```
    4. **SUBSCRIPTION_ID**: Subscription ID associated to the Azure Subscription
    5. **TENANT_ID**: Tenant ID of Azure crednetials in the **AZURE_CREDENTIALS** ```Secrets```
2. [**OPTIONAL**] After the above ```Secrets``` are created, navigate to the ```Settings``` tab within your Organization's GitHub main page and select ```Environments```. Within ```Environments```, select the ```New environment``` option and name the environment based on the working environment:
    1. Add a reviewer for this step and place up to 6 resources that will approve Azure Infrastructure deployments. This step will force manual intervention to occur between the “Terraform Plan” and “Terraform Apply” stages within the workflow
    2. **If this step is performed**, be sure to uncomment and include lines 70-71 in the ```<env>-infrastructure.yml``` file with the appropriate environment name
3. Update the ```terraform.tfvars``` file for the appropriate environment (```/tf-infrastructure/<env>-env```) file with the required values for deployment
4. Open the Environments ```<env>-infrastructure.yml``` file for the appropriate environment and adjust the ```env``` variables to reflect where the ```.tfstate``` file will be located for the Terraform managed resources:
    1. **resourceGroup**: Name of the ```Resource Group``` created in the [General Prerequisites](#General-Prerequisites) step #5
    2. **storageAccountName**: Name of the ```Storage Account``` created in the [General Prerequisites](#General-Prerequisites) step #5
    3. **storageContainerName**: Name of the ```Container``` created in the [General Prerequisites](#General-Prerequisites) step #5
    4. **storageKey**: Name of the ```.tfstate``` file. Must be in ```<name>.tfstate``` format. It is best practice to have the name reflect the environment
5. Save/commit all changes and follow the process outlined in the [previous section](#Start-Building-Azure-Infrastructure-for-an-Environment), but select the [second workflow](https://github.com/centricconsulting/FastForge-ReferenceApp-dotnet/blob/main/.github/workflows/DEV-infrastructure.yml)```Dev-infrastructure (run 2nd)``` to run

## Deploy the API/WebApp for the Environment
The last step in the build of FastForge is the deployment of each environment’s API and WebApp. The following steps are required to complete the deployment:
1. Use the ```env``` section within the .yml file (```<env>-deploy-apiWebApp-pipeline.yml```) to store the following variable:
    1. **apiAppName**: Name of app service created in the [previous section](#How-to-Get-Started-with-a-Public-GitHub-Repository) step #4 
2. Save/commit all changes in the .yml file
3. Navigate to the ```Settings``` tab within your Organization’s GitHub main page and create the last ```secret``` needed in order to connect to the storage account that was provisioned in the [previous section](#Start-Building-Azure-Infrastructure-for-an-Environment)
    1. **AZURE_STORAGE_ACCOUNT_CS**: Connection String for the created Storage Account that was part of the [previous section](#Start-Building-Azure-Infrastructure-for-an-Environment) terraform scripts deployment
4. Navigate to the ```Actions``` tab within your Organization’s GitHub main page and select the [third workflow](https://github.com/centricconsulting/FastForge-ReferenceApp-dotnet/blob/main/.github/workflows/DEV-deploy-apiWebApp.yml) ```<env>-deploy-apiWebApp.yml``` to run
    1. After running the workflow, the API/WEbAPp will be built fo the designated environment
5. When needed, repeat the above steps to deploy the API/WebApp for each subsequent environment. The [previous section](#Start-Building-Azure-Infrastructure-for-an-Environment) must occur first for each environment in order to have the resources required to deploy the API/WebApp associated with this section


## How to Get Started with Development and Run Locally
* Install Docker for your platform
  * Windows: https://hub.docker.com/search?offering=community&q=&type=edition&operating_system=windows
  * Mac: https://hub.docker.com/search?offering=community&q=&type=edition&operating_system=mac
  * Linux: https://hub.docker.com/search?offering=community&operating_system=linux&q=&type=edition
* Build the containers and run all services
  * `docker-compose build && docker-compose up`

tl;dr

* Build the API
  * `cd api`
  * `dotnet restore`
  * `dotnet build`
* Start the WebApp
  * `cd webapp`
  * `npm install`
  * `yarn start`
* Start the API, SQL Server, and execute the end-to-end in Docker containers via Docker Compose
  * `docker-compose up`
