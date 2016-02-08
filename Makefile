# These flags work with pretty much any compiler
OPT	  = -O3

# Fortran 2008 compiler
FC	  = ifort
ifeq ($(FC),ifort)
FFLAGS    = $(OPT) -std08 -coarray
endif
ifeq ($(FC),gfortran)
FFLAGS    = $(OPT) -std=f2008 -fcoarray=single
endif

# OpenMP C99 compiler
OMPCC     = icc
ifeq ($(OMPCC),icc)
OMPCFLAGS = $(OPT) -qopenmp
else # GCC and Clang, at least
OMPCFLAGS = $(OPT) -fopenmp
endif

# OpenSHMEM compiler wrapper script
OSHCC     = oshcc
OSHCFLAGS = $(CFLAGS)

# UPC Compiler
UPCC      = gupc
# Berkeley UPC
ifeq ($(UPCC),upcc)
UPCFLAGS  = -Wc,$(CFLAGS)
endif
# Intrepid GCC UPC
ifeq ($(UPCC),gupc)
UPCFLAGS  = $(CFLAGS) -x upc
endif

# MPI Compiler
MPICC     = mpicc
MPICFLAGS = $(CFLAGS)

TESTS  = shmem.x upc.x mpirma.x openmp1.x openmp2.x openmp3.x

# Intel Fortran does not support coarrays on Mac...
ifeq ($(FC),ifort)
ifeq ($(shell uname),Linux)
TESTS += coarray.x
endif
endif
ifeq ($(FC),gfortran)
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

openmp3.x: openmp3.c
	$(OMPCC) $(OMPCFLAGS) $< -o $@

coarray.x: coarray.f90
	$(FC) $(FFLAGS) $< -o $@

clean:
	-rm -f  *.o
	-rm -f  $(TESTS)
	-rm -fr *.dSYM

