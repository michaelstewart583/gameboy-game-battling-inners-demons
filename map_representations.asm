def MAP_SIDE_LENGTH equ(32)

def MAP_MEMORY_SIZE = equ((MAP_SIDE_LENGTH / 8) * (MAP_SIDE_LENGTH) / 8)

def MAP_1_WALLS_STORAGE_START rb MAP_MEMORY_SIZE

def MAP_2_WALL_STORAGE_START rb MAP_MEMORY_SIZE

def MAP_3_WALL_STORAGE_START rb MAP_MEMORY_SIZE


init_map_1_walls:
    ld de, MAP_1_WALLS_STORAGE_START
    ;row 0
    ld [de], %11111111
    inc de
    ld [de], %11111111
    inc de
    ld [de], %11111111
    inc de
    ld [de], %11111111
    inc de
    ;row 1
    ld [de], %11111111
    inc de
    ld [de], %11111111
    inc de
    ld [de], %11111111
    inc de
    ld [de], %11111111
    inc de
    ;row 2
    ld [de], %11111111
    inc de
    ld [de], %11111111
    inc de
    ld [de], %11111111
    inc de
    ld [de], %11111111
    inc de
    ;row 3
    ld [de], %11100000
    inc de
    ld [de], %00000000
    inc de
    ld [de], %00111111
    inc de
    ld [de], %00000111
    inc de
    ;row 4
    ld [de], %11100000
    inc de
    ld [de], %00000000
    inc de
    ld [de], %00111111
    inc de
    ld [de], %00000111
    inc de
    ;row 5
    ld [de], %11100000
    inc de
    ld [de], %00000000
    inc de
    ld [de], %00111111
    inc de
    ld [de], %00000111
    inc de
    ;row 6
    ld [de], %11100011
    inc de
    ld [de], %11111110
    inc de
    ld [de], %00111111
    inc de
    ld [de], %00000000
    inc de
    ;row 7
    ld [de], %11100011
    inc de
    ld [de], %11111110
    inc de
    ld [de], %00111111
    inc de
    ld [de], %00000000
    inc de
    ;row 8
    ld [de], %11100011
    inc de
    ld [de], %11111110
    inc de
    ld [de], %00111111
    inc de
    ld [de], %00000000
    inc de
    ;row 9
    ld [de], %11100000
    inc de
    ld [de], %01110000
    inc de
    ld [de], %00111111
    inc de
    ld [de], %00000111
    inc de
    ;row 10
    ld [de], %11100000
    inc de
    ld [de], %01110000
    inc de
    ld [de], %00111111
    inc de
    ld [de], %00000111
    inc de
    ;row 11
    ld [de], %11100000
    inc de
    ld [de], %01110000
    inc de
    ld [de], %00111111
    inc de
    ld [de], %00000111
    inc de
    ;row 12
    ld [de], %11111100
    inc de
    ld [de], %01110001
    inc de
    ld [de], %11111111
    inc de
    ld [de], %00000111
    inc de
    ;row 13
    ld [de], %11111100
    inc de
    ld [de], %01110001
    inc de
    ld [de], %11111111
    inc de
    ld [de], %00000111
    inc de
    ;row 14
    ld [de], %11111100
    inc de
    ld [de], %01110001
    inc de
    ld [de], %11111111
    inc de
    ld [de], %00000111
    inc de
    ;row 15
    ld [de], %00000000
    inc de
    ld [de], %01110001
    inc de
    ld [de], %11000111
    inc de
    ld [de], %00111111
    inc de
    ;row 16
    ld [de], %00000000
    inc de
    ld [de], %01110001
    inc de
    ld [de], %11000111
    inc de
    ld [de], %00111111
    inc de
    ;row 17
    ld [de], %11100000
    inc de
    ld [de], %01110001
    inc de
    ld [de], %11000111
    inc de
    ld [de], %00111111
    inc de
    ;row 18
    ld [de], %11100011
    inc de
    ld [de], %11110001
    inc de
    ld [de], %11000111
    inc de
    ld [de], %00000111
    inc de
    ;row 19
    ld [de], %11100011
    inc de
    ld [de], %11110001
    inc de
    ld [de], %11000111
    inc de
    ld [de], %00000111
    inc de
    ;row 20
    ld [de], %11100011
    inc de
    ld [de], %11110001
    inc de
    ld [de], %11000111
    inc de
    ld [de], %00000111
    inc de
    ;row 21
    ld [de], %11100000
    inc de
    ld [de], %11110000
    inc de
    ld [de], %00000111
    inc de
    ld [de], %11100111
    inc de
    ;row 22
    ld [de], %11100000
    inc de
    ld [de], %11110000
    inc de
    ld [de], %00000111
    inc de
    ld [de], %11100111
    inc de
    ;row 23
    ld [de], %11100000
    inc de
    ld [de], %11110000
    inc de
    ld [de], %00000111
    inc de
    ld [de], %11100111
    inc de
    ;row 24
    ld [de], %11100000
    inc de
    ld [de], %11110001
    inc de
    ld [de], %11000111
    inc de
    ld [de], %00000111
    inc de
    ;row 25
    ld [de], %11100000
    inc de
    ld [de], %11110001
    inc de
    ld [de], %11000111
    inc de
    ld [de], %00000111
    inc de
    ;row 26
    ld [de], %11100000
    inc de
    ld [de], %11110001
    inc de
    ld [de], %11000111
    inc de
    ld [de], %00000111
    inc de
    ;row 27
    ld [de], %11100000
    inc de
    ld [de], %11110001
    inc de
    ld [de], %11000000
    inc de
    ld [de], %00000111
    inc de
    ;row 28
    ld [de], %11100000
    inc de
    ld [de], %11110001
    inc de
    ld [de], %11000000
    inc de
    ld [de], %00000111
    inc de
    ;row 29
    ld [de], %11111111
    inc de
    ld [de], %11110001
    inc de
    ld [de], %11000000
    inc de
    ld [de], %00000111
    inc de
    ;row 30
    ld [de], %11111111
    inc de
    ld [de], %11111111
    inc de
    ld [de], %11111111
    inc de
    ld [de], %11111111
    inc de
    ;row 31
    ld [de], %11111111
    inc de
    ld [de], %11111111
    inc de
    ld [de], %11111111
    inc de
    ld [de], %11111111
