package Excel::Writer::XLSX::Package::XMLwriter;

###############################################################################
#
# XMLwriter - A base class for the Excel::Writer::XLSX writer classes.
#
# Used in conjunction with Excel::Writer::XLSX
#
# Copyright 2000-2012, John McNamara, jmcnamara@cpan.org
#
# Documentation after __END__
#

# perltidy with the following options: -mbl=2 -pt=0 -nola

use 5.008002;
use strict;
use warnings;
use Exporter;
use Carp;
use IO::File;

our @ISA     = qw(Exporter);
our $VERSION = '0.51';

#
# NOTE: this module is a light weight re-implementation of XML::Writer. See
# the Pod docs below for a full explanation. The methods  are implemented
# for speed rather than readibility since they are used heavily in tight
# loops by Excel::Writer::XLSX.
#

# Note "local $\ = undef" protect print statements from -l on commandline.


###############################################################################
#
# new()
#
# Constructor.
#
sub new {

    my $class = shift;
    my $fh    = shift;    # May be undef and set later.

    my $self = { _fh => $fh };

    bless $self, $class;

    return $self;
}


###############################################################################
#
# _set_xml_writer()
#
# Set the XML writer filehandle for the object.
#
sub _set_xml_writer {

    my $self     = shift;
    my $filename = shift;

    my $fh = IO::File->new( $filename, 'w' );
    croak "Couldn't open file $filename for writing.\n" unless $fh;

    binmode $fh, ':utf8';

    $self->{_fh} = $fh;
}


###############################################################################
#
# _write_xml_declaration()
#
# Write the XML declaration.
#
sub _write_xml_declaration {

    my $self = shift;

    $self->xmlDecl();
}


###############################################################################
#
# xmlDecl()
#
# Write the XML declaration at the start of an XML document.
#
sub xmlDecl {

    my $self = shift;
    local $\ = undef;

    print { $self->{_fh} }
      qq(<?xml version="1.0" encoding="UTF-8" standalone="yes"?>\n);

}


###############################################################################
#
# startTag()
#
# Write an XML start tag with optional attributes.
#
sub startTag {

    my $self = shift;
    my $tag  = shift;

    while ( @_ ) {
        my $key   = shift @_;
        my $value = shift @_;

        $tag .= qq( $key="$value");
    }

    local $\ = undef;
    print { $self->{_fh} } "<$tag>";
}


###############################################################################
#
# startTag()
#
# Write an XML start tag with optional encoded attributes.
#
sub startTagEncoded {

    my $self = shift;
    my $tag  = shift;

    while ( @_ ) {
        my $key   = shift @_;
        my $value = shift @_;
        $value = _escape_xml_chars( $value );

        $tag .= qq( $key="$value");
    }

    local $\ = undef;
    print { $self->{_fh} } "<$tag>";
}


###############################################################################
#
# endTag()
#
# Write an XML end tag.
#
sub endTag {

    my $self = shift;
    my $tag  = shift;
    local $\ = undef;

    print { $self->{_fh} } "</$tag>";
}


###############################################################################
#
# emptyTag()
#
# Write an empty XML tag with optional attributes.
#
sub emptyTag {

    my $self = shift;
    my $tag  = shift;

    while ( @_ ) {
        my $key   = shift @_;
        my $value = shift @_;

        $tag .= qq( $key="$value");
    }

    local $\ = undef;

    # Note extra space before closing tag like XML::Writer.
    print { $self->{_fh} } "<$tag />";

}


###############################################################################
#
# emptyTagEncoded()
#
# Write an empty XML tag with optional encoded attributes.
#
sub emptyTagEncoded {

    my $self = shift;
    my $tag  = shift;

    while ( @_ ) {
        my $key   = shift @_;
        my $value = shift @_;
        $value = _escape_xml_chars( $value );

        $tag .= qq( $key="$value");
    }

    local $\ = undef;

    # Note extra space before closing tag like XML::Writer.
    print { $self->{_fh} } "<$tag />";

}


###############################################################################
#
# dataElement()
#
# Write an XML element containing data with optional attributes.
# XML characters in the data are encoded.
#
sub dataElement {

    my $self    = shift;
    my $tag     = shift;
    my $data    = shift;
    my $end_tag = $tag;

    while ( @_ ) {
        my $key   = shift @_;
        my $value = shift @_;

        $tag .= qq( $key="$value");
    }

    $data = _escape_xml_chars( $data );

    local $\ = undef;
    print { $self->{_fh} } "<$tag>$data</$end_tag>";
}


###############################################################################
#
# dataElementEncoded()
#
# Write an XML element containing data with optional encoded attributes.
# XML characters in the data are encoded.
#
sub dataElementEncoded {

    my $self    = shift;
    my $tag     = shift;
    my $data    = shift;
    my $end_tag = $tag;

    while ( @_ ) {
        my $key   = shift @_;
        my $value = shift @_;
        $value = _escape_xml_chars( $value );

        $tag .= qq( $key="$value");
    }

    $data = _escape_xml_chars( $data );

    local $\ = undef;
    print { $self->{_fh} } "<$tag>$data</$end_tag>";
}


