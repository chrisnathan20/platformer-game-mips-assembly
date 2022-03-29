##################################################################### 
# 
# CSCB58 Winter 2022 Assembly Final Project 
# University of Toronto, Scarborough 
# 
# Student: Christopher Nathanael, 1006853870, nathana6, Christopher Nathanael 
# 
# Bitmap Display Configuration: 
# - Unit width in pixels: 4 (update this as needed)  
# - Unit height in pixels: 4 (update this as needed) 
# - Display width in pixels: 256 (update this as needed) 
# - Display height in pixels: 256 (update this as needed) 
# - Base Address for Display: 0x10008000 ($gp) 
# 
# Which milestones have been reached in this submission? 
# (See the assignment handout for descriptions of the milestones) 
# - Milestone 1/2/3 (choose the one the applies) 
# 
# Which approved features have been implemented for milestone 3? 
# (See the assignment handout for the list of additional features) 
# 1. (fill in the feature, if any) 
# 2. (fill in the feature, if any) 
# 3. (fill in the feature, if any) 
# ... (add more if necessary) 
# 
# Link to video demonstration for final submission: 
# - (insert YouTube / MyMedia / other URL here). Make sure we can view it! 
# 
# Are you OK with us sharing the video with people outside course staff? 
# - yes, and please share this project github link as well! 
# 
# Any additional information that the TA needs to know: 
# - (write here, if any) 
# 
##################################################################### 

.eqv  BASE_ADDRESS  0x10008000
      
.data 

    padding:	.space	36000   #Empty space to prevent game data from being overwritten due to large bitmap size

    char_pos: .word 33040

    char_status: .word 1 #1 for right stand, 2 for left stand, 3 for right climb, 4 for left stand

    sprite_status: .word 1 #used to toggle between sprites

.text

.globl main

main: 
    jal f_set_screen
    addi $t9, $zero, 10
    
main_while:
    la $t0, char_pos
    lw $a0, 0($t0)
    jal f_draw_lw_three
    
    #la $t0, char_pos
    #lw $a0, 0($t0)
    #jal f_draw_rw_one
    #li $v0 32
    #li $a0 150
    #syscall
    
    #la $t0, char_pos
    #lw $a0, 0($t0)
    #jal f_erase_rw
    
    #la $t0, char_pos
    #lw $a0, 0($t0)
    #jal f_draw_rw_two
    #li $v0 32
    #li $a0 150
    #syscall
    
    #la $t0, char_pos
    #lw $a0, 0($t0)
    #jal f_erase_rw
    
    #la $t0, char_pos
    #lw $a0, 0($t0)
    #jal f_draw_rw_three
    #li $v0 32
    #li $a0 150
    #syscall
    
    #la $t0, char_pos
    #lw $a0, 0($t0)
    #jal f_erase_rw
    
    #la $t0, char_pos
    #lw $a0, 0($t0)
    #jal f_draw_rw_two
    #li $v0 32
    #li $a0 150
    #syscall
    
    #addi $t9, $t9, -1
    
    #bnez $t9, main_while
    
    li $v0, 10 # terminate the program gracefully 
    syscall 

f_set_screen:
    li $t0, BASE_ADDRESS # $t0 stores the base address for display
    li $t1, 0xFFFFFF # white
    addi $t2, $t0, 65536 # stores bottom right pixel index number + 4

while_set_screen:
    sw $t1, 0($t0) # set $t2 to white
    addi $t0, $t0, 4 # increment $t2 to next index
    bne $t0, $t2, while_set_screen

    jr $ra 


f_draw_rw_one: # fetches location passed in $a0
    li $t0, BASE_ADDRESS # $t0 stores the base address for display
    add $t0, $t0, $a0

    li $t1, 0xCA1515 # body red
    li $t2, 0xD93333 # bright red
    li $t3, 0x8E0000 # dark red
    li $t4, 0xECC500 # belly yellow
    li $t5, 0xC9A800 # dark yellow

    addi $t0, $t0, -5112
    addi $t6, $t0, 32

rwone_row1:
    sw $t2, 0($t0)
    addi $t0, $t0, 4
    bne $t0, $t6, rwone_row1

    addi $t0, $t0, 512
    sw $t2, 0($t0)
    sw $t2, 4($t0)
    addi $t0, $t0, -4
    addi $t6, $t0, -32
    
rwone_row2:
    sw $t1, 0($t0)
    addi $t0, $t0, -4
    bne $t0, $t6, rwone_row2

    sw $t3, 0($t0)

    addi $t0, $t0, 512

