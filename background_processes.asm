;Contains all methods the control the background, and handles gamestate
;@file background_processes.asm
;@author Michael Stewart and Mitch Johnson

include "utils.inc"

section "vblank_interrupt", rom0[$0040]
    reti

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

def TILES_COUNT                     equ (384)
def BYTES_PER_TILE                  equ (16)
def TILES_BYTE_SIZE                 equ (TILES_COUNT * BYTES_PER_TILE)

def TILEMAPS_COUNT                  equ (4)
def BYTES_PER_TILEMAP               equ (1024)
def TILEMAPS_BYTE_SIZE              equ (TILEMAPS_COUNT * BYTES_PER_TILEMAP)

def GRAPHICS_DATA_SIZE              equ (TILES_BYTE_SIZE + (TILEMAPS_BYTE_SIZE * TILEMAPS_COUNT))
def GRAPHICS_DATA_ADDRESS_END       equ ($8000)
def TILESET_ADDRESS_START           equ (GRAPHICS_DATA_ADDRESS_END - GRAPHICS_DATA_SIZE)
def WINDOW_ADDRESS_START            equ (TILESET_ADDRESS_START + TILES_BYTE_SIZE)
def START_SCREEN_ADDRESS_START      equ (WINDOW_ADDRESS_START + BYTES_PER_TILEMAP)
def LEVEL_1_ADDRESS_START           equ (START_SCREEN_ADDRESS_START + BYTES_PER_TILEMAP)
def LEVEL_2_ADDRESS_START           equ (LEVEL_1_ADDRESS_START + BYTES_PER_TILEMAP)
def VRAM_TILEMAP_ADDRESS_START      equ (_VRAM8000 + TILES_BYTE_SIZE) ;where tilemaps would actually start in VRAM
def VRAM_WINDOW_ADDRESS_START       equ (VRAM_TILEMAP_ADDRESS_START + BYTES_PER_TILEMAP)

def LEFT_SIDE_OF_SCREEN             equ (53)
def RIGHT_SIDE_OF_SCREEN            equ (106)
def TOP_OF_SCREEN                   equ (48)
def BOTTOM_OF_SCREEN                equ (96)
def FAR_RIGHT_OF_SCREEN             equ (160)

def LEVEL_FLAGS                     rb 1
def ON_LEVEL_1                      equ(%00000001)
def ON_LEVEL_2                      equ(%00000010)
def LOST_GAME                       equ(%10000000)
def WON_GAME                        equ(%01000000)

;Text printing constants
def WHITE_SPACE                     equ($C3)
def START_OF_ALPHABET_IN_TILESET    equ($61)
def NEW_LINE_OFFSET                 equ($20)
def TEXT_ON_WINDOW                  equ($9C02)
def ASCII_WHITE_SPACE               equ(20)
def START_OF_ALPHABET_HEX           equ($41)

macro LoadTileSetIntoVRAM
    ld de, TILESET_ADDRESS_START
    ld hl, _VRAM8000
    .load_tile\@
        ld a, [de]
        inc de
        ld [hli], a
        ld a, d
        cp a, high(WINDOW_ADDRESS_START)
        jr nz, .load_tile\@
endm

macro LoadWindowIntoVRAM
    ld de, WINDOW_ADDRESS_START
    ld hl, VRAM_WINDOW_ADDRESS_START
    .load_tile\@
        ld a, [de]
        inc de
        ld [hli], a
        ld a, d
        cp a, high(START_SCREEN_ADDRESS_START)
        jr nz, .load_tile\@
    endm

macro LoadStartScreenTileMapIntoVRAM
    ld de, START_SCREEN_ADDRESS_START
    ld hl, VRAM_TILEMAP_ADDRESS_START
    .load_tile\@
        ld a, [de]
        inc de
        ld [hli], a
        ld a, d
        cp a, high(LEVEL_1_ADDRESS_START)
        jr nz, .load_tile\@
