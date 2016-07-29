use strict;
use warnings;
use Dancer2;

use Test::More  tests => 4;
use Plack::Test;

use SamRaymer::TwitterService;

our $recent_count = config->{'recent_tweet_count'};
my $mock_twitter = eval {
    package MockTwitter;
    use Data::Dumper;
    sub new {
        my $type = shift;
        my $this = { currentIndex=>0 };
        bless $this, $type;
    }

    sub friends_ids {
        my $args = $_[1];
        Test::More::ok($args->{screen_name} ne '');

        if ($args->{screen_name} eq 'dork'){
            return {ids => ['3', '4', '5']};
        }

        return {ids => ['1', '2', '3', '4']};
    }

    sub user_timeline {
        my $args = $_[1];
        Test::More::ok ($args->{count} == $recent_count);
        Test::More::ok ($args->{screen_name} ne '');
        return ['i am eating food',
                'i am using SEO'];
    }

    sub lookup_users {
        my $args = $_[1];
        Test::More::ok ($args->{user_id} eq '3,4');
        return { user1 => "totally cool",
                user2 => "also very cool"}
    }
    __PACKAGE__;
}->new();

SamRaymer::TwitterService->get_recent_statuses_by_handle($mock_twitter, 'bobby');
SamRaymer::TwitterService->get_friend_intersection_by_handles($mock_twitter, 'bobby', 'dork');

