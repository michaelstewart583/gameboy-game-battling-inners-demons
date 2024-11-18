;Contains methods for controlling inner
;@file inner.asm
;@author Michael Stewart and Mitch Johnson

include "utils.inc"

section "inner", rom0

init_inner:
    ;initializes inner 
    ;X positions
    ld a, [INNER_X_POSITION]
    ld [INNER_SPRITE_0_ADDRESS + OAMA_X], a
    ld [INNER_SPRITE_2_ADDRESS + OAMA_X], a
    add a, SPRITE_TILE_WIDTH
    ld [INNER_SPRITE_1_ADDRESS + OAMA_X], a
    ld [INNER_SPRITE_3_ADDRESS + OAMA_X], a

    ;Y position
    ld a, [INNER_Y_POSITION]
    ld [INNER_SPRITE_0_ADDRESS + OAMA_Y], a
    ld [INNER_SPRITE_1_ADDRESS + OAMA_Y], a
    add a, SPRITE_TILE_WIDTH
    ld [INNER_SPRITE_2_ADDRESS + OAMA_Y], a
    ld [INNER_SPRITE_3_ADDRESS + OAMA_Y], a

    copy [INNER_SPRITE_0_ADDRESS + OAMA_TILEID], SPRITE_TOP_LEFT_TILE_NUM
    copy [INNER_SPRITE_0_ADDRESS + OAMA_FLAGS], OAMF_PAL0

    copy [INNER_SPRITE_1_ADDRESS + OAMA_TILEID], SPRITE_TOP_LEFT_TILE_NUM + 1
    copy [INNER_SPRITE_1_ADDRESS + OAMA_FLAGS], OAMF_PAL0
    
    copy [INNER_SPRITE_2_ADDRESS + OAMA_TILEID], SPRITE_BOTTOM_LEFT_TILE_NUM
    copy [INNER_SPRITE_2_ADDRESS + OAMA_FLAGS], OAMF_PAL0

    copy [INNER_SPRITE_3_ADDRESS + OAMA_TILEID], SPRITE_BOTTOM_LEFT_TILE_NUM + 1
    copy [INNER_SPRITE_3_ADDRESS + OAMA_FLAGS], OAMF_PAL0

    copy [FACING_DIRECTION], PADF_DOWN
    ret


update_inner:
    ;updates the location and sprite tiles of inner to 
    ld hl, INNER_SPRITE_0_ADDRESS
    ;start dpad polling
    ld a, P1F_GET_DPAD
    ld [rP1], a

    ; wait
    ld a, [rP1]

    ; read poll results:
    .poll_right
    ld a, [rP1]
    ld [IS_WALKING], a
    bit 0, a
    jp nz, .left_poll
    .right
        swap a
        ld [FACING_DIRECTION], a
        MoveEntityRight INNER_MOVEMENT_AMOUNT
        jp .up_poll
    .left_poll
    ld a, [rP1]
    bit 1, a
    jp nz, .up_poll
    .left
        swap a
        ld [FACING_DIRECTION], a
        MoveEntityLeft INNER_MOVEMENT_AMOUNT

    .up_poll
    ld a, [rP1]
    bit 2, a
    jp nz, .down_poll
    .up
        swap a
        ld [FACING_DIRECTION], a
        MoveEntityUp INNER_MOVEMENT_AMOUNT
        jp .done

    .down_poll
    ld a, [rP1]
    bit 3, a
    jp nz, .done
    .down
        swap a
        ld [FACING_DIRECTION], a
        MoveEntityDown INNER_MOVEMENT_AMOUNT

    .done
    ld a, P1F_GET_NONE
    ld [rP1], a
    ret
