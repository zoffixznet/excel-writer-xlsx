###############################################################################
#
# Tests for Excel::Writer::XLSX::Worksheet methods.
#
# Copyright 2000-2022, John McNamara, jmcnamara@cpan.org
#

use lib 't/lib';
use TestFunctions qw(_expected_to_aref _got_to_aref _is_deep_diff _new_worksheet);
use strict;
use warnings;

use Test::More tests => 1;

###############################################################################
#
# Tests setup.
#
my $expected;
my $got;
my $caption;
my $worksheet;


###############################################################################
#
# Test the _assemble_xml_file() method.
#
# Test merged cells.
#
$caption = " \tWorksheet: _assemble_xml_file()";

my $format = Excel::Writer::XLSX::Format->new( {}, {}, xf_index => 1 );
$worksheet = _new_worksheet(\$got);

$worksheet->select();
$worksheet->merge_range( 'B3:C3', 'Foo', $format);

$worksheet->_assemble_xml_file();

$expected = _expected_to_aref();
$got      = _got_to_aref( $got );

_is_deep_diff( $got, $expected, $caption );

__DATA__
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
  <dimension ref="B3:C3"/>
  <sheetViews>
    <sheetView tabSelected="1" workbookViewId="0"/>
  </sheetViews>
  <sheetFormatPr defaultRowHeight="15"/>
  <sheetData>
    <row r="3" spans="2:3">
      <c r="B3" s="1" t="s">
        <v>0</v>
      </c>
      <c r="C3" s="1"/>
    </row>
  </sheetData>
  <mergeCells count="1">
    <mergeCell ref="B3:C3"/>
  </mergeCells>
  <pageMargins left="0.7" right="0.7" top="0.75" bottom="0.75" header="0.3" footer="0.3"/>
</worksheet>
