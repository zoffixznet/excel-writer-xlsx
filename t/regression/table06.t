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
my $filename     = 'table06.xlsx';
my $dir          = 't/regression/';
my $got_filename = $dir . "ewx_$filename";
my $exp_filename = $dir . 'xlsx_files/' . $filename;

my $ignore_members  = [];
my $ignore_elements = {};


###############################################################################
#
# Test the creation of a simple Excel::Writer::XLSX file with tables.
#
use Excel::Writer::XLSX;

my $workbook  = Excel::Writer::XLSX->new( $got_filename );
my $worksheet = $workbook->add_worksheet();

# Set the column width to match the target worksheet.
$worksheet->set_column('C:H', 10.288);

# Add the tables.
$worksheet->add_table('C3:F13');
$worksheet->add_table('F15:H20');
$worksheet->add_table('C23:D30');


# Turn off default URL format for testing.
$worksheet->{_default_url_format} = undef;

# Add a link to check rId handling.
$worksheet->write( 'A1', 'http://perl.com/' );
$worksheet->write( 'C1', 'http://perl.com/' );

# Add comments to check rId handling.
$worksheet->set_comments_author( 'John' );
$worksheet->write_comment( 'H1', 'Test1' );
$worksheet->write_comment( 'J1', 'Test2' );

# Add drawing to check rId handling.
$worksheet->insert_image( 'A4',  $dir . 'images/blue.png' );

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



