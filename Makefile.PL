use inc::Module::Install; 

name          	'Text-Levenshtein-Damerau-XS';
all_from      	'lib/XS.pm';
readme_from 		'lib/XS.pm', 1;

auto_manifest;
auto_set_repository;
auto_license;

test_requires 'Test::More';
 
WriteAll();
