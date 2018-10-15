#!/usr/bin/env perl

use v5.10;
use warnings;
use strict;
use File::Find ();
use Pod::Strip;
use autodie;

sub wanted;
sub dostrip;
sub delete_pod;

use Cwd ();
my $cwd = Cwd::cwd();

# Traverse desired filesystems
File::Find::find({wanted => \&wanted}, 'local/');
exit;

sub wanted {
    my ($dev,$ino,$mode,$nlink,$uid,$gid);

    (($dev,$ino,$mode,$nlink,$uid,$gid) = lstat($_)) &&
    -f _ &&
    /^.*\.pm\z/s &&
    dostrip($_);

    (($dev,$ino,$mode,$nlink,$uid,$gid) = lstat($_)) &&
    -f _ &&
    /^.*\.pod\z/s &&
    delete_pod($_);

}

sub delete_pod {
    my $file = shift;
    unlink $file;
}

sub dostrip {
    my $file = shift;
    say "Stripping $file";

    my $strip = Pod::Strip->new;
    my $module;
    { local $/ = undef;
      open my $pm, '<', $file;
      $module = <$pm>;
      close $pm
    }

    # We unlink the original pm
    unlink $file;

    open my $pm, '>', $file;
    $strip->output_fh($pm);
    $strip->parse_string_document($module);
    close $pm;
}

