package IPublish::Switch;
use strict;

use IPublish::Config;

sub current_version {
    my ($project_name) = @_;
    &load_conf;
    &project_exist_check($project_name);
    foreach(@{$servers{ "$project_name" }}) {
        my $host = $_->{ "host" };
        my %params = (
            user => $_->{ "user" }
        );
        my $version_file = $confs{ "$project_name" }->{"version_file"};
        my $ssh = Net::OpenSSH->new($host, %params);
        my $cmd = "cat $version_file";
        open my $oldout, ">&", \*STDERR or die "error";
        open STDERR, '>', '/dev/null' or die "error";
        my @out = $ssh->capture( $cmd );
        open STDERR, ">&", $oldout;
        if($ssh->error) {
            print color("red");
            print "You haven't publish a version!\n";
            print color("reset");
        }
        print color("yellow");
        print "@out";
        print color("reset");
        #only get version from one server
        exit;
    }
}

sub change_version {
    my ($project_name, $new_version) = @_;
    &load_conf;
    &project_exist_check($project_name);
    &all_versions_exist_check($project_name, $new_version);
    foreach(@{$servers{ "$project_name" }}) {
        my $host = $_->{ "host" };
        my %params = (
            user => $_->{ "user" }
        );
        my $version_file = $confs{ "$project_name" }->{"version_file"};
        my $ssh = Net::OpenSSH->new($host, %params);
        my $cmd = "echo $new_version > $version_file";
        open my $oldout, ">&", \*STDERR or die "error";
        open STDERR, '>', '/dev/null' or die "error";
        my $out = $ssh->capture( $cmd );
        open STDERR, ">&", $oldout;
        if($ssh->error) {
            print color("red");
            print "$host Change Version to $new_version Failed!\n";
        } else {
            print color("green");
            print "$host Change Version to $new_version Successful.\n";
        }
    }
    print color("reset");
}

sub servers_version_check {
    # check if the version are exists in all servers of a project
    my ($project_name, $version) = @_;
    my $res;
    foreach(@{$servers{ "$project_name" }}) {
        $res = &server_version_check($project_name, $_->{ "host" }, $version);
        if($res) {
            print color("red");;
            print "$version does not exists in".$_->{ "host" }."\n";
            print color("reset");
            exit;
        }
    }
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

sub add_server_version {
    my ($project_name, $host, $user, $dest_dir, $version) = @_;
    my $ssh = IPublish::Ssh->connect_server($host, $user);
    my @args = ("mkdir", $dest_dir."/".$version);
    my $out = $ssh->system(@args);
}

sub list_versions {
    my ($project_name) = @_;
    &load_conf;
    &project_exist_check($project_name);
    #print versions of one server(use iPublish default every servers' versions are same)
    foreach(@{$servers{ "$project_name" }}) {
        my $host = $_->{ "host" };
        my %params = (
            user => $_->{ "user" }
        );
        my $dir = $confs{ "$project_name" }->{"dest_dir"};
        my $ssh = Net::OpenSSH->new($host, %params);
        my $cmd = "ls -l $dir";
        my @out = $ssh->capture( $cmd );
        shift @out;
        print color("yellow");
        foreach (@out) {
            my @line = split(' ', $_);   
            print pop(@line);
            print "\n";
        }
        print color("reset");
        exit;
    }
}
