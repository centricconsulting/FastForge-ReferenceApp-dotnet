<h1 align="center"> Use Terraform to Provision all Microsoft Resources needed to launch the "Fast Forge" application </h1>
<h3 align="center"> Azure DevOps, GitHub Actions, Terraform IaC </h3>

<!-- TABLE OF CONTENTS -->
<h2 id="table-of-contents">Table of Contents</h2>

<details open="open">
  <summary>Table of Contents</summary>
  <ol>
    <li><a href="#introduction"> ➤ Introduction</a></li>
    <li><a href="#overview"> ➤ Overview</a></li>
    <li><a href="#file-descriptions"> ➤ File Descriptions</a></li>
    <li><a href="#getting-started"> ➤ Getting Started</a></li>
    <li><a href="#deploying"> ➤ Deploying the Environment </a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->
<h2 id="introduction"> Introduction</h2>

<p align="justify"> 
  This repository can be utilized to build the Azure Cloud Infrastructure and the configurations required to deploy the "Fast Forge" application. A functional understanding of Microsoft Azure, Azure DevOps and Terraform are required for this build. 
</p>

<!-- OVERVIEW -->
<h2 id="overview"> Overview</h2>

<p align="justify"> 
   Leveraging the Terraform scripts and Modules provided in the "tf" folder, a user will be able to create all needed Microsoft Azure resources required for the "Fast Forge" application. The resource creation will occur with the use of the <code>main.tf</code>, the <code>variables.tf</code>, and the <code>*.tfvars</code> Terraform files. The deployment of the resources will occur with the use of a deployment pipeline for automation. This will enable the entire end-to-end build of the Infrastructure resources to be managed and owned by Azure DevOps. 
</p>

<!-- FILES DESCRIPTION -->
<h2 id="file-descriptions"> File Descriptions</h2>

<ul>
  <li><b>main.tf</b> - The main file is used to declare what Infrastructure resources to create, configure, and manage.</li>
  <li><b>variables.tf</b> - Contains variable definitions for your <code>main.tf</code> file.</li>
  <li><b>output.tf</b> - If applicable, resource output values will be specified in this file.</li>
  <li><b>terraform.tfvars</b> - The <code>*.tfvars</code> file contains input variables that are set in the <code>variables.tf</code> file.</li>
</ul>

<h3>Some other supporting folders/files</h3>
<ul>
  <li><b>dev-env</b> - Example folder for a DEV environment with Infrastructure resource values defined.</li>
  <li><b>test-env</b> - Example folder for a TEST environment with Infrastructure resource values defined.</li>
  <li><b>prod-env</b> - Example folder for a PROD environment with Infrastructure resource values defined.</li>
  <li><b>_Modules</b> - Library folder containing multiple modules that can be leveraged in a <code>main.tf</code> file.</li>
  <li><b>init_shared_state_store.sh</b> - Powershell script that can be used to create a location to store the <code>*.tfstate</code> file.</li>
</ul>


<!-- GETTING STARTED -->
<h2 id="getting-started"> Getting Started</h2>

<h3>Before starting any resource deployment, first ensure the following is established:</h3>
<ul>
  <li> Microsoft Azure Subscription</li>
  <li> Microsoft DevOps Organization</li>
  <li> Resource Group, Storage Account, and Container needed to store a shared <code>*.tfstate</code> file. A separate <code>*.tfstate</code> will be used per environment.</li>
</ul>


<!-- SCENARIO1 -->
<h2 id="deploying"> Deploying the Environment</h2>

<p>TBD, fill in soon</p>
<p>abc xyz</p>

<pre><code>xyz xyz</code></pre>
<pre><code>$ </code></pre>
<pre><code>$ </code></pre>
