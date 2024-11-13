;Contains methods controling swinging the sword
;@file sword.asm
;@author Michael Stewart and Mitch Johnson

include "utils.inc"

section "sword", rom0

def SWORD_SWINGING equ(1)
def LAST_SWORD_ANIMATION_SPRITE equ(95)

def SWORDF rb 1

macro SwingSword
    ;Puts sword at top left of inner
    copy [SWORD_SPRITE_ADDRESS + OAMA_X], [INNER_SPRITE_0_ADDRESS + OAMA_X]
    copy [SWORD_SPRITE_ADDRESS + OAMA_Y], [INNER_SPRITE_0_ADDRESS + OAMA_Y]

    ld a, [FACING_DIRECTION]
    ;Moves the sword based on the current direction inner is facing
    .poll_right
        ld a, [FACING_DIRECTION]
        and PADF_RIGHT
        jp nz, .poll_left
    .right
        ld a, [SWORD_SPRITE_ADDRESS + OAMA_X]
        add SPRITE_TILE_WIDTH * 2
        ld [SWORD_SPRITE_ADDRESS + OAMA_X], a
        copy [SWORD_SPRITE_ADDRESS + OAMA_FLAGS], OAMF_PAL0
        jp .poll_up
    .poll_left
        ld a, [FACING_DIRECTION]
        and PADF_LEFT
        jp nz, .poll_up
    .left
        ld a, [SWORD_SPRITE_ADDRESS + OAMA_X]
        sub SPRITE_TILE_WIDTH
        ld [SWORD_SPRITE_ADDRESS + OAMA_X], a
        copy [SWORD_SPRITE_ADDRESS + OAMA_FLAGS], OAMF_XFLIP | OAMF_PAL0
    .poll_up
        ld a, [FACING_DIRECTION]
        and PADF_UP
        jp nz, .poll_down
    .up
        ld a, [SWORD_SPRITE_ADDRESS + OAMA_Y]
        sub SPRITE_TILE_WIDTH
        ld [SWORD_SPRITE_ADDRESS + OAMA_Y], a
        jp .done
    .poll_down
        ld a, [FACING_DIRECTION]
        and PADF_DOWN
        jp nz, .done
    .down
        ld a, [SWORD_SPRITE_ADDRESS + OAMA_Y]
        add SPRITE_TILE_WIDTH * 2
        ld [SWORD_SPRITE_ADDRESS + OAMA_Y], a
        jp .done
endm

init_sword:
    copy [SWORD_SPRITE_ADDRESS + OAMA_X], 0
    copy [SWORD_SPRITE_ADDRESS + OAMA_Y], 0
    copy [SWORD_SPRITE_ADDRESS + OAMA_TILEID], 15
    copy [SWORD_SPRITE_ADDRESS + OAMA_FLAGS], OAMF_PAL0

    copy [SWORDF], 0
    ret

update_sword:
    ;Check if sword is currently swinging
    ld a, [SWORDF]
    xor SWORD_SWINGING
    jp z, .swing_sword
    copy [rP1], P1F_GET_BTN
    ;wait
    ld a, [rP1]
    ld a, [rP1]
    ld a, [rP1]
    ld a, [rP1]
    ld a, [rP1]

    ;check for sword swing
    ld a, [rP1]
    bit 0, a
    jp nz, .done
    copy [SWORDF], SWORD_SWINGING
    SwingSword

    .swing_sword
    ld a, [SWORD_SPRITE_ADDRESS + OAMA_TILEID]
    add SPRITE_BOTTOM_LEFT_TILE_NUM
    cp LAST_SWORD_ANIMATION_SPRITE
    jp nc, .swing_over
    ld [SWORD_SPRITE_ADDRESS + OAMA_TILEID], a
    jp .done

    .swing_over
        ld a, [SWORDF]
        xor SWORD_SWINGING
        ld [SWORDF], a
        copy [SWORD_SPRITE_ADDRESS + OAMA_X], 0
        copy [SWORD_SPRITE_ADDRESS + OAMA_Y], 0
        copy [SWORD_SPRITE_ADDRESS + OAMA_TILEID], 15

    .done
        ;reset button polling
        ld a, P1F_GET_NONE
        ld [rP1], a
        ret