rwone_row3:
    sw $t3, -4($t0)
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    sw $t1, 0($t0)
    addi $t0, $t0, 4

    li $t7, 0xFFFFFF # temp color: white
    sw $t7, 0($t0)
    addi $t0, $t0, 4
    li $t7, 0x000000 # temp color: black
    sw $t7, 0($t0)
    addi $t0, $t0, 4
    
    sw $t1, 0($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    addi $t0, $t0, 12
    
    li $t7, 0x2D2D2D # temp color: grey
    sw $t7, 0($t0)
    
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    sw $t7, 12($t0)
    
rwone_row4:
    addi $t0, $t0, 524
    
    addi $t6, $t0, -28
    
rwone_row4_a:
    sw $t1, 0($t0)
    addi $t0, $t0, -4
    bne $t0, $t6, rwone_row4_a

    li $t7, 0x000000 # temp color: black
    sw $t7, 0($t0)
    sw $t7, -4($t0)
    
    sw $t1, -8($t0)
    sw $t1, -12($t0)
    sw $t3, -16($t0)
    
rwone_row5:
    addi $t0, $t0, 496
    sw $t3, -4($t0)
    
    addi $t6, $t0, 48
    
rwone_row5_a:
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    bne $t0, $t6, rwone_row5_a
    
rwone_row6:
    addi $t0, $t0, 504
    
    addi $t6, $t0, -28
    
rwone_row6_a:
    sw $t3, 0($t0)
    addi $t0, $t0, -4
    bne $t0, $t6, rwone_row6_a
    
    addi $t6, $t0, -16
    
rwone_row6_b:
    sw $t1, 0($t0)
    addi $t0, $t0, -4
    bne $t0, $t6, rwone_row6_b
    
    sw $t3, 0($t0)
    
    sw $t2, -28($t0)
    sw $t2, -32($t0)
    
rwone_row7:
    addi $t0, $t0, 512
    
    sw $t2, -24($t0)
    sw $t1, -28($t0)
    sw $t1, -32($t0)
    sw $t1, -36($t0)
    
    sw $t3, -4($t0)
    
    addi $t6, $t0, 20
    
rwone_row7_a:
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    bne $t0, $t6, rwone_row7_a

    sw $t4, 0($t0)
    sw $t4, 4($t0)
    
rwone_row8:
    addi $t0, $t0, 492
    sw $t2, -20($t0)
    sw $t1, -24($t0)
    sw $t1, -28($t0)
    sw $t3, -32($t0)
    sw $t2, -36($t0)
    
    sw $t3, -4($t0)
    
    addi $t6, $t0, 8
    
rwone_row8_a:
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    bne $t0, $t6, rwone_row8_a

    sw $t3, 0($t0)
    
    addi $t0, $t0, 4
    addi $t6, $t0, 8
    
rwone_row8_b:
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    bne $t0, $t6, rwone_row8_b

    sw $t4, 0($t0)
    sw $t4, 4($t0)
    
rwone_row9:
    addi $t0, $t0, 512
    sw $t4, 0($t0)
    sw $t4, 4($t0)
    sw $t4, -4($t0)
    sw $t3, 8($t0)
    
    addi $t0, $t0, -8
    
    sw $t3, 0($t0)
    sw $t3, -4($t0)
    addi $t0, $t0, -8
    
    addi $t6, $t0, -12
    
rwone_row9_a:
    sw $t1, 0($t0)
    addi $t0, $t0, -4
    bne $t0, $t6, rwone_row9_a
    
    addi $t6, $t0, -12
    
rwone_row9_b:
    sw $t2, 0($t0)
    addi $t0, $t0, -4
    bne $t0, $t6, rwone_row9_b
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    
    sw $t3, -8($t0)
    sw $t3, -16($t0)

rwone_row10:
    addi $t0, $t0, 508
    sw $t3, -4($t0)
    
    addi $t6, $t0, 36
    
rwone_row10_a:
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    bne $t0, $t6, rwone_row10_a
    
    sw $t3, 0($t0)
    sw $t4, 4($t0)
    sw $t4, 8($t0)
    sw $t3, 16($t0)
    
rwone_row11:
    addi $t0, $t0, 512
    sw $t4, 4($t0)
    sw $t4, 8($t0)
    
    addi $t6, $t0, -36
    
rwone_row11_a:
    sw $t1, 0($t0)
    addi $t0, $t0, -4
    bne $t0, $t6, rwone_row11_a
    
    sw $t3, 0($t0)
    
rwone_row12:
    addi $t0, $t0, 520
    sw $t3, -4($t0)
    
    addi $t6, $t0, 32
    
rwone_row12_a:
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    bne $t0, $t6, rwone_row12_a
    
    sw $t4, 0($t0)
    sw $t4, 4($t0)

rwone_row13:    
    addi $t0, $t0, 500
    sw $t4, 4($t0)
    sw $t4, 8($t0)
    sw $t4, 12($t0)
    sw $t4, 16($t0)
    
    addi $t6, $t0, -24
    
rwone_row13_a:
    sw $t1, 0($t0)
    addi $t0, $t0, -4
    bne $t0, $t6, rwone_row13_a
    
    sw $t3, 0($t0)
    
rwone_row14:
    addi $t0, $t0, 524
    sw $t3, -4($t0)
    sw $t3, -8($t0)
    
    sw $t1, 0($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    
    sw $t5, 12($t0)
    sw $t5, 16($t0)
    sw $t5, 20($t0)
    sw $t5, 24($t0)
    
rwone_row15:
    addi $t0, $t0, 512
    
    sw $t3, 0($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    
    sw $t3, 16($t0)
    sw $t3, 20($t0)
    sw $t3, 24($t0)
    
rwone_row16:
    addi $t0, $t0, 512
    
    sw $t3, 0($t0)
    sw $t1, 4($t0)
    
    sw $t3, 16($t0)
    sw $t3, 20($t0)
    
rwone_row17:
    addi $t0, $t0, 512
    
    sw $t3, 0($t0)
    
    sw $t3, 16($t0)
    
rwone_row18:
    addi $t0, $t0, 512
    
    sw $t3, 0($t0)
    sw $t3, 4($t0)
    
    sw $t3, 16($t0)
    sw $t3, 20($t0)
    
    jr $ra
    

f_draw_rw_two: # fetches location passed in $a0
    li $t0, BASE_ADDRESS # $t0 stores the base address for display
    add $t0, $t0, $a0

    li $t1, 0xCA1515 # body red
    li $t2, 0xD93333 # bright red
    li $t3, 0x8E0000 # dark red
    li $t4, 0xECC500 # belly yellow
    li $t5, 0xC9A800 # dark yellow

    sw $t1, 0($t0) #alignment check

    addi $t0, $t0, -5112
    addi $t6, $t0, 32

rwtwo_row1:
    sw $t2, 0($t0)
    addi $t0, $t0, 4
    bne $t0, $t6, rwtwo_row1

    addi $t0, $t0, 512
    sw $t2, 0($t0)
    sw $t2, 4($t0)
    addi $t0, $t0, -4
    addi $t6, $t0, -32
    
rwtwo_row2:
    sw $t1, 0($t0)
    addi $t0, $t0, -4
    bne $t0, $t6, rwtwo_row2

    sw $t3, 0($t0)

    addi $t0, $t0, 512

rwtwo_row3:
    sw $t3, -4($t0)
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    sw $t1, 0($t0)
    addi $t0, $t0, 4

    li $t7, 0xFFFFFF # temp color: white
    sw $t7, 0($t0)
    addi $t0, $t0, 4
    li $t7, 0x000000 # temp color: black
    sw $t7, 0($t0)
    addi $t0, $t0, 4
    
    sw $t1, 0($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    addi $t0, $t0, 12
    
    li $t7, 0x2D2D2D # temp color: grey
    sw $t7, 0($t0)
    
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    sw $t7, 12($t0)
    
rwtwo_row4:
    addi $t0, $t0, 524
    
    addi $t6, $t0, -28
    
rwtwo_row4_a:
    sw $t1, 0($t0)
    addi $t0, $t0, -4
    bne $t0, $t6, rwtwo_row4_a

    li $t7, 0x000000 # temp color: black
    sw $t7, 0($t0)
    sw $t7, -4($t0)
    
    sw $t1, -8($t0)
    sw $t1, -12($t0)
    sw $t3, -16($t0)
    
rwtwo_row5:
    addi $t0, $t0, 496
    sw $t3, -4($t0)
    
    addi $t6, $t0, 48
    
rwtwo_row5_a:
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    bne $t0, $t6, rwtwo_row5_a
    
rwtwo_row6:
    addi $t0, $t0, 504
    
    addi $t6, $t0, -28
    
rwtwo_row6_a:
    sw $t3, 0($t0)
    addi $t0, $t0, -4
    bne $t0, $t6, rwtwo_row6_a
    
    addi $t6, $t0, -16
    
rwtwo_row6_b:
    sw $t1, 0($t0)
    addi $t0, $t0, -4
    bne $t0, $t6, rwtwo_row6_b
    
    sw $t3, 0($t0)
    
    sw $t2, -28($t0)
    sw $t2, -32($t0)
    
rwtwo_row7:
    addi $t0, $t0, 512
    
    sw $t2, -24($t0)
    sw $t1, -28($t0)
    sw $t1, -32($t0)
    sw $t1, -36($t0)
    
    sw $t3, -4($t0)
    
    addi $t6, $t0, 20
    
rwtwo_row7_a:
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    bne $t0, $t6, rwtwo_row7_a

    sw $t4, 0($t0)
    sw $t4, 4($t0)
    
rwtwo_row8:
    addi $t0, $t0, 492
    sw $t2, -20($t0)
    sw $t1, -24($t0)
    sw $t1, -28($t0)
    sw $t3, -32($t0)
    sw $t2, -36($t0)
    
    sw $t3, -4($t0)
    
    addi $t6, $t0, 8
    
rwtwo_row8_a:
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    bne $t0, $t6, rwtwo_row8_a

    sw $t3, 0($t0)
    
    addi $t0, $t0, 4
    addi $t6, $t0, 8
    
rwtwo_row8_b:
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    bne $t0, $t6, rwtwo_row8_b

    sw $t4, 0($t0)
    sw $t4, 4($t0)
    
rwtwo_row9:
    addi $t0, $t0, 512
    sw $t4, 0($t0)
    sw $t4, 4($t0)
    sw $t4, -4($t0)
    sw $t3, 8($t0)
    
    addi $t0, $t0, -8
    
    sw $t3, 0($t0)
    sw $t3, -4($t0)
    addi $t0, $t0, -8
    
    addi $t6, $t0, -12
    
rwtwo_row9_a:
    sw $t1, 0($t0)
    addi $t0, $t0, -4
    bne $t0, $t6, rwtwo_row9_a
    
    addi $t6, $t0, -12
    
rwtwo_row9_b:
    sw $t2, 0($t0)
    addi $t0, $t0, -4
    bne $t0, $t6, rwtwo_row9_b
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    
    sw $t3, -8($t0)
    sw $t3, -16($t0)

rwtwo_row10:
    addi $t0, $t0, 508
    sw $t3, -4($t0)
    
    addi $t6, $t0, 36
    
rwtwo_row10_a:
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    bne $t0, $t6, rwtwo_row10_a
    
    sw $t3, 0($t0)
    sw $t4, 4($t0)
    sw $t4, 8($t0)
    sw $t3, 16($t0)
    
rwtwo_row11:
    addi $t0, $t0, 512
    sw $t4, 4($t0)
    sw $t4, 8($t0)
    
    addi $t6, $t0, -36
    
rwtwo_row11_a:
    sw $t1, 0($t0)
    addi $t0, $t0, -4
    bne $t0, $t6, rwtwo_row11_a
    
    sw $t3, 0($t0)
    
rwtwo_row12:
    addi $t0, $t0, 520
    sw $t3, -4($t0)
    
    addi $t6, $t0, 32
    
rwtwo_row12_a:
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    bne $t0, $t6, rwtwo_row12_a
    
    sw $t4, 0($t0)
    sw $t4, 4($t0)

rwtwo_row13:    
    addi $t0, $t0, 500
    sw $t1, 4($t0)
    sw $t4, 8($t0)
    sw $t4, 12($t0)
    sw $t4, 16($t0)
    
    addi $t6, $t0, -24
    
rwtwo_row13_a:
    sw $t1, 0($t0)
    addi $t0, $t0, -4
    bne $t0, $t6, rwtwo_row13_a
    
    sw $t3, 0($t0)
    
rwtwo_row14:
    addi $t0, $t0, 524
    sw $t3, -4($t0)
    sw $t3, -8($t0)
    
    sw $t1, 0($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    
    sw $t1, 12($t0)
    sw $t5, 16($t0)
    sw $t5, 20($t0)
    sw $t5, 24($t0)
    
rwtwo_row15:
    addi $t0, $t0, 512
    
    sw $t3, 0($t0)
    sw $t3, 4($t0)
    sw $t1, 8($t0)
    sw $t1, 12($t0)
    sw $t3, 16($t0)
    sw $t3, 20($t0)
    
rwtwo_row16:
    addi $t0, $t0, 516
    
    sw $t3, 0($t0)
    sw $t1, 4($t0)
    sw $t3, 8($t0)
    sw $t3, 12($t0)
    
rwtwo_row17:
    addi $t0, $t0, 512
    
    sw $t3, 0($t0)
    sw $t3, 8($t0)
    
rwtwo_row18:
    addi $t0, $t0, 512
    
    sw $t3, 0($t0)
    sw $t3, 4($t0)
    sw $t3, 8($t0)
    sw $t3, 12($t0)
    
    jr $ra
    
f_draw_rw_three: # fetches location passed in $a0
    li $t0, BASE_ADDRESS # $t0 stores the base address for display
    add $t0, $t0, $a0

    li $t1, 0xCA1515 # body red
    li $t2, 0xD93333 # bright red
    li $t3, 0x8E0000 # dark red
    li $t4, 0xECC500 # belly yellow
    li $t5, 0xC9A800 # dark yellow

    addi $t0, $t0, -5112
    addi $t6, $t0, 32

rwthree_row1:
    sw $t2, 0($t0)
    addi $t0, $t0, 4
    bne $t0, $t6, rwthree_row1

    addi $t0, $t0, 512
    sw $t2, 0($t0)
    sw $t2, 4($t0)
    addi $t0, $t0, -4
    addi $t6, $t0, -32
    
rwthree_row2:
    sw $t1, 0($t0)
    addi $t0, $t0, -4
    bne $t0, $t6, rwthree_row2

    sw $t3, 0($t0)

    addi $t0, $t0, 512

rwthree_row3:
    sw $t3, -4($t0)
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    sw $t1, 0($t0)
    addi $t0, $t0, 4

    li $t7, 0xFFFFFF # temp color: white
    sw $t7, 0($t0)
    addi $t0, $t0, 4
    li $t7, 0x000000 # temp color: black
    sw $t7, 0($t0)
    addi $t0, $t0, 4
    
    sw $t1, 0($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    addi $t0, $t0, 12
    
    li $t7, 0x2D2D2D # temp color: grey
    sw $t7, 0($t0)
    
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    sw $t7, 12($t0)
    
rwthree_row4:
    addi $t0, $t0, 524
    
    addi $t6, $t0, -28
    
rwthree_row4_a:
    sw $t1, 0($t0)
    addi $t0, $t0, -4
    bne $t0, $t6, rwthree_row4_a

    li $t7, 0x000000 # temp color: black
    sw $t7, 0($t0)
    sw $t7, -4($t0)
    
    sw $t1, -8($t0)
    sw $t1, -12($t0)
    sw $t3, -16($t0)
    
rwthree_row5:
    addi $t0, $t0, 496
    sw $t3, -4($t0)
    
    addi $t6, $t0, 48
    
rwthree_row5_a:
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    bne $t0, $t6, rwthree_row5_a
    
rwthree_row6:
    addi $t0, $t0, 504
    
    addi $t6, $t0, -28
    
rwthree_row6_a:
    sw $t3, 0($t0)
    addi $t0, $t0, -4
    bne $t0, $t6, rwthree_row6_a
    
    addi $t6, $t0, -16
    
rwthree_row6_b:
    sw $t1, 0($t0)
    addi $t0, $t0, -4
    bne $t0, $t6, rwthree_row6_b
    
    sw $t3, 0($t0)
    
    sw $t2, -28($t0)
    sw $t2, -32($t0)
    
rwthree_row7:
    addi $t0, $t0, 512
    
    sw $t2, -24($t0)
    sw $t1, -28($t0)
    sw $t1, -32($t0)
    sw $t1, -36($t0)
    
    sw $t3, -4($t0)
    
    addi $t6, $t0, 20
    
rwthree_row7_a:
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    bne $t0, $t6, rwthree_row7_a

    sw $t4, 0($t0)
    sw $t4, 4($t0)
    
rwthree_row8:
    addi $t0, $t0, 492
    sw $t2, -20($t0)
    sw $t1, -24($t0)
    sw $t1, -28($t0)
    sw $t3, -32($t0)
    sw $t2, -36($t0)
    
    sw $t3, -4($t0)
    
    addi $t6, $t0, 8
    
rwthree_row8_a:
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    bne $t0, $t6, rwthree_row8_a

    sw $t3, 0($t0)
    
    addi $t0, $t0, 4
    addi $t6, $t0, 8
    
rwthree_row8_b:
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    bne $t0, $t6, rwthree_row8_b

    sw $t4, 0($t0)
    sw $t4, 4($t0)
    
rwthree_row9:
    addi $t0, $t0, 512
    sw $t4, 0($t0)
    sw $t4, 4($t0)
    sw $t4, -4($t0)
    sw $t3, 8($t0)
    
    addi $t0, $t0, -8
    
    sw $t3, 0($t0)
    sw $t3, -4($t0)
    addi $t0, $t0, -8
    
    addi $t6, $t0, -12
    
rwthree_row9_a:
    sw $t1, 0($t0)
    addi $t0, $t0, -4
    bne $t0, $t6, rwthree_row9_a
    
    addi $t6, $t0, -12
    
rwthree_row9_b:
    sw $t2, 0($t0)
    addi $t0, $t0, -4
    bne $t0, $t6, rwthree_row9_b
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    
    sw $t3, -8($t0)
    sw $t3, -16($t0)

rwthree_row10:
    addi $t0, $t0, 508
    sw $t3, -4($t0)
    
    addi $t6, $t0, 36
    
rwthree_row10_a:
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    bne $t0, $t6, rwthree_row10_a
    
    sw $t3, 0($t0)
    sw $t4, 4($t0)
    sw $t4, 8($t0)
    sw $t3, 16($t0)
    
rwthree_row11:
    addi $t0, $t0, 512
    sw $t4, 4($t0)
    sw $t4, 8($t0)
    
    addi $t6, $t0, -36
    
rwthree_row11_a:
    sw $t1, 0($t0)
    addi $t0, $t0, -4
    bne $t0, $t6, rwthree_row11_a
    
    sw $t3, 0($t0)
    
rwthree_row12:
    addi $t0, $t0, 520
    sw $t3, -4($t0)
    
    addi $t6, $t0, 32
    
rwthree_row12_a:
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    bne $t0, $t6, rwthree_row12_a
    
    sw $t4, 0($t0)
    sw $t4, 4($t0)

rwthree_row13:    
    addi $t0, $t0, 500
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    sw $t4, 12($t0)
    sw $t4, 16($t0)
    
    addi $t6, $t0, -24
    
rwthree_row13_a:
    sw $t1, 0($t0)
    addi $t0, $t0, -4
    bne $t0, $t6, rwthree_row13_a
    
    sw $t3, 0($t0)
    
rwthree_row14:
    addi $t0, $t0, 524
    sw $t3, -4($t0)
    sw $t3, -8($t0)
    
    sw $t1, 0($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    
    sw $t1, 12($t0)
    sw $t1, 16($t0)
    sw $t5, 20($t0)
    sw $t5, 24($t0)
    
rwthree_row15:
    addi $t0, $t0, 512
    
    sw $t3, 0($t0)
    sw $t3, 4($t0)
    sw $t3, 8($t0)
    sw $t1, 12($t0)
    sw $t1, 16($t0)
    
rwthree_row16:
    addi $t0, $t0, 520
    
    sw $t3, 0($t0)
    sw $t1, 4($t0)
    
rwthree_row17:
    addi $t0, $t0, 512
    sw $t3, 0($t0)
    
rwthree_row18:
    addi $t0, $t0, 512
    sw $t3, 0($t0)
    sw $t3, 4($t0)

    jr $ra
    
    
f_erase_rw: # fetches location passed in $a0
    li $t0, BASE_ADDRESS # $t0 stores the base address for display
    add $t0, $t0, $a0

    li $t1, 0xFFFFFF # white

    addi $t0, $t0, -5112
    addi $t6, $t0, 32
    
rwerase_row1:
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    bne $t0, $t6, rwerase_row1
    
    addi $t0, $t0, 516
    addi $t6, $t0, -44
    
rwerase_row2:
    sw $t1, 0($t0)
    addi $t0, $t0, -4
    bne $t0, $t6, rwerase_row2
    
    addi $t0, $t0, 512
    addi $t6, $t0, 48
    
rwerase_row3:
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    bne $t0, $t6, rwerase_row3
    
    addi $t0, $t0, 508
    addi $t6, $t0, -48
    
rwerase_row4:
    sw $t1, 0($t0)
    addi $t0, $t0, -4
    bne $t0, $t6, rwerase_row4
    
    addi $t0, $t0, 512
    addi $t6, $t0, 52
    
rwerase_row5:
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    bne $t0, $t6, rwerase_row5
    
    addi $t0, $t0, 504
    addi $t6, $t0, -80
    
rwerase_row6:
    sw $t1, 0($t0)
    addi $t0, $t0, -4
    bne $t0, $t6, rwerase_row6
    
    addi $t0, $t0, 512
    addi $t6, $t0, 64
    
rwerase_row7:
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    bne $t0, $t6, rwerase_row7
    
    addi $t0, $t0, 508
    addi $t6, $t0, -64
    
rwerase_row8:
    sw $t1, 0($t0)
    addi $t0, $t0, -4
    bne $t0, $t6, rwerase_row8
    
    addi $t0, $t0, 516
    addi $t6, $t0, 68
    
rwerase_row9:
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    bne $t0, $t6, rwerase_row9
    
    addi $t0, $t0, 508
    addi $t6, $t0, -60
    
rwerase_row10:
    sw $t1, 0($t0)
    addi $t0, $t0, -4
    bne $t0, $t6, rwerase_row10

    addi $t0, $t0, 520
    addi $t6, $t0, 48
    
rwerase_row11:
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    bne $t0, $t6, rwerase_row11
    
    addi $t0, $t0, 508
    addi $t6, $t0, -44
    
rwerase_row12:
    sw $t1, 0($t0)
    addi $t0, $t0, -4
    bne $t0, $t6, rwerase_row12
    
    addi $t0, $t0, 516
    addi $t6, $t0, 44
    
rwerase_row13:
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    bne $t0, $t6, rwerase_row13
    
    addi $t0, $t0, 508
    addi $t6, $t0, -40
    
rwerase_row14:
    sw $t1, 0($t0)
    addi $t0, $t0, -4
    bne $t0, $t6, rwerase_row14
    
    addi $t0, $t0, 524
    addi $t6, $t0, 28
    
rwerase_row15:
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    bne $t0, $t6, rwerase_row15
    
    addi $t0, $t0, 504
    addi $t6, $t0, -24
    
rwerase_row16:
    sw $t1, 0($t0)
    addi $t0, $t0, -4
    bne $t0, $t6, rwerase_row16
    
    addi $t0, $t0, 516
    addi $t6, $t0, 20
    
rwerase_row17:
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    bne $t0, $t6, rwerase_row17
    
    addi $t0, $t0, 512
    addi $t6, $t0, -24
    
rwerase_row18:
    sw $t1, 0($t0)
    addi $t0, $t0, -4
    bne $t0, $t6, rwerase_row18
    
    jr $ra
    
    
f_draw_lw_one: # fetches location passed in $a0
    li $t0, BASE_ADDRESS # $t0 stores the base address for display
    add $t0, $t0, $a0

    li $t1, 0xCA1515 # body red
    li $t2, 0xD93333 # bright red
    li $t3, 0x8E0000 # dark red
    li $t4, 0xECC500 # belly yellow
    li $t5, 0xC9A800 # dark yellow

    sw $t1, 0($t0)

    addi $t0, $t0, -5128
    addi $t6, $t0, -32

lwone_row1:
    sw $t2, 0($t0)
    addi $t0, $t0, -4
    bne $t0, $t6, lwone_row1
    
    addi $t0, $t0, 508
    
    sw $t2, 0($t0)
    addi $t0, $t0, 4
    
    sw $t2, 0($t0)
    addi $t0, $t0, 4
    
    addi $t6, $t0, 32

lwone_row2_a:
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    bne $t0, $t6, lwone_row2_a
    
    sw $t3, 0($t0)
    
lwone_row3:
    addi $t0, $t0, 512
    sw $t3, 4($t0)
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    
    li $t7, 0xFFFFFF # white
    sw $t7, -8($t0)
    
    li $t7, 0x000000 # black
    sw $t7, -12($t0)
    
    sw $t1, -16($t0)
    sw $t1, -20($t0)
    sw $t1, -24($t0)
    
    li $t7, 0x2D2D2D # grey
    sw $t7, -28($t0)
    sw $t1, -32($t0)
    sw $t1, -36($t0)
    sw $t7, -40($t0)
    
lwone_row4:
    addi $t0, $t0, 512
    sw $t3, 4($t0)
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    
    li $t7, 0x000000 # black
    sw $t7, -8($t0)
    sw $t7, -12($t0)
    
    addi $t0, $t0, -16
    addi $t6, $t0, -28

lwone_row4_a:
    sw $t1, 0($t0)
    addi $t0, $t0, -4
    bne $t0, $t6, lwone_row4_a
    
    addi $t0, $t0, 516
    addi $t6, $t0, 48

lwone_row5_a:
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    bne $t0, $t6, lwone_row5_a
    
    sw $t3, 0($t0)
    
    addi $t0, $t0, 508
    sw $t3, 4($t0)
    
    sw $t2, 32($t0)
    sw $t2, 36($t0)
    
    addi $t6, $t0, -16

lwone_row6_a:
    sw $t1, 0($t0)
    addi $t0, $t0, -4
    bne $t0, $t6, lwone_row6_a
    
    addi $t6, $t0, -28

lwone_row6_b:
    sw $t3, 0($t0)
    addi $t0, $t0, -4
    bne $t0, $t6, lwone_row6_b
    
lwone_row7:
    addi $t0, $t0, 544
    
    sw $t4, -4($t0)
    sw $t4, -8($t0) 
    
    addi $t6, $t0, 20

lwone_row7_a:
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    bne $t0, $t6, lwone_row7_a
    
    sw $t3, 0($t0)
    sw $t2, 20($t0)
    sw $t1, 24($t0)
    sw $t1, 28($t0)
    sw $t2, 32($t0)


lwone_row8:
    addi $t0, $t0, 512
    sw $t3, 0($t0)
    
    sw $t2, 16($t0)
    sw $t1, 20($t0)
    sw $t1, 24($t0)
    sw $t3, 28($t0)
    sw $t2, 32($t0)
    
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    sw $t3, -12($t0)
    sw $t1, -16($t0)
    sw $t1, -20($t0)
    sw $t4, -24($t0)
    sw $t4, -28($t0)
    
lwone_row9:
    addi $t0, $t0, 512
    
    sw $t2, 4($t0)
    sw $t2, 8($t0)
    sw $t2, 12($t0)
    
    sw $t1, 16($t0)
    sw $t1, 20($t0)
    sw $t3, 24($t0)
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    
    sw $t3, -12($t0)
    sw $t3, -16($t0)
    
    sw $t4, -20($t0)
    sw $t4, -24($t0)
    sw $t4, -28($t0)
    sw $t3, -32($t0)
    
lwone_row10:
    addi $t0, $t0, 500
    sw $t3, -4($t0)
    sw $t4, -8($t0)
    sw $t4, -12($t0)
    
    sw $t3, -20($t0)
    
    addi $t6, $t0, 36

lwone_row10_a:
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    bne $t0, $t6, lwone_row10_a
    
    sw $t3, 0($t0)
    
lwone_row11:
    addi $t0, $t0, 504
    
    sw $t3, 4($t0)

    addi $t6, $t0, -36

lwone_row11_a:
    sw $t1, 0($t0)
    addi $t0, $t0, -4
    bne $t0, $t6, lwone_row11_a
    
    sw $t4, -4($t0)
    sw $t4, 0($t0)
    
lwone_row12:
    addi $t0, $t0, 516
    
    sw $t4, -4($t0)
    sw $t4, -8($t0)
    
    addi $t6, $t0, 32

lwone_row12_a:
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    bne $t0, $t6, lwone_row12_a
    
    sw $t3, 0($t0)
    
lwone_row13:
    addi $t0, $t0, 508
    
    sw $t3, 4($t0)
    
    addi $t6, $t0, -24
lwone_row13_a:
    sw $t1, 0($t0)
    addi $t0, $t0, -4
    bne $t0, $t6, lwone_row13_a
    
    sw $t4, 0($t0)
    sw $t4, -4($t0)
    sw $t4, -8($t0)
    sw $t4, -12($t0)
    
lwone_row14:
    addi $t0, $t0, 516
    
    sw $t5, 0($t0)
    sw $t5, -4($t0)
    sw $t5, -8($t0)
    sw $t5, -12($t0)
    
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    sw $t1, 12($t0)
    
    sw $t3, 16($t0)
    sw $t3, 20($t0)
    
lwone_row15:
    addi $t0, $t0, 512
    sw $t3, -4($t0)
    sw $t3, -8($t0)
    sw $t3, -12($t0)
    
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    sw $t3, 12($t0)
    
lwone_row16:
    addi $t0, $t0, 512
    sw $t3, -4($t0)
    sw $t3, -8($t0)
    
    sw $t1, 8($t0)
    sw $t3, 12($t0)
    
lwone_row17:
    addi $t0, $t0, 512
    sw $t3, -4($t0)
    
    sw $t3, 12($t0)
    
lwone_row18:
    addi $t0, $t0, 512
    sw $t3, -4($t0)
    sw $t3, -8($t0)
    
    sw $t3, 8($t0)
    sw $t3, 12($t0)

    jr $ra
    

f_draw_lw_two: # fetches location passed in $a0
    li $t0, BASE_ADDRESS # $t0 stores the base address for display
    add $t0, $t0, $a0

    li $t1, 0xCA1515 # body red
    li $t2, 0xD93333 # bright red
    li $t3, 0x8E0000 # dark red
    li $t4, 0xECC500 # belly yellow
    li $t5, 0xC9A800 # dark yellow

    sw $t1, 0($t0)

    addi $t0, $t0, -5128
    addi $t6, $t0, -32

lwtwo_row1:
    sw $t2, 0($t0)
    addi $t0, $t0, -4
    bne $t0, $t6, lwtwo_row1
    
    addi $t0, $t0, 508
    
    sw $t2, 0($t0)
    addi $t0, $t0, 4
    
    sw $t2, 0($t0)
    addi $t0, $t0, 4
    
    addi $t6, $t0, 32

lwtwo_row2_a:
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    bne $t0, $t6, lwtwo_row2_a
    
    sw $t3, 0($t0)
    
lwtwo_row3:
    addi $t0, $t0, 512
    sw $t3, 4($t0)
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    
    li $t7, 0xFFFFFF # white
    sw $t7, -8($t0)
    
    li $t7, 0x000000 # black
    sw $t7, -12($t0)
    
    sw $t1, -16($t0)
    sw $t1, -20($t0)
    sw $t1, -24($t0)
    
    li $t7, 0x2D2D2D # grey
    sw $t7, -28($t0)
    sw $t1, -32($t0)
    sw $t1, -36($t0)
    sw $t7, -40($t0)
    
lwtwo_row4:
    addi $t0, $t0, 512
    sw $t3, 4($t0)
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    
    li $t7, 0x000000 # black
    sw $t7, -8($t0)
    sw $t7, -12($t0)
    
    addi $t0, $t0, -16
    addi $t6, $t0, -28

lwtwo_row4_a:
    sw $t1, 0($t0)
    addi $t0, $t0, -4
    bne $t0, $t6, lwtwo_row4_a
    
    addi $t0, $t0, 516
    addi $t6, $t0, 48

lwtwo_row5_a:
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    bne $t0, $t6, lwtwo_row5_a
    
    sw $t3, 0($t0)
    
    addi $t0, $t0, 508
    sw $t3, 4($t0)
    
    sw $t2, 32($t0)
    sw $t2, 36($t0)
    
    addi $t6, $t0, -16

lwtwo_row6_a:
    sw $t1, 0($t0)
    addi $t0, $t0, -4
    bne $t0, $t6, lwtwo_row6_a
    
    addi $t6, $t0, -28

lwtwo_row6_b:
    sw $t3, 0($t0)
    addi $t0, $t0, -4
    bne $t0, $t6, lwtwo_row6_b
    
lwtwo_row7:
    addi $t0, $t0, 544
    
    sw $t4, -4($t0)
    sw $t4, -8($t0) 
    
    addi $t6, $t0, 20

lwtwo_row7_a:
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    bne $t0, $t6, lwtwo_row7_a
    
    sw $t3, 0($t0)
    sw $t2, 20($t0)
    sw $t1, 24($t0)
    sw $t1, 28($t0)
    sw $t2, 32($t0)


lwtwo_row8:
    addi $t0, $t0, 512
    sw $t3, 0($t0)
    
    sw $t2, 16($t0)
    sw $t1, 20($t0)
    sw $t1, 24($t0)
    sw $t3, 28($t0)
    sw $t2, 32($t0)
    
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    sw $t3, -12($t0)
    sw $t1, -16($t0)
    sw $t1, -20($t0)
    sw $t4, -24($t0)
    sw $t4, -28($t0)
    
lwtwo_row9:
    addi $t0, $t0, 512
    
    sw $t2, 4($t0)
    sw $t2, 8($t0)
    sw $t2, 12($t0)
    
    sw $t1, 16($t0)
    sw $t1, 20($t0)
    sw $t3, 24($t0)
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    
    sw $t3, -12($t0)
    sw $t3, -16($t0)
    
    sw $t4, -20($t0)
    sw $t4, -24($t0)
    sw $t4, -28($t0)
    sw $t3, -32($t0)
    
lwtwo_row10:
    addi $t0, $t0, 500
    sw $t3, -4($t0)
    sw $t4, -8($t0)
    sw $t4, -12($t0)
    
    sw $t3, -20($t0)
    
    addi $t6, $t0, 36

lwtwo_row10_a:
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    bne $t0, $t6, lwtwo_row10_a
    
    sw $t3, 0($t0)
    
lwtwo_row11:
    addi $t0, $t0, 504
    
    sw $t3, 4($t0)

    addi $t6, $t0, -36

lwtwo_row11_a:
    sw $t1, 0($t0)
    addi $t0, $t0, -4
    bne $t0, $t6, lwtwo_row11_a
    
    sw $t4, -4($t0)
    sw $t4, 0($t0)
    
lwtwo_row12:
    addi $t0, $t0, 516
    
    sw $t4, -4($t0)
    sw $t4, -8($t0)
    
    addi $t6, $t0, 32

lwtwo_row12_a:
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    bne $t0, $t6, lwtwo_row12_a
    
    sw $t3, 0($t0)
    
lwtwo_row13:
    addi $t0, $t0, 508
    
    sw $t3, 4($t0)
    
    addi $t6, $t0, -24
lwtwo_row13_a:
    sw $t1, 0($t0)
    addi $t0, $t0, -4
    bne $t0, $t6, lwtwo_row13_a
    
    sw $t1, 0($t0)
    sw $t4, -4($t0)
    sw $t4, -8($t0)
    sw $t4, -12($t0)
    
lwtwo_row14:
    addi $t0, $t0, 516
    
    sw $t1, 0($t0)
    sw $t5, -4($t0)
    sw $t5, -8($t0)
    sw $t5, -12($t0)
    
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    sw $t1, 12($t0)
    
    sw $t3, 16($t0)
    sw $t3, 20($t0)
    
lwtwo_row15:
    addi $t0, $t0, 512
    sw $t3, -4($t0)
    sw $t3, -8($t0)
    sw $t1, 0($t0)
    
    sw $t1, 4($t0)
    sw $t3, 8($t0)
    sw $t3, 12($t0)
    
lwtwo_row16:
    addi $t0, $t0, 512
    sw $t3, 0($t0)
    sw $t3, -4($t0)
    
    sw $t1, 4($t0)
    sw $t3, 8($t0)
    
lwtwo_row17:
    addi $t0, $t0, 512
    sw $t3, 0($t0)
    
    sw $t3, 8($t0)
    
lwtwo_row18:
    addi $t0, $t0, 512
    sw $t3, 0($t0)
    sw $t3, -4($t0)
    
    sw $t3, 4($t0)
    sw $t3, 8($t0)

    jr $ra


f_draw_lw_three: # fetches location passed in $a0
    li $t0, BASE_ADDRESS # $t0 stores the base address for display
    add $t0, $t0, $a0

    li $t1, 0xCA1515 # body red
    li $t2, 0xD93333 # bright red
    li $t3, 0x8E0000 # dark red
    li $t4, 0xECC500 # belly yellow
    li $t5, 0xC9A800 # dark yellow

    sw $t1, 0($t0)

    addi $t0, $t0, -5128
    addi $t6, $t0, -32

lwthree_row1:
    sw $t2, 0($t0)
    addi $t0, $t0, -4
    bne $t0, $t6, lwthree_row1
    
    addi $t0, $t0, 508
    
    sw $t2, 0($t0)
    addi $t0, $t0, 4
    
    sw $t2, 0($t0)
    addi $t0, $t0, 4
    
    addi $t6, $t0, 32

lwthree_row2_a:
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    bne $t0, $t6, lwthree_row2_a
    
    sw $t3, 0($t0)
    
lwthree_row3:
    addi $t0, $t0, 512
    sw $t3, 4($t0)
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    
    li $t7, 0xFFFFFF # white
    sw $t7, -8($t0)
    
    li $t7, 0x000000 # black
    sw $t7, -12($t0)
    
    sw $t1, -16($t0)
    sw $t1, -20($t0)
    sw $t1, -24($t0)
    
    li $t7, 0x2D2D2D # grey
    sw $t7, -28($t0)
    sw $t1, -32($t0)
    sw $t1, -36($t0)
    sw $t7, -40($t0)
    
lwthree_row4:
    addi $t0, $t0, 512
    sw $t3, 4($t0)
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    
    li $t7, 0x000000 # black
    sw $t7, -8($t0)
    sw $t7, -12($t0)
    
    addi $t0, $t0, -16
    addi $t6, $t0, -28

lwthree_row4_a:
    sw $t1, 0($t0)
    addi $t0, $t0, -4
    bne $t0, $t6, lwthree_row4_a
    
    addi $t0, $t0, 516
    addi $t6, $t0, 48

lwthree_row5_a:
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    bne $t0, $t6, lwthree_row5_a
    
    sw $t3, 0($t0)
    
    addi $t0, $t0, 508
    sw $t3, 4($t0)
    
    sw $t2, 32($t0)
    sw $t2, 36($t0)
    
    addi $t6, $t0, -16

lwthree_row6_a:
    sw $t1, 0($t0)
    addi $t0, $t0, -4
    bne $t0, $t6, lwthree_row6_a
    
    addi $t6, $t0, -28

lwthree_row6_b:
    sw $t3, 0($t0)
    addi $t0, $t0, -4
    bne $t0, $t6, lwthree_row6_b
    
lwthree_row7:
    addi $t0, $t0, 544
    
    sw $t4, -4($t0)
    sw $t4, -8($t0) 
    
    addi $t6, $t0, 20

lwthree_row7_a:
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    bne $t0, $t6, lwthree_row7_a
    
    sw $t3, 0($t0)
    sw $t2, 20($t0)
    sw $t1, 24($t0)
    sw $t1, 28($t0)
    sw $t2, 32($t0)


lwthree_row8:
    addi $t0, $t0, 512
    sw $t3, 0($t0)
    
    sw $t2, 16($t0)
    sw $t1, 20($t0)
    sw $t1, 24($t0)
    sw $t3, 28($t0)
    sw $t2, 32($t0)
    
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    sw $t3, -12($t0)
    sw $t1, -16($t0)
    sw $t1, -20($t0)
    sw $t4, -24($t0)
    sw $t4, -28($t0)
    
lwthree_row9:
    addi $t0, $t0, 512
    
    sw $t2, 4($t0)
    sw $t2, 8($t0)
    sw $t2, 12($t0)
    
    sw $t1, 16($t0)
    sw $t1, 20($t0)
    sw $t3, 24($t0)
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    
    sw $t3, -12($t0)
    sw $t3, -16($t0)
    
    sw $t4, -20($t0)
    sw $t4, -24($t0)
    sw $t4, -28($t0)
    sw $t3, -32($t0)
    
lwthree_row10:
    addi $t0, $t0, 500
    sw $t3, -4($t0)
    sw $t4, -8($t0)
    sw $t4, -12($t0)
    
    sw $t3, -20($t0)
    
    addi $t6, $t0, 36

lwthree_row10_a:
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    bne $t0, $t6, lwthree_row10_a
    
    sw $t3, 0($t0)
    
lwthree_row11:
    addi $t0, $t0, 504
    
    sw $t3, 4($t0)

    addi $t6, $t0, -36

lwthree_row11_a:
    sw $t1, 0($t0)
    addi $t0, $t0, -4
    bne $t0, $t6, lwthree_row11_a
    
    sw $t4, -4($t0)
    sw $t4, 0($t0)
    
lwthree_row12:
    addi $t0, $t0, 516
    
    sw $t4, -4($t0)
    sw $t4, -8($t0)
    
    addi $t6, $t0, 32

lwthree_row12_a:
    sw $t1, 0($t0)
    addi $t0, $t0, 4
    bne $t0, $t6, lwthree_row12_a
    
    sw $t3, 0($t0)
    
lwthree_row13:
    addi $t0, $t0, 508
    
    sw $t3, 4($t0)
    
    addi $t6, $t0, -24
lwthree_row13_a:
    sw $t1, 0($t0)
    addi $t0, $t0, -4
    bne $t0, $t6, lwthree_row13_a
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    sw $t4, -8($t0)
    sw $t4, -12($t0)
    
lwthree_row14:
    addi $t0, $t0, 516
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    sw $t5, -8($t0)
    sw $t5, -12($t0)
    
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    sw $t1, 12($t0)
    
    sw $t3, 16($t0)
    sw $t3, 20($t0)
    
lwthree_row15:
    addi $t0, $t0, 512
    sw $t1, -4($t0)
    sw $t1, 0($t0)
    
    sw $t3, 4($t0)
    sw $t3, 8($t0)
    sw $t3, 12($t0)
    
lwthree_row16:
    addi $t0, $t0, 512

    sw $t1, 0($t0)
    sw $t3, 4($t0)
    
lwthree_row17:
    addi $t0, $t0, 512
    sw $t3, 4($t0)
    
lwthree_row18:
    addi $t0, $t0, 512
    sw $t3, 0($t0)   
    sw $t3, 4($t0)

    jr $ra