endm

macro LoadLevel1TileMapIntoVRAM
    ld de, LEVEL_1_ADDRESS_START
    ld hl, VRAM_TILEMAP_ADDRESS_START
    .load_tile\@
        ld a, [de]
        inc de
        ld [hli], a
        ld a, d
        cp a, high(LEVEL_2_ADDRESS_START)
        jr nz, .load_tile\@
endm

macro LoadLevel2TileMapIntoVRAM
    ld de, LEVEL_2_ADDRESS_START
    ld hl, VRAM_TILEMAP_ADDRESS_START
    .load_tile\@
        ld a, [de]
        inc de
        ld [hli], a
        ld a, d
        cp a, high(GRAPHICS_DATA_ADDRESS_END)
        jr nz, .load_tile\@
endm

; clear the OAM
macro InitOAM
    ld c, OAM_COUNT
    ld hl, _OAMRAM + OAMA_Y
    ld de, sizeof_OAM_ATTRS
    .init_oam\@
        ld [hl], 0
        add hl, de
        dec c
        jr nz, .init_oam\@
endm

macro FixScreenLeft
    ld hl, INNER_SPRITE_0_ADDRESS
    ld bc, ENTITY_SIZE
    ld c, NUM_INNER_DEMONS
    inc c
    .left_loop
        MoveEntityLeftNoAnimation INNER_MOVEMENT_AMOUNT
        add hl, bc
        dec c
        jp nz, .left_loop

    ld a, [rSCX]
    sub 2
    ld [rSCX], a
endm

macro FixScreenRight
    ld hl, INNER_SPRITE_0_ADDRESS
    ld bc, ENTITY_SIZE
    ld c, NUM_INNER_DEMONS
    inc c
    .right_loop
        MoveEntityRightNoAnimation INNER_MOVEMENT_AMOUNT
        add hl, bc
        dec c
        jp nz, .right_loop

    ld a, [rSCX]
    add 2
    ld [rSCX], a
endm

macro FixScreenUp
    ld hl, INNER_SPRITE_0_ADDRESS
    ld bc, ENTITY_SIZE
    ld c, NUM_INNER_DEMONS
    inc c
    .up_loop
        MoveEntityUpNoAnimation INNER_MOVEMENT_AMOUNT
        add hl, bc
        dec c
        jp nz, .up_loop

    ld a, [rSCY]
    sub 2
    ld [rSCY], a
endm

macro FixScreenBottom
    ld hl, INNER_SPRITE_0_ADDRESS
    ld bc, ENTITY_SIZE
    ld c, NUM_INNER_DEMONS
    inc c
    .bottom_loop
        MoveEntityDownNoAnimation INNER_MOVEMENT_AMOUNT
        add hl, bc
        dec c
        jp nz, .bottom_loop

    ld a, [rSCY]
    add 2
    ld [rSCY], a
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section "background_processes", rom0

macro ScrollHudPositionUpOneTile
    push bc
    push af
    ld c, 8
    .scroll
        halt
        ld a, [rWY]
        dec a
        ld [rWY], a
        dec c
        jp nz, .scroll
    pop af
    pop bc
endm

;Prints out text declaring if you have won or lost the game
print_text:
    ; hl = pointer to tile (letter) in memory
    ; bc = tile map index
    push hl
    push bc
    push af
    halt
    .write_letter
        ld a, [hli]
        cp a, $00
        jp z, .done
        cp a, ASCII_WHITE_SPACE
        jp z, .space

        sub a, START_OF_ALPHABET_HEX
        add START_OF_ALPHABET_IN_TILESET
        ld [bc], a
        jp .letter_printed

        .space
            ld a, WHITE_SPACE
            ld [bc], a
            
        .letter_printed
        inc bc
        jp .write_letter
        
    .done
    ScrollHudPositionUpOneTile
    pop af
    pop bc
    pop hl
    ret

