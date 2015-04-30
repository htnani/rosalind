#!/usr/bin/env perl

# PODNAME: revp-bioperl.pl
# ABSTRACT: Locating Restriction Sites

## Author     : ian.sealy@sanger.ac.uk
## Maintainer : ian.sealy@sanger.ac.uk
## Created    : 2015-04-30

use warnings;
use strict;
use autodie;
use Getopt::Long;
use Pod::Usage;
use Carp;
use version; our $VERSION = qv('v0.1.0');

use Bio::SeqIO;

# Default options
my $dataset_file;
my ( $debug, $help, $man );

# Get and check command line options
get_and_check_options();

# Get input
my $in = Bio::SeqIO->new(
    -file     => $dataset_file,
    -format   => 'fasta',
    -alphabet => 'dna',
);
my $seq  = $in->next_seq;
my $revc = $seq->revcom->seq;
$seq = $seq->seq;

foreach my $pos ( 0 .. ( length $seq ) - 1 ) {
    foreach my $length ( 2 .. 6 ) {    ## no critic (ProhibitMagicNumbers)
        next if $pos + $length * 2 > length $seq;
        my $seq1 = substr $seq, $pos, $length;
        my $seq2 = substr $revc, -( $pos + $length * 2 ), $length;
        if ( $seq1 eq $seq2 ) {
            printf "%d %d\n", $pos + 1, $length * 2;
        }
    }
}

# Get and check command line options
sub get_and_check_options {

    # Get options
    GetOptions(
        'dataset_file=s' => \$dataset_file,
        'debug'          => \$debug,
        'help'           => \$help,
        'man'            => \$man,
    ) or pod2usage(2);

    # Documentation
    if ($help) {
        pod2usage(1);
    }
    elsif ($man) {
        pod2usage( -verbose => 2 );
    }

    # Check options
    if ( !$dataset_file ) {
        pod2usage("--dataset_file must be specified\n");
    }

    return;
}

__END__
=pod

=encoding UTF-8

=head1 NAME

revp-bioperl.pl

Locating Restriction Sites

=head1 VERSION

version 0.1.0

=head1 DESCRIPTION

This script is given "A DNA string of length at most 1 kbp in FASTA format" and
returns "The position and length of every reverse palindrome in the string
having length between 4 and 12. You may return these pairs in any order".

=head1 EXAMPLES

    perl revp-bioperl.pl --dataset_file sample.txt

=head1 USAGE

    revp-bioperl.pl
        [--dataset_file file]
        [--debug]
        [--help]
        [--man]

=head1 OPTIONS

=over 8

=item B<--dataset_file FILE>

File containing "A DNA string of length at most 1 kbp in FASTA format".

=item B<--debug>

Print debugging information.

=item B<--help>

Print a brief help message and exit.

=item B<--man>

Print this script's manual page and exit.

=back

=head1 DEPENDENCIES

None

=head1 AUTHOR

=over 4

=item *

Ian Sealy <ian.sealy@sanger.ac.uk>

=back

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2015 by Genome Research Ltd.

This is free software, licensed under:

  The GNU General Public License, Version 3, June 2007

=cut
