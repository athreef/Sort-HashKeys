use strict;
use warnings;
use Benchmark qw/cmpthese timethese/;
use Sort::HashKeys;

my (@perl, @xs, %hash, %hash1, %hash2);

my @chars = ("A".."Z", "a".."z", "0".."9");
for (1..1000) {
    my $string;
    $string .= $chars[rand @chars] for 1..6;

    $hash{$string} = $_;
}

# Different data sets to avoid cache effects
%hash1 = %hash;
%hash2 = %hash;

cmpthese(-10, {
        xs_sort    => sub { @xs   = Sort::HashKeys::sort(%hash1) },
        perl_sort  => sub { @perl = map { ($_, $hash2{$_}) } sort keys %hash2 },
});

@perl == @xs or die "Functions didn't return the same output";
for (0..$#perl) {
    $perl[$_] eq $xs[$_] or die "Functions didn't return the same output";
}

