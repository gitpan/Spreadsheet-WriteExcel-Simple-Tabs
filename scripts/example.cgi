#!/usr/bin/perl
use strict;
use warnings;
use blib;
use Spreadsheet::WriteExcel::Simple::Tabs;
my $ss=Spreadsheet::WriteExcel::Simple::Tabs->new;
my @data=(["Heading1", "Heading2"], ["data1", "data2"], ["data3", "data4"]);
$ss->add(Tab1=>\@data, Tab2=>\@data);
print $ss->header(filename=>"filename.xls"), $ss->content;
