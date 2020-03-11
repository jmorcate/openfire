#!/usr/bin/perl
use warnings;
use strict;

use Digest::SHA;
use Crypt::Blowfish;
use Crypt::CBC;
use MIME::Base64;

sub stuffPlainText {
    # Data to encrypt. Stuffing with \0 chars.
    my $plain_text=$_[0];
    my $buf="";
    for (1..length($plain_text)){
        my $my_char=substr($plain_text,$_-1, 1);
        $buf=$buf."\0".$my_char;
    }
    my $rem = (2*length($plain_text))%8;
    my $padValue=8;
    if ($rem != 0 ) {
        $padValue=8-$rem;
    } 
    for (1..$padValue){
        $buf=$buf.chr($padValue);
    }
    return $buf;
}

# Dealing with the key.
my $sha1 = Digest::SHA->new('sha1'); 
$sha1->add("Blowfish-CBC");
my $key=pack("H*", $sha1->hexdigest);

# Create the Blowfish encryptor.
my $blowfish = new Crypt::Blowfish($key);

# Prepare the CBC mode to cipher.
my $iv = Crypt::CBC->random_bytes(8);

my $cipher = Crypt::CBC->new(
    -cipher => $blowfish,
    -blocksize => 8,
    -iv => $iv,
    -header => "none",
    -padding => 'standard'
);

# Open the file.
my $file_name=$ARGV[0];
open(my $fh, ">>", $ARGV[0]) or die "Could not openfile.";
say $fh "INSERT INTO ofproperty (name, propvalue, encrypted, iv)";
say $fh "VALUES";

# Encrypt the LDAP Admin DN
my $buf = stuffPlainText($ARGV[1]);

# Cypher now!
my $cipher_text=$cipher->encrypt($buf);

# print the cipher text as a Hexadecimal string
my $result=substr(unpack("H*",$iv).unpack("H*",$cipher_text), 0, length($buf)*2+16);

chomp(my $iv_16 =  encode_base64(Crypt::CBC->random_bytes(16)));
say $fh "   ('ldap.adminDN', '". $result."', 1,'". $iv_16."'),";

# Encrypt the LDAP Admin password
$buf = stuffPlainText($ARGV[2]);

# Cypher now!
$cipher_text=$cipher->encrypt($buf);

# print the cipher text as a Hexadecimal string
$result=substr(unpack("H*",$iv).unpack("H*",$cipher_text), 0, length($buf)*2+16);

chomp($iv_16 =  encode_base64(Crypt::CBC->random_bytes(16)));
say $fh "   ('ldap.adminPassword', '". $result."', 1,'". $iv_16."');";

close $fh;