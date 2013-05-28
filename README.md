Some automated scripts writen in perl
============
modules-list is a perl script to list all the installed
perl modules in your computer.

## iPublish

### Introduction

* Data Structure to save conf
```perl
    $conf{"project_name"} = {
        "name" => $name,
        "source_dir" => $src,
        "dest_dir" => $dest,
        "servers" => [{"host" => $host, "user" => $user },
                {"host" => $host, "user" => $user}],
    };
```

### Install
sudo cpan 

install IO::Pty

install Net::OpenSSH

cp bin/iPublish to your $HOME/bin directory, cp .iPublish config file
to your $HOME directory. Ofcourse you must have add your $HOME/bin 
to your PATH variable. Then you can use iPublish as your linux command.

### Command help
Show help info 
```text
iPublish -h | --help
```

List all projects that you have add to iPublish
```text
iPublish -l | --list
```
   
List all versions of a project
```text
iPublish [-p | --project] [name] [-l | --list]
``` 

Publish a project 
```text
iPublish [-p | --project] name [-v | --version] [version]
```

### Example
```
* 1.Write config in .iPublish for your projects
* 2.To see help info of iPublish command ```iPublish -h```.
* 3.iPublish [--list list all projects in .iPublish]  
            [-p project] [[-l list all versions] | [-v version]]
```

##

