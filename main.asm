;Contains the game loop, and calls the rest of the functions
;@file main.asm
;@author Michael Stewart and Mitch Johnson

include "utils.inc"
include "shared_methods.asm"
include "inner.asm"
include "inner_demon.asm"
include "sword.asm"
include "background_processes.asm"
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

section "header", rom0[$0100]
entrypoint:
    di
    jp main
    ds ($0150 - @), 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

macro DisableLCD
    ; wait for the vblank
    .wait_vblank\@
        ld a, [rLY]
        cp a, SCRN_Y
        jr nz, .wait_vblank\@

    ; turn the LCD off
    xor a
    ld [rLCDC], a
endm

section "main", rom0

main:
    copy [LEVEL_FLAGS], 0
restart_game:
    DisableLCD
    call init_start_screen

start_screen_loop:
    halt
    call check_for_start
    jp nz, start_screen_loop
    
start_level_1:
    DisableLCD
    call init_inner
    call init_inner_demons
    call init_sword
    call update_visuals
    call init_level_1
    jp game_loop

start_level_2:
    DisableLCD
    call init_inner
    call init_inner_demons
    call init_sword
    call init_level_2
    jp game_loop

game_loop:
    call update_inner
    call move_inner_demons
    call move_screen
    call update_sword
    call update_visuals
    call handle_interaction
    call update_game_state
    jp game_loop   
    