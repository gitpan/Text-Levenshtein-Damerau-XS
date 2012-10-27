use ExtUtils::MakeMaker;
my %options = %{
{
  'TYPEMAPS' => [],
  'NAME' => 'Text::Levenshtein::Damerau::XS',
  'INC' => '',
  'VERSION' => '0.20',
  'AUTHOR' => 'ugexe',
}
};
WriteMakefile(%options);

# Remove the Makefile dependency. Causes problems on a few systems.
sub MY::makefile { '' }
