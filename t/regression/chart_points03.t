###############################################################################
#
# Tests the output of Excel::Writer::XLSX against Excel generated files.
#
# Copyright 2000-2022, John McNamara, jmcnamara@cpan.org
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
my $filename     = 'chart_points03.xlsx';
my $dir          = 't/regression/';
my $got_filename = $dir . "ewx_$filename";
my $exp_filename = $dir . 'xlsx_files/' . $filename;

my $ignore_members  = [];

my $ignore_elements = {};


###############################################################################
#
# Test the creation of an Excel::Writer::XLSX file with point formatting.
#
use Excel::Writer::XLSX;

my $workbook  = Excel::Writer::XLSX->new( $got_filename );
my $worksheet = $workbook->add_worksheet();
my $chart     = $workbook->add_chart( type => 'pie', embedded => 1 );

# Replicate the cutom colors for testing.
$workbook->set_custom_color( 40, 0xCC, 0x00, 0x00 );
$workbook->set_custom_color( 41, 0x99, 0x00, 0x00 );

my $data = [ 2, 5, 4, ];

$worksheet->write_col( 'A1', $data );

$chart->add_series(
    values => '=Sheet1!$A$1:$A$3',
    points => [
        { fill => { color => '#FF0000' } },
        { fill => { color => '#CC0000' } },
        { fill => { color => '#990000' } },
    ],
);

$worksheet->insert_chart( 'E9', $chart );

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



