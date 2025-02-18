###############################################################################
#
# Tests for Excel::Writer::XLSX::Package::XMLwriter methods.
#
# Copyright 2000-2022, John McNamara, jmcnamara@cpan.org
#

use lib 't/lib';
use TestFunctions qw(_new_object);
use strict;
use warnings;
use Excel::Writer::XLSX::Package::XMLwriter;

use Test::More tests => 1;

###############################################################################
#
# Tests setup.
#
my $expected;
my $caption;
my $got;
my $obj = _new_object( \$got, 'Excel::Writer::XLSX::Package::XMLwriter' );


###############################################################################
#
# Test the xml_declaration() method.
#
$caption  = " \tXMLwriter: xml_declaration()";
$expected = qq(<?xml version="1.0" encoding="UTF-8" standalone="yes"?>\n);

$obj->xml_declaration();

is( $got, $expected, $caption );

__END__