init_start_screen:
    ; init the palettes
    ld a, %11100100
    ld [rBGP], a
    ld [rOBP0], a
    ld a, %00011011
    ld [rOBP1], a

    ; init graphics data
    InitOAM
    LoadTileSetIntoVRAM
    LoadWindowIntoVRAM
    LoadStartScreenTileMapIntoVRAM

    ; enable the vblank interrupt
    ld a, IEF_VBLANK
    ld [rIE], a
    ei

    ; place the window at the bottom of the LCD
    ld a, 7
    ld [rWX], a
    ld a, 144
    ld [rWY], a

    copy [rSCX], 0
    copy [rSCY], 0

    ; set the graphics parameters and turn back LCD on
    ld a, LCDCF_ON | LCDCF_WIN9C00 | LCDCF_WINON | LCDCF_BG8800 | LCDCF_BG9800 | LCDCF_OBJON | LCDCF_OBJ8 | LCDCF_BGON
    ld [rLCDC], a

    ld a, [LEVEL_FLAGS]
    and LOST_GAME
    jp nz, .lost_game
    ld a, [LEVEL_FLAGS]
    and WON_GAME
    jp nz, .won_game
    jp .done

    ;Detects that you got to the start screen from a lost game
    .lost_game
        ld hl, YOU_LOSE_TEXT_LOCATION
        ld bc, TEXT_ON_WINDOW
        call print_text
        jp .done

    ;Detects that you got to the start screen from a won game
    .won_game
        ld hl, YOU_WIN_TEXT_LOCATION
        ld bc, TEXT_ON_WINDOW
        call print_text
        jp .done

    .done
    ret

init_level_1:
    ; init the palettes
    ld a, %11100100
    ld [rBGP], a
    ld [rOBP0], a
    ld a, %00011011
    ld [rOBP1], a

    copy [LEVEL_FLAGS], 1

    ; init graphics data
    LoadLevel1TileMapIntoVRAM

    ; enable the vblank interrupt
    ld a, IEF_VBLANK
    ld [rIE], a
    ei

    ; place the window at the bottom of the LCD
    ld a, 7
    ld [rWX], a
    ld a, 120
    ld [rWY], a

    ld a, 50
    ld [rSCY], a

    ; set the graphics parameters and turn back LCD on
    ld a, LCDCF_ON | LCDCF_WIN9C00 | LCDCF_BG8800 | LCDCF_BG9800 | LCDCF_OBJON | LCDCF_OBJ8 | LCDCF_BGON
    ld [rLCDC], a
    ret

init_level_2:
    ; init the palettes
    ld a, %11100100
    ld [rBGP], a
    ld [rOBP0], a
    ld a, %00011011
    ld [rOBP1], a

    copy [LEVEL_FLAGS], 2

    ; init graphics data
    LoadLevel2TileMapIntoVRAM

    ; enable the vblank interrupt
    ld a, IEF_VBLANK
    ld [rIE], a
    ei

    ; place the window at the bottom of the LCD
    ld a, 7
    ld [rWX], a
    ld a, 120
    ld [rWY], a

    ; set the graphics parameters and turn back LCD on
    ld a, LCDCF_ON | LCDCF_WIN9C00 | LCDCF_BG8800 | LCDCF_BG9800 | LCDCF_OBJON | LCDCF_OBJ8 | LCDCF_BGON
    ld [rLCDC], a

    ret


