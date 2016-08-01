use strict;
use warnings;

use SamRaymer::TwitterStuff;
use Test::More tests => 6;
use Plack::Test;
use HTTP::Request::Common;

my $app = SamRaymer::TwitterStuff->to_app;
is( ref $app, 'CODE', 'Got app' );

my $test = Plack::Test->create($app);
my $res  = $test->request( GET '/statuses/recent/SamRaymer' );
ok( $res->is_success, '[GET /statuses/recent/SamRaymer] successful' );

$res  = $test->request( GET '/common-follows' );
ok( !$res->is_success, '[GET /common-follows] unsuccessful without params' );

$res  = $test->request( GET '/common-follows?name1=&name2=' );
ok( !$res->is_success, '[GET /common-follows] unsuccessful with empty params' );

$res  = $test->request( GET '/common-follows?name1=hello' );
ok( !$res->is_success, '[GET /common-follows] unsuccessful with only one param' );

$res  = $test->request( GET '/common-follows?name1=nbc&name2=cbs' );
ok( $res->is_success, '[GET /common-follows] successful' );

