section "map_rep", rom0

init_map_1_walls:
    ld de, MAP_WALL_STORAGE_START
    ;row 0
    copy [de], %11111111
    inc de
    copy [de], %11111111
    inc de
    copy [de], %11111111
    inc de
    copy [de], %11111111
    inc de
    ;row 1
    copy [de], %11111111
    inc de
    copy [de], %11111111
    inc de
    copy [de], %11111111
    inc de
    copy [de], %11111111
    inc de
    ;row 2
    copy [de], %11111111
    inc de
    copy [de], %11111111
    inc de
    copy [de], %11111111
    inc de
    copy [de], %11111111
    inc de
    ;row 3
    copy [de], %11100000
    inc de
    copy [de], %00000000
    inc de
    copy [de], %00111111
    inc de
    copy [de], %00000111
    inc de
    ;row 4
    copy [de], %11100000
    inc de
    copy [de], %00000000
    inc de
    copy [de], %00111111
    inc de
    copy [de], %00000111
    inc de
    ;row 5
    copy [de], %11100000
    inc de
    copy [de], %00000000
    inc de
    copy [de], %00111111
    inc de
    copy [de], %00000111
    inc de
    ;row 6
    copy [de], %11100011
    inc de
    copy [de], %11111110
    inc de
    copy [de], %00111111
    inc de
    copy [de], %00000000
    inc de
    ;row 7
    copy [de], %11100011
    inc de
    copy [de], %11111110
    inc de
    copy [de], %00111111
    inc de
    copy [de], %00000000
    inc de
    ;row 8
    copy [de], %11100011
    inc de
    copy [de], %11111110
    inc de
    copy [de], %00111111
    inc de
    copy [de], %00000000
    inc de
    ;row 9
    copy [de], %11100000
    inc de
    copy [de], %01110000
    inc de
    copy [de], %00111111
    inc de
    copy [de], %00000111
    inc de
    ;row 10
    copy [de], %11100000
    inc de
    copy [de], %01110000
    inc de
    copy [de], %00111111
    inc de
    copy [de], %00000111
    inc de
    ;row 11
    copy [de], %11100000
    inc de
    copy [de], %01110000
    inc de
    copy [de], %00111111
    inc de
    copy [de], %00000111
    inc de
    ;row 12
    copy [de], %11111100
    inc de
    copy [de], %01110001
    inc de
    copy [de], %11111111
    inc de
    copy [de], %00000111
    inc de
    ;row 13
    copy [de], %11111100
    inc de
    copy [de], %01110001
    inc de
    copy [de], %11111111
    inc de
    copy [de], %00000111
    inc de
    ;row 14
    copy [de], %11111100
    inc de
    copy [de], %01110001
    inc de
    copy [de], %11111111
    inc de
    copy [de], %00000111
    inc de
    ;row 15
    copy [de], %00000000
    inc de
    copy [de], %01110001
    inc de
    copy [de], %11000111
    inc de
    copy [de], %00111111
    inc de
    ;row 16
    copy [de], %00000000
    inc de
    copy [de], %01110001
    inc de
    copy [de], %11000111
    inc de
    copy [de], %00111111
    inc de
    ;row 17
    copy [de], %11100000
    inc de
    copy [de], %01110001
    inc de
    copy [de], %11000111
    inc de
    copy [de], %00111111
    inc de
    ;row 18
    copy [de], %11100011
    inc de
    copy [de], %11110001
    inc de
    copy [de], %11000111
    inc de
    copy [de], %00000111
    inc de
    ;row 19
    copy [de], %11100011
    inc de
    copy [de], %11110001
    inc de
    copy [de], %11000111
    inc de
    copy [de], %00000111
    inc de
    ;row 20
    copy [de], %11100011
    inc de
    copy [de], %11110001
    inc de
    copy [de], %11000111
    inc de
    copy [de], %00000111
    inc de
    ;row 21
    copy [de], %11100000
    inc de
    copy [de], %11110000
    inc de
    copy [de], %00000111
    inc de
    copy [de], %11100111
    inc de
    ;row 22
    copy [de], %11100000
    inc de
    copy [de], %11110000
    inc de
    copy [de], %00000111
    inc de
    copy [de], %11100111
    inc de
    ;row 23
    copy [de], %11100000
    inc de
    copy [de], %11110000
    inc de
    copy [de], %00000111
    inc de
    copy [de], %11100111
    inc de
    ;row 24
    copy [de], %11100000
    inc de
    copy [de], %11110001
    inc de
    copy [de], %11000111
    inc de
    copy [de], %00000111
    inc de
    ;row 25
    copy [de], %11100000
    inc de
    copy [de], %11110001
    inc de
    copy [de], %11000111
    inc de
    copy [de], %00000111
    inc de
    ;row 26
    copy [de], %11100000
    inc de
    copy [de], %11110001
    inc de
    copy [de], %11000111
    inc de
    copy [de], %00000111
    inc de
    ;row 27
    copy [de], %11100000
    inc de
    copy [de], %11110001
    inc de
    copy [de], %11000000
    inc de
    copy [de], %00000111
    inc de
    ;row 28
    copy [de], %11100000
    inc de
    copy [de], %11110001
    inc de
    copy [de], %11000000
    inc de
    copy [de], %00000111
    inc de
    ;row 29
    copy [de], %11111111
    inc de
    copy [de], %11110001
    inc de
    copy [de], %11000000
    inc de
    copy [de], %00000111
    inc de
    ;row 30
    copy [de], %11111111
    inc de
    copy [de], %11111111
    inc de
    copy [de], %11111111
    inc de
    copy [de], %11111111
    inc de
    ;row 31
    copy [de], %11111111
    inc de
    copy [de], %11111111
    inc de
    copy [de], %11111111
    inc de
    copy [de], %11111111
