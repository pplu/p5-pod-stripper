# POD Stripper

Utility to strip POD from Perl module files.

This utility is focused on reducing the size of Perl installations by deleting the POD documentation from the source files. It's basically aimed at running inside Docker containers to make them smaller.

Some initial tests show great earnings:
```
mkdir podstrip_test
cd podstrip_test
cpanm --no-man-pages -n -l local Moose
curl -s https://raw.githubusercontent.com/pplu/p5-pod-stripper/feature/fatpack/fatpacked/pod_stripper.pl | perl
> Original module size: 3029692
> Stripped to: 2041114
> Won 32.63%

rm -rf local
cpanm --no-man-pages -n -l local Paws
Original module size: 63479951
Stripped to: 28912215
Won 54.45%
```
