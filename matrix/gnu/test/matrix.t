#!/usr/bin/perl

use strict;
use warnings;
use File::Basename;
use File::Find;

sub process_file {
    my $file = shift;
    my $dir = dirname($file);
    my $base = basename($file);

    if (-f $file) {
        my $ext = File::Basename::extension($base);
        my $new_base = substr($base, 0, -length($ext)) . '.'; 

        if ($ext eq '.txt') {
        open(my $fh, '<', $file) or die "Can't open $file";
        while (my $line = <$fh>) {
            s/\bthe\b/THE/g;
            print $line;
        }
        close($fh);
        } elsif ($ext eq '.jpg') {
            system("convert $file -resize 100x100 $dir/$base");
        }
        rename($file, "$dir/$base");
    }
    elsif (-d $file) {
        find(\&process_file, $file);
        rmdir($file) unless -e "$file/." || -e "$file/.";
        }

}

find(\&process_file, '.');


    