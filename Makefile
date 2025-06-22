.PHONY: all run clean cleanall

CC         ?= $(CC)
ARGS       ?=
BUILD_TYPE ?= default

ifneq ($(filter $(BUILD_TYPE), default debug release), $(BUILD_TYPE))
$(error invalid BUILD_TYPE '$(BUILD_TYPE)'. \
	Must be one of: default, debug or release)
endif

BIN           := a.out
BIN_ROOT_PATH := bin
BIN_PATH      := $(BIN_ROOT_PATH)/$(BUILD_TYPE)
OUT_NATIVE    := $(BIN_PATH)/$(BIN)

SRC_PATH      := src
SRCS          := $(shell find $(SRC_PATH) -type f -name "*.c")

OBJ_ROOT_PATH := obj
OBJ_PATH      := $(OBJ_ROOT_PATH)/$(BUILD_TYPE)
OBJS          := $(SRCS:$(SRC_PATH)/%.c=$(OBJ_PATH)/%.o)

DIRS := $(sort \
	$(dir $(OBJS)) \
	$(dir $(OUT_NATIVE)) \
)

WARNINGS :=\
	-Wall \
	-Wextra \
	-Wpedantic \
	-Wconversion

LDLIBS  :=
LDFLAGS :=
FLAGS   :=

INCLUDE :=\
	-Isrc \
	-Ilib

CFLAGS := $(WARNINGS) $(INCLUDE) $(FLAGS)

ifeq ($(BUILD_TYPE), debug)
	CFLAGS  += -g
	CFLAGS  += -O0
	CFLAGS  += -DDEBUG
	LDFLAGS += -fsanitize=address
endif

ifeq ($(BUILD_TYPE), release)
	CFLAGS  += -O3
	CFLAGS  += -DNDEBUG
endif

all: $(DIRS) $(OUT_NATIVE)

run: all
	./$(OUT_NATIVE) $(ARGS)

clean:
	rm -rf $(BIN_PATH) $(OBJ_PATH)

cleanall:
	rm -rf $(BIN_ROOT_PATH) $(OBJ_ROOT_PATH)

$(DIRS):
	mkdir -p $@

$(OUT_NATIVE): $(OBJS)
	$(CC) $(CFLAGS) $(LDFLAGS) $(LDLIBS) -o $@ $^

$(OBJ_PATH)/%.o: $(SRC_PATH)/%.c
	$(CC) $(CFLAGS) -c $< -o $@
