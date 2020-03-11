#!/usr/bin/env perl
use strict;
use warnings;

use Digest::MD5;
use MIME::Base64;

my $plain_text=$ARGV[0];
chomp($plain_text);

my $ctx=Digest::MD5->new;
$ctx->add($plain_text);
print '{MD5}' . encode_base64($ctx->digest,'') . "\n";

