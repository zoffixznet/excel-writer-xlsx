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
my $filename     = 'header_image18.xlsx';
my $dir          = 't/regression/';
my $got_filename = $dir . "ewx_$filename";
my $exp_filename = $dir . 'xlsx_files/' . $filename;

my $ignore_members  = [];
my $ignore_elements =
  { 'xl/worksheets/sheet1.xml' => [ '<pageMargins', '<pageSetup' ] };


###############################################################################
#
# Test the creation of a simple Excel::Writer::XLSX file with image(s).
#
use Excel::Writer::XLSX;

my $workbook  = Excel::Writer::XLSX->new( $got_filename );
my $worksheet = $workbook->add_worksheet();

$worksheet->insert_image( 'E9', $dir . 'images/red.png' );

$worksheet->set_header('&L&G&C&G&R&G', undef,
    {
        image_left   => $dir . 'images/red.jpg',
        image_center => $dir . 'images/blue.jpg',
        image_right  => $dir . 'images/red.jpg'
    }
);

$worksheet->set_footer('&L&G&C&G&R&G', undef,
    {
        image_left   => $dir . 'images/blue.jpg',
        image_center => $dir . 'images/red.jpg',
        image_right  => $dir . 'images/blue.jpg'
    }
);

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
