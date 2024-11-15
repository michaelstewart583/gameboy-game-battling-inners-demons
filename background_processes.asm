;Contains all methods the control the background, and handles gamestate
;@file background_processes.asm
;@author Michael Stewart and Mitch Johnson

include "utils.inc"

section "vblank_interrupt", rom0[$0040]
    push af
    ld a, [HALT_TIMER]
    inc a
    pop af
    reti

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
        cp a, high(LEVEL_3_ADDRESS_START)
        jr nz, .load_tile\@
endm

macro LoadLevel3TileMapIntoVRAM
    ld de, LEVEL_3_ADDRESS_START
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
    ld de, ENTITY_SIZE
    copy c, [NUM_INNER_DEMONS]
    inc c
    .left_loop
        MoveEntityRightNoAnimation INNER_MOVEMENT_AMOUNT
        add hl, de
        dec c
        jp nz, .left_loop

    ld a, [rSCX]
    sub 2
    ld [SCREEN_X_RAM], a
endm

macro FixScreenRight
    ld hl, INNER_SPRITE_0_ADDRESS
    ld de, ENTITY_SIZE
    copy c, [NUM_INNER_DEMONS]
    inc c
    .right_loop
        MoveEntityLeftNoAnimation INNER_MOVEMENT_AMOUNT
        add hl, de
        dec c
        jp nz, .right_loop

    ld a, [rSCX]
    add 2
    ld [SCREEN_X_RAM], a
endm

macro FixScreenUp
    ld hl, INNER_SPRITE_0_ADDRESS
    ld de, ENTITY_SIZE
    copy c, [NUM_INNER_DEMONS]
    inc c
    .up_loop
        MoveEntityDownNoAnimation INNER_MOVEMENT_AMOUNT
        add hl, de
        dec c
        jp nz, .up_loop

    ld a, [SCREEN_Y_RAM]
    sub 2
    ld [SCREEN_Y_RAM], a
endm

macro FixScreenBottom
    ld hl, INNER_SPRITE_0_ADDRESS
    ld de, ENTITY_SIZE
    copy c, [NUM_INNER_DEMONS]
    inc c
    .bottom_loop
        MoveEntityUpNoAnimation INNER_MOVEMENT_AMOUNT
        add hl, de
        dec c
        jp nz, .bottom_loop

    ld a, [SCREEN_Y_RAM]
    add 2
    ld [SCREEN_Y_RAM], a
endm

macro InitRamSprites
    ld hl , SWORD_SPRITE_ADDRESS
    ld c, TOTAL_SPRITE_SIZE
    .init_ram\@
        ld [hl], 0
        inc hl
        dec c
        jp nz, .init_ram\@
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
    InitRamSprites
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

    copy [SCREEN_X_RAM], [rSCX]
    copy [SCREEN_Y_RAM], [rSCY]

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

    copy [LEVEL_FLAGS], ON_LEVEL_1
    copy [INNER_DEMON_RESPAWN_X], INNER_DEMON_LEVEL_1_RESPAWN_X
    copy [INNER_DEMON_RESPAWN_Y], INNER_DEMON_LEVEL_1_RESPAWN_Y

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

    copy [rSCX], 0
    copy [rSCY], 50

    copy [SCREEN_X_RAM], [rSCX]
    copy [SCREEN_Y_RAM], [rSCY]

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

    copy [LEVEL_FLAGS], ON_LEVEL_2

    copy [INNER_DEMON_RESPAWN_X], INNER_DEMON_LEVEL_2_RESPAWN_X
    copy [INNER_DEMON_RESPAWN_Y], INNER_DEMON_LEVEL_2_RESPAWN_Y

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

    copy [rSCX], 0
    copy [rSCY], 50
    
    copy [SCREEN_X_RAM], [rSCX]
    copy [SCREEN_Y_RAM], [rSCY]

    ; set the graphics parameters and turn back LCD on
    ld a, LCDCF_ON | LCDCF_WIN9C00 | LCDCF_BG8800 | LCDCF_BG9800 | LCDCF_OBJON | LCDCF_OBJ8 | LCDCF_BGON
    ld [rLCDC], a

    ret

init_level_3:
        ; init the palettes
    ld a, %11100100
    ld [rBGP], a
    ld [rOBP0], a
    ld a, %00011011
    ld [rOBP1], a

    copy [LEVEL_FLAGS], ON_LEVEL_3
    copy [INNER_DEMON_RESPAWN_X], INNER_DEMON_LEVEL_3_RESPAWN_X
    copy [INNER_DEMON_RESPAWN_Y], INNER_DEMON_LEVEL_3_RESPAWN_Y

    ; init graphics data
    LoadLevel3TileMapIntoVRAM

    ; enable the vblank interrupt
    ld a, IEF_VBLANK
    ld [rIE], a
    ei

    ; place the window at the bottom of the LCD
    ld a, 7
    ld [rWX], a
    ld a, 120
    ld [rWY], a

    copy [rSCX], 0
    copy [rSCY], 50
    
    copy [SCREEN_X_RAM], [rSCX]
    copy [SCREEN_Y_RAM], [rSCY]

    ; set the graphics parameters and turn back LCD on
    ld a, LCDCF_ON | LCDCF_WIN9C00 | LCDCF_BG8800 | LCDCF_BG9800 | LCDCF_OBJON | LCDCF_OBJ8 | LCDCF_BGON
    ld [rLCDC], a

    ret


