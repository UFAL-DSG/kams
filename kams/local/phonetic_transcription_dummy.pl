#!/usr/bin/perl

use strict;
use warnings;
use utf8;
use Encode;

# $ PhoneticTranscription.pl [inputFile inputFile2 ...] outputFile
#
# All input files will be concatenated into the output file. If no
# input files are specified, reads from STDIN.
#
# If you want the script to operate in another encoding, set the EV_encoding
# environment variable to the desired encoding.
#

my $enc = 'utf8';

my $out_fn = pop @ARGV;
if ($out_fn) {
    close STDOUT;
    open STDOUT, '>', $out_fn or die "Couldn't open '$out_fn': $!";
}

my %seen = ();
while (<>) {
    for (decode($enc, $_)) {
        chomp;
        $_ = uc($_);

        print encode($enc, $_);
        print(' ' x 7);

        $_ = lc($_);

        $_ =~ s/#//g;
        $_ =~ s/\`/'/g;
        
        $_ = join(" ", split(//, $_));

        print encode($enc, $_);
        print "\n";
    }
}

