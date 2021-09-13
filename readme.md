# Centrc FastForge Reference Application (dotnet/React/SQL)
Centric's FastForge platform is our opionated framework for starting certain classes of cloud-hosted web and mobile applications based on a mainstream framework. The projects in this repository are based on the dotnet framework with a React user interface and Microsoft SQL Server.

## Directory Structure
* **Root** - contains files useable or using data from the varous projects. There are four projects (outlined below) that contain the source for the major components of this software, API, Testing, Infrastructure, and DevOps
* **api** - dotnet core API consumed by the webapp
* **webapp** - React single-page web application
* **e2e** - contains the  end-to-end functional testing framework and a starter set of tests.
* **tf-infrastructure** - Terraform scripts to build the various cloud-based development, test, and production environments.
* **pipelines-azure-devops** - Azure DevOps build-pipeline files
* **github/workflows** - GitHub Actions workflows for automated deployments

## Prerequisites
* Docker (Desktop)
* dotnet core

If enhanced Azure Infrastructure management is desired: 
* Code Editor installed 
* Terraform package installed
* GIT installed
* Azure PowerShell Modules installed

## How to Get Started with a Public GitHub Repository
Once the steps outlined in the [FastForge Foundation Repository](https://github.com/centricconsulting/FastForge-Foundation/blob/main/tf-GitHub/readme.md) have been followed, the following tasks can be performed to deploy FastForge. 
1. Fork [this repository](https://github.com/centricconsulting/FastForge-ReferenceApp-dotnet) into your Organization’s GitHub.
2. If not already completed, navigate to the ```Actions``` tab within your Organization’s GitHub main page and enable workflows for your repository.
3. Navigate to the ```Settings``` tab within your Organization’s GitHub main page and create ```Secrets``` needed in order to connect to the previously provisioned ```Azure Container Registry```. The variable information can be found under the ```Access Keys``` section of the ```Azure Container Registry```.
* **REGISTRY_LOGIN_SERVER**: Name of Container Registry created in [FastForge Foundation Repository steps](https://github.com/centricconsulting/FastForge-Foundation/blob/main/tf-GitHub/readme.md).azurecr.io. (Example: exampleCR123.azurecr.io)
* **REGISTRY_USERNAME**: Chosen Username
* **REGISTRY_PASSWORD**: Chosen Password (Be sure to adjust this variable if the password is refreshed on the Container Registry)
4. Once the above secret values are created, the [first workflow](https://github.com/centricconsulting/FastForge-ReferenceApp-dotnet/blob/main/.github/workflows/BuildTestStage-apiWebApp.yml) can run
* Open the ```BuildTestStage-apiWebApp.yml``` file and ensure the ref path within the .yml file is pointing to the “main” branch if applicable
* Navigate to the ```Actions``` tab within your Organization’s GitHub main page and select the ```BuildTestStage-apiWebApp (run 1st)``` workflow, and select “Run workflow” on the right-hand side




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