move_screen:
    ld a, [IS_WALKING]
    and %00001111
    xor %00001111
    jp z, .done
    ld a, [INNER_SPRITE_0_ADDRESS + OAMA_X]
    cp a, LEFT_SIDE_OF_SCREEN
    jp c, .on_left_side
    cp a, RIGHT_SIDE_OF_SCREEN
    jp nc, .on_right_side
    jp .check_up_down

    .on_left_side
        ld a, [FACING_DIRECTION]
        and PADF_LEFT
        jp z, .fix_screen_left
        jp .check_up_down
        .fix_screen_left
            ld a, [SCREEN_X_RAM]
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
            ld a, [SCREEN_X_RAM]
            cp a, 93
            jp nc, .check_up_down
            FixScreenRight

    .check_up_down
    ld a, [INNER_SPRITE_0_ADDRESS + OAMA_Y]
    cp a, TOP_OF_SCREEN
    jp c, .on_top
    cp a, BOTTOM_OF_SCREEN
    jp nc, .on_bottom
    jp .done

    .on_top
        ld a, [FACING_DIRECTION]
        and PADF_UP
        jp z, .fix_screen_up
        jp .done
        .fix_screen_up
            ld a, [SCREEN_Y_RAM]
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
            ld a, [SCREEN_Y_RAM]
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
        ld a, [LEVEL_FLAGS]
        and a, ON_LEVEL_2
        jp nz, start_level_3
        jp restart_game
    .done
    ret

macro CheckCollisionNotRight
    copy b, [INNER_SPRITE_0_ADDRESS + OAMA_Y]
    ld hl, INNER_DEMONS_START_ADDRESS + OAMA_Y
    copy c, [NUM_INNER_DEMONS]

    .loop_not_right
        push hl
        ;Check if Inner is abover Inner Demon
        ld a, [hl]
        sub a, SPRITES_WIDTH
        cp a, b
        jp nc, .done_check_not_right
        ;Checks if Inner is below Inner Demon
        add a, SPRITES_WIDTH * 2
        cp a, b
        jp c, .done_check_not_right
        ;Check horizontal position
        copy b, [INNER_SPRITE_0_ADDRESS + OAMA_X]
        ld de, OAMA_X
        add hl, de

        ;Check if Inner is to the right of Inner Demon
        ld a, [hl]
        sub a, SPRITES_WIDTH
        cp a, b
        jp nc, .done_check_not_right
        ;Checks if Inner is to the left of Inner Demon
        add a, SPRITES_WIDTH * 2
        cp a, b
        jp c, .done_check_not_right

        jp .lost_game

        .done_check_not_right
        copy b, [INNER_SPRITE_0_ADDRESS + OAMA_Y]
        pop hl
        ld de, ENTITY_SIZE
        add hl, de
        dec c
        jp nz, .loop_not_right
endm

macro CheckCollisionRight
    copy b, [INNER_SPRITE_1_ADDRESS + OAMA_Y]
    ld hl, INNER_DEMONS_START_ADDRESS + sizeof_OAM_ATTRS + OAMA_Y
    copy c, [NUM_INNER_DEMONS]

    .loop_right
        push hl
        ;Check if Inner is abover Inner Demon
        ld a, [hl]
        sub a, SPRITES_WIDTH
        cp a, b
        jp nc, .done_check_right
        ;Checks if Inner is below Inner Demon
        add a, SPRITES_WIDTH * 2
        cp a, b
        jp c, .done_check_right
        ;Check horizontal position
        copy b, [INNER_SPRITE_1_ADDRESS + OAMA_X]
        ld de, OAMA_X
        add hl, de

        ;Check if Inner is to the right of Inner Demon
        ld a, [hl]
        sub a, SPRITES_WIDTH
        cp a, b
        jp nc, .done_check_right
        ;Checks if Inner is to the left of Inner Demon
        add a, SPRITES_WIDTH * 2
        cp a, b
        jp c, .done_check_right

        jp .lost_game

        .done_check_right
        copy b, [INNER_SPRITE_1_ADDRESS + OAMA_Y]
        pop hl
        ld de, ENTITY_SIZE
        add hl, de
        dec c
        jp nz, .loop_right
endm

;Checks if Inner Collides with an Inner Demon
handle_interaction:
    ld a, [INNER_SPRITE_0_ADDRESS + OAMA_FLAGS]
    and OAMF_XFLIP
    jp nz, .right
    CheckCollisionNotRight
    jp .done
    .right
        CheckCollisionRight
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
    ld de, SWORD_SPRITE_ADDRESS
    ld c, TOTAL_SPRITE_SIZE
    .loop
        copy [hl], [de]
        inc hl
        inc de
        dec c
        jp nz, .loop

    copy [rSCX], [SCREEN_X_RAM]
    copy [rSCY], [SCREEN_Y_RAM]

    .done
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
incbin "level_3_tilemap.tlm"