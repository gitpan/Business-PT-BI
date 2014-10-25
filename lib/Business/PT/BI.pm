package Business::PT::BI;

use warnings;
use strict;

=head1 NAME

Business::PT::BI - Validate Portuguese BI (Bilhete de Identidade)

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

require Exporter;

our @ISA = qw(Exporter);

our @EXPORT = qw(valid_bi);

=head1 SYNOPSIS

    use Business::PT::BI;

    if ( valid_bi($bi, $control_number) ) {
      # ...
    }

=head1 FUNCTIONS

=head2 valid_bi

Validates Portuguese BI's.

A Portuguese BI number is comprised by eight digits. Between that
number and the "issue" box, the card also has a small box with a
single digit. That's the control digit. In order to validate a
Portuguese BI, you have to provide C<valid_bi> with the BI number and
the control digit.

  valid_bi( $bi, $control_number );

Validation is done as follows:

 1) BI is matched with /^\d{8}$/ (eigth consecutive digits with
    nothing more)
 2) First digit is multiplied by 9, second by 8, third by 7, fourth by
    6, fifth by 5, sixth by 4, seventh by 3, eighth by 2
 3) All the results of the multiplication are summed
 4) Modulo of the sum by 11 is found
 5) Complement of the sum by 11 is found
 6) Control digit is compared to said complement

Example for BI 12345678, with control digit 9:

 1) BI is matched with /^\d{8}/, test passes
 2) Multiplication: 1*9, 2*8, 3*7, 4*6, 5*5, 6*4, 7*3, 8*2
 3) Sum: 156
 4) 156 % 11 = 2
 5) 11 - 2 = 9
 6) 9 == 9, test passes

When the complement (the result of step 5) is greater than 9, the
number is assumed to be 0.

=cut

sub valid_bi {
  my $bi = shift      or return undef;
     $bi =~ /^\d{8}$/ or return undef;

  my $control = shift;
  defined $control or return undef;

  my $sum;
  for (2..9) {
    $sum += $_ * chop $bi;
  }

  my $expected = 11 - $sum % 11;
  if ($expected > 9) { $expected = 0 }

  return $control == $expected;
}

=head1 AUTHOR

Jose Castro, C<< <cog at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-business-pt-bi at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Business-PT-BI>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Business::PT::BI

You can also look for information at:

=over 4

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Business-PT-BI>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Business-PT-BI>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Business-PT-BI>

=item * Search CPAN

L<http://search.cpan.org/dist/Business-PT-BI>

=back

=head1 COPYRIGHT & LICENSE

Copyright 2005 Jose Castro, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of Business::PT::BI
