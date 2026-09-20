ANTE ?= ../ante/target/debug/ante
CC ?= cc
AR ?= ar

BUILD_DIR := build
NATIVE_OBJECT := $(BUILD_DIR)/socket_compat.o
NATIVE_LIBRARY := $(BUILD_DIR)/libante_http_socket.a

CFLAGS ?= -std=c11 -Wall -Wextra -Werror
ANTE_LINK_FLAGS := -L $(BUILD_DIR) -l ante_http_socket

.PHONY: native run test clean

native: $(NATIVE_LIBRARY)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(NATIVE_OBJECT): native/socket_compat.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(NATIVE_LIBRARY): $(NATIVE_OBJECT)
	$(AR) rcs $@ $<

run: $(NATIVE_LIBRARY)
	$(ANTE) run --bin main.an --delete-binary $(ANTE_LINK_FLAGS)

test: $(NATIVE_LIBRARY)
	$(ANTE) run --bin test.an --delete-binary $(ANTE_LINK_FLAGS)

clean:
	rm -rf $(BUILD_DIR)
