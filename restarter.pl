#
# Copyright 2013 by Denis Erygin,
# denis.erygin@gmail.com
#

use warnings;
use strict;

use constant PORT      => 2302; # Change it with epoch.sh
use constant PATH      => $ENV{'PWD'}.'/'; # Set your epoch server dir
use constant PIDFILE   => PATH.PORT.'.pid';
use constant CACHE_DIR => PATH.'cache/players';

unless (-f PATH.'epoch') {
    print STDERR "Can't found server binary!\n";
    exit;
}

set_time  ();
logrotate ();

if (-f PIDFILE) {
    open  (IN, '<'.PIDFILE) or die "Can't open: $!";
    my $pid = int(<IN>);
    close (IN);

    my $res = `kill -TERM $pid 2>&1`;
    print STDERR $res,"\n" if $res;
   
    unlink (PIDFILE) if (-f PIDFILE);    
    backup_cache();
}

print STDERR "Restart Dayz Epoch server...\n";
chdir (PATH);

my $cmd = '/usr/bin/screen -h 20000 -fa -d -m -S epoch '.PATH.'epoch.sh';
my $res = `$cmd`;
print STDERR $res,"\n" if $res;
exit;

#-----------------------------------------------------------------------------------------------
sub set_time {
    my ($s, $m, $h, $day, $mon, $y) = localtime(time() - 3*3600);
    $y += 1900;
    $mon++;
    
    # Uncomment to disabe night
    #($h, $m) = (17, 0) if ($h > 17 || ($h >= 0 && $h < 4));
