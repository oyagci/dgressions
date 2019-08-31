NAME		:= dgressions

SRC_ASM_RAW	:=
SRC_ASM		:= $(addprefix src/,$(SRC_ASM_RAW))

SRCDIR		:= src
SRC_C		:=

SRC_RS		:= lib.rs
SRC_RS		:= $(addprefix $(SRCDIR)/,$(SRC_RS))

BUILDDIR	:= build

OBJ_ASM		:= $(addprefix $(BUILDDIR)/,$(SRC_ASM_RAW:.s=.o))
OBJ_C		:= $(addprefix $(BUILDDIR)/,$(SRC_C:.c=.o))
OBJ_RS		:= $(addprefix $(BUILDDIR)/,$(SRC_RS:.rs=.o))

CC			:= gcc
CFLAGS		:= -Wall -Wextra -ffreestanding -static

AS			:= nasm
ASFLAGS		:= -f elf64

LD			:= ld
LDFLAGS		:= -melf_x86_64 -n

RUST_LIB	:= target/release/libdgressions.a

.PHONY : all, run, clean

all: $(BUILDDIR)/$(NAME)

$(BUILDDIR)/$(NAME): $(BUILDDIR) $(OBJ_ASM) $(OBJ_C) $(RUST_LIB) $(LINKER_FILE)
	gcc $(CFLAGS) -o $(BUILDDIR)/$(NAME) $(RUST_LIB) -ldl -lpthread

$(BUILDDIR)/%.o: $(SRCDIR)/%.c
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILDDIR)/%.o: $(SRCDIR)/%.s
	$(AS) $(ASFLAGS) $< -o $@

$(RUST_LIB): $(SRC_RS)
	cargo build --release

clean:
	rm -Rf $(BUILDDIR)
	cargo clean

$(BUILDDIR):
	mkdir build