ret

init_map_2_walls:
    ld de, MAP_WALL_STORAGE_START
    ;row 0
    copy [de], %11111111
    inc de
    copy [de], %11111111
    inc de
    copy [de], %11111111
    inc de
    copy [de], %11111111
    inc de
    ;row 1
    copy [de], %11111111
    inc de
    copy [de], %11111111
    inc de
    copy [de], %11111111
    inc de
    copy [de], %11111111
    inc de
    ;row 2
    copy [de], %11111111
    inc de
    copy [de], %11111111
    inc de
    copy [de], %11111111
    inc de
    copy [de], %11111111
    inc de
    ;row 3
    copy [de], %11100000
    inc de
    copy [de], %00000000
    inc de
    copy [de], %00000000
    inc de
    copy [de], %00000011
    inc de
    ;row 4
    copy [de], %11100000
    inc de
    copy [de], %00000000
    inc de
    copy [de], %00000000
    inc de
    copy [de], %00000011
    inc de
    ;row 5
    copy [de], %11100000
    inc de
    copy [de], %00000000
    inc de
    copy [de], %00000000
    inc de
    copy [de], %00000011
    inc de
    ;row 6
    copy [de], %11100011
    inc de
    copy [de], %10001110
    inc de
    copy [de], %00111111
    inc de
    copy [de], %11111111
    inc de
    ;row 7
    copy [de], %11100011
    inc de
    copy [de], %10001110
    inc de
    copy [de], %00111111
    inc de
    copy [de], %11111111
    inc de
    ;row 8
    copy [de], %11100011
    inc de
    copy [de], %10001110
    inc de
    copy [de], %00111111
    inc de
    copy [de], %11111111
    inc de
    ;row 9
    copy [de], %11100011
    inc de
    copy [de], %10001110
    inc de
    copy [de], %00111000
    inc de
    copy [de], %00000000
    inc de
    ;row 10
    copy [de], %11100011
    inc de
    copy [de], %10001110
    inc de
    copy [de], %00111000
    inc de
    copy [de], %00000000
    inc de
    ;row 11
    copy [de], %11100011
    inc de
    copy [de], %10001110
    inc de
    copy [de], %00111000
    inc de
    copy [de], %00000000
    inc de
    ;row 12
    copy [de], %00000011
    inc de
    copy [de], %10001110
    inc de
    copy [de], %00111000
    inc de
    copy [de], %11111111
    inc de
    ;row 13
    copy [de], %00000011
    inc de
    copy [de], %10001110
    inc de
    copy [de], %00111000
    inc de
    copy [de], %11111111
    inc de
    ;row 14
    copy [de], %00000011
    inc de
    copy [de], %10001110
    inc de
    copy [de], %00111000
    inc de
    copy [de], %11111111
    inc de
    ;row 15
    copy [de], %11100011
    inc de
    copy [de], %10001110
    inc de
    copy [de], %00111000
    inc de
    copy [de], %11100011
    inc de
    ;row 16
    copy [de], %11100011
    inc de
    copy [de], %10001110
    inc de
    copy [de], %00111000
    inc de
    copy [de], %11100011
    inc de
    ;row 17
    copy [de], %11100011
    inc de
    copy [de], %10001110
    inc de
    copy [de], %00111000
    inc de
    copy [de], %11100011
    inc de
    ;row 18
    copy [de], %11100011
    inc de
    copy [de], %11111110
    inc de
    copy [de], %00111000
    inc de
    copy [de], %11100011
    inc de
    ;row 19
    copy [de], %11100011
    inc de
    copy [de], %11111110
    inc de
    copy [de], %00111000
    inc de
    copy [de], %11100011
    inc de
    ;row 20
    copy [de], %11100011
    inc de
    copy [de], %11111110
    inc de
    copy [de], %00111000
    inc de
    copy [de], %11100011
    inc de
    ;row 21
    copy [de], %11100011
    inc de
    copy [de], %10000000
    inc de
    copy [de], %00000000
    inc de
    copy [de], %00000011
    inc de
    ;row 22
    copy [de], %11100011
    inc de
    copy [de], %10000000
    inc de
    copy [de], %00000000
    inc de
    copy [de], %00000011
    inc de
    ;row 23
    copy [de], %11100011
    inc de
    copy [de], %10000000
    inc de
    copy [de], %00000000
    inc de
    copy [de], %00000011
    inc de
    ;row 24
    copy [de], %11100011
    inc de
    copy [de], %11111111
    inc de
    copy [de], %11111111
    inc de
    copy [de], %11100011
    inc de
    ;row 25
    copy [de], %11100011
    inc de
    copy [de], %11111111
    inc de
    copy [de], %11111111
    inc de
    copy [de], %11100011
    inc de
    ;row 26
    copy [de], %11100011
    inc de
    copy [de], %11111111
    inc de
    copy [de], %11111111
    inc de
    copy [de], %11100011
    inc de
    ;row 27
    copy [de], %11100000
    inc de
    copy [de], %00000001
    inc de
    copy [de], %11000000
    inc de
    copy [de], %00000011
    inc de
    ;row 28
    copy [de], %11100000
    inc de
    copy [de], %00000001
    inc de
    copy [de], %11000000
    inc de
    copy [de], %00000011
    inc de
    ;row 29
    copy [de], %11100000
    inc de
    copy [de], %00000001
    inc de
    copy [de], %11000000
    inc de
    copy [de], %00000011
    inc de
    ;row 30
    copy [de], %11111111
    inc de
    copy [de], %11111111
    inc de
    copy [de], %11111111
    inc de
    copy [de], %11111111
    inc de
    ;row 31
    copy [de], %11111111
    inc de
    copy [de], %11111111
    inc de
    copy [de], %11111111
    inc de
    copy [de], %11111111
ret

init_map_3_walls:
    ld de, MAP_WALL_STORAGE_START
    ;row 0
    ;...
ret

    










