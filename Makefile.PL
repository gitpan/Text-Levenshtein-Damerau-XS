use ExtUtils::MakeMaker;

my $pm = 'lib/Text/Levenshtein/Damerau/XS.pm';

my %options = %{
{
  'TYPEMAPS' => [],
  'NAME' => 'Text::Levenshtein::Damerau::XS',
  'INC' => '',
  'VERSION_FROM' => $pm,
  'LICENSE' => 'perl',
}
};
WriteMakefile(%options);

# Remove the Makefile dependency. Causes problems on a few systems.
sub MY::makefile { '' }