move_screen:
    halt
    ld a, [IS_WALKING]
    and %00001111
    xor %00001111
    jp z, .done
    ld a, [INNER_SPRITE_0_ADDRESS + OAMA_X]
    cp a, LEFT_SIDE_OF_SCREEN
    jp c, .on_left_side
    cp a, RIGHT_SIDE_OF_SCREEN
    jp nc, .on_right_side

    .on_left_side
        ld a, [FACING_DIRECTION]
        and PADF_LEFT
        jp z, .fix_screen_left
        jp .check_up_down
        .fix_screen_left
            ld a, [rSCX]
            cp a, 2
            jp c, .check_up_down
            FixScreenLeft
            jp .check_up_down
    .on_right_side
        ld a, [FACING_DIRECTION]
        and PADF_RIGHT
        jp z, .fix_screen_right
        jp .check_up_down
        .fix_screen_right
            ld a, [rSCX]
            cp a, 93
            jp nc, .check_up_down
            FixScreenRight

    .check_up_down
    ld a, [INNER_SPRITE_0_ADDRESS + OAMA_Y]
    cp a, TOP_OF_SCREEN
    jp c, .on_top
    cp a, BOTTOM_OF_SCREEN
    jp nc, .on_bottom

    .on_top
        ld a, [FACING_DIRECTION]
        and PADF_UP
        jp z, .fix_screen_up
        jp .done
        .fix_screen_up
            ld a, [rSCY]
            cp a, 2
            jp c, .done
            FixScreenUp
            jp .done

    .on_bottom
        ld a, [FACING_DIRECTION]
        and PADF_DOWN
        jp z, .fix_screen_bottom
        jp .done
        .fix_screen_bottom
            ld a, [rSCY]
            cp a, 113
            jp nc, .done
            FixScreenBottom

    .done
    ret

;Detects if you beat a level, and what level/start screen to send you to
update_game_state:
    ld a, [INNER_SPRITE_1_ADDRESS + OAMA_X]
    cp a, FAR_RIGHT_OF_SCREEN
    jp c, .done
    .level_beat
        ld a, [LEVEL_FLAGS]
        or WON_GAME
        ld [LEVEL_FLAGS], a
        and a, ON_LEVEL_1
        jp nz, start_level_2
        jp restart_game
    .done
    ret

;Checks if Inner Collides with an Inner Demon
handle_interaction:
    ld a, [INNER_SPRITE_0_ADDRESS + OAMA_Y]
    ld b, a
    ld hl, INNER_DEMONS_START_ADDRESS + OAMA_Y
    ld c, NUM_INNER_DEMONS
    .loop
        ld a, [hl]
        cp a, b
        jp nz, .done_check

        push hl
        ld a, [INNER_SPRITE_0_ADDRESS + OAMA_X]
        ld b, a
        ld de, OAMA_X
        add hl, de
        ld a, [hl]
        cp a, b
        jp z, .lost_game
        ld a, [INNER_SPRITE_0_ADDRESS + OAMA_X]
        ld b, a
        pop hl

        .done_check
            ld de, ENTITY_SIZE
            add hl, de
            dec c
            jp nz, .loop
            jp .done

    .lost_game
        copy [LEVEL_FLAGS], LOST_GAME
        jp restart_game
    .done
    ret

check_for_start:
    copy [rP1], P1F_GET_BTN
    ;wait
    ld a, [rP1]
    ld a, [rP1]
    ld a, [rP1]
    ld a, [rP1]
    ld a, [rP1]
    
    ;poll
    ld a, [rP1]
    and PADF_START
    ret

update_visuals:
    ld hl, SWORD_SPRITE_ADDRESS_OAM
    ld bc, SWORD_SPRITE_ADDRESS
    ld c, TOTAL_SPRITE_SIZE
    .loop
        copy [hl], [bc]
        inc hl
        inc bc
        dec c
        jp nz, .loop
    ret
    
YOU_WIN_TEXT_LOCATION:
    db "YOU WIN\0"

YOU_LOSE_TEXT_LOCATION:
    db "YOU LOSE\0"
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section "graphics_data", rom0[TILESET_ADDRESS_START]
incbin "tileset.chr"
incbin "window_tilemap.tlm" 
incbin "start_screen_tilemap.tlm"
incbin "level_1_tilemap.tlm"
incbin "level_2_tilemap.tlm"


