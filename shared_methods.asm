;Contains the macros which are shared between inner, and inner_demon
;@file shared_methods.asm
;@author Michael Stewart and Mitch Johnson

macro copy_or_movement
    ;\2 is intended to be a sprite's TileID
    ;Copies value \1 into \2 while maintaining if the sprite is mid step
    ld a, \1
    and %00000010
    or \2
    ld \1, a
endm

macro copy_or_palette
    ;\2 is intended to be a sprite's flags
    ;Copies value \1 into \2 while maintaining it's current palette
    ld a, \1
    and OAMF_PAL1
    or \2
    ld \1, a
endm

macro copy_xor_movement
    ;\2 is intended to be a sprite's TileID
    ;Copies value \1 into \2 while switching if the sprite is mid step
    ld a, \1
    and %00000010
    xor %00000010
    or \2
    ld \1, a
endm

macro MoveEntityRightNoAnimation
    ;store the memory address of the top left sprite address
    push hl
    push bc
    ld bc, OAMA_X
    add hl, bc
    ld a, 0
    ld bc, sizeof_OAM_ATTRS
    ;loop through, starting at the entity address + OAM_X, and jumping in memory by sizeof_OAM_ATTRS
    .right_location_loop
        push af
        ld a, [hl]
        add \1
        ld [hl], a
        add hl, bc
        pop af
        inc a
        cp a, NUM_SPRITES_IN_ENTITY 
        jp nz, .right_location_loop

    ;get the entity address
    pop bc
    pop hl
endm

macro MoveEntityRight
    ;moves the entity with its top left sprite at memory address [hl] \1 pixels to the right
    push bc
    MoveEntityRightNoAnimation \1
    push hl
    ;sprite 0
    ld bc, OAMA_TILEID
    add hl, bc
    ld a, [hl]
    cp a, SPRITE_SIDE_MOVEMENT
    jp c, .start_walking_right
    add 2
    and %01000011
    or %00000001
    ld [hl], a

    ;sprite 1
    dec a
    ld bc, sizeof_OAM_ATTRS
    add hl, bc
    ld [hl], a
    
    ;sprite 2
    add SPRITE_BOTTOM_LEFT_TILE_NUM + 1
    add hl, bc
    ld [hl], a

    ;sprite 3
    dec a
    add hl, bc
    ld [hl], a

    jp .done_right

    .start_walking_right
        pop hl
        push hl
        ld bc, OAMA_TILEID
        add hl, bc
        copy_or_movement [hl], SPRITE_SIDE_MOVEMENT + 1
        ld bc, sizeof_OAM_ATTRS
        add hl, bc
        copy_or_movement [hl], SPRITE_SIDE_MOVEMENT
        add hl, bc
        copy_or_movement [hl], SPRITE_SIDE_MOVEMENT + SPRITE_BOTTOM_LEFT_TILE_NUM + 1
        add hl, bc       
        copy_or_movement [hl], SPRITE_SIDE_MOVEMENT + SPRITE_BOTTOM_LEFT_TILE_NUM

    .done_right
        pop hl
        push hl
        ld bc, OAMA_FLAGS
        add hl, bc
        copy_or_palette [hl], OAMF_XFLIP
        ld bc, sizeof_OAM_ATTRS
        add hl, bc
        copy_or_palette [hl], OAMF_XFLIP
        add hl, bc
        copy_or_palette [hl], OAMF_XFLIP
        add hl, bc
        copy_or_palette [hl], OAMF_XFLIP
    pop hl
    pop bc
endm

macro MoveEntityLeftNoAnimation
    ;store the memory address of the top left sprite address
    push hl
    push bc
    ld bc, OAMA_X
    add hl, bc
    ld a, 0
    ld bc, sizeof_OAM_ATTRS
    ;loop through, starting at the entity address + OAM_X, and jumping in memory by sizeof_OAM_ATTRS
    .left_location_loop
        push af
        ld a, [hl]
        sub \1
        ld [hl], a
        add hl, bc
        pop af
        inc a
        cp a, NUM_SPRITES_IN_ENTITY 
        jp nz, .left_location_loop

    ;restores the state
    pop bc
    pop hl
endm

macro MoveEntityLeft
    ;moves the entity with its top left sprite at memory address [hl] two pixels to the left
    push bc
    MoveEntityLeftNoAnimation \1
    push hl
    ;sprite 0
    ld bc, OAMA_TILEID
    add hl, bc
    ld a, [hl]
    cp a, SPRITE_SIDE_MOVEMENT
    jp c, .start_walking_left
    add 2
    and %01000010
    ld [hl], a

    ;sprite 1
    inc a
    ld bc, sizeof_OAM_ATTRS
    add hl, bc
    ld [hl], a
    
    ;sprite 2
    add SPRITE_BOTTOM_LEFT_TILE_NUM - 1
    add hl, bc
    ld [hl], a

    ;sprite 3
    inc a
    add hl, bc
    ld [hl], a

    jp .done_left

    .start_walking_left
        pop hl
        push hl
        ld bc, OAMA_TILEID
        add hl, bc
        copy_or_movement [hl], SPRITE_SIDE_MOVEMENT
        ld bc, sizeof_OAM_ATTRS
        add hl, bc
        copy_or_movement [hl], SPRITE_SIDE_MOVEMENT + 1
        add hl, bc
        copy_or_movement [hl], SPRITE_SIDE_MOVEMENT + SPRITE_BOTTOM_LEFT_TILE_NUM
        add hl, bc       
        copy_or_movement [hl], SPRITE_SIDE_MOVEMENT + SPRITE_BOTTOM_LEFT_TILE_NUM + 1

    .done_left
        pop hl
        push hl
        ld bc, OAMA_FLAGS
        add hl, bc
        copy_or_palette [hl], 0
        ld bc, sizeof_OAM_ATTRS
        add hl, bc
        copy_or_palette [hl], 0
        add hl, bc
        copy_or_palette [hl], 0
        add hl, bc
        copy_or_palette [hl], 0
    pop hl
    pop bc
