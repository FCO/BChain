unit class BChain::Trie;
has %!children;
has $!value;

multi method add([], $data) {
    die "Value already set" with $!value;
    $!value = $data
}

multi method add([$first, *@arr], $data) {
    (%!children{$first} //= ::?CLASS.new).add: @arr, $data
}

multi method add(Str $string, $data = $string) {
    self.add: $string.comb, $data
}

multi method get {
    .return with $!value;
    die "deu ruim" if %!children.keys.elems != 1;
    %!children.values.head.get
}

multi method get([]) { self.get }

multi method get([$first, *@arr]) {
    die "hash does not exist" unless %!children{$first}:exists;
    %!children{$first}.get: @arr
}

multi method get(Str $string) {
    self.get: $string.comb
}
