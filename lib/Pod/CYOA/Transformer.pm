package Pod::CYOA::Transformer;
use Moose;
with 'Pod::Elemental::Transformer';

use Pod::Elemental::Types qw(FormatName);

has format_name => (
  is  => 'ro',
  isa => FormatName,
  default => 'cyoa',
);

sub transform_node {
  my ($self, $node) = @_;

  for my $i (reverse(0 .. $#{ $node->children })) {
    my $para = $node->children->[ $i ];
    next unless $self->__is_xformable($para);

    my @replacements = $self->_expand_cyoa( $para );
    splice @{ $node->children }, $i, 1, @replacements;
  }
}

sub __is_xformable {
  my ($self, $para) = @_;

  return unless $para->isa('Pod::Elemental::Element::Pod5::Region')
         and $para->format_name eq $self->format_name;

  confess("CYOA regions must be non-pod (=begin " . $self->format_name . ")")
    if $para->is_pod;
  
  return 1;
}

sub _expand_cyoa {
  my ($self, $para) = @_;

  my ($data, @wtf) = @{ $para->children };
  confess "more than one child of a non-Pod region!" if @wtf;

  my @replacements;

  push @replacements, Pod::Elemental::Element::Pod5::Region->new({
    is_pod      => 1,
    format_name => 'html',
    content     => '',
    children    => [
      Pod::Elemental::Element::Pod5::Data->new({ content => "<hr />" }),
    ],
  });

  push @replacements, Pod::Elemental::Element::Pod5::Command->new({
    command => 'over',
    content => 4,
  });

  my @lines = split /\n/, $data->as_pod_string;
  for my $line (@lines) {
    my ($link, $desc) = $line =~ /\A\?\s*([-a-z0-9]+)\s*\?\s*(.+)\z/;
    confess "do not understand CYOA line: $line" unless $link and $desc;

    push @replacements, Pod::Elemental::Element::Pod5::Command->new({
      command => 'item',
      content => '*',
    });

    push @replacements, Pod::Elemental::Element::Pod5::Ordinary->new({
      content => "If you'd like to L<$desc|\@$link>",
    });
  }

  push @replacements, Pod::Elemental::Element::Pod5::Command->new({
    command => 'back',
    content => '',
  });

  return @replacements;
}

1;
