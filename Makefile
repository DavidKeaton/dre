TARGET	= dre
STATIC	= 

ODIR = obj
DDIR = dist

MODULES = dre io map snd ui
OBJS    = $(patsubst %,$(ODIR)/%.a,$(MODULES))

CXX			:= $(CROSS)$(CXX)
CXXFLAGS	+= -std=c++11 -fPIC
LDFLAGS		+= -soname,lib$(TARGET).so
DEFINES =

LIBFLAGS	= $(CPPFLAGS) $(CXXFLAGS) -shared -Wl,$(LDFLAGS)

ifeq ($(OPTIMIZE),1)
  ifeq ($(CROSS),"")
    CXXFLAGS += -mtune=native
  endif
endif
ifeq ($(DEBUG),1)
  DEFINES  += -D_GLIBCXX_DEBUG -DDEBUG
  CXXFLAGS += -g
else ifeq ($(RELEASE),1)
  CXXFLAGS += -O3
endif
#$(CXX) $(CXXFLAGS) -shared -Wl,$(LDFLAGS) -o $(DDIR)/$@ $(OBJS)
#===========================================================
all: lib archive
	@

lib: $(DDIR) $(ODIR) $(OBJS)
	$(CXX) $(LIBFLAGS) -o $(DDIR)/libdre.so $(OBJS)

archive: $(DDIR) $(ODIR) $(OBJS)
	ar rcs $(DDIR)/dre.a $(OBJS)

$(ODIR)/dre.a:
	make -C src

$(ODIR)/io.a:
	make -C src/io

$(ODIR)/map.a:
	make -C src/map

$(ODIR)/snd.a:
	make -C src/snd

$(ODIR)/ui.a:
	make -C src/ui

$(DDIR):
	mkdir -p $(DDIR)

$(ODIR):
	mkdir -p $(ODIR)

.PHONY: clean
clean: 
	rm -rf $(DDIR) $(ODIR)
	make -C src clean
	make -C src/io clean
	make -C src/map clean
	make -C src/snd clean
	make -C src/ui clean

