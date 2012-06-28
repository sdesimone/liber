#! /usr/bin/perl

my $in_file = shift;

my $in;
open $in, $in_file || die "Error: " . $?;

my $id = 102;
my $line;

my $max_len_aut = 0;
my $max_len_tit = 0;
my $max_len_pub = 0;
my $max_aut;
my $max_tit;
my $max_pub;

while ($line = <$in>) {
    my @record = split('\t', $line);
    my $title = $record[2];
    my $data = $record[1];
    my $arg = $record[4];
    my $aut = $record[7];
    my $num = $record[8];
    my $ed = $record[9];
    my $chiave = $record[0];
    my $note = $record[3];

	#     print "    <object type=\"LIBRO\" id=\"z$id\">
	#         <attribute name=\"title\" type=\"string\">$title</attribute>
	#         <attribute name=\"publisher\" type=\"string\">$ed</attribute>
	#         <attribute name=\"id\" type=\"int32\">$num</attribute>
	#         <attribute name=\"author\" type=\"string\">$aut</attribute>
	#         <attribute name=\"date\" type=\"string\">$data</attribute>
	#         <attribute name=\"keys\" type=\"string\">$chiave</attribute>
	#         <attribute name=\"notes\" type=\"string\">$note</attribute>
	#         <attribute name=\"summary\" type=\"string\">$arg</attribute>
	#     </object>\n";
	
	if (length $aut > 128) {
		print "BAD AUTH: ($num)\n";
	}
	if (length $title > 128) {
		print "BAD TIT: ($num)\n";
	}
	if (length $ed > 128) {
		print "BAD PUB: ($num)\n";
	}
	
    $id++;
}

