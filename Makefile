# These flags work with the Intel compiler
OPT	  = -Ofast

# Intel Fortran compiler supports coarrays on Linux only
FC	  = ifort
FFLAGS    = $(OPT) -std08 -coarray

# Intel C compiler
OMPCC     = icc
OMPCFLAGS = $(OPT) -qopenmp

# OpenSHMEM compiler wrapper script
OSHCC     = /opt/shmem/sandia/intel/bin/oshcc
OSHCFLAGS = $(CFLAGS)

# UPC Compiler
UPCC      = /opt/upc/berkeley_upc-2.22.0/bin/upcc
# If using Berkeley UPC, compiler flags are prepended by -Wc
UPCFLAGS  = -Wc,$(CFLAGS)

# MPI Compiler
MPICC     = /opt/mpich/dev/intel/default/bin/mpicc
MPICFLAGS = $(CFLAGS)

# Intel Fortran does not support coarrays on Mac...
TESTS  = upc.x shmem.x mpirma.x openmp1.x openmp2.x
ifeq (`uname`,Linux)
TESTS += coarray.x
endif

all: $(TESTS)

upc.x: upc.upc
	$(UPCC) $(UPCFLAGS) $< -o $@

shmem.x: shmem.c
	$(OSHCC) $(OSHCFLAGS) $< -o $@

mpirma.x: mpirma.c
	$(MPICC) $(MPICFLAGS) $< -o $@

openmp1.x: openmp1.c
	$(OMPCC) $(OMPCFLAGS) $< -o $@

openmp2.x: openmp2.c
	$(OMPCC) $(OMPCFLAGS) $< -o $@

coarray.x: coarray.f90
	$(FC) $(FFLAGS) $< -o $@

clean:
	-rm -f *.o
	-rm -f $(TESTS)

