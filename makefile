GCC = nvcc

all: DecodeEmail2FULP

DecodeEmail2FULP:      DecodeEmail2FULP.cu
	$(GCC) -o DecodeEmail2FULP DecodeEmail2FULP.cu
clean:
	$(RM)  DecodeEmail2FULP DecodeEmail2FULP.o
