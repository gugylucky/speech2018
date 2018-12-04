#!/usr/bin/perl

use File::Basename;

$grammar = 'def/grammar.4';
$wordnet = 'def/wdnet';
$dictionary = 'def/dict.1';
$hmmlist = 'model/hmmlist.1';
$hmm_model_name = 'model/hmm5/*';
$config_file = 'config/directin.config';

# Decoding
my @files = glob($hmm_model_name);
$hmmsdef = '';
foreach (@files){
	$name = basename($_);
	$hmmsdef .= " -H $_";
}
$command = "HVite -T 1 -C $config_file -g $hmmsdef -w $wordnet $dictionary $hmmlist";
print $command;
system($command);
