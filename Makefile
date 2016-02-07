# These flags work with the Intel 15+ compiler.
OPT	 = -Ofast
OMPFLAGS = -qopenmp

# Intel C compiler
OMPCC    = icc $(OMPFLAGS)
CFLAGS   = $(OPT)

# Intel Fortran compiler supports coarrays
FC	 = ifort
FFLAGS   = $(OPT) -std08

# OpenSHMEM compiler wrapper script
OSHCC    = /opt/shmem/sandia/intel/bin/oshcc

# UPC Compiler
UPCC     = true

# MPI Compiler
MPICC    = /opt/mpich/dev/intel/default/bin/mpicc

# Intel Fortran does not support coarrays on Mac...
TESTS = upc.x shmem.x mpirma.x openmp1.x openmp2.x #coarray.x

all: $(TESTS)

upc.x: upc.upc
	$(UPCC) $(CFLAGS) $< -o $@

shmem.x: shmem.c
	$(OSHCC) $(CFLAGS) $< -o $@

mpirma.x: mpirma.c
	$(MPICC) $(CFLAGS) $< -o $@

openmp1.x: openmp1.c
	$(OMPCC) $(CFLAGS) $< -o $@

openmp2.x: openmp2.c
	$(OMPCC) $(CFLAGS) $< -o $@

coarray.x: coarray.f90
	$(FC) $(FFLAGS) $< -o $@

clean:
	-rm -f *.o
	-rm -f $(TESTS)

