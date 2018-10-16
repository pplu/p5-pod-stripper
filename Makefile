fatpack:
	cpanm -l local -n --installdeps .
	mkdir -p fatpacked
	PERL5LIB=local/lib/perl5 fatpack pack script/pod_stripper.pl > fatpacked/pod_stripper.pl
