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

## How to Get Started with the Azure Infrastructure
Once the steps outlined in the [FastForge Foundation Repository](https://github.com/centricconsulting/FastForge-Foundation/blob/main/tf-GitHub/readme.md) have been followed, the following tasks can be performed to deploy FastForge. 
1. dasdfa
2. asdfasdf
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
