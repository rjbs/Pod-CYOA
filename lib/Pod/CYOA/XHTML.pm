use strict;
use warnings;
package Pod::CYOA::XHTML;
use Pod::Simple::XHTML 3.13;
use base 'Pod::Simple::XHTML';
# ABSTRACT: private Pod::Simple::XHTML subclass for CYOA

=head1 OVERVIEW

Pod::CYOA::HTML is a private class whose interface should not yet be relied
upon.

It transforms Pod to HTML, with one important change: links with targets that
begin with C<@> become links to relative html documents.  In other words,
C<< LE<lt>the start page|@startE<gt> >> becomes a link to C<start.html> rather
than the "start" section of the current page.

=cut

sub resolve_pod_page_link {
  my ($self, $to, $section) = @_;

  return $self->SUPER::resolve_pod_page_link($to, $section) if $to !~ s/^\@//;

  return "$to.html";
}

1;
