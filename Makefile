# ARCH=-m32
CC=gcc
CFLAGS=-c -Wall -Wno-unused
LDFLAGS=-O3
SOURCES=Recognition/src/dictionary.c Recognition/src/match.c Recognition/src/commands.c
OBJECTS=$(SOURCES:.cpp=.o)
EXECUTABLE=Recognition/dictionary

all: $(SOURCES) $(EXECUTABLE)
	echo "coucou"
	touch palaver_test

$(EXECUTABLE): $(OBJECTS)
	$(CC) $(LDFLAGS) $(OBJECTS) -o $@
.cpp.o:
	$(CC) $(CFLAGS) $< -o $@
check-syntax:
	$(CC) $(CFLAGS) -fsyntax-only $(SOURCES)
