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
my $filename     = 'table01.xlsx';
my $dir          = 't/regression/';
my $got_filename = $dir . "ewx2_$filename";
my $exp_filename = $dir . 'xlsx_files/' . $filename;

# Ignore increased shared string count.
my $ignore_members  = ['xl/sharedStrings.xml'];
my $ignore_elements = {};


###############################################################################
#
# Test the creation of a simple Excel::Writer::XLSX file with tables.
#
use Excel::Writer::XLSX;

my $workbook  = Excel::Writer::XLSX->new( $got_filename );
my $worksheet = $workbook->add_worksheet();

# Set the column width to match the target worksheet.
$worksheet->set_column('C:F', 10.288);

# Add the table.
$worksheet->add_table('C3:F13');


# The following table should be ignored since it contains duplicate headers.
# Catch and ignore the warning during testing.
local $SIG{__WARN__} = sub {};
eval {
    $worksheet->add_table( 'C3:F7', { columns => [ { header => 'Column1' },
                                                   { header => 'column1' }]});
};

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
