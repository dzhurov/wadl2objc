wadl2objc
=========

This is console tool for generating Objective-C code based on WADL and XSD protocols files
[About WADL](https://en.wikipedia.org/wiki/Web_Application_Description_Language)

## Install 

#### Build
To build and run the project you need: 
1. Clone the project `git clone https://github.com/dzhurov/wadl2objc`
2. Prepare your .wadl and .xsd files
3. In the schema settings set related path to .wadl and .xsd files 
![Schema settings](doc/schema_parameters.png)

#### Use binary 
To use ready build you need copy [Build Folder](wadl2objc/BUILD/Release/) whenever you whant. There are no gem or any package management, so I'd advice you to add wadl2objc folder insied your target project folder to make it available to all contributors of your project. Also it would be nice to add some generateObjCSources.sh file somwhere in repo. Up to you.

## Usage 
First of all you need to provide output dir path using parameter: `--output-dir:`.
There are two options to provide .wadl and .xsd files

#### Use local files
In this case use two parameters `--xsd:` and `--wadl:` with related paths to .wadl and .xsd files.

#### Use remote files
In this case use parameters: `--wadlURL:` and `--xsdURL:` with URLs to needed files. 

## What you get
#### Base classes:
- [`XSDBaseEntity`](wadl2objc/wadl2objc/Resources/XSDBaseEntity.h) class. Is a _Base Entity_ class wich has implemented:
  - NSCopying protocol for all inheritors including copying of _machine classes_ properties
  - Mapping from/to `NSDictionary` and `NSArray<NSDictionary*>`
  - Default `NSDateFormatter`s for xs:date and xs:dateTime
  - [Setting](wadl2objc/wadl2objc/Resources/XSDBaseEntity.h#L77) `NSDictionary` without loosing existing _human class_ data
