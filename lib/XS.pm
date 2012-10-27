package Text::Levenshtein::Damerau::XS;
use utf8;

require Exporter;
*import = \&Exporter::import;
require DynaLoader;

$Text::Levenshtein::Damerau::XS::VERSION = '0.12';

DynaLoader::bootstrap Text::Levenshtein::Damerau::XS $Text::Levenshtein::Damerau::XS::VERSION;

@Text::Levenshtein::Damerau::XS::EXPORT = ();
@Text::Levenshtein::Damerau::XS::EXPORT_OK = qw/xs_edistance/);

sub xs_edistance {

    # Wrapper for XS converted inline_c_edistance function
    my $str1 = shift;
    my $str2 = shift;
    my @arr1 = unpack 'U*', $str1;
    my @arr2 = unpack 'U*', $str2;

    return Text::Levenshtein::Damerau::XS::raw_xs_edistance( \@arr1, \@arr2 );
}

sub dl_load_flags {0} 

1;

__END__

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
	use Text::Levenshtein::Damerau::InlineC qw/xs_distance/;
	use warnings;
	use strict;

	print xs_edistance('Neil','Niel');
	# prints 1

=head1 DESCRIPTION

Returns the true Damerau Levenshtein edit distance of strings with adjacent transpositions. L<XS> implementation.

=head1 METHODS

=head1 EXPORTABLE METHODS

=head2 xs_edistance

Arguments: source string and target string.

Returns: scalar containing int that represents the edit distance between the two argument.

Wrapper function to take the edit distance between a source and target string using L<XS> algorithm implementation.

	use Text::Levenshtein::Damerau::XS qw/xs_edistance/;
	print c_edistance('Neil','Niel');
	# prints 1

=over 4

=item * L<Text::Levenshtein::Damerau>

=item * L<Text::Levenshtein::Damerau::PP>

=back

=head1 BUGS

Please report bugs to:

L<https://rt.cpan.org/Public/Dist/Display.html?Name=Text-Levenshtein-Damerau-XS>

=head1 AUTHOR

ugexe <F<ug@skunkds.com>>

=head1 LICENSE AND COPYRIGHT

This library is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=cut