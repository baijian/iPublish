package IPublish::Pub;
use strict;

use IPublish::Config;
use IPublish::Ssh;

#list all projects confs have added to iPublish
sub list_projects {
    my ($project) = @_;
    IPublish::Config->load_config;
    if(defined $project) {
        &project_exist_check($project);
        print $project."\n";
        if(defined $confs{ "$project" }->{ "git_address" }) {
            print "\tGit Address: ".$confs{ "$project" }->{ "git_address" }."\n";
        } else {
            print "\tSrc Directory: ".$confs{ "$project" }->{ "source_dir" }."\n";
        }
        print "\t"."Dest Directory: ".$confs{ "$project" }->{ "dest_dir" }."\n";
        print "\t"."Version File: ".$confs{ "$project" }->{ "version_file" }."\n";
        print "\tServers:\n";
        foreach (@{$servers{ "$project" }}) {
            print "\t\t"."HostAddress: ".$_->{ "host" }."\n";
            print "\t\t"."HostUser: ".$_->{ "user" }."\n";
        }
    } else {
        foreach my $project_name ( keys %confs) {
            print $project_name."\n";
            if(defined $confs{ "$project_name" }->{ "git_address" }) {
                print "\tGit Address: ".$confs{ "$project_name" }->{ "git_address" }."\n";
            } else {
                print "\tSrc Directory: ".$confs{ "$project_name" }->{ "source_dir" }."\n";
            }
            print "\t"."Dest Directory: ".$confs{ "$project_name" }->{ "dest_dir" }."\n";
            print "\t"."Version File: ".$confs{ "$project_name" }->{ "version_file" }."\n";
            print "\tServers:\n";
            foreach (@{$servers{ "$project_name" }}) {
                print "\t\t"."HostAddress: ".$_->{ "host" }."\n";
                print "\t\t"."HostUser: ".$_->{ "user" }."\n";
            }
        }   
    }
}

sub add_server_version {
    my ($project_name, $host, $user, $dest_dir, $version) = @_;
    my $ssh = IPublish::Ssh->connect_server($host, $user);
    my @args = ("mkdir", $dest_dir."/".$version);
    my $out = $ssh->system(@args);
}

#publish a version to every server, check exists one by one.
sub publish_version {
    my ($project_name, $version) = @_;
    &load_conf;
    &project_exist_check($project_name);
    foreach(@{$servers{ "$project_name" }}) {
        my $user = $_->{ "user" };
        my $host = $_->{ "host" };
        my $uhost = $user."\@".$host.":";
        my %params = (
            user => $_->{ "user" }
        );
        my $out = undef;
        if(defined $confs{ "$project_name" }->{ "git_address" }) {
            my $git_address = $confs{ "$project_name" }->{ "git_address" };
            my $dir = $confs{ "$project_name" }->{"dest_dir"};
            &add_server_version($project_name, $host, $_->{ "user" }, $dir, $version);
            my $ssh = IPublish::Ssh->connect_server($host, $user);
            my @args = ("type", "git");
            $out = $ssh->system(@args);
            if($out == 0) {
                @args = ("ls", "$dir"."/".$version);
                $out = $ssh->system(@args);
                if($out == 0) {
                    my $p = "Please input y or n %d> ";
                    printf( $p, 0 );    
                    while( <> ) {
                        do {
                            @args = ("git", "clone", "$git_address", "$dir"."/".$version);    
                            $out = $ssh->system(@args);
                            last;
                        } if m/y/i;
                        do {
                            $out = 201;
                            last;
                        } if m/n/i;
                        printf( $p, $. );
                    }
                } else {
                    @args = ("git", "clone", "$git_address", "$dir"."/".$version);
                    $out = $ssh->system(@args);
                }
            } else {
                print color("red");
                print $host." has not install git yet!\n";
                print color("reset");
            }
        } else {
            my $source_dir = $confs{"$project_name"}->{ "source_dir" };
            my $dir = $confs{ "$project_name" }->{"dest_dir"};
            &add_server_version($project_name, $host, $_->{ "user" }, $dir, $version);
            open my $oldout, ">&", \*STDOUT or die "error";
            open STDOUT, '>', '/dev/null' or die "error";
            my @args = ("scp", "-r", "$source_dir", $uhost.$dir."/".$version."/");
            $out = system(@args);
            open STDOUT, ">&", $oldout;
            
        }
        if($out == 201) {
            print color("yellow");
            print $host." has haved the version $version, and you choose not cover!";
        }elsif($out == 0) {
            print color("green");
            print $host." publish successful.\n";
        } else {
            print color("red");
            print $host." publish fail.\n";
        }
        print color("reset");
    }
}
