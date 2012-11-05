
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  "build_requires" => {
    "Module::Build" => "0.3601",
    "Test::More" => 0
  },
  "configure_requires" => {
    "ExtUtils::MakeMaker" => "6.30",
    "Module::Build" => "0.3601"
  },
  "dist_abstract" => "Reduces the presence of URLs using http://waa.ai",
  "dist_author" => [
    "Kovensky <diogomfranco\@gmail.com>"
  ],
  "dist_name" => "WWW-Shorten-Akari",
  "dist_version" => "v1.0.0",
  "license" => "open_source",
  "module_name" => "WWW::Shorten::Akari",
  "recommends" => {},
  "recursive_test_files" => 1,
  "requires" => {
    "Carp" => 0,
    "Encode" => 0,
    "Exporter" => 0,
    "Scalar::Util" => 0,
    "WWW::Shorten::generic" => 0,
    "constant" => 0,
    "parent" => 0,
    "perl" => "v5.8.0",
    "strict" => 0,
    "utf8" => 0,
    "warnings" => 0
  },
  "script_files" => []
);


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
