package SamRaymer::TwitterStuff;
use strict;
use warnings;
use Data::Dumper;

use Dancer2;
use SamRaymer::TwitterService;

use Scalar::Util 'blessed';

our $VERSION = '0.1';

get '/statuses/recent/:name' => sub {
    my $name = params->{name};
    my $tw = SamRaymer::TwitterService->get_twitter();
    my $body;
    eval {
        $body = {
            'data' => SamRaymer::TwitterService
                ->get_recent_statuses_by_handle($tw, $name),
            'status' => 200 
        };
    };

    if ( my $err = $@ ) {
        die $@ unless blessed $err && $err->isa('Net::Twitter::Error');
        if ($err->code == 404) {
            status(404);
            warn "Recent statuses for " . $name . " not found";
            return;
        }
        warn "HTTP Response Code: ", $err->code, "\n",
            "HTTP Message......: ", $err->message, "\n",
            "Twitter error.....: ", $err->error, "\n";
        die $@;
    }
    return $body;
};

get '/common-follows' => sub {
    my $screen_name1 = params->{'name1'};
    my $screen_name2 = params->{'name2'};
    my $tw = SamRaymer::TwitterService->get_twitter();

    # validation for inputs

    if (!defined($screen_name1) ||
            $screen_name1 eq '') {
        status(400);
        return {'status' => 400,
            'data' => "Bad request: need name 1" };
    }
    if (!defined($screen_name2) ||
            $screen_name2 eq '') {
        status(400);
        return {'status' => 400,
            'data' => "Bad request: need name 2" };
    };

    my $ids, my $body;
    eval {
        $ids = SamRaymer::TwitterService
                        ->get_friend_intersection_by_handles(
                            $tw,
                            $screen_name1,
                            $screen_name2
                        );
                            
        $body = {
            'data' => SamRaymer::TwitterService
                ->get_user_array_from_id_array( $tw, @$ids ),
            'status' => 200
        };
    };

    if ( my $err = $@ ) {
        die $@ unless blessed $err && $err->isa('Net::Twitter::Error');

        warn "HTTP Response Code: ", $err->code, "\n",
            "HTTP Message......: ", $err->message, "\n",
            "Twitter error.....: ", $err->error, "\n";
        die $@;
    }
    return $body;
};

true;
