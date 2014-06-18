#!/usr/bin/perl

use strict;
use warnings;
#use Text::CSV;

## globally accessible variables
my $validArgs = checkArgs(); #boolean
my $lookForCEO = 0;
my $element;
my @lastLine;
my $lastLineBlank=0;
my $neverAgain=0;

my $name;
my $month;
my $day;
my $year;
my $address;
my $giftAmt;
my $giftDate;
my $giftType;
my $fund;
my $checkNum;
my $checkDate;



##
#	Code - constructor if you will!
##
if ($validArgs) {
	my $lineNumber = 0;
	my $inFile = $ARGV[0];
	my $outFile = "file.txt";
	
	open (OUTFILE, ">>", $outFile) or die " cannot open output file";
	open (INFILE, "<", $inFile) or die " cannot open input file";
		
		while(<INFILE>){
			chomp $_;

			if ($_ =~ /^\s*$/){			#drop blank lines
				$lastLineBlank=1;
				#print "omitted a blank line\n"
				}
			else {
				my @line=split(" ",$_); 
				if ($line[0] eq "Dear"){
					#print "found Dear\n";
					$lookForCEO =1;
					}
				if ($line[$#line] eq "CEO"){
					$lookForCEO=0;
					#print "found CEO\n";
					}
				elsif ($lookForCEO != 1){			
						if ($lineNumber == 0){
							($month, $day, $year) = split(" ", $_);
							chop($day);
							}
						if ($lineNumber == 1){
							$name = $_;
							}
						if ($lineNumber > 1 && $lastLineBlank !=1 && $neverAgain != 1){
							#print "made it into address if \n";
							$address = $address . $_ . " ";
							}
						elsif ($lineNumber > 1 && $lastLineBlank == 1){$neverAgain=1;}
						$lineNumber++;
						}
				else {
					#print "skipped ", $line[0], "\n";
					}
				#print $_, "\n";
				@lastLine=split(/;/, $_);
				$lastLineBlank=0
				}
		}
	close INFILE;
	#here is where we split up @lastLine
	foreach $element (@lastLine){
		$element = lc $element;
		$element =~ s/^\s+|\s+$//g;
		#print $element, "\n";
		my @words = split(" ", $element);
		#print $words[0], "_","\n";
		#print $words[1], "_","\n";
		#print $words[2], "_","\n";
		SWITCH: {
		 	if ($words[0] eq "gift") {
					GIFTTYPE: {
						if ($words[1] eq "type:") {$giftType=$words[2]; last GIFTTYPE;}
						if ($words[1] eq "date:") {$giftDate=$words[2]; last GIFTTYPE;}
						if ($words[1] eq "amt:") {$giftAmt=$words[2] ; last GIFTTYPE;}
						print "fell off the end of the GIFTTYPE block\n";
					}; 
					last SWITCH; 
				};
			if ($words[0] eq "fund:") {$fund=$words[1]; chop($fund); last SWITCH; };
			if ($words[0] eq "check") {
				CHECKTYPE: {
				if ($words[1] eq "date:") {$checkDate=pop @words; last CHECKTYPE;}
				if ($words[1] eq "#") {$checkNum=pop @words; last CHECKTYPE;}
				if ($words[1] eq "#:") {$checkNum=pop @words; last CHECKTYPE;}
				print "fell off the end of the CHECKDATA block\n";
			}; 

			}
			print "fell off the end of the SWITCH block\n";
			}
		}

print OUTFILE $inFile, ";",$name, ";", $month, ";", $day, ";", $year, ";",$address, ";", $giftAmt, ";", $giftDate, ";", $giftType, ";", $fund, ";", $checkNum, ";", $checkDate, "\n";
close(OUTFILE);
} else {
	print "\l\n check command line arguments \l\n";
	print $ARGV[0];
}
## End of code



##
#	checkArgs subroutine checks that the script has been
#	called with the correct number of aguements, and that 
#	the last one at least appears to be a url
#
#	returns: boolean
##
sub checkArgs {
	if (!defined $ARGV[0]) {
		return 0;
	} else {
		return 1;
	}
}




################kill
#							GIFTYPE: {
#								if ($giftType eq "personal") {}
#								 $giftType eq "business") {$checkType = $words[2];
#									CHECKTYPE: {
#										if ()
#									}
#								}
#								if ($giftType eq "gift") {}
#								if ($giftType eq "recurring") {}
#								if ($giftType eq "card") {}
#								if ($giftType eq "online") {}
