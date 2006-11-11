

test default: td nd
	@ #./td
	./nd

clean:
	rm -f td nd

td: td.c
	gcc -o td td.c

nd: nd.c
	gcc -I/usr/include/pbc -o nd nd.c -lpbc
