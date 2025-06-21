.PHONY: all run clean

CC      := $(CC)
DEBUG   ?= 0
RELEASE ?= 0

BIN      = magic
BIN_PATH = bin

SRC_PATH = src
SRCS     = $(shell find $(SRC_PATH) -type f -name "*.c")

OBJ_PATH = obj
OBJS     = $(SRCS:$(SRC_PATH)/%.c=$(OBJ_PATH)/%.o)

RES_PATH = res

OUT_NATIVE = $(BIN_PATH)/$(BIN)

DIRS =\
	$(sort $(dir $(OBJS))) \
	$(BIN_PATH)/

WARNINGS =\
	-Wall \
	-Wextra \
	-Wpedantic \
	-Wconversion

LDLIBS =\
	-lraylib

RELEASE_FLAGS =\
	-O3 \
	-DNDEBUG

DEBUG_FLAGS =\
	-g \
	-O0 \
	-DDEBUG

INCLUDE =\
	-Isrc \
	-Ilib

CFLAGS = $(WARNINGS) $(INCLUDE)

ifeq ($(DEBUG), 1)
	CFLAGS += $(DEBUG_FLAGS)
endif

ifeq ($(RELEASE), 1)
	CFLAGS += $(RELEASE_FLAGS)
endif

all: $(DIRS) $(OUT_NATIVE)

run: all
	./$(OUT_NATIVE)

clean:
	rm -rf $(BIN_PATH) $(OBJ_PATH)

$(DIRS):
	mkdir -p $@

$(OUT_NATIVE): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^ $(LDLIBS)

$(OBJ_PATH)/%.o: $(SRC_PATH)/%.c
	$(CC) $(CFLAGS) -c $< -o $@
