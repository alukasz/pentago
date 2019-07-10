# adapter from https://github.com/riverrun/argon2_elixir/blob/378975d72ee1bef544a26a17d57a2dc729a2bbdb/Makefile

SRC_DIR = src
SRC = $(SRC_DIR)/algorithm.c $(SRC_DIR)/algorithm.h $(SRC_DIR)/board.c\
      $(SRC_DIR)/board.h $(SRC_DIR)/nifs.c $(SRC_DIR)/nifs.h

ERLANG_PATH = $(shell erl -eval 'io:format("~s", [lists:concat([code:root_dir(), "/erts-", erlang:system_info(version), "/include"])])' -s init stop -noshell)
CFLAGS += -pthread -O3 -Wall -g -std=c99 -I$(SRC_DIR) -Ic_src -I"$(ERLANG_PATH)"

KERNEL_NAME := $(shell uname -s)

LIB_NAME = priv/libbit_board.so
ifneq ($(CROSSCOMPILE),)
	LIB_CFLAGS := -shared -fPIC -fvisibility=hidden
else
	ifeq ($(KERNEL_NAME), Linux)
		LIB_CFLAGS := -shared -fPIC -fvisibility=hidden
	endif
	ifeq ($(KERNEL_NAME), Darwin)
		LIB_CFLAGS := -dynamiclib -undefined dynamic_lookup
	endif
	ifeq ($(KERNEL_NAME), $(filter $(KERNEL_NAME),OpenBSD FreeBSD NetBSD))
		LIB_CFLAGS := -shared -fPIC
	endif
endif

all: $(LIB_NAME)

$(LIB_NAME): $(SRC)
	mkdir -p priv
	$(CC) $(CFLAGS) $(LIB_CFLAGS) $(SO_LDFLAGS) $^ -o $@

clean:
	rm -f $(LIB_NAME)

.PHONY: all clean
