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
# - Display height in pixels: 512 (update this as needed) 
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

    char_pos: .word 16512

    char_status: .word 1 #1 for right stand, 2 for left stand, 3 for right climb, 4 for left stand

    sprite_status: .word 1 #used to toggle between sprites

.text

.globl main

main: 
    jal f_set_screen
    addi $t9, $zero, 10
    
main_while:
    la $t0, char_pos
    lw $t1, 0($t0)
    addi $t1, $t1, 20
    sw $t1, 0($t0)
    jal f_draw_lc
    
    li $v0, 10 # terminate the program gracefully 
    syscall 

f_set_screen:
    li $t0, BASE_ADDRESS # $t0 stores the base address for display
    li $t1, 0xFFFFFF # white
    addi $t2, $t0, 32768 # stores bottom right pixel index number + 4

while_set_screen:
    sw $t1, 0($t0) # set $t2 to white
    addi $t0, $t0, 4 # increment $t2 to next index
    bne $t0, $t2, while_set_screen

    jr $ra 
    
f_draw_rw_one:

    la $t0, char_pos
    lw $t0, 0($t0)
    addi $t0, $t0, BASE_ADDRESS
    
    li $t1, 0x2DA7FF # body blue
    li $t2, 0x1E54FF # dark blue
    li $t3, 0xc1E5FF # light blue
    li $t4, 0x000000 # black
    
