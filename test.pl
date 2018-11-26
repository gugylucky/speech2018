#!/usr/bin/perl

use File::Basename;

$grammar = 'def/grammar.2';
$wordnet = 'def/wdnet';
$dictionary = 'def/dict';
$hmmlist = 'model/hmmlist';
$testlist = 'data/test/testlist';
$hmm_model_name = 'model/hmm10/*';
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