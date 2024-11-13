;Contains methods for controlling inner
;@file inner.asm
;@author Michael Stewart and Mitch Johnson

include "utils.inc"

section "inner", rom0

def NUM_SPRITES_IN_ENTITY equ (4)
def ENTITY_SIZE equ(NUM_SPRITES_IN_ENTITY * sizeof_OAM_ATTRS)
def NUM_INNER_DEMONS equ (3)
def TOTAL_SPRITE_SIZE equ((5 + (NUM_INNER_DEMONS * NUM_SPRITES_IN_ENTITY)) * sizeof_OAM_ATTRS)

rsset _OAMRAM

def SWORD_SPRITE_ADDRESS_OAM rb sizeof_OAM_ATTRS
def INNER_SPRITE_0_ADDRESS_OAM rb sizeof_OAM_ATTRS
def INNER_SPRITE_1_ADDRESS_OAM rb sizeof_OAM_ATTRS
def INNER_SPRITE_2_ADDRESS_OAM rb sizeof_OAM_ATTRS
def INNER_SPRITE_3_ADDRESS_OAM rb sizeof_OAM_ATTRS
def INNER_DEMONS_START_ADDRESS_OAM rb (NUM_INNER_DEMONS * ENTITY_SIZE)


rsset _RAM

def SWORD_SPRITE_ADDRESS rb sizeof_OAM_ATTRS
def INNER_SPRITE_0_ADDRESS rb sizeof_OAM_ATTRS
def INNER_SPRITE_1_ADDRESS rb sizeof_OAM_ATTRS
def INNER_SPRITE_2_ADDRESS rb sizeof_OAM_ATTRS
def INNER_SPRITE_3_ADDRESS rb sizeof_OAM_ATTRS
def INNER_DEMONS_START_ADDRESS rb (NUM_INNER_DEMONS * ENTITY_SIZE)
def SCREEN_X rb 1
def SCREEN_Y rb 1

def FACING_DIRECTION rb 1
def IS_WALKING rb 1

def SPRITE_TOP_LEFT_X equ (16)
def SPRITE_TOP_LEFT_Y equ (85)
def SPRITE_TILE_WIDTH equ (8)
def SPRITE_TOP_LEFT_TILE_NUM equ (0)
def SPRITE_BOTTOM_LEFT_TILE_NUM equ (16)
def SPRITE_DOWN_MOVEMENT equ (0)
def SPRITE_UP_MOVEMENT equ (8)
def SPRITE_SIDE_MOVEMENT equ (64)

def INNER_MOVEMENT_AMOUNT equ (2)



init_inner:
    ;initializes inner 
    copy [INNER_SPRITE_0_ADDRESS + OAMA_X], SPRITE_TOP_LEFT_X
    copy [INNER_SPRITE_0_ADDRESS + OAMA_Y], SPRITE_TOP_LEFT_Y
    copy [INNER_SPRITE_0_ADDRESS + OAMA_TILEID], SPRITE_TOP_LEFT_TILE_NUM
    copy [INNER_SPRITE_0_ADDRESS + OAMA_FLAGS], OAMF_PAL0

    copy [INNER_SPRITE_1_ADDRESS + OAMA_X], SPRITE_TOP_LEFT_X + SPRITE_TILE_WIDTH
    copy [INNER_SPRITE_1_ADDRESS + OAMA_Y], SPRITE_TOP_LEFT_Y
    copy [INNER_SPRITE_1_ADDRESS + OAMA_TILEID], SPRITE_TOP_LEFT_TILE_NUM + 1
    copy [INNER_SPRITE_1_ADDRESS + OAMA_FLAGS], OAMF_PAL0
    
    copy [INNER_SPRITE_2_ADDRESS + OAMA_X], SPRITE_TOP_LEFT_X
    copy [INNER_SPRITE_2_ADDRESS + OAMA_Y], SPRITE_TOP_LEFT_Y + SPRITE_TILE_WIDTH
    copy [INNER_SPRITE_2_ADDRESS + OAMA_TILEID], SPRITE_BOTTOM_LEFT_TILE_NUM
    copy [INNER_SPRITE_2_ADDRESS + OAMA_FLAGS], OAMF_PAL0

    copy [INNER_SPRITE_3_ADDRESS + OAMA_X], SPRITE_TOP_LEFT_X + SPRITE_TILE_WIDTH
    copy [INNER_SPRITE_3_ADDRESS + OAMA_Y], SPRITE_TOP_LEFT_Y + SPRITE_TILE_WIDTH
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
