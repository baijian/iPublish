package IPublish::Pub;
use strict;

use IPublish::Config;

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
