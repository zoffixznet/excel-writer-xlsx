###############################################################################
#
# Tests for Excel::Writer::XLSX::Drawing methods.
#
# Copyright 2000-2022, John McNamara, jmcnamara@cpan.org
#

use lib 't/lib';
use TestFunctions '_new_object';
use strict;
use warnings;
use Excel::Writer::XLSX::Drawing;

use Test::More tests => 1;


###############################################################################
#
# Tests setup.
#
my $expected;
my $got;
my $caption;
my $drawing;


###############################################################################
#
# Test the _write_xfrm_offset() method.
#
$caption  = " \tDrawing: _write_xfrm_offset()";
$expected = '<a:off x="0" y="0"/>';

$drawing = _new_object( \$got, 'Excel::Writer::XLSX::Drawing' );

$drawing->_write_xfrm_offset();

is( $got, $expected, $caption );

__END__


