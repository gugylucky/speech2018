#!/usr/bin/perl

use File::Basename;

my $type = $ARGV[0];
if ($type == 'test') {
   print('Converting testing data...');
   $source_dir = 'data/test/mpeg/*';
   $wav_dir = 'data/test/wav/';
   $sig_dir = 'data/test/sig/';
   $config_file = 'config/wav_to_sig.config';
   $analysis_conf_file = 'config/analysis.config';
   $targetlist = 'data/test/targetlist';
} else {
   print('Converting training data...');
   $source_dir = 'data/train/mpeg/*';
   $wav_dir = 'data/train/wav/';
   $sig_dir = 'data/train/sig/';
   $config_file = 'config/wav_to_sig.config';
   $analysis_conf_file = 'config/analysis.config';
   $targetlist = 'data/train/targetlist';
}

# delete all files in wav and sig folder
$command = 'rm '.$wav_dir.'*';
print $command . "\n";
system($command);
$command = 'rm '.$sig_dir.'*';
print $command . "\n";
system($command);

# convert
my @files = glob($source_dir);
foreach(@files){
   ($name, $path, $suffix) = fileparse($_, '\.[^\.]*');
   
   # other to wav
   $wav_filename = $wav_dir . $name . ".wav";
   $command = 'ffmpeg -i ' . $path . $name . $suffix . ' ' . $wav_filename;
   print $command . "\n";
   system($command);

   # wav to sig
   $sig_filename = $sig_dir . $name . ".sig";
   $command = 'HCopy -C ' . $config_file . ' ' . $wav_filename . ' ' . $sig_filename;
   print $command . "\n";
   system($command);
}

# sig to mfcc
$command = 'HCopy -D -C ' . $analysis_conf_file . ' -S ' . $targetlist;
print $command . "\n";
system($command);