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
# Test conditional formats.
#
$caption = " \tWorksheet: _assemble_xml_file()";

$worksheet = _new_worksheet(\$got);

$worksheet->{_date_1904} = 0;

$worksheet->select();

# Start test code.
$worksheet->write( 'A1',  1 );
$worksheet->write( 'A2',  2 );
$worksheet->write( 'A3',  3 );
$worksheet->write( 'A4',  4 );
$worksheet->write( 'A5',  5 );
$worksheet->write( 'A6',  6 );
$worksheet->write( 'A7',  7 );
$worksheet->write( 'A8',  8 );
$worksheet->write( 'A9',  9 );
$worksheet->write( 'A10', 10 );
$worksheet->write( 'A11', 11 );
$worksheet->write( 'A12', 12 );

$worksheet->conditional_formatting( 'A1:A12',
    {
        type     => 'data_bar',
    }
);
# End test code.

$worksheet->_assemble_xml_file();

$expected = _expected_to_aref();
$got      = _got_to_aref( $got );

_is_deep_diff( $got, $expected, $caption );

__DATA__
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
  <dimension ref="A1:A12"/>
  <sheetViews>
    <sheetView tabSelected="1" workbookViewId="0"/>
  </sheetViews>
  <sheetFormatPr defaultRowHeight="15"/>
  <sheetData>
    <row r="1" spans="1:1">
      <c r="A1">
        <v>1</v>
      </c>
    </row>
    <row r="2" spans="1:1">
      <c r="A2">
        <v>2</v>
      </c>
    </row>
    <row r="3" spans="1:1">
      <c r="A3">
        <v>3</v>
      </c>
    </row>
    <row r="4" spans="1:1">
      <c r="A4">
        <v>4</v>
      </c>
    </row>
    <row r="5" spans="1:1">
      <c r="A5">
        <v>5</v>
      </c>
    </row>
    <row r="6" spans="1:1">
      <c r="A6">
        <v>6</v>
      </c>
    </row>
    <row r="7" spans="1:1">
      <c r="A7">
        <v>7</v>
      </c>
    </row>
    <row r="8" spans="1:1">
      <c r="A8">
        <v>8</v>
      </c>
    </row>
    <row r="9" spans="1:1">
      <c r="A9">
        <v>9</v>
      </c>
    </row>
    <row r="10" spans="1:1">
      <c r="A10">
        <v>10</v>
      </c>
    </row>
    <row r="11" spans="1:1">
      <c r="A11">
        <v>11</v>
      </c>
    </row>
    <row r="12" spans="1:1">
      <c r="A12">
        <v>12</v>
      </c>
    </row>
  </sheetData>
  <conditionalFormatting sqref="A1:A12">
    <cfRule type="dataBar" priority="1">
      <dataBar>
        <cfvo type="min" val="0"/>
        <cfvo type="max" val="0"/>
        <color rgb="FF638EC6"/>
      </dataBar>
    </cfRule>
  </conditionalFormatting>
  <pageMargins left="0.7" right="0.7" top="0.75" bottom="0.75" header="0.3" footer="0.3"/>
</worksheet>
