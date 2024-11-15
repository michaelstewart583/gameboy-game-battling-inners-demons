;Contains methods controling swinging the sword
;@file sword.asm
;@author Michael Stewart and Mitch Johnson

include "utils.inc"

section "sword", rom0

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

macro CheckSwordHit
    copy b, [SWORD_SPRITE_ADDRESS + OAMA_Y]
    ld hl, INNER_DEMONS_START_ADDRESS
    copy c, [NUM_INNER_DEMONS]

    .loop
        push hl
        ;Check if sword is abover Inner Demon
        ld a, [hl]
        sub a, SPRITES_WIDTH
        cp a, b
        jp nc, .done_check
        ;Checks if sword is below Inner Demon
        add a, SPRITES_WIDTH * 2
        cp a, b
        jp c, .done_check
        ;Check horizontal position
        copy b, [SWORD_SPRITE_ADDRESS + OAMA_X]
        ld de, OAMA_X
        add hl, de

        ;Check if sword is to the right of Inner Demon
        ld a, [hl]
        sub a, SPRITES_WIDTH
        cp a, b
        jp nc, .done_check
        ;Checks if sword is to the left of Inner Demon
        add a, SPRITES_WIDTH * 2
        cp a, b
        jp c, .done_check
        pop hl
        jp .kill_inner_demon

        .done_check
        copy b, [SWORD_SPRITE_ADDRESS + OAMA_Y]
        pop hl
        ld de, ENTITY_SIZE
        add hl, de
        dec c
        jp nz, .loop
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
    CheckSwordHit
    jp .done

    .swing_over
        ld a, [SWORDF]
        xor SWORD_SWINGING
        ld [SWORDF], a
        copy [SWORD_SPRITE_ADDRESS + OAMA_X], 0
        copy [SWORD_SPRITE_ADDRESS + OAMA_Y], 0
        copy [SWORD_SPRITE_ADDRESS + OAMA_TILEID], 15
        jp .done

    .kill_inner_demon
        ld c, NUM_SPRITES_IN_ENTITY

        ;Kills the inner demon that was hit by the sword by placing them at 0,0
        .kill_loop
            push hl
            copy [hl], 0
            ld de, OAMA_X
            add hl, de
            copy [de], 0
            pop hl
            ld de, sizeof_OAM_ATTRS
            add hl, de
            dec c
            jp nz, .kill_loop

    .done
        ;reset button polling
        ld a, P1F_GET_NONE
        ld [rP1], a
        ret