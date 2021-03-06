requires "Dancer2" => ">= 0.201000";
requires "Net::Twitter" => ">= 4.01020";
requires 'Plack' => '>= 1.0000';

recommends "YAML"             => "0";
recommends "URL::Encode::XS"  => "0";
recommends "CGI::Deurl::XS"   => "0";
recommends "HTTP::Parser::XS" => "0";

on "test" => sub {
    requires "Test::More"            => "0";
    requires "HTTP::Request::Common" => "0";
};
