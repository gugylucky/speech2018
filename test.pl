#!/usr/bin/perl

use File::Basename;

$grammar = 'def/grammar.4';
$wordnet = 'def/wdnet';
$dictionary = 'def/dict.2';
$hmmlist = 'model/hmmlist.2';
$testlist = 'data/test/testlist.2';
$hmm_model_name = 'model/hmm5/*';
$config_file = 'config/test.config';

# HParse grammarnya dulu
$command = "HParse -T 1 $grammar $wordnet";
print $command;
system($command);

# Decoding
my @files = glob($hmm_model_name);
$hmmsdef = '';
foreach (@files){
	$name = basename($_);
	$hmmsdef .= " -H $_";
}
$command = "HVite -T 1 -S $testlist $hmmsdef -C $config_file -i rec.mlf -w $wordnet $dictionary $hmmlist";
print $command;
system($command);

# Evaluating
$labellist = 'def/labellist';
$command = "HResults -T 1 -e ??? sil -I ref.mlf $labellist rec.mlf > results";
print $command . "\n";
system($command);
system("cat results");