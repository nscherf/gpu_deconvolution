NVCC := nvcc
INCL := --include-path "$(JAVA_HOME)/include" --include-path "$(JAVA_HOME)/include/linux"
NVCC_COMPILE_FLAGS := -c -O2 -m64 -Xcompiler -fPIC
NVCC_LINK_FLAGS := --shared -m64 -lcufft
REDISTRIBUTABLE := libNativeSPIMReconstructionCuda.so

all: $(REDISTRIBUTABLE)

CPP_SOURCES = fastspim_NativeSPIMReconstructionCuda.cpp \
	      fmvd_deconvolve.cpp \
	      fmvd_deconvolve_hdd.cpp \
	      fmvd_cuda_utils.cpp

CU_SOURCES  = fmvd_transform.cu \
	      fmvd_deconvolve_cuda.cu

CPP_OBJS = $(patsubst %.cpp, %.obj, $(CPP_SOURCES))
CU_OBJS  = $(patsubst %.cu, %.obj, $(CU_SOURCES))

REBUILDABLES = $(CPP_OBJS) $(CU_OBJS) $(REDISTRIBUTABLE)

clean :
	rm -f $(REBUILDABLES)

$(REDISTRIBUTABLE) : $(CPP_OBJS) $(CU_OBJS)
	$(NVCC) $(NVCC_LINK_FLAGS) $^ -o $@

$(CPP_OBJS) : %.obj : %.cpp
	$(NVCC) $(NVCC_COMPILE_FLAGS) $(INCL) -o $@ $<

$(CU_OBJS) : %.obj : %.cu
	$(NVCC) $(NVCC_COMPILE_FLAGS) $(INCL) -o $@ $<


