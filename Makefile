test: ex17a.bin ex17b.bin
	./ex17a.bin
	./ex17b.bin

ex17a.bin:
	gcc -Wall ex17a.c -o ex17a.bin

ex17b.bin:
	gcc -Wall ex17b.c -o ex17b.bin

.PHONY: test
