ODIR   = ../../obj
TARGET = $(ODIR)/io.a

SOURCES = $(wildcard *.cpp)
HEADERS = $(wildcard *.h)
OBJS    = $(SOURCES:%.cpp=%.o)

CXX			:= $(CROSS)$(CXX)
CXXFLAGS	+= -std=c++11 -fPIC

#ifeq ($(OPTIMIZE),1)
  #ifeq ($(CROSS),"")
    #CXXFLAGS += -mtune=native
  #endif
#endif
#ifeq ($(DEBUG),1)
  #DEFINES  += -D_GLIBCXX_DEBUG -DDEBUG
  #CXXFLAGS += -g
#else ifeq ($(RELEASE),1)
  #CXXFLAGS += -O3
#endif
#===========================================================
all: $(ODIR) $(TARGET)
	@

$(TARGET): $(OBJS)
	ar rcs $@ $^

%.o: %.cpp
	$(CXX) $(CPPFLAGS) $(DEFINES) $(CXXFLAGS) -c $< -o $@

$(ODIR):
	mkdir -p $(ODIR)

.PHONY: clean
clean:
	rm -f $(TARGET) $(OBJS)
