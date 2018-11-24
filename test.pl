#!/usr/bin/perl

use File::Basename;

$wordnet = 'def/wdnet';
$dictionary = 'def/dict';
$hmmlist = 'model/hmmlist';
$testlist = 'data/test/testlist';
$hmm_model_name = 'model/hmm3/*';
$config_file = 'config/test.config';

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