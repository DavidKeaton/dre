SDIR = src
ODIR = obj

TARGET	= dre

SOURCES = $(wildcard $(SDIR)/*.cpp)
HEADERS = $(wildcard $(SDIR)/*.h)
OBJS = $(patsubst %,$(ODIR)/%, \
	   $(SOURCES:$(SDIR)/%.cpp=%.o))

CXX			:= $(CROSS)$(CXX)
CXXFLAGS	+= -std=c++11 -fPIC
LDFLAGS		+= -soname,lib$(TARGET).so
DEFINES =

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
#===========================================================
all: $(TARGET)
	@

$(TARGET): $(ODIR) $(OBJS)
	$(CXX) -shared -Wl,$(LDFLAGS) -o lib$(TARGET).so $(OBJS)

archive: $(TARGET).a
	@

$(TARGET).a: $(ODIR) $(OBJS)
	ar rcs $(TARGET).a $(OBJS)

$(ODIR):
	mkdir -p $(ODIR)

$(ODIR)/%.o: $(SDIR)/%.cpp
	$(CXX) $(CPPFLAGS) $(DEFINES) $(CXXFLAGS) -c $< -o $@

.PHONY: clean ctags
clean: 
	rm -rf lib$(TARGET).so $(TARGET).a $(ODIR)

ctags:
	ctags $(SOURCES) $(HEADERS)

