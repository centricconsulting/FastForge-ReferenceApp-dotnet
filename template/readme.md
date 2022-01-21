# Reference Application Template Documentation

This documentation will review the creation of the reference application template, the reference applicaton Nuget Package, and the import steps for managing creating a new repository for clients.

## Creating a Template

In order to create a template for the Reference Application a **.template.config** folder is created in the root folder, so all necessary projects and dependencies are included, and inside that folder a template.json file needs to be created. 

The following information is copied and pasted in the template.json file:

```
{
    "$schema": "http://json.schemastore.org/template",
    "author": "Centric Consulting",
    "classifications": [
        "construct-refapp",
        "Web"
    ],
    "tags": {
        "language": "C#"
    },
    "identity": "Construct.ReferenceApp",
    "name": "Centric Consulting Construct Reference Application",
    "shortName": "construct",
    "sourceName": "referenceApp",
    "preferNameDirectory": true
}
```

Make sure the dotnet command line tool is installed on your system and run the following command to create a template of the reference application:

```
$ dotnet new --install <Path To Your Root Folder>
```

Once the template has been installed you can test it by creating a new reference application using the template in another directory by typing the following:

```
$ dotnet new construct -n <New Project Name> -o <New Output Directory>
```

Your new renamed solution should be available in the directory you created it in. Try running it.

## Creating a Nuget Package
In order to make the template installable to other systems, we have to create an installable nuget package. We will follow the same steps for creating the template, however, we will use nuget to package an installable template.

Once the .template.config folder and the template.json file is created we must make sure the nuget.exe cli tool is installed. It can be found here:
https://www.nuget.org/downloads

Once the nuget tool is installed, we have to crate a nuspec file named with the following properties:

```
<?xml version="1.0" encoding="utf-8"?>
<package xmlns="http://schemas.microsoft.com/packaging/2012/06/nuspec.xsd">
  <metadata>
    <id>Construct.ReferenceApp</id>
    <version>1.0.0</version>
    <description>Creates A reference app named after the organization using this package</description>
    <authors>Centric Consulting</authors>
    <packageTypes>
      <packageType name="Template" />
    </packageTypes>
  </metadata>
  <files>
    <file src=".\**" target="content" exclude="**\bin\**;**\obj\**;**\.git\**;**\.github\**;**\*.user;**\.vs\**;**\.vscode\**;**\.gitignore" />  </files>  
</package>
```
You can change the files to fit other needs and other file inclusions. Name this spec file **Construct.ReferenceAp.nuspec** or whatever you have placed in the id field in the file above. This files should be placed in the root directory.

After creating the nuget file, while in the root of the files we can create the package as follows:
```
 nuget pack Construct.ReferenceApp.nuspec -OutputDirectory .\nupkg
```
The output package will be located in a new folder named **nupkg** which is also in the root directory.

To install our new template we run:
```
dotnet new --install <PATH>\nupkg\Fastforge.ReferenceAp.nuspec.1.0.0.nupkg
```
And with our newly installed template we can run:

```
$ dotnet new construct -n <New Project Name> -o <New Output Directory>
```
Which creates our newly renamed reference application.

## Importing for a Client
In order to import for a client we must do the following:

1. Install the required cli tools:
    - dotnet
2. Create the new solution using the nuget package that has been generated
3. Import the new repository into the version control system we will be using
