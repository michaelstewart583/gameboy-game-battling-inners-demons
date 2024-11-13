
.PHONY: all

all: game.gb

game.gb: main.o
	rgblink --dmg --tiny --map game.map --sym game.sym -o game.gb main.o
	rgbfix -v -p 0xFF game.gb

main.o: main.asm shared_methods.asm background_processes.asm inner.asm sword.asm inner_demon.asm hardware.inc utils.inc *.tlm *.chr
	rgbasm -o main.o main.asm