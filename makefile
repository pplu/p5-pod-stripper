fatpack:
	cpanm -Llocal -nq --installdeps .
	mkdir -p fatpacked
	fatpack-simple -o fatpacked/pod_stripper.pl script/pod_stripper.pl