rwone_row1:
    addi $t0, $t0 -1280
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    sw $t2, -8($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    
rwone_row2:
    addi $t0, $t0 256
    
    sw $t4, 0($t0)
    sw $t1, -4($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    sw $t1, 12($t0)
    
rwone_row3:
    addi $t0, $t0 256
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    sw $t2, -8($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    sw $t1, 12($t0)
    
rwone_row4:
    addi $t0, $t0 256
    
    sw $t3, 0($t0)
    sw $t3, 4($t0)
    sw $t1, -4($t0)
    
rwone_row5:
    addi $t0, $t0 256
    
    sw $t1, 0($t0)
    sw $t3, 4($t0)
    sw $t1, 8($t0)
    sw $t1, -4($t0)
    sw $t2, -8($t0)
    
rwone_row6:
    addi $t0, $t0 256
    
    sw $t3, 0($t0)
    sw $t3, 4($t0)
    sw $t1, -4($t0)
    
rwone_row7:
    addi $t0, $t0 256
    
    sw $t3, 0($t0)
    sw $t3, 4($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    
rwone_row8:
    addi $t0, $t0 256
    
    sw $t1, 4($t0)
    sw $t1, -4($t0)

    jr $ra     
    

f_draw_rw_two:

    la $t0, char_pos
    lw $t0, 0($t0)
    addi $t0, $t0, BASE_ADDRESS
    
    li $t1, 0x2DA7FF # body blue
    li $t2, 0x1E54FF # dark blue
    li $t3, 0xc1E5FF # light blue
    li $t4, 0x000000 # black
    
rwtwo_row1:
    addi $t0, $t0 -1280
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    sw $t2, -8($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    
rwtwo_row2:
    addi $t0, $t0 256
    
    sw $t4, 0($t0)
    sw $t1, -4($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    sw $t1, 12($t0)
    
rwtwo_row3:
    addi $t0, $t0 256
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    sw $t2, -8($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    sw $t1, 12($t0)
    
rwtwo_row4:
    addi $t0, $t0 256
    
    sw $t3, 0($t0)
    sw $t3, 4($t0)
    sw $t1, -4($t0)
    
rwtwo_row5:
    addi $t0, $t0 256
    
    sw $t1, 0($t0)
    sw $t3, 4($t0)
    sw $t1, 8($t0)
    sw $t1, -4($t0)
    sw $t2, -8($t0)
    
rwtwo_row6:
    addi $t0, $t0 256
    
    sw $t3, 0($t0)
    sw $t3, 4($t0)
    sw $t1, -4($t0)
    
rwtwo_row7:
    addi $t0, $t0 256
    
    sw $t1, 0($t0)
    sw $t3, 4($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    
rwtwo_row8:
    addi $t0, $t0 256
    
    sw $t1, 0($t0)

    jr $ra   

f_draw_lw_one:

    la $t0, char_pos
    lw $t0, 0($t0)
    addi $t0, $t0, BASE_ADDRESS
    
    li $t1, 0x2DA7FF # body blue
    li $t2, 0x1E54FF # dark blue
    li $t3, 0xc1E5FF # light blue
    li $t4, 0x000000 # black
    
lwone_row1:
    addi $t0, $t0 -1280
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    sw $t1, 4($t0)
    sw $t2, 8($t0)
    
lwone_row2:
    addi $t0, $t0 256
    
    sw $t4, 0($t0)
    sw $t1, 4($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    sw $t1, -12($t0)
    
lwone_row3:
    addi $t0, $t0 256
    
    sw $t1, 0($t0)
    sw $t1, 4($t0)
    sw $t2, 8($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    sw $t1, -12($t0)
    
lwone_row4:
    addi $t0, $t0 256
    
    sw $t3, 0($t0)
    sw $t3, -4($t0)
    sw $t1, 4($t0)
    
lwone_row5:
    addi $t0, $t0 256
    
    sw $t1, 0($t0)
    sw $t3, -4($t0)
    sw $t1, -8($t0)
    sw $t1, 4($t0)
    sw $t2, 8($t0)
    
lwone_row6:
    addi $t0, $t0 256
    
    sw $t3, 0($t0)
    sw $t3, -4($t0)
    sw $t1, 4($t0)
    
lwone_row7:
    addi $t0, $t0 256
    
    sw $t3, 0($t0)
    sw $t3, -4($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    
lwone_row8:
    addi $t0, $t0 256
    
    sw $t1, -4($t0)
    sw $t1, 4($t0)

    jr $ra
    
f_draw_lw_two:

    la $t0, char_pos
    lw $t0, 0($t0)
    addi $t0, $t0, BASE_ADDRESS
    
    li $t1, 0x2DA7FF # body blue
    li $t2, 0x1E54FF # dark blue
    li $t3, 0xc1E5FF # light blue
    li $t4, 0x000000 # black
    
lwtwo_row1:
    addi $t0, $t0 -1280
    
    sw $t1, 0($t0)
    sw $t1, 4($t0)
    sw $t2, 8($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    
lwtwo_row2:
    addi $t0, $t0 256
    
    sw $t4, 0($t0)
    sw $t1, 4($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    sw $t1, -12($t0)
    
lwtwo_row3:
    addi $t0, $t0 256
    
    sw $t1, 0($t0)
    sw $t1, 4($t0)
    sw $t2, 8($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    sw $t1, -12($t0)
    
lwtwo_row4:
    addi $t0, $t0 256
    
    sw $t3, 0($t0)
    sw $t3, -4($t0)
    sw $t1, 4($t0)
    
lwtwo_row5:
    addi $t0, $t0 256
    
    sw $t1, 0($t0)
    sw $t3, -4($t0)
    sw $t1, -8($t0)
    sw $t1, 4($t0)
    sw $t2, 8($t0)
    
lwtwo_row6:
    addi $t0, $t0 256
    
    sw $t3, 0($t0)
    sw $t3, -4($t0)
    sw $t1, 4($t0)
    
lwtwo_row7:
    addi $t0, $t0 256
    
    sw $t1, 0($t0)
    sw $t3, -4($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    
lwtwo_row8:
    addi $t0, $t0 256
    
    sw $t1, 0($t0)

    jr $ra
    
f_erase_lw:

    la $t0, char_pos
    lw $t0, 0($t0)
    addi $t0, $t0, BASE_ADDRESS
    
    li $t1, 0xFFFFFF # white
    
elw_row1:
    addi $t0, $t0 -1280
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    
elw_row2:
    addi $t0, $t0 256
    
    sw $t1, 0($t0)
    sw $t1, 4($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    sw $t1, -12($t0)
    
elw_row3:
    addi $t0, $t0 256
    
    sw $t1, 0($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    sw $t1, -12($t0)
    
elw_row4:
    addi $t0, $t0 256
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    sw $t1, 4($t0)
    
elw_row5:
    addi $t0, $t0 256
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    
elw_row6:
    addi $t0, $t0 256
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    sw $t1, 4($t0)
    
elw_row7:
    addi $t0, $t0 256
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    
elw_row8:
    addi $t0, $t0 256
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    sw $t1, 4($t0)

    jr $ra
    

f_erase_rw:

    la $t0, char_pos
    lw $t0, 0($t0)
    addi $t0, $t0, BASE_ADDRESS
    
    li $t1, 0xFFFFFF # white
    
erw_row1:
    addi $t0, $t0 -1280
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    
erw_row2:
    addi $t0, $t0 256
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    sw $t1, 12($t0)
    
erw_row3:
    addi $t0, $t0 256
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    sw $t1, 12($t0)
    
erw_row4:
    addi $t0, $t0 256
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    sw $t1, 4($t0)
    
erw_row5:
    addi $t0, $t0 256
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    
erw_row6:
    addi $t0, $t0 256
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    sw $t1, 4($t0)
    
erw_row7:
    addi $t0, $t0 256
    
    sw $t1, 0($t0)
    sw $t1, 4($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    
erw_row8:
    addi $t0, $t0 256
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    sw $t1, 4($t0)

    jr $ra         
    

f_draw_rc:

    la $t0, char_pos
    lw $t0, 0($t0)
    addi $t0, $t0, BASE_ADDRESS
    
    li $t1, 0x2DA7FF # body blue
    li $t2, 0x1E54FF # dark blue
    li $t3, 0xc1E5FF # light blue
    li $t4, 0x000000 # black
    
rc_row1:
    addi $t0, $t0 -1280
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    sw $t2, -8($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    
rc_row2:
    addi $t0, $t0 256
    
    sw $t4, 0($t0)
    sw $t1, -4($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    sw $t1, 12($t0)
    
rc_row3:
    addi $t0, $t0 256
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    sw $t2, -8($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    sw $t1, 12($t0)
    
rc_row4:
    addi $t0, $t0 256
    
    sw $t1, 0($t0)
    sw $t3, 8($t0)
    sw $t1, 4($t0)
    sw $t2, -4($t0)
    
rc_row5:
    addi $t0, $t0 256
    
    sw $t1, 0($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    sw $t1, 12($t0)
    
rc_row6:
    addi $t0, $t0 256
    
    sw $t1, 0($t0)
    sw $t3, 8($t0)
    sw $t1, 4($t0)
    
rc_row7:
    addi $t0, $t0 256
    
    sw $t1, 0($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    sw $t1, 12($t0)
    
rc_row8:
    addi $t0, $t0 256
    
    sw $t1, -4($t0)

    jr $ra
    
    
f_draw_lc:

    la $t0, char_pos
    lw $t0, 0($t0)
    addi $t0, $t0, BASE_ADDRESS
    
    li $t1, 0x2DA7FF # body blue
    li $t2, 0x1E54FF # dark blue
    li $t3, 0xc1E5FF # light blue
    li $t4, 0x000000 # black
    
lc_row1:
    addi $t0, $t0 -1280
    
    sw $t1, 0($t0)
    sw $t1, 4($t0)
    sw $t2, 8($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    
lc_row2:
    addi $t0, $t0 256
    
    sw $t4, 0($t0)
    sw $t1, 4($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    sw $t1, -12($t0)
    
lc_row3:
    addi $t0, $t0 256
    
    sw $t1, 0($t0)
    sw $t1, 4($t0)
    sw $t2, 8($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    sw $t1, -12($t0)
    
lc_row4:
    addi $t0, $t0 256
    
    sw $t1, 0($t0)
    sw $t3, -8($t0)
    sw $t1, -4($t0)
    sw $t2, 4($t0)
    
lc_row5:
    addi $t0, $t0 256
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    sw $t1, -12($t0)
    
lc_row6:
    addi $t0, $t0 256
    
    sw $t1, 0($t0)
    sw $t3, -8($t0)
    sw $t1, -4($t0)
    
lc_row7:
    addi $t0, $t0 256
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    sw $t1, -12($t0)
    
lc_row8:
    addi $t0, $t0 256
    
    sw $t1, 4($t0)

    jr $ra    