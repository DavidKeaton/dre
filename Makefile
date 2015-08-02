#===========================================================
TARGET	= dre
#===========================================================
CXX = ccache clang++
CPPFLAGS = -mtune=native
#===========================================================
SDIR = src
ODIR = obj
DDIR = dist
#===========================================================
MODULES = io map snd ui
OBJS    = $(ODIR)/dre.a $(patsubst %,$(ODIR)/%.a,$(MODULES))
DIRS	= $(patsubst %,$(SDIR)/%,$(MODULES))
#===========================================================
CXX			:= $(CROSS)$(CXX)
CXXFLAGS	+= -Wall -std=c++11 -fPIC
LDFLAGS		+= -soname,lib$(TARGET).so
DEFINES 	=
SO_FLAGS	= $(CPPFLAGS) $(CXXFLAGS) -shared -Wl,$(LDFLAGS)
#===========================================================
ifeq ($(OPTIMIZE),1)
  ifeq ($(CROSS),"")
    CXXFLAGS += -mtune=native
  endif
endif
ifeq ($(RELEASE),1)
  CXXFLAGS += -O3
else
  DEFINES  += -D_GLIBCXX_DEBUG -DDEBUG
  CXXFLAGS += -g
endif
#===========================================================
PASS_ON		= CXX="$(CXX)" CPPFLAGS="$(CPPFLAGS)" \
			  CXXFLAGS="$(CXXFLAGS)" DEFINES="$(DEFINES)"
#===========================================================
#.SILENT: all lib archive
all: lib archive
	@

lib: $(DDIR) $(ODIR) $(MODULES) dre
	$(CXX) $(SO_FLAGS) -o $(DDIR)/libdre.so $(OBJS)

archive: $(DDIR) $(ODIR) $(MODULES) dre
	ar rcs $(DDIR)/libdre.a $(OBJS)
#===========================================================
$(MODULES):
	make -C $(SDIR)/$@ $(PASS_ON)

dre:
	make -C src $(PASS_ON)
#===========================================================
$(DDIR):
	mkdir -p $(DDIR)

$(ODIR):
	mkdir -p $(ODIR)
#===========================================================
.PHONY: clean clean-vim
clean:
	rm -rf $(DDIR) $(ODIR)
	make -C src clean
	for i in $(DIRS); do make -C $${i} clean; done;

clean-vim:
	find -name "*~" -delete
#===========================================================
