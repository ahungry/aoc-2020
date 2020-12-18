test: ex17a.bin
	./ex17a.bin

ex17a.bin:
	gcc -Wall ex17a.c -o ex17a.bin

.PHONY: test
