###############################################################################
#
# Tests the output of Excel::Writer::XLSX against Excel generated files.
#
# Copyright 2000-2021, John McNamara, jmcnamara@cpan.org
#

use lib 't/lib';
use TestFunctions qw(_compare_xlsx_files _is_deep_diff);
use strict;
use warnings;

use Test::More tests => 1;

###############################################################################
#
# Tests setup.
#
my $filename     = 'rich_string12.xlsx';
my $dir          = 't/regression/';
my $got_filename = $dir . "ewx_$filename";
my $exp_filename = $dir . 'xlsx_files/' . $filename;

my $ignore_members  = [];
my $ignore_elements = {};


###############################################################################
#
# Test the creation of a simple Excel::Writer::XLSX file.
#
use Excel::Writer::XLSX;

my $workbook  = Excel::Writer::XLSX->new( $got_filename );
my $worksheet = $workbook->add_worksheet();

$worksheet->set_column( 'A:A', 30 );
$worksheet->set_row( 2, 60 );

my $bold      = $workbook->add_format( bold      => 1 );
my $italic    = $workbook->add_format( italic    => 1 );
my $wrap      = $workbook->add_format( text_wrap => 1 );


$worksheet->write( 'A1', 'Foo', $bold );
$worksheet->write( 'A2', 'Bar', $italic );
$worksheet->write_rich_string( 'A3', "This is\n", $bold, "bold\n", "and this is\n", $italic, 'italic', $wrap );

$workbook->close();


###############################################################################
#
# Compare the generated and existing Excel files.
#

my ( $got, $expected, $caption ) = _compare_xlsx_files(

    $got_filename,
    $exp_filename,
    $ignore_members,
    $ignore_elements,
);

_is_deep_diff( $got, $expected, $caption );


###############################################################################
#
# Cleanup.
#
unlink $got_filename;

__END__



