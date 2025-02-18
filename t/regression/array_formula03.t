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

use Test::More tests => 2;

###############################################################################
#
# Tests setup.
#
my $filename     = 'array_formula03.xlsx';
my $dir          = 't/regression/';
my $got_filename = $dir . "ewx_$filename";
my $exp_filename = $dir . 'xlsx_files/' . $filename;

my $ignore_members  = [ 'xl/calcChain.xml', '\[Content_Types\].xml', 'xl/_rels/workbook.xml.rels' ];
my $ignore_elements = {  'xl/workbook.xml' => ['<workbookView'] };


###############################################################################
#
# Test the creation of an Excel::Writer::XLSX file with an array formula.
#
use Excel::Writer::XLSX;

my $workbook  = Excel::Writer::XLSX->new( $got_filename );
my $worksheet = $workbook->add_worksheet();

my $data = [ 0, 0, 0 ];

$worksheet->write_col( 'B1', $data );
$worksheet->write_col( 'C1', $data );

$worksheet->write_formula( 'A1', '{=SUM(B1:C1*B2:C2)}',  undef, 0  );


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
# Test the creation of an Excel::Writer::XLSX file with an array formula.
#
$workbook  = Excel::Writer::XLSX->new( $got_filename );
$worksheet = $workbook->add_worksheet();

$data = [ 0, 0, 0 ];

$worksheet->write_col( 'B1', $data );
$worksheet->write_col( 'C1', $data );

$worksheet->write( 'A1', '{=SUM(B1:C1*B2:C2)}',  undef, 0  );


$workbook->close();


###############################################################################
#
# Compare the generated and existing Excel files.
#

( $got, $expected, $caption ) = _compare_xlsx_files(

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
