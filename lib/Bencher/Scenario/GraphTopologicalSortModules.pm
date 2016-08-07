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
            code_template  => 'my $graph = <graph>; Sort::Topological::toposort(sub { @{ $graph->{shift} || [] } }, <unsorted>)',
            result_is_list => 1,
        },
        {
            fcall_template => 'Data::Graph::Util::toposort(<graph>, <unsorted>)',
            result_is_list => 1,
        },
    ],

    datasets => [
        {
            name => 'g1',
            args => {
                graph => {
                    'a' => [ 'b', 'c' ],
                    'c' => [ 'x' ],
                    'b' => [ 'x' ],
                    'x' => [ 'y' ],
                    'y' => [ 'z' ],
                    'z' => [ ],
                },
                unsorted => ['z', 'a', 'x', 'c', 'b', 'y'],
            },
        },
    ],
};

1;
# ABSTRACT:
