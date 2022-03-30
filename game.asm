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
