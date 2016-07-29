package SamRaymer::TwitterService;
use strict;
use warnings;

use Dancer2;
use Net::Twitter;
use Data::Dumper;

use Net::Twitter;
use Scalar::Util 'blessed';

use Exporter qw(import);
 
our @EXPORT_OK = qw(get_twitter get_friend_intersection_by_handles get_recent_statuses_by_handle);
 
# get_friend_intersection_by_handle("TwitterName1", "TwitterName2")
# returns array of twitter ID numbers
sub get_friend_intersection_by_handles {
    my $twitter = $_[1];

    my $screen_name1 = $_[2];
    my $screen_name2 = $_[3];

    info 'Calling friends_ids for ' . 
        $screen_name1 .
        ' and ' . 
        $screen_name2;
    my @common_list = ();
        
    my $res1 = $twitter->friends_ids({
                screen_name => $screen_name1
            });
    my $res2 = $twitter->friends_ids({
                screen_name => $screen_name2
            });

    my %count = ();

    my $list1 = $res1->{ids};
    my $list2 = $res2->{ids};
    foreach my $user ( @$list1, @$list2 ) {
        $count{$user}++;
    }
    
    foreach my $element (keys %count) {
        if ($count{$element} > 1) {
            push @common_list, $element;
        }
    }

    info 'Found ' .
        ($#common_list + 1) . ' friends_ids for ' . 
        $screen_name1 .
        ' and ' . 
        $screen_name2;

    return \@common_list;
}

sub get_recent_statuses_by_handle {
    my $twitter = $_[1];
    my $tweets;

    my $name = $_[2];

    info 'Calling get_recent_statuses_by_handle for ' . 
        $name;
    $tweets = $twitter->user_timeline({ 
        screen_name => $name, 
        count => config->{'recent_tweet_count'}
    });
    return $tweets;
}

sub get_user_array_from_id_array {
    my @users = ();

    shift @_; # remove sub name
    my $twitter = shift @_; 
    my @ids = @_;
    info 'Calling lookup_users for ' . 
            ($#ids + 1) . ' user ids';

    while ($#ids > 0) {
        my @chunk = splice @ids, 0, 100;
        push @users, $twitter
            ->lookup_users({
                user_id => join( ',', @chunk)
            });
    }

    return \@users;
}

sub get_twitter {
    my $nt = Net::Twitter->new(
        traits   => [qw/API::RESTv1_1/, 'OAuth'],

        consumer_key        => @ENV{TWITTER_CONSUMER_KEY},
        consumer_secret     => @ENV{TWITTER_CONSUMER_SECRET},
        access_token        => @ENV{TWITTER_TOKEN},
        access_token_secret => @ENV{TWITTER_TOKEN_SECRET},
    );
    
}

1;
