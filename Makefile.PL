

use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME         => 'Spreadsheet::WriteExcel::Simple::Tabs',
    VERSION_FROM => 'lib/Spreadsheet/WriteExcel/Simple/Tabs.pm', # finds \$VERSION
    AUTHOR       => 'Michael R. Davis (domain=>michaelrdavis,tld=>com,account=>perl)',
    ABSTRACT     => 'Simple Interface to the Spreadsheet::WriteExcel Package',
    PREREQ_PM    => {
                     'Test::Simple' => 0.44,
                    },
);
