#!/usr/bin/perl

use File::Basename;
use File::Path qw( make_path );


$trainlist = 'data/train/trainlist';
$config_file = 'config/train.config';
$proto_dir_search = 'model/proto/*';
$proto_dir = 'model/proto/';
$iteration = 3;

# HInit
$directory = 'model/hmm0';
make_path $directory or die "Failed to create path: $directory" if !-d $directory;

my @files = glob($proto_dir_search);
foreach (@files){
	$name = basename($_);
	$command = "HInit -D -T 1 -C $config_file -S $trainlist -M $directory -H " . $proto_dir . $name . " -l $name -L data/train/lab $name";
	print $command . "\n";
	system($command);
}

# HCompV
$directory = 'model/hmm0flat';
make_path $directory or die "Failed to create path: $directory" if !-d $directory;

my @files = glob($proto_dir_search);
foreach (@files){
  $name = basename($_);
	$command = "HCompV -D -T 1 -C $config_file -S $trainlist -M $directory -H " . $proto_dir . $name . " -f 0.01 $name";
	print $command . "\n";
	system($command);
}

# HRest
my @files = glob($proto_dir_search);
for ($i = 1; $i <= $iteration; $i = $i + 1){
	$directory = 'model/hmm' . $i;
	make_path $directory or die "Failed to create path: $directory" if !-d $directory;
	foreach (@files){
		$j = $i-1;
		$name = basename($_);
		$previous_directory = 'model/hmm'. $j . '/';
		$command = "HRest -D -T 1 -C $config_file -S $trainlist -M $directory -H " . $previous_directory . $name . " -l $name -L data/train/lab $name";
		print $command . "\n";
		system($command);
	}
}