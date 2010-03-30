use strict;
use warnings;
package Pod::CYOA::XHTML;
use Pod::Simple::XHTML 3.13;
use base 'Pod::Simple::XHTML';
# ABSTRACT: Pod::Simple::XHTML subclass for CYOA

sub resolve_pod_page_link {
  my ($self, $to, $section) = @_;

  return $self->SUPER::resolve_pod_page_link($to, $section) if $to !~ s/^\@//;

  return "$to.html";
}

1;
