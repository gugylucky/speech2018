#!/usr/bin/perl

use File::Basename;
use File::Path qw( make_path );

my $type = $ARGV[0];

$trainlist = 'data/train/trainlist';
$config_file = 'config/train.config';
$hmmlist = 'model/hmmlist';
$proto_dir = 'model/proto/';
$proto_name = '6states';
$iteration = 5;

# HInit or HCompV
$directory = 'model/hmm0';
make_path $directory or die "Failed to create path: $directory" if !-d $directory;

open my $info, $hmmlist or die "Could not open $file: $!";
while( my $label = <$info>) {
	chomp $label;
	if ($type eq 'hinit') {
		$command = "HInit -D -T 1 -C $config_file -S $trainlist -M $directory -H " . $proto_dir . $proto_name . " -o $label -l $label -L data/train/lab proto";
	} else {
		$command = "HCompV -D -T 1 -C $config_file -S $trainlist -M $directory -H " . $proto_dir . $proto_name . " -o $label -f 0.01 -l $label -L data/train/lab proto";
	}
	print $command . "\n";
	system($command);
	system("mv " . $directory . '/' . $proto_name . " " . $directory . '/' . $label);
}
close $info;

# HRest
open my $info, $hmmlist or die "Could not open $file: $!";
for ($i = 1; $i <= $iteration; $i = $i + 1){
	$directory = 'model/hmm' . $i;
	make_path $directory or die "Failed to create path: $directory" if !-d $directory;

	while( my $label = <$info>) {
		$j = $i-1;
		chomp $label;
		$previous_directory = 'model/hmm'. $j . '/';
		$command = "HRest -D -T 1 -C $config_file -S $trainlist -M $directory -H " . $previous_directory . $label . " -l $label -L data/train/lab $label";
		print $command . "\n";
		system($command);
	}
	close $info;
}