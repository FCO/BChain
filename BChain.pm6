use BChain::Block;
use BChain::Trie;
use BChain::Sha1;
unit class BChain;
has BChain::Block   @.blocks;
has BChain::Trie    $!cache = Trie.new;

method TWEAK(:$timestamp = now, :$phash = "0" x 40, :$data = Nil) {
    my \genesis = BChain::Block.new: :0index, :$timestamp, :$phash, :$data;
    $!cache.add: genesis.hash, genesis;
    @!blocks.push: genesis
}

method create-block($data) {
    my \new-block = BChain::Block.new: :index(+@!blocks), :phash(@!blocks.tail.hash), :parent(@!blocks.tail), :$data;
    $!cache.add: new-block.hash, new-block;
    @!blocks.push: new-block
}

method last-block { @!blocks.tail }

method validate-chain { self.last-block.validate-chain }

multi method get-block(BChain::Sha1 $hash) {
    $!cache.get: $hash
}

multi method get-block(UInt $index) {
    @!blocks[$index]
}
