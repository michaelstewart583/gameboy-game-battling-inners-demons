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

CheckRightMoveValidity:
    ;sets (a) equal to 1 if moving the entity with sprite 0 stored at 
    ;[hl] up by one pixel would result in a collision with a wall and sets 
    ;(a) equal to 0 otherwise
    push hl
    ; byte index that they are in = (x / 8) * 4 + (y / 8)
    ; bit in byte = x mod 8  ;; mod 8 by doing and %00000111
    ; start with 10000000 and shift right by bit in byte times
    ; then once shifted, and it with the byte
    ld de, sizeof_OAM_ATTRS
    add hl, de
    ld de, OAMA_Y
    add hl, de
    ld a, [rSCY] ;look at sprite y coordinate
    sub a, 16
    add a, [hl]
    srl a
    srl a
    srl a 
    ld b, a ;b is now the entity's row number if it moved up by 1
    inc hl 
    ld a, [rSCX] ;now look at sprite's x coordinate
    sub a, 8
    add a, [hl]
    add a, 9 ;moving right by 1 pixel
    srl a
    srl a
    srl a
    ld c, a ;c is the column number
    ld a, b
    ld hl, MAP_WALL_STORAGE_START
    cp a, 0
    jp z, .done_getting_map_row_start_byte
    .get_map_row_start_byte
        ld de, 4
        add hl, de
        dec a
        cp a, 0
        jp nz, .get_map_row_start_byte
    .done_getting_map_row_start_byte
    ld a, c
    srl a
    srl a
    srl a
    cp a, 0
    jp z, .done_getting_map_column_byte
    .get_map_column_start_byte
        inc hl
        dec a
        cp a, 0
        jp nz, .get_map_column_start_byte
    .done_getting_map_column_byte
    ld a, c
    and a, %00000111 ;a mod 8 = bit num (from the left) within byte
    ld c, %10000000 ;bit checker
    cp a, 0
    jp z, .done_determining_bit_location_in_map_byte
    .determine_bit_location_in_map_byte ;sets the bit location of the sprite within the byte equal to 1
        srl c
        dec a
        jp nz, .determine_bit_location_in_map_byte
    .done_determining_bit_location_in_map_byte
    ld a, [hl]
    pop hl
    and a, c ;checking if there is a 1 at the bit location wher the sprite is in the map byte
    ret


macro MoveEntityRight
    ;moves the entity with its top left sprite at memory address [hl] \1 pixels to the right
    call CheckRightMoveValidity
    jp nz, .no_movement_right
    push hl
    ld de, (sizeof_OAM_ATTRS * 2)
    add hl, de
    call CheckRightMoveValidity
    pop hl
    jp nz, .no_movement_right
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
    .no_movement_right
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

CheckLeftMoveValidity:
    ;sets (a) equal to 1 if moving the entity with sprite 0 stored at 
    ;[hl] up by one pixel would result in a collision with a wall and sets 
    ;(a) equal to 0 otherwise
    push hl
    ; byte index that they are in = (x / 8) * 4 + (y / 8)
    ; bit in byte = x mod 8  ;; mod 8 by doing and %00000111
    ; start with 10000000 and shift right by bit in byte times
    ; then once shifted, and it with the byte
    ld de, OAMA_Y
    add hl, de
    ld a, [rSCY] ;look at sprite y coordinate
    sub a, 16
    add a, [hl]
    srl a
    srl a
    srl a 
    ld b, a ;b is now the entity's row number if it moved up by 1
    inc hl 
    ld a, [rSCX] ;now look at sprite's x coordinate
    dec a ;check one pixel to the left
    sub a, 8
    add a, [hl]
    srl a
    srl a
    srl a
    ld c, a ;c is the column number
    ld a, b
    ld hl, MAP_WALL_STORAGE_START
    cp a, 0
    jp z, .done_getting_map_row_start_byte
    .get_map_row_start_byte
        ld de, 4
        add hl, de
        dec a
        cp a, 0
        jp nz, .get_map_row_start_byte
    .done_getting_map_row_start_byte
    ld a, c
    srl a
    srl a
    srl a
    cp a, 0
    jp z, .done_getting_map_column_byte
    .get_map_column_start_byte
        inc hl
        dec a
        cp a, 0
        jp nz, .get_map_column_start_byte
    .done_getting_map_column_byte
    ld a, c
    and a, %00000111 ;a mod 8 = bit num (from the left) within byte
    ld c, %10000000 ;bit checker
    cp a, 0
    jp z, .done_determining_bit_location_in_map_byte
    .determine_bit_location_in_map_byte ;sets the bit location of the sprite within the byte equal to 1
        srl c
        dec a
        jp nz, .determine_bit_location_in_map_byte
    .done_determining_bit_location_in_map_byte
    ld a, [hl]
    pop hl
    and a, c ;checking if there is a 1 at the bit location wher the sprite is in the map byte
    ret


macro MoveEntityLeft
    call CheckLeftMoveValidity
    jp nz, .no_movement_left
    push hl
    ld de, (sizeof_OAM_ATTRS * 2)
    add hl, de
    call CheckLeftMoveValidity
    pop hl
    jp nz, .no_movement_left

    ;moves the entity with its top left sprite at memory address [hl] the argument's pixels to the left
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
    .no_movement_left
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

