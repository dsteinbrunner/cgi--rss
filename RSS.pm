
package CGI::RSS;

use strict;
use base 'CGI';

our $VERSION = 0.92;

# TODO: this collection of tag names is hardly "correct" or complete
our @TAGS = qw(
    rss channel item

    title link description

    language copyright managingEditor webMaster pubDate lastBuildDate category generator docs
    cloud ttl image rating textInput skipHours skipDays

    link description author category comments enclosure guid pubDate source

    date url
);

1;

sub make_tags {
    $CGI::EXPORT{$_} = 1 for @TAGS;
}

sub header {
    my $this = shift;

    &make_tags;

    return $this->SUPER::header("application/xml") . "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n\n";
}

sub begin_rss {
    my $this = shift;
    my $opts = $_[0];
       $opts = {@_} unless ref $opts;

    # NOTE: This isn't nearly as smart as CGI.pm's argument parsing... 
    # I assume I could call it, but but I'm only mortal.

    my $ver = $opts->{version} || "2.0";
    my $ret = $this->start_rss({version=>$ver});
       $ret .= $this->start_channel;
       $ret .= $this->link($opts->{link})   if exists $opts->{link};
       $ret .= $this->title($opts->{title}) if exists $opts->{title};

    return $ret;
}

sub finish_rss {
    my $this = shift;

    return $this->end_channel, $this->end_rss;
}