ret


init_map_2_walls:
    ld de, MAP_2_WALLS_STORAGE_START
    ;row 0
    ld [de], %11111111
    inc de
    ld [de], %11111111
    inc de
    ld [de], %11111111
    inc de
    ld [de], %11111111
    inc de
    ;row 1
    ld [de], %11111111
    inc de
    ld [de], %11111111
    inc de
    ld [de], %11111111
    inc de
    ld [de], %11111111
    inc de
    ;row 2
    ld [de], %11111111
    inc de
    ld [de], %11111111
    inc de
    ld [de], %11111111
    inc de
    ld [de], %11111111
    inc de
    ;row 3
    ld [de], %11100000
    inc de
    ld [de], %00000000
    inc de
    ld [de], %00000000
    inc de
    ld [de], %00000011
    inc de
    ;row 4
    ld [de], %11100000
    inc de
    ld [de], %00000000
    inc de
    ld [de], %00000000
    inc de
    ld [de], %00000011
    inc de
    ;row 5
    ld [de], %11100000
    inc de
    ld [de], %00000000
    inc de
    ld [de], %00000000
    inc de
    ld [de], %00000011
    inc de
    ;row 6
    ld [de], %11100011
    inc de
    ld [de], %10001110
    inc de
    ld [de], %00111111
    inc de
    ld [de], %11111111
    inc de
    ;row 7
    ld [de], %11100011
    inc de
    ld [de], %10001110
    inc de
    ld [de], %00111111
    inc de
    ld [de], %11111111
    inc de
    ;row 8
    ld [de], %11100011
    inc de
    ld [de], %10001110
    inc de
    ld [de], %00111111
    inc de
    ld [de], %11111111
    inc de
    ;row 9
    ld [de], %11100011
    inc de
    ld [de], %10001110
    inc de
    ld [de], %00111000
    inc de
    ld [de], %00000000
    inc de
    ;row 10
    ld [de], %11100011
    inc de
    ld [de], %10001110
    inc de
    ld [de], %00111000
    inc de
    ld [de], %00000000
    inc de
    ;row 11
    ld [de], %11100011
    inc de
    ld [de], %10001110
    inc de
    ld [de], %00111000
    inc de
    ld [de], %00000000
    inc de
    ;row 12
    ld [de], %00000011
    inc de
    ld [de], %10001110
    inc de
    ld [de], %00111000
    inc de
    ld [de], %11111111
    inc de
    ;row 13
    ld [de], %00000011
    inc de
    ld [de], %10001110
    inc de
    ld [de], %00111000
    inc de
    ld [de], %11111111
    inc de
    ;row 14
    ld [de], %00000011
    inc de
    ld [de], %10001110
    inc de
    ld [de], %00111000
    inc de
    ld [de], %11111111
    inc de
    ;row 15
    ld [de], %11100011
    inc de
    ld [de], %10001110
    inc de
    ld [de], %00111000
    inc de
    ld [de], %11100011
    inc de
    ;row 16
    ld [de], %11100011
    inc de
    ld [de], %10001110
    inc de
    ld [de], %00111000
    inc de
    ld [de], %11100011
    inc de
    ;row 17
    ld [de], %11100011
    inc de
    ld [de], %10001110
    inc de
    ld [de], %00111000
    inc de
    ld [de], %11100011
    inc de
    ;row 18
    ld [de], %11100011
    inc de
    ld [de], %11111110
    inc de
    ld [de], %00111000
    inc de
    ld [de], %11100011
    inc de
    ;row 19
    ld [de], %11100011
    inc de
    ld [de], %11111110
    inc de
    ld [de], %00111000
    inc de
    ld [de], %11100011
    inc de
    ;row 20
    ld [de], %11100011
    inc de
    ld [de], %11111110
    inc de
    ld [de], %00111000
    inc de
    ld [de], %11100011
    inc de
    ;row 21
    ld [de], %11100011
    inc de
    ld [de], %10000000
    inc de
    ld [de], %00000000
    inc de
    ld [de], %00000011
    inc de
    ;row 22
    ld [de], %11100011
    inc de
    ld [de], %10000000
    inc de
    ld [de], %00000000
    inc de
    ld [de], %00000011
    inc de
    ;row 23
    ld [de], %11100011
    inc de
    ld [de], %10000000
    inc de
    ld [de], %00000000
    inc de
    ld [de], %00000011
    inc de
    ;row 24
    ld [de], %11100011
    inc de
    ld [de], %11111111
    inc de
    ld [de], %11111111
    inc de
    ld [de], %11100011
    inc de
    ;row 25
    ld [de], %11100011
    inc de
    ld [de], %11111111
    inc de
    ld [de], %11111111
    inc de
    ld [de], %11100011
    inc de
    ;row 26
    ld [de], %11100011
    inc de
    ld [de], %11111111
    inc de
    ld [de], %11111111
    inc de
    ld [de], %11100011
    inc de
    ;row 27
    ld [de], %11100000
    inc de
    ld [de], %00000001
    inc de
    ld [de], %11000000
    inc de
    ld [de], %00000011
    inc de
    ;row 28
    ld [de], %11100000
    inc de
    ld [de], %00000001
    inc de
    ld [de], %11000000
    inc de
    ld [de], %00000011
    inc de
    ;row 29
    ld [de], %11100000
    inc de
    ld [de], %00000001
    inc de
    ld [de], %11000000
    inc de
    ld [de], %00000011
    inc de
    ;row 30
    ld [de], %11111111
    inc de
    ld [de], %11111111
    inc de
    ld [de], %11111111
    inc de
    ld [de], %11111111
    inc de
    ;row 31
    ld [de], %11111111
    inc de
    ld [de], %11111111
    inc de
    ld [de], %11111111
    inc de
    ld [de], %11111111
ret

init_map_3_walls:
    ld de, MAP_3_WALLS_STORAGE_START
    ;row 0
    ;...
ret

    