###############################################################################
#
# stringElement()
#
# Optimised tag writer for <c> cell string elements in the inner loop.
#
sub stringElement {

    my $self  = shift;
    my $index = shift;
    my $attr  = '';

    while ( @_ ) {
        my $key   = shift;
        my $value = shift;
        $attr .= qq( $key="$value");
    }

    local $\ = undef;
    print { $self->{_fh} } "<c$attr t=\"s\"><v>$index</v></c>";
}


###############################################################################
#
# siElement()
#
# Optimised tag writer for shared strings <si> elements.
#
sub siElement {

    my $self  = shift;
    my $string = shift;
    my $attr  = '';


    while ( @_ ) {
        my $key   = shift;
        my $value = shift;
        $attr .= qq( $key="$value");
    }

    $string = _escape_xml_chars( $string );

    local $\ = undef;
    print { $self->{_fh} } "<si><t$attr>$string</t></si>";
}




###############################################################################
#
# siRichElement()
#
# Optimised tag writer for shared strings <si> rich string elements.
#
sub siRichElement {

    my $self  = shift;
    my $string = shift;


    local $\ = undef;
    print { $self->{_fh} } "<si>$string</si>";
}


###############################################################################
#
# numberElement()
#
# Optimised tag writer for <c> cell number elements in the inner loop.
#
sub numberElement {

    my $self  = shift;
    my $index = shift;
    my $attr  = '';

    while ( @_ ) {
        my $key   = shift;
        my $value = shift;
        $attr .= qq( $key="$value");
    }

    local $\ = undef;
    print { $self->{_fh} } "<c$attr><v>$index</v></c>";
}


###############################################################################
#
# formulaElement()
#
# Optimised tag writer for <c> cell formula elements in the inner loop.
#
sub formulaElement {

    my $self    = shift;
    my $formula = shift;
    my $value   = shift;
    my $attr    = '';

    while ( @_ ) {
        my $key   = shift;
        my $value = shift;
        $attr .= qq( $key="$value");
    }

    $formula = _escape_xml_chars( $formula );

    local $\ = undef;
    print { $self->{_fh} } "<c$attr><f>$formula</f><v>$value</v></c>";
}


###############################################################################
#
# inlineStr()
#
# Optimised tag writer for inlineStr cell elements in the inner loop.
#
sub inlineStr {

    my $self     = shift;
    my $string   = shift;
    my $preserve = shift;
    my $attr     = '';
    my $t_attr   = '';

    # Set the <t> attribute to preserve whitespace.
    $t_attr = ' xml:space="preserve"' if $preserve;

    while ( @_ ) {
        my $key   = shift;
        my $value = shift;
        $attr .= qq( $key="$value");
    }

    $string = _escape_xml_chars( $string );

    local $\ = undef;
    print { $self->{_fh} }
      "<c$attr t=\"inlineStr\"><is><t$t_attr>$string</t></is></c>";
}


###############################################################################
#
# richInlineStr()
#
# Optimised tag writer for rich inlineStr cell elements in the inner loop.
#
sub richInlineStr {

    my $self  = shift;
    my $string = shift;
    my $attr  = '';

    while ( @_ ) {
        my $key   = shift;
        my $value = shift;
        $attr .= qq( $key="$value");
    }

    local $\ = undef;
    print { $self->{_fh} } "<c$attr t=\"inlineStr\"><is>$string</is></c>";
}


###############################################################################
#
# characters()
#
# For compatibility with XML::Writer only.
#
sub characters {

    my $self = shift;
    my $data = shift;
    local $\ = undef;

    $data = _escape_xml_chars( $data );

    print { $self->{_fh} } $data;
}


###############################################################################
#
# end()
#
# For compatibility with XML::Writer only.
#
sub end {

    my $self = shift;
    local $\ = undef;

    print { $self->{_fh} } "\n";
}


###############################################################################
#
# getOutput()
#
# Return the output filehandle.
#
sub getOutput {

    my $self = shift;

    return $self->{_fh};
}


###############################################################################
#
# _escape_xml_chars()
#
# Escape XML characters.
#
sub _escape_xml_chars {

    my $str = $_[0];

    return $str if $str !~ m/[&<>]/;

    for ( $str ) {
        s/&/&amp;/g;
        s/</&lt;/g;
        s/>/&gt;/g;
    }

    return $str;
}


1;


__END__

=pod

=head1 NAME

XMLwriter - A base class for the Excel::Writer::XLSX writer classes.

=head1 DESCRIPTION

This module is used by L<Excel::Writer::XLSX> for writing XML documents. It is a light weight re-implementation of L<XML::Writer>.

XMLwriter is approximately twice as fast as L<XML::Writer>. This speed is achieved at the expense of error and correctness checking. In addition not all of the L<XML::Writer> methods are implemented. As such, XMLwriter is not recommended for use outside of Excel::Writer::XLSX.

=head1 SEE ALSO

L<XML::Writer>.

=head1 AUTHOR

John McNamara jmcnamara@cpan.org

=head1 COPYRIGHT

� MM-MMXII, John McNamara.

All Rights Reserved. This module is free software. It may be used, redistributed and/or modified under the same terms as Perl itself.

=head1 LICENSE

Either the Perl Artistic Licence L<http://dev.perl.org/licenses/artistic.html> or the GPL L<http://www.opensource.org/licenses/gpl-license.php>.

=head1 DISCLAIMER OF WARRANTY

See the documentation for L<Excel::Writer::XLSX>.

=cut
