openssl dgst -sha1 -binary < "$1" \
	| openssl dgst -dss1 -sign ../../keys/liber_dsa_pri.pem \
	| openssl enc -base64

#	| openssl dgst -dss1 -sign <(security find-generic-password -g -l "$2" 2>&1 1>/dev/null | perl -pe '($_) = /"(.+)"/; s/\\012/\n/g' | perl -MXML::LibXML -e 'print XML::LibXML->new()->parse_file("-")->findvalue(q(//string[preceding-sibling::key[1] = "NOTE"]))' )\
