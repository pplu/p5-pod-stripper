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

my $original_bytes = 0;
my $final_bytes = 0;

use Cwd ();
my $cwd = Cwd::cwd();

# Traverse desired filesystems
File::Find::find({wanted => \&wanted}, 'local/');

say "Original module size: $original_bytes";
say "Stripped to: $final_bytes";
say sprintf "Won %0.02f%%", (1- ($final_bytes / $original_bytes)) * 100;

exit;

sub wanted {
    my ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size);

    ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size) = lstat($_);
    $original_bytes += $size;

    if (-f $_ && /^.*\.pm\z/s) {
        dostrip($_);
    }

    if (-f _ && /^.*\.pod\z/s) {
        delete_pod($_);
    }

    $final_bytes += (-s $_ // 0);
}

sub delete_pod {
    my $file = shift;
    unlink $file;
}

sub dostrip {
    my $file = shift;

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

