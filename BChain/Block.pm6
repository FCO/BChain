use Digest::SHA1::Native;
use BChain::Sha1;

unit class BChain::Block;
has UInt        $.index       is required;
has Instant     $.timestamp = now;
has Str         $.hash;
has Str         $.phash       is required;
has Any         $.data;
has ::?CLASS    $.parent;
has UInt        $.proof;
has UInt        $.dificulty = 1;

method TWEAK(|) {
    # generate dificulty
    $!hash  = self.sha1;
    $!proof = self.prove;
}

method WHICH { "{self.^name}|{$!index}|{$!timestamp}|{$!phash}|{$!dificulty}|{$!data.perl}" }

method sha1 { sha1-hex self.WHICH }

method validate-index { self.index ~~ 0 or self.index ~~ self.parent.index + 1 }
method validate-phash { self.index ~~ 0 or self.phash ~~ self.parent.hash }
method validate-hash  { self.sha1 ~~ self.hash }
method validate-proof { self.proof-hash($.proof).ends-with: "0" x $.dificulty }

method validate {
    self.validate-index and self.validate-phash and self.validate-hash and do with self.proof {self.validate-proof} else {True}
}

method validate-chain {
    self.validate and do with self.parent { .validate-chain } else { True }
}

method proof-hash(\count) {
    sha1-hex "{do with self.parent { .proof } else { 0 } } - {self.hash} - {count}"
}

method prove {
    my Int $count;
    my BChain::Sha1 $hash;
    repeat {
        $hash = self.proof-hash: ++$count;
    } until $hash.ends-with: "0" x $.dificulty;
    $count
}
