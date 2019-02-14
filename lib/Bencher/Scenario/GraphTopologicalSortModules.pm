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
            name => 'empty',
            args => { graph => {}, unsorted => [] },
            result => [],
            include_by_default => 0, # croaks Algorithm::Dependency
        },

        {
            name => '2nodes-1edge',
            args => {
                graph => {
                    a => ['b'],
                    b => [], # Algorithm::Dependency requires all nodes to be specified
                },
                unsorted => ['b','a'],
            },
            result => ['a', 'b'],
        },

        {
            name => '6nodes-7edges',
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

        {
            name => '10nodes-35edges',
            args => {
                graph => {
                    (map { sprintf("%02d",$_) => [grep {$_<=10} sprintf("%02d", $_+1), sprintf("%02d", $_+2), sprintf("%02d", $_+3), sprintf("%02d", $_+4), sprintf("%02d", $_+5)] } 1..10)
                },
                unsorted => [reverse(map {sprintf("%02d", $_)} 1..10)],
            },
            result => [map {sprintf("%02d", $_)} 1..10],
        },

        {
            # Algorithm::Dependency gives different results when we use 1..100 instead of 001 .. 100
            name => '100nodes-100edges',
            args => {
                graph => {
                    (map { (sprintf("%03d",$_) => [$_==1 ? ("002","003") : $_==100 ? () : (sprintf("%03d", $_+1))]) } 1..100)
                },
                unsorted => [reverse(map {sprintf("%03d", $_)} 1..100)],
            },
            result => [map {sprintf("%03d", $_)} 1..100],
        },

        {
            name => '100nodes-500edges',
            args => {
                graph => {
                    (map { (sprintf("%03d",$_) => [$_==1 ? ("002".."021") : (grep {$_<=100} sprintf("%03d", $_+1), sprintf("%03d", $_+2), sprintf("%03d", $_+3), sprintf("%03d", $_+4), sprintf("%03d", $_+5))]) } 1..100)
                },
                unsorted => [reverse(map {sprintf("%03d", $_)} 1..100)],
            },
            result => [map {sprintf("%03d", $_)} 1..100],
            # Sort::Topological eats too much memory
            include_by_default => 0,
        },

        # cyclic datasets not included by default because they hang
        # Sort::Topological
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
