package Spreadsheet::WriteExcel::Simple::Tabs;
use strict;
use warnings;
use IO::Scalar qw{};
use Spreadsheet::WriteExcel qw{};

our $VERSION='0.01';

=head1 NAME

Spreadsheet::WriteExcel::Simple::Tabs - Simple Interface to the Spreadsheet::WriteExcel Package

=head1 SYNOPSIS

  use Spreadsheet::WriteExcel::Simple::Tabs;
  my $ss=Spreadsheet::WriteExcel::Simple::Tabs->new;
  my @data=(["Heading1", "Heading2"], ["data1", "data2"], ["data3", "data4"]);
  $ss->add(Tab1=>\@data, Tab2=>\@data);
  print $ss->header(filename=>"filename.xls"), $ss->content;

=head1 DESCRIPTION

This is a simple wrapper around Spreadsheet::WriteExcel that creates tabs for data.  It is ment to be simple not full featured.  I use this package to export data from the L<DBIx::Array> sqlarrayarrayname method which is an array of array references where the first array is the column headings.

=head1 USAGE

=head1 CONSTRUCTOR

=head2 new

=cut

sub new {
  my $this = shift();
  my $class = ref($this) || $this;
  my $self = {};
  bless $self, $class;
  $self->initialize(@_);
  return $self;
}

sub initialize {
  my $self=shift;
  %$self=@_;
}

=head2 book

Returns the workbook object

=cut

sub book {
  my $self=shift;
  #Thanks to Tony Bowden for the IO::Scalar stuff
  unless (defined($self->{"book"})) {
    $self->{"book"}=Spreadsheet::WriteExcel->new(
                      IO::Scalar->new_tie(\($self->{"content"}))
                    );
  }
  return $self->{"book"};
}

=head2 add

  $ss->add("Tab Name", \@data);
  $ss->add(Tab1=>\@data, Tab2=>\@data);

=cut

sub add {
  my $self=shift;
  die("Error: method requires even number of arguments") if scalar(@_) % 2;
  while (@_ > 0) {
    my $tab=shift;
    my $data=shift;
    die(sprintf("Error: Expecting array reference but got %s", ref($data)))
      unless ref($data) eq "ARRAY";
      $self->add1($tab=>$data);
  }
  return $self;
}

sub add1 {
  my $self=shift;
  my $tab=shift;
  my $data=shift;
  my $sheet=$self->book->add_worksheet($tab);
  $self->add_data($sheet, $data);
  return $sheet;
}

sub add_data {
  my $self=shift;
  my $worksheet=shift;
  my $data=shift;
  my $header=shift(@$data);
  my %border=(border=>1, border_color=>"gray", num_format=>'@');
  my %font=(bg_color=>"silver", bold=>1);
  $worksheet->write_col(0,0,[$header], $self->book->add_format(%font, %border));
  $worksheet->write_col(1,0, $data,    $self->book->add_format(%border));

  #Auto resize columns
  foreach my $col (0 .. scalar(@$header) - 1) {
    my $width=(sort {$a<=>$b} map {length($_->[$col]||'')} $header, @$data)[-1];
    $width = 8 if $width < 8;
    $worksheet->set_column($col, $col, $width);
  }
  return $self;
}

=head2 header

Returns a header appropriate for a web application

  Content-type: application/vnd.ms-excel
  Content-Disposition: attachment; filename=filename.xls

  $ss->header                                           #embedded in browser
  $ss->header(filename=>"filename.xls")                 #download prompt
  $ss->header(content_type=>"application/vnd.ms-excel") #default content type

=cut

sub header {
  my $self=shift;
  my %data=@_;
     $data{"content_type"}="application/vnd.ms-excel"
       unless defined $data{"content_type"};
  my $header=sprintf("Content-type: %s\n", $data{"content_type"});
     $header.=sprintf("Content-Disposition: attachment; filename=%s\n",
                         $data{"filename"}) if defined $data{"filename"};
     $header.="\n";
  return $header;
}

=head2 content

  print $ss->content

This returns the binary content of the spreadsheet.

=cut

sub content {
  my $self = shift;
  $self->book->close;
  return $self->{"content"};
}


=head1 BUGS

Log bugs on CPAN.

=head1 SUPPORT

Try the Author.

=head1 AUTHOR

    Michael R. Davis
    CPAN ID: MRDVT
    STOP, LLC
    domain=>michaelrdavis,tld=>com,account=>perl
    http://www.stopllc.com/

=head1 COPYRIGHT

Copyright (c) 2009 Michael R. Davis
Copyright (C) 2001-2005 Tony Bowden (IO::Scalar portion used here "under the same terms as Perl itself")

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

=head1 SEE ALSO

L<Spreadsheet::WriteExcel::Simple>, L<DBIx::Array sqlarrayarrayname>

=cut

1;
