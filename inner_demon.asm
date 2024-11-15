;Contains methods about moving the inner_demons
;@file inner_demon.asm
;@author Michael Stewart and Mitch Johnson

include "utils.inc"

section "inner_demon", rom0

init_inner_demons:
    ;spawns NUM_INNER_DEMONS spread out accross the screen in a line
    ld a, 0
    ld hl, INNER_DEMONS_START_ADDRESS
    ld bc, SPRITE_ATTRIBUTE_SIZE
    ld d, INNER_DEMONS_SPAWN_POINT_Y
    ld e, INNER_DEMONS_SPAWN_POINT_X
    ;looping through and initializing each inner demon in OAM
    .loop
        ;initializes the SPRITE_0 of an inner demon
        push af
        copy [hl], d
        add hl, bc
        copy [hl], e
        add hl, bc
        copy [hl], SPRITE_TOP_LEFT_TILE_NUM
        add hl, bc
        copy [hl], OAMF_PAL1
    
        ;initializes the SPRITE_1 of an inner demon
        add hl, bc
        copy [hl], d 
        add hl, bc
        ld a, e
        add a, SPRITE_TILE_WIDTH
        copy [hl], a
        add hl, bc
        copy [hl], SPRITE_TOP_LEFT_TILE_NUM + 1
        add hl, bc
        copy [hl], OAMF_PAL1
        
        ;initializes the SPRITE_2 of an inner demon
        add hl, bc
        ld a, d
        add a, SPRITE_TILE_WIDTH
        copy [hl], a
        add hl, bc
        copy [hl], e
        add hl, bc
        copy [hl], SPRITE_BOTTOM_LEFT_TILE_NUM
        add hl, bc
        copy [hl], OAMF_PAL1
    
        ;initializes the SPRITE_3 of an inner demon
        add hl, bc
        ld a, d
        add a, SPRITE_TILE_WIDTH
        copy [hl], a
        add hl, bc
        ld a, e
        add a, SPRITE_TILE_WIDTH
        copy [hl], a
        add hl, bc
        copy [hl], SPRITE_BOTTOM_LEFT_TILE_NUM + 1
        add hl, bc
        copy [hl], OAMF_PAL1
        add hl, bc

        ;incrementing the offset so that inner demons are spread out in a line accross screen
        ld a, d
        add a, INNER_DEMONS_SPAWN_Y_OFFSET
        ld d, a
        ld a, e
        add a, INNER_DEMONS_SPAWN_X_OFFSET
        ld e, a
        pop af
        inc a
        push hl
        ld hl, NUM_INNER_DEMONS
        cp a, [hl]
        pop hl
        jp nz, .loop
    ret

macro calculate_inner_demon_movement_vector
    ;returns the optimal vector (_, _) in (bc) for the inner demon 
    ;who is stored in OAM at address [hl] to get to inner
    push hl

    ;calculating x component of the vector that goes from inner's location to inner demon's location 
    ld bc, 0
    ld a, [INNER_SPRITE_0_ADDRESS + OAMA_X] 
    ld b, a 
    ld de, OAMA_X
    add hl, de
    ld a, [hl]
    sub a, b
    jp z, .inner_x_is_inline_with_demon 
    jp c, .inner_x_is_right_of_demon
    jp .inner_x_left_of_demon

    ;determining x direction that inner demon should go
    .inner_x_is_inline_with_demon
        ld b, 0
        jp .done_x
    .inner_x_is_right_of_demon
        ld b, 1
        jp .done_x
    .inner_x_left_of_demon
        ld b, -1
        jp .done_x
    .done_x

    pop hl
    push hl
    push bc 

    ;calculating y component of the vector that goes from inner's location to inner demon's location 
    ld a, [INNER_SPRITE_0_ADDRESS + OAMA_Y] 
    ld b, a ;inner y coordinate
    ld de, OAMA_Y
    add hl, de
    ld a, [hl] ;inner demon y coordinate
    sub a, b
    pop bc ;pop back off stack so we can store y move in c
    jp z, .inner_y_is_inline_with_demon 
    jp c, .inner_y_below_demon
    jp .inner_y_is_above_demon

    ;determining x direction that inner demon should go
    .inner_y_is_inline_with_demon
        ld c, 0
        jp .done_y
    .inner_y_below_demon
        ld c, 1
        jp .done_y
    .inner_y_is_above_demon
        ld c, -1
        jp .done_y
    .done_y
    pop hl
endm

move_inner_demons:
    ;moves all inner demons (one demon per frame) towards inner 
    ld a, 0
    ld hl, INNER_DEMONS_START_ADDRESS
    ;looping through all inner demons
    .loop
        push af
        push hl
        calculate_inner_demon_movement_vector

        .x_movement
            ld a, b
            cp a, 1
            jp z, .move_entity_right_call
            ld a, b
            cp a, -1
            jp z, .move_entity_left_call
            jp .y_movement
            .move_entity_right_call
                MoveEntityRight INNER_DEMEON_MOVEMENT_AMOUNT
                jp .y_movement
            .move_entity_left_call
                MoveEntityLeft INNER_DEMEON_MOVEMENT_AMOUNT
                jp .y_movement
            
        .y_movement
            ld a, c
            cp a, 1
            jp z, .move_entity_down_call
            ld a, c
            cp a, -1
            jp z, .move_entity_up_call
            jp .done_y_movement
            .move_entity_up_call
                MoveEntityUp INNER_DEMEON_MOVEMENT_AMOUNT
                jp .done_y_movement
            .move_entity_down_call
                MoveEntityDown INNER_DEMEON_MOVEMENT_AMOUNT
                jp .done_y_movement
        .done_y_movement

        pop hl
        ld bc, ENTITY_SIZE
        add hl, bc
        pop af
        inc a
        push hl
        ld hl, NUM_INNER_DEMONS
        cp a, [hl]
        pop hl
        jp nz, .loop
    .done
    ret