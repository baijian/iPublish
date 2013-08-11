package IPublish::Cmd;
use strict;

use IPublish::Pub;

our(
    $help,
    $listall_of_projects,
    $listinfo_of_project,
    $list_versions_of_project,
    $list_current_version_of_project,
    $publish_project,
    $switch_project,
    $version,
)

sub run {
    GetOptions(
        'help|h!' => \$help,
        'listall|all!' => \$listall_of_projects, 
        'list|l=s' => \$listinfo_of_project,
        'listversions|lvs=s' => \$list_versions_of_project,
        'listversion|lv=s' => \$list_current_version_of_project,
        'publish|pub=s' => \$publish_project,
        'switch|sw=s' => \$switch_project,
        'version|v=s' => \$version,
    );
    if ($help) {
        &help_info;
    } elsif ($listall_of_projects) {
        #list all projects' info
        IPublish::Pub->list_projects;
    } elsif ($listinfo_of_project) {
        #list conf of one project
        IPublish::Pub->list_projects($listinfo_of_project);
    } elsif ($list_versions_of_project) {
        #list project's all versions
        &list_versions($list_versions_of_project);
    } elsif ($list_current_version_of_project) {
        #list project's current version
        &current_version($list_current_version_of_project);
    } elsif ($publish_project and $version) {
        #publish a new version for a project
        &publish_version($publish_project, $version);
    } elsif ($switch_project and $version) {
        #convert into a new version for a project
        &change_version($switch_project, $version);
    } else {
        &help_info;
    }
}
