use strict;
use Test;
BEGIN{plan test => 1 };
use Config::ParamValueReader qw(ReadConfig);
ok(1);

my %Config = ();
ReadConfig("test.cfg",\%Config);
foreach my $I ('Param', 'Param2')
{
    print("\n$I: \n");
    foreach my $J (@{$Config{$I}})
    {
        print("$J\n");
    }
    print("\n----\n");
}

ok($Config{'Param'}->[0], 'Value');
ok($Config{'Param2'}->[0], 'Value2');
ok($Config{'Param2'}->[1], 'Value3');
ok($Config{'Param2'}->[2], 'Value4');
ok($Config{'Param2'}->[3], 'Value5');
ok($Config{'Param2'}->[4], 'Value6');