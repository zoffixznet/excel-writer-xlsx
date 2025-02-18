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
my $filename     = 'vml04.xlsx';
my $dir          = 't/regression/';
my $got_filename = $dir . "ewx_$filename";
my $exp_filename = $dir . 'xlsx_files/' . $filename;

my $ignore_members  = [];
my $ignore_elements = {};


###############################################################################
#
# Test the creation of a simple Excel::Writer::XLSX file with mixed VML.
#
use Excel::Writer::XLSX;

my $workbook  = Excel::Writer::XLSX->new( $got_filename );
my $worksheet1 = $workbook->add_worksheet();
my $worksheet2 = $workbook->add_worksheet();
my $worksheet3 = $workbook->add_worksheet();

for my $row ( 0 .. 127 ) {
    for my $col ( 0 .. 15 ) {
        $worksheet1->write_comment( $row, $col, 'Some text' );
    }
}

$worksheet3->write_comment( 'A1', 'More text' );

# Set the author to match the target XLSX file.
$worksheet1->set_comments_author( 'John' );
$worksheet3->set_comments_author( 'John' );

$worksheet1->insert_button( 'B2', {} );
$worksheet1->insert_button( 'C4', {} );
$worksheet1->insert_button( 'E6', {} );

$worksheet3->insert_button( 'E8', {} );

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



