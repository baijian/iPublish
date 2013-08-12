package IPublish::Ssh;
use strict;

sub connect_server {
    my ($host, $user) = @_;
    my $ssh = Net::OpenSSH->new($host, (user=>$user));
    print color("red");
    $ssh->error and die "Couldn't establish SSH connection: ". $ssh->error;
    print color("reset");
    return $ssh;
}


