use strict;
use warnings;
package PX;
use Pod::Simple::XHTML 3.13;
use base 'Pod::Simple::XHTML';

sub resolve_pod_page_link {
  my ($self, $to, $section) = @_;

  return $self->SUPER::resolve_pod_page_link($to, $section) if $to !~ s/^\@//;

  return "$to.html";
}

1;
