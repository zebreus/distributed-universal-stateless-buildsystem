# distributed universal stateless build system configuration documentation

Currently this is just a collection of thoughts, full of inconsistencies and grammatical errors. Everything can and probably will change

## goals
The goal of this project is to create a stateless universal distributed build system. What that means is specified below
### distributed
Not distributed like cluster computing, but distributed like git. You can run builds locally or somewhere else and it will produce the same feeling of happiness, because everything works the same way.
### universal
The build system should be more about specifing the environment of a task, than the actual task.
### stateless
The result of the build shall only depend on the inputs and the configuration. Basically this means reproducible builds.
### build system
A framework in which to execute jobs.

## Ideas
The build system has some concepts, I will describe some of them here.
### Resources
A resource is a versioned set of files in a directory structure.
### Resource configuration
A resource configuration is a set of resources, each with a path, that is prefixed to each file of the resource. A resource configuration is valid if all files of all resources can be combined into one root.

If you have the following resources

```
resourcea:
  file.txt

resourceb:
  test/fileb.txt
  file.txt
```

A valid configuration, containg both resources could look like

```
resources:
  - name: resourcea
    path: /resa
  - name: resourceb
    path: /
```

and result in this directory structure:

```
/test/fileb.txt
/resa/file.txt
/file.txt
```

An example for an invalid configuration would be

```
resources:
  - name: resourcea
    path: /test
  - name: resourceb
    path: /
```

because the file at path /test/file.txt is defined by both resources.

### Resources
A resource consists of three main parts
- A resource configuration ; the input
- A output configuration ; the output
- A task ; how to produce the output from the input

### Primary and secondary resources
A primary resource is a resource, that is fetched from outside the build system. This could be for example a git repository or a container image. A secondary resource on the other side is made by the build system, and derived from primary resources. The version of a primary resource comes from an external source, the version of a secondary resource is defined by the primary resources, that it is based on. Technically, there will probably be no distincition between primary and secondary resources.

### Resource types
Resource type could state, how to get a primary resource. I am not sure wheter this is a good idea, or if there rather should be instructions, that specifiy how to get the resource content..

### Tasks
While the resource configuration defines the data structure, on which things are done, the task specifies what is done. At the current stage, the plan is to let this be quite loosly defined and basically boil down to execute a command on the host computer. So it could be possible to do quite lowlevel and absolutly not stateless things, like compiling directly on the host. While this is possible, it is not how it is intended to be done. There will be template task configurations, that for example, start a container with the resource configuration as the rootfs and execute a custom command in the container. It is also planned, to create a template, that starts a container in a virtual machine, so you can even define things like cpu architecture in the configuration.
#### Background
Tasks are defined so freely to allow the easy usage of custom sandboxing techniques, as some tasks can for example not be executed in a container, so you just write a configuration, to do sandboxing in a virtual machine.
#### Thoughts
I would probably really like it, if the task just sets up the environment and gets the ball rolling, and the actual task is part of the resource configuration. The more I think about this concept, the more I like it. Basically the task should just be the way the resource configuration is executed and the resource configuration should contain a script with the actual work

### Files configuration
The files configuration of a resource specifies, which files are actually part of the resource

## configuration file format

The configuration file is a yaml file, 
Here I will describe the keys in the current format

### `resources: [resource]`
Resources contains all resources, that are invovled in this configuration.

### `resource`
A resource consists of a name, a resource confifiguration, a output configuration and a task

#### `resource.name: string`
The name this resource will be referenced by.

#### `resource.resources: [configurationEntry]`
The resource configuration is an array of configuration entries. The resources defined by the configuration entries will be combined under one common root. If there are no configurationEntrys, this resource is a primary resource.

#### `resource.files: [fileEntry]`
The output configuration consists of a list of file entries, that are part of this resource. The files defined by the fileEntrys make up the resource. If this value is not specified, every file is part of this resource. If this value is specified and left empty, no files are part of this resource

#### `resource.task: [task]`
The task that has to be executed, to produce this resource.

### `configurationEntry`
A configurationEntry is a reference to a resource.

#### `configurationEntry.name: string`
The name of the referenced resource. Has to be the resource.name of a resource.

#### `configurationEntry.path: string`
All files of the referenced resource will be placed under this path. Defaults to / if left empty or not specified.

### `fileEntry`
A file entry defines a file, that will be part of the resource.

#### `fileEntry.path: string`
The path of the file, this fileEntry specifies. The file has to exist, after the task was executed.

#### `task`
The task that will be executed

#### `task.environment`
I still have to deceide how this will be structured. It could be as simple, as a path to a executable, or a real configuration.
For now this only contains a command, that will be executed on host. The

#### `task.environment.command: string`
A command that will be executed. The command will be executed in a directory prepared with a `resource.yml` file containining only the yaml configuration of the current resource, a `res` directory containing the prepared resource configuration and in future maybe a file containing all resource configurations. This is a hacky prototype solution and will probably be replaced in the future

#### `task.*: misc`
In the current thoughts.yml the idea  is, that whatever is defined in `task.environment` has some kind of access to every other key in task.