CheckUpMoveValidity:
    ;sets (a) equal to 1 if moving the entity with sprite 0 stored at 
    ;[hl] up by one pixel would result in a collision with a wall and sets 
    ;(a) equal to 0 otherwise
    push hl
    ; byte index that they are in = (x / 8) * 4 + (y / 8)
    ; bit in byte = x mod 8  ;; mod 8 by doing and %00000111
    ; start with 10000000 and shift right by bit in byte times
    ; then once shifted, and it with the byte

    ld de, OAMA_Y
    add hl, de
    ld a, [rSCY] ;look at sprite y coordinate
    dec a ;move entity up by 1 pixel
    sub a, 16
    add a, [hl]
    srl a
    srl a
    srl a 
    ld b, a ;b is now the entity's row number if it moved up by 1
    inc hl 
    ld a, [rSCX] ;now look at sprite's x coordinate
    sub a, 8
    add a, [hl]
    srl a
    srl a
    srl a
    ld c, a ;c is the column number
    ld a, b
    ld hl, MAP_WALL_STORAGE_START
    cp a, 0
    jp z, .done_getting_map_row_start_byte
    .get_map_row_start_byte
        ld de, 4
        add hl, de
        dec a
        cp a, 0
        jp nz, .get_map_row_start_byte
    .done_getting_map_row_start_byte
    ld a, c
    srl a
    srl a
    srl a
    cp a, 0
    jp z, .done_getting_map_column_byte
    .get_map_column_start_byte
        inc hl
        dec a
        cp a, 0
        jp nz, .get_map_column_start_byte
    .done_getting_map_column_byte
    ld a, c
    and a, %00000111 ;a mod 8 = bit num (from the left) within byte
    ld c, %10000000 ;bit checker
    cp a, 0
    jp z, .done_determining_bit_location_in_map_byte
    .determine_bit_location_in_map_byte ;sets the bit location of the sprite within the byte equal to 1
        srl c
        dec a
        jp nz, .determine_bit_location_in_map_byte
    .done_determining_bit_location_in_map_byte
    ld a, [hl]
    pop hl
    and a, c ;checking if there is a 1 at the bit location wher the sprite is in the map byte
    ret

macro MoveEntityUp
    call CheckUpMoveValidity
    jp nz, .no_movement_up
    push hl
    ld de, sizeof_OAM_ATTRS
    add hl, de
    call CheckUpMoveValidity
    pop hl
    jp nz, .no_movement_up

    ;moves the entity with its top left sprite at memory address [hl] the argument's pixels up
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
    .no_movement_up
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

CheckDownMoveValidity:
    ;sets (a) equal to 1 if moving the entity with sprite 0 stored at 
    ;[hl] up by one pixel would result in a collision with a wall and sets 
    ;(a) equal to 0 otherwise
    push hl
    ; byte index that they are in = (x / 8) * 4 + (y / 8)
    ; bit in byte = x mod 8  ;; mod 8 by doing and %00000111
    ; start with 10000000 and shift right by bit in byte times
    ; then once shifted, and it with the byte
    ld de, (sizeof_OAM_ATTRS * 2)
    add hl, de
    ld de, OAMA_Y
    add hl, de
    ld a, [rSCY] ;look at sprite y coordinate
    add a, 9 ;move entity down by 1 tile
    sub a, 16
    add a, [hl]
    srl a
    srl a
    srl a 
    ld b, a ;b is now the entity's row number if it moved up by 1
    inc hl 
    ld a, [rSCX] ;now look at sprite's x coordinate
    sub a, 8
    add a, [hl]
    srl a
    srl a
    srl a
    ld c, a ;c is the column number
    ld a, b
    ld hl, MAP_WALL_STORAGE_START
    cp a, 0
    jp z, .done_getting_map_row_start_byte
    .get_map_row_start_byte
        ld de, 4
        add hl, de
        dec a
        cp a, 0
        jp nz, .get_map_row_start_byte
    .done_getting_map_row_start_byte
    ld a, c
    srl a
    srl a
    srl a
    cp a, 0
    jp z, .done_getting_map_column_byte
    .get_map_column_start_byte
        inc hl
        dec a
        cp a, 0
        jp nz, .get_map_column_start_byte
    .done_getting_map_column_byte
    ld a, c
    and a, %00000111 ;a mod 8 = bit num (from the left) within byte
    ld c, %10000000 ;bit checker
    cp a, 0
    jp z, .done_determining_bit_location_in_map_byte
    .determine_bit_location_in_map_byte ;sets the bit location of the sprite within the byte equal to 1
        srl c
        dec a
        jp nz, .determine_bit_location_in_map_byte
    .done_determining_bit_location_in_map_byte
    ld a, [hl]
    pop hl
    and a, c ;checking if there is a 1 at the bit location wher the sprite is in the map byte
    ret

macro MoveEntityDown
    call CheckDownMoveValidity
    jp nz, .no_movement_down
    push hl
    ld de, sizeof_OAM_ATTRS
    add hl, de
    call CheckDownMoveValidity
    pop hl
    jp nz, .no_movement_down
    ;moves the entity with its top left sprite at memory address [hl] [arg1] pixels down
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
    .no_movement_down
endm