endm

macro MoveEntityUpNoAnimation
    ;store the memory address of the top left sprite address
    push hl
    push bc
    ld bc, OAMA_Y
    add hl, bc
    ld a, 0
    ld bc, sizeof_OAM_ATTRS
    ;loop through, starting at the entity address + OAM_X, and jumping in memory by sizeof_OAM_ATTRS
    .up_location_loop
        push af
        ld a, [hl]
        sub \1
        ld [hl], a
        add hl, bc
        pop af
        inc a
        cp a, NUM_SPRITES_IN_ENTITY 
        jp nz, .up_location_loop

    ;restores the state
    pop bc
    pop hl
endm

macro MoveEntityUp
    ;moves the entity with its top left sprite at memory address [hl] two pixels up
    push bc
    MoveEntityUpNoAnimation \1
    push hl
    ;sprite 0
    ld bc, OAMA_TILEID
    add hl, bc
    ld a, [hl]
    cp a, SPRITE_UP_MOVEMENT
    jp c, .start_walking_up
    cp a, SPRITE_SIDE_MOVEMENT
    jp nc, .start_walking_up
    add 2
    and %00001010
    ld [hl], a

    ;sprite 1
    inc a
    ld bc, sizeof_OAM_ATTRS
    add hl, bc
    ld [hl], a
    
    ;sprite 2
    add SPRITE_BOTTOM_LEFT_TILE_NUM - 1
    add hl, bc
    ld [hl], a

    ;sprite 3
    inc a
    add hl, bc
    ld [hl], a

    jp .done_up

    .start_walking_up
        pop hl
        push hl
        ld bc, OAMA_TILEID
        add hl, bc
        copy_xor_movement [hl], SPRITE_UP_MOVEMENT
        ld bc, sizeof_OAM_ATTRS
        add hl, bc
        copy_xor_movement [hl], SPRITE_UP_MOVEMENT + 1
        add hl, bc
        copy_xor_movement [hl], SPRITE_UP_MOVEMENT + SPRITE_BOTTOM_LEFT_TILE_NUM
        add hl, bc       
        copy_xor_movement [hl], SPRITE_UP_MOVEMENT + SPRITE_BOTTOM_LEFT_TILE_NUM + 1

    .done_up
        pop hl
        push hl
        ld bc, OAMA_FLAGS
        add hl, bc
        copy_or_palette [hl], 0
        ld bc, sizeof_OAM_ATTRS
        add hl, bc
        copy_or_palette [hl], 0
        add hl, bc
        copy_or_palette [hl], 0
        add hl, bc
        copy_or_palette [hl], 0
    pop hl
    pop bc
endm

macro MoveEntityDownNoAnimation
    ;store the memory address of the top left sprite address
    push hl
    push bc
    ld bc, OAMA_Y
    add hl, bc
    ld a, 0
    ld bc, sizeof_OAM_ATTRS
    .down_location_loop ;loop through, starting at the entity address + OAM_X, and jumping in memory by sizeof_OAM_ATTRS
        push af
        ld a, [hl]
        add \1
        ld [hl], a
        add hl, bc
        pop af
        inc a
        cp a, NUM_SPRITES_IN_ENTITY 
        jp nz, .down_location_loop

    ;restores the state
    pop bc
    pop hl
endm

macro MoveEntityDown
    ;moves the entity with its top left sprite at memory address [hl] two pixels down
    push bc
    MoveEntityDownNoAnimation \1
    push hl
    ;sprite 0
    ld bc, OAMA_TILEID
    add hl, bc
    ld a, [hl]
    cp a, SPRITE_DOWN_MOVEMENT
    jp c, .start_walking_down
    add 2
    and %00000010
    ld [hl], a

    ;sprite 1
    inc a
    ld bc, sizeof_OAM_ATTRS
    add hl, bc
    ld [hl], a
    
    ;sprite 2
    add SPRITE_BOTTOM_LEFT_TILE_NUM - 1
    add hl, bc
    ld [hl], a

    ;sprite 3
    inc a
    add hl, bc
    ld [hl], a

    jp .done_down

    .start_walking_down
        pop hl
        push hl
        ld bc, OAMA_TILEID
        add hl, bc
        copy_or_movement [hl], SPRITE_DOWN_MOVEMENT
        ld bc, sizeof_OAM_ATTRS
        add hl, bc
        copy_or_movement [hl], SPRITE_DOWN_MOVEMENT + 1
        add hl, bc
        copy_or_movement [hl], SPRITE_DOWN_MOVEMENT + SPRITE_BOTTOM_LEFT_TILE_NUM
        add hl, bc       
        copy_or_movement [hl], SPRITE_DOWN_MOVEMENT + SPRITE_BOTTOM_LEFT_TILE_NUM + 1

    .done_down
        pop hl
        push hl
        ld bc, OAMA_FLAGS
        add hl, bc
        copy_or_palette [hl], 0
        ld bc, sizeof_OAM_ATTRS
        add hl, bc
        copy_or_palette [hl], 0
        add hl, bc
        copy_or_palette [hl], 0
        add hl, bc
        copy_or_palette [hl], 0
    pop hl
    pop bc
endm

check_down
