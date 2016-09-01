INCLUDEPATH = /usr/include
INCLUDEPATH2 = /home/users/sradanov/Code/Analogue/RSdev/lapack95
LIBPATH = /usr/lib64
LIBPATH2 = /home/users/sradanov/Code/Analogue/RSdev/lapack95/lib
lib1 = -lnetcdff
lib2 = -lmkl_lapack95 
COMPILE = ifort -mkl -c -O2 -ipo -check all,noarg_temp_created -warn all -heap_arrays -openmp 
#COMPILE = gfortran -c -fbacktrace -Warray-bounds -fopenmp -ffree-line-length-0 

LINK = ifort -mkl -openmp -warn -o 
#LINK = gfortran  -Warray-bounds -Wall -O3 -o 

netcdf = netcdf.mod

PROGRAM = analogue.out
prog.f90 = analogue.f90
prog.o = analogue.o

all: $(PROGRAM) 

config.o: config.f90
	$(COMPILE) config.f90 -I$(INCLUDEPATH)
config.mod: config.o
	@true
	
eofs.o: eofs.f90
	$(COMPILE) eofs.f90 -I$(INCLUDEPATH)
eofs.mod: eofs.o
	@true
	
read.o: read.f90
	$(COMPILE) read.f90 -I$(INCLUDEPATH)
read.mod: read.o
	@true
	
write.o: write.f90 config.mod
	$(COMPILE) write.f90 -I$(INCLUDEPATH)
write.mod: write.o
	@true
	
distance.o: distance.f90
	$(COMPILE) distance.f90 -I$(INCLUDEPATH) -I$(INCLUDEPATH2)
distance.mod: distance.o
	@true

routines.o: routines.f90 read.mod distance.mod eofs.mod
	$(COMPILE) routines.f90 -I$(INCLUDEPATH)
routines.mod: routines.o
	@true

# analogues	
$(prog.o): write.mod routines.mod $(prog.f90)
	$(COMPILE) $(prog.f90) -I$(INCLUDEPATH)

$(PROGRAM): $(prog.o) config.o read.o write.o distance.o routines.o eofs.o
	$(LINK) $(PROGRAM) read.o write.o config.o distance.o routines.o eofs.o $(prog.o) -I$(INCLUDEPATH) -I$(INCLUDEPATH2) -L$(LIBPATH) -L$(LIBPATH2) $(lib1) $(lib2)

