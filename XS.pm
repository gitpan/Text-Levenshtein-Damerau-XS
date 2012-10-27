package Text::Levenshtein::Damerau::XS;
use utf8;
require Exporter;
*import = \&Exporter::import;
require DynaLoader;

$Text::Levenshtein::Damerau::XS::VERSION = '0.5';

DynaLoader::bootstrap Text::Levenshtein::Damerau::XS $Text::Levenshtein::Damerau::XS::VERSION;

@Text::Levenshtein::Damerau::XS::EXPORT = ();
@Text::Levenshtein::Damerau::XS::EXPORT_OK = qw(
	cxs_edistance 
	xs_edistance
    );

sub dl_load_flags {0} # Prevent DynaLoader from complaining and croaking

sub xs_edistance {
    # Wrapper for XS cxs_edistance function
    my $str1 = shift;
    my $str2 = shift;
    my @arr1 = unpack 'U*', $str1;
    my @arr2 = unpack 'U*', $str2;

    return cxs_edistance( \@arr1, \@arr2 );
}

1;

__END__

=encoding utf8

=head1 NAME

C<Text::Levenshtein::Damerau::XS> - XS Damerau Levenshtein edit distance

=head1 SYNOPSIS

	# Normal usage through Text::Levenshtein::Damerau
	use Text::Levenshtein::Damerau qw/edistance/;
	use warnings;
	use strict;

	print edistance('Neil','Niel');
	# prints 1



	# Using this module directly
	use Text::Levenshtein::Damerau::XS qw/xs_edistance/;
	use warnings;
	use strict;

	print xs_edistance('Neil','Niel');
	# prints 1

=head1 DESCRIPTION

Returns the true Damerau Levenshtein edit distance of strings with adjacent transpositions. L<XS> implementation. Works correctly with utf8.

	use utf8;
	xs_edistance('ⓕⓞⓤⓡ','ⓕⓤⓞⓡ'), 
	# prints 1

=head1 METHODS

=head1 EXPORTABLE METHODS

=head2 xs_edistance

Arguments: source string and target string.

Returns: scalar containing int that represents the edit distance between the two argument.

Wrapper function to take the edit distance between a source and target string using L<XS> algorithm implementation.

	use Text::Levenshtein::Damerau::XS qw/xs_edistance/;
	print xs_edistance('Neil','Niel');
	# prints 1

=over 4

=item * L<Text::Levenshtein::Damerau>

=item * L<Text::Levenshtein::Damerau::PP>

=back

=head1 BUGS

Please report bugs to:

L<https://rt.cpan.org/Public/Dist/Display.html?Name=Text-Levenshtein-Damerau-XS>

=head1 AUTHOR

Nick Logan ugexe <F<ug@skunkds.com>>

=head1 LICENSE AND COPYRIGHT

This library is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=cut
