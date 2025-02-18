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
my $filename     = 'protect06.xlsx';
my $dir          = 't/regression/';
my $got_filename = $dir . "ewx_$filename";
my $exp_filename = $dir . 'xlsx_files/' . $filename;

my $ignore_members  = [];
my $ignore_elements = {};


###############################################################################
#
# Test the a simple Excel::Writer::XLSX file with worksheet protection.
#
use Excel::Writer::XLSX;

my $workbook  = Excel::Writer::XLSX->new( $got_filename );
my $worksheet = $workbook->add_worksheet();

my $unlocked  = $workbook->add_format( locked => 0, hidden => 0 );
my $hidden    = $workbook->add_format( locked => 0, hidden => 1 );

$worksheet->protect();

$worksheet->unprotect_range('A1', undef, 'password');
$worksheet->unprotect_range('C1:C3');
$worksheet->unprotect_range('G4:I6', 'MyRange');
$worksheet->unprotect_range('K7', undef, 'foobar');

$worksheet->write( 'A1', 1 );
$worksheet->write( 'A2', 2, $unlocked );
$worksheet->write( 'A3', 3, $hidden );

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



