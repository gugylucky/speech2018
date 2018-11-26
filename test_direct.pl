#!/usr/bin/perl

use File::Basename;

$grammar = 'def/grammar';
$wordnet = 'def/wdnet';
$dictionary = 'def/dict';
$hmmlist = 'model/hmmlist';
$hmm_model_name = 'model/hmm3/*';
$config_file = 'config/directin.config';

# Decoding
my @files = glob($hmm_model_name);
$hmmsdef = '';
foreach (@files){
	$name = basename($_);
	$hmmsdef .= " -H $_";
}
$command = "HVite -T 1 -C $config_file -g $hmmsdef -w $wordnet $dictionary $hmmlist";
HVite -A -D -T 1 -C directin.conf -g -H hmmsdef.mmf -w net.slf dict.txt hmmlist.txt
print $command;
system($command);