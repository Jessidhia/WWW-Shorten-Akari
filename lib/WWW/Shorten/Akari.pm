use v5.8;
use strict;
use warnings;
use utf8;

package WWW::Shorten::Akari;
# ABSTRACT: Reduces the presence of URLs using http://waa.ai

=head1 SYNOPSIS

    use WWW::Shorten::Akari;

    my $presence = WWW::Shorter::Akari->new;
    my $short = $presence->reduce("http://google.com");
    my $long  = $presence->increase($short);

    $short = makeashortlink("http://google.com");
    $long  = makealonglink($short);

=head1 DESCRIPTION

Reduces the presence of URLs through the L<http://waa.ai> service.
This module has both an object interface and a function interface
as defined by L<WWW::Shorten>. This module is compatible with
L<WWW::Shorten::Simple> and, since L<http://waa.ai> always returns
the same short URL for a given long URL, may be memoized.

=cut

use base qw{WWW::Shorten::generic Exporter};
our @EXPORT = qw{makeashorterlink makealongerlink};

use constant API_URL => q{http://waa.ai/api.php};

use Carp;
use Encode qw{};

=method new

Creates a new instance of Akari.

=cut
sub new {
    my $class = shift;
    my $self = {};
    bless $self, $class;

    $self->_init(@_);
    return $self;
}

sub _init {
    my ($self) = @_;

    $self->{ua} = __PACKAGE__->ua;
    $self->{utf8} = Encode::find_encoding("UTF-8");
}

=method reduce($url)

Reduces the presence of the C<$url>. Returns the shortened URL.

On failure, or if C<$url> is false, C<carp>s and returns false.

Aliases: C<shorten>, C<short_link>

=for Pod::Coverage shorten short_link

=cut
sub reduce {
    my ($self, $url) = @_;
    unless ($url) {
        carp "No URL given";
        return;
    }

    #$url = $self->{utf8}->encode($url) if Encode::is_utf8($url);

    my $uri = URI->new(API_URL);
    $uri->query_form(url => $url);

    my $res = $self->{ua}->get($uri->as_string);

    unless ($res->is_success) {
        carp "HTTP error ". $res->status_line ." when shortening $url";
        return;
    }

    return $res->decoded_content;
}

sub shorten {
    my ($self, @args) = @_;
    return $self->reduce(@args);
}

sub short_link {
    my ($self, @args) = @_;
    return $self->reduce(@args);
}

=method increase($url)

Increases the presence of the C<$url>. Returns the original URL.

On failure, or if C<$url> is false, or if the C<$url> isn't
a shortened link from L<http://waa.ai>, C<carp>s and returns
false.

Aliases: C<lenghten>, C<long_link>, C<extract>

=for Pod::Coverage lenghten long_link extract

=cut
sub increase {
    my ($self, $url) = @_;
    unless ($url) {
        carp "No URL given";
        return;
    }

    unless ($self->_check_url($url)) {
        carp "URL $url wasn't shortened by Akari";
        return;
    }

    my $res = $self->{ua}->head($url);
    return $res->header("Location");
}

sub _check_url {
    my ($self, $url) = @_;
    return scalar $url =~ m{^http://waa\.ai/[^.]+$};
}

sub lenghten {
    my ($self, @args) = @_;
    return $self->increase(@args);
}

sub long_link {
    my ($self, @args) = @_;
    return $self->increase(@args);
}

sub extract {
    my ($self, @args) = @_;
    return $self->increase(@args);
}

my $presence = WWW::Shorten::Akari->new;

=head1 FUNCTIONS

=head2 makeashorterlink($url)

L<Makes a shorter link|http://tvtropes.org/pmwiki/pmwiki.php/Main/ExactlyWhatItSaysOnTheTin>

=cut
sub makeashorterlink($) {
    return $presence->reduce(@_);
}

=head2 makealongerlink($url)

L<The opposite of|http://tvtropes.org/pmwiki/pmwiki.php/Main/CaptainObvious>
L</makeashorterlink($url)>

=cut
sub makealongerlink($) {
    return $presence->increase(@_);
}

1;

=head1 SOURCE CODE

https://github.com/Kovensky/WWW-Shorten-Akari

=cut
