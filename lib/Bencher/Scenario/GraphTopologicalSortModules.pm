package Bencher::Scenario::GraphTopologicalSortModules;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

our $scenario = {
    summary => 'Benchmark graph topological sort modules',
    modules => {
    },
    participants => [
        {
            module => 'Sort::Topological',
            function => 'toposort',
            code_template  => 'my $graph = <graph>; Sort::Topological::toposort(sub { @{ $graph->{$_[0]} || [] } }, <unsorted>)',
            result_is_list => 1,
        },
        {
            fcall_template => 'Data::Graph::Util::toposort(<graph>, <unsorted>)',
            result_is_list => 1,
        },
        {
            module => 'Algorithm::Dependency',
            helper_modules => ['Algorithm::Dependency::Source::HoA'],
            code_template => 'my $deps = Algorithm::Dependency::Source::HoA->new(<graph>); my $dep = Algorithm::Dependency->new(source=>$deps); $dep->schedule_all',
        },
    ],

    datasets => [
        {
            name => 'g1',
            args => {
                graph => {
                    'a' => [ 'b', 'c' ],
                    'c' => [ 'x' ],
                    'b' => [ 'c', 'x' ],
                    'x' => [ 'y' ],
                    'y' => [ 'z' ],
                    'z' => [ ],
                },
                unsorted => ['z', 'a', 'x', 'c', 'b', 'y'],
            },
            result => ['a', 'b', 'c', 'x', 'y', 'z'],
        },
        # hangs Sort::Topological
        {
            name => 'cyclic1',
            args => {
                graph => {a=>["a"]},
                unsorted => ['a'],
            },
            include_by_default => 0,
        },
        {
            name => 'cyclic2',
            args => {
                graph => {a=>["b"], b=>["a"]},
                unsorted => ['b', 'a'],
            },
            include_by_default => 0,
        },
        {
            name => 'cyclic3',
            args => {
                graph => {a=>["b"], b=>["c"], c=>["a"]},
                unsorted => ['a', 'c', 'b'],
            },
            include_by_default => 0,
        },
        {
            name => 'cyclic4',
            args => {
                graph => {a=>["b","c"], c=>["a","b"], d=>["e"], e=>["f","g","h","a"]},
                unsorted => ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'],
            },
            include_by_default => 0,
        },
    ],
};

1;
# ABSTRACT:
