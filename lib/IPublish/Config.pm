package IPublish::Config;
use strict;

our (
    %confs,
    %servers,
    @errmsg,
);

sub load_conf {
    if(open(CONF, "/etc/ipublish.conf")) {
        #begin to parser conf
        my $mutex = -1;
        my $project_name;
        my $i = 0;
        while(<CONF>) {
            if($_ =~ m/\s*project\s*\{\s*/i) {
                #project block enter
                $mutex++;
            } elsif(m/\s*name\s*(\w+);\s*/ && $mutex == 0) {
                #project name $1
                $project_name = $1;
                if(exists $confs{$1}) {
                    push(@errmsg, "Project $1 duplicated!");
                }
            } elsif(m/\s*version_file\s*((\/\w+)+);\s*/ && $mutex == 0) {
                #version file location 
                $confs{"$project_name"}{"version_file"} = $1;
            } elsif(m/\s*source_dir\s*((\/(.?\w+)+)+);\s*/ && $mutex == 0) {
                #source dir $1
                $confs{"$project_name"}{ "source_dir" } = $1; 
            } elsif(m/\s*git_address\s*(\w+\@\w+(\.\w+)+:\w+\/\w+(\.git)?);\s*/ && $mutex == 0) {
                $confs{"$project_name"}{ "git_address" } = $1;
            } elsif(m/\s*dest_dir\s*((\/\w+)+);\s*/ && $mutex == 0) {
                #dest dir $1
                $confs{"$project_name"}{ "dest_dir" } = $1;
            } elsif(m/\s*server\s*\{\s*/ && $mutex == 0) {
                #server block enter
                $mutex++;
            } elsif(m/\s*host\s*(\w+(\.\w+)+);\s*/ && $mutex == 1) {
                #one host address $1
                $servers{"$project_name"}[$i]{ 'host' } = $1;
            } elsif(m/\s*user\s*(\w+);\s*/ && $mutex == 1) {
                # host user name $1
                $servers{"$project_name"}[$i]{ 'user' } = $1;
            } elsif(m/\s*\}\s*/ && $mutex == 1) {
                # server block out
                $i++;
                $mutex--;
            } elsif(m/(\s*\}\s*)/ && $mutex == 0) {
                # project block out
                $mutex--;
                $i = 0;
            }
        }
    } else {
        print color("red");
        print "Can not read config file.\n";
        print "Error:$!\n";
        print color("reset");
        exit;
    }  
    close CONF;
    if(scalar(@errmsg) > 0) {
        for(@errmsg) {
            print color("red");
            print $_;
            print "\n";
        }
        print color("reset");
        exit;
    }
}

