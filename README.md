iPublish
============

## Introduction
iPublish is a small program writen in perl to help you
publish projects to your production servers. We aim to 
make publish operation easier and faster when you have 
many projects to manage.

## Install

* Install perl dependencies
```text
sudo cpan 
install IO::Pty
install Net::OpenSSH
```

* Install iPublish commands

Just cp bin/* to your $HOME/bin directory, ofcourse you must 
have add your $HOME/bin PATH to your PATH. Then you can use 
iPublish as your linux commands.

## Configuration

```text
project {
    name demo;
    source_dir /tmp/demo;
    dest_dir /home/www/projects/demo;
    server {
        host joinjoy.me;
        user bj;
    }
    server {
        host joinjoy2.me;
        user bj;
    }
}

project {
    name demo2;
    source_dir /tmp/demo2;
    dest_dir /home/www/projects/demo2;
    server {
        host joinjoy.me;
        user bj;
    }
}
```

## Command help
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

## Others

### Data Structure to save conf

* Hash of hash
```perl
$conf{"project_name"}{"name"} = "demo";
$conf{"project_name"}{"source_dir"} = "";
$conf{"project_name"}{"dest_dir"} = "";
```

* Hash of array of hash
```perl
$servers{"project_name"}[$i]{"host"} = "joinjoy.me";
$servers{"project_name"}[$i]{"user"} = "bj";
```

### Use Example
```
* 1.Write config in .iPublish for your projects
* 2.To see help info of iPublish command 
    ``` iPublish -h ```.
* 3.iPublish -p <name> -v <version> 
* 4.iPublish -p -l
```


