use lib ".";
use BChain;

my $a = BChain.new;
$a.create-block([1,2,3]);

say $a;

#say $a.get-block: get

say $a.validate-chain
