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
my $filename     = 'chart_combined08.xlsx';
my $dir          = 't/regression/';
my $got_filename = $dir . "ewx_$filename";
my $exp_filename = $dir . 'xlsx_files/' . $filename;

my $ignore_members  = [];

# TODO. There are too many ignored elements here. Remove when the
# axis writing is fixed for secondary scatter charts.
my $ignore_elements = { 'xl/charts/chart1.xml' => ['<c:dispBlanksAs',
                                                   '<c:crossBetween',
                                                   '<c:tickLblPos',
                                                   '<c:auto',
                                                   '<c:valAx>',
                                                   '<c:catAx>',
                                                   '</c:valAx>',
                                                   '</c:catAx>',
                                                   '<c:crosses',
                                                   '<c:lblOffset',
                                                   '<c:lblAlgn'] };


###############################################################################
#
# Test the creation of a simple Excel::Writer::XLSX file.
#
use Excel::Writer::XLSX;

my $workbook  = Excel::Writer::XLSX->new( $got_filename );
my $worksheet = $workbook->add_worksheet();
my $chart1    = $workbook->add_chart( type => 'column', embedded => 1 );
my $chart2    = $workbook->add_chart( type => 'scatter',   embedded => 1 );

# For testing, copy the randomly generated axis ids in the target xlsx file.
# For this test the ids match the generated ids.
$chart1->{_axis_ids} = [ 81267328, 81297792 ];
$chart2->{_axis_ids} = [ 81267328, 81297792 ];
$chart2->{_axis2_ids} = [ 89510656, 84556032 ];

my $data = [
    [ 2,   3,  4,  5,   6 ],
    [ 20, 25, 10, 10,  20 ],
    [ 5,  10, 15, 10,   5 ],

];

$worksheet->write( 'A1', $data );

$chart1->add_series(
    categories => '=Sheet1!$A$1:$A$5',
    values     => '=Sheet1!$B$1:$B$5'
);

$chart2->add_series(
    categories => '=Sheet1!$A$1:$A$5',
    values     => '=Sheet1!$C$1:$C$5',
    y2_axis    => 1,
);


$chart1->combine($chart2);


$worksheet->insert_chart( 'E9', $chart1 );

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
