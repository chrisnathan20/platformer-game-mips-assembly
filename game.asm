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
# - Display width in pixels: 512 (update this as needed) 
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
.eqv  CHECK_KEYPRESS  0xFFFF0000
.eqv  HEALTH_BAR_POS 1032
.eqv  START_MENU_POS 6700
.eqv  CHAR_START_POS 50192
.eqv  FIXED_ENEMY_POS

# Harmful colors (each deal -1 damage)
.eqv CACTUS_GREEN 0x2B4D1B
.eqv UPPERBODY_ORANGE 0xFC6A03
.eqv LOWERBODY_ORANGE 0xC95B0C
.eqv LAVA_ORANGE 0xF76806



.data 

    padding:	.space	36000   #Empty space to prevent game data from being overwritten due to large bitmap size

    char_pos: .word	79888

    char_status: .word 1 #1 for right walk/stand, 2 for left walk/stand, 3 for right climb, 4 for left stand
    
    char_health: .word 6 #ranges from 6 to 1
    
    jump_counter: .word -1
    
    djump_counter: .word -1
    
    gravity_counter: .word 0
    
    damage_cooldown: .word 0 #max is 25, damage cooldown for 1 seconds (25 frames), decrement every frame once hit

    sprite_walk_status: .word 0 #used to toggle between sprites
    
    moving_enemy_pos: .word 1

.text

.globl main

main: 
    
initialize_start_menu:
	#jal f_set_screen_black
	#jal f_draw_start_menu
	#li $s1, 0 #used to keep track which option we are in    
    
    #j END
    
initialize_char:    
    la $t0, char_pos
    li $t1, CHAR_START_POS
    sw $t1, 0($t0)
    
    la $t0, char_status
    li $t1, 1
    sw $t1, 0($t0)
    
    la $t0, char_health
    li $t1, 6
    sw $t1, 0($t0)
    
    la $t0, jump_counter
    li $t1, -1
    sw $t1, 0($t0)
    
    la $t0, djump_counter
    li $t1, -1
    sw $t1, 0($t0)
    
    la $t0, gravity_counter
    li $t1, 0
    sw $t1, 0($t0)
    
    la $t0, damage_cooldown
    li $t1, 0
    sw $t1, 0($t0)
    
    la $t0, sprite_walk_status
    li $t1, 0
    sw $t1, 0($t0)
    
    
    jal f_set_screen
    jal f_draw_health_bar
    
    jal f_draw_level
    
#s0 - save previous char_pos
#s1 - save previous char_status
#s2 - reserved for drawing character red when hurt and reset when cooldown finishes

#s6 - counter limit for while loops that call other functions
#s7 - counter for while loops calling other functions

	jal f_draw_char
main_while:
	
    la $t0, char_pos
    lw $s0, 0($t0)
    
    la $t0, char_status
    lw $s1, 0($t0)
    
    li $s2, 1
    
if_mid_jump:    
    la $t0, jump_counter
    lw $t1, 0($t0)
    
    ble $t1, 0, do_gravity #FIX THIS to gravity check
    
j_one:    
    bne $t1, 1, j_two
    li $s7, 0
    
while_jump_one:
	jal f_move_up
	addi $s7, $s7, 1
	bne $s7, 4, while_jump_one
	
	j end_if_mid_jump
    
j_two:
	bne $t1, 2, j_three
    li $s7, 0
    
while_jump_two:
	jal f_move_up
	addi $s7, $s7, 1
	bne $s7, 3, while_jump_two
	
	j end_if_mid_jump
	
j_three:
	bne $t1, 3, j_four
    li $s7, 0
    
while_jump_three:
	jal f_move_up
	addi $s7, $s7, 1
	bne $s7, 3, while_jump_three
	
	j end_if_mid_jump
	
j_four:
	bne $t1, 4, j_five
    li $s7, 0
    
while_jump_four:
	jal f_move_up
	addi $s7, $s7, 1
	bne $s7, 2, while_jump_four
	
	j end_if_mid_jump
	
j_five:
	bne $t1, 5, j_six
    li $s7, 0
    
while_jump_five:
	jal f_move_up
	addi $s7, $s7, 1
	bne $s7, 2, while_jump_five
	
	j end_if_mid_jump
	
j_six:
	bne $t1, 6, j_seven
    li $s7, 0
    
while_jump_six:
	jal f_move_up
	addi $s7, $s7, 1
	bne $s7, 1, while_jump_six
	
	j end_if_mid_jump
	
j_seven:
	bne $t1, 7, j_eight
    li $s7, 0
    
while_jump_seven:
	jal f_move_up
	addi $s7, $s7, 1
	bne $s7, 1, while_jump_seven
	
	j end_if_mid_jump
	
j_eight:
	bne $t1, 8, end_if_mid_jump
    li $s7, 0
    
while_jump_eight:
	jal f_move_up
	addi $s7, $s7, 1
	bne $s7, 1, while_jump_eight
	
	j end_if_mid_jump

end_if_mid_jump:   
	la $t0, jump_counter
    lw $t1, 0($t0)
    addi $t1, $t1, 1
    bne $t1 , 12, end_jump
    li $t1, -1
end_jump:    
    sw $t1, 0($t0)
    j key_check
    
do_gravity:
	la $t0, gravity_counter
    lw $t1, 0($t0)
    
g_one:
	bgt $t1, 1, g_three
	jal f_move_down	

	j end_do_gravity
	
g_three:
	bgt $t1, 3, g_five
	jal f_move_down
	jal f_move_down	
	
	j end_do_gravity
	
g_five:
	bgt $t1, 5, g_terminal
	jal f_move_down
	jal f_move_down
	jal f_move_down	
	
	j end_do_gravity
	
g_terminal:
	jal f_move_down
	jal f_move_down
	jal f_move_down	
	jal f_move_down	
	
	
end_do_gravity:

	la $t0, gravity_counter
    lw $t1, 0($t0)
    addi $t1, $t1, 1
    sw $t1, 0($t0)
    
key_check:
    li $t9, 0xFFFF0000  
	lw $t8, 0($t9) 
	bne $t8, 1, end_if_keypress_happened  
	
	lw $t2, 4($t9) # this assumes $t9 is set to 0xfff0000 from before 

if_p_pressed:
	bne $t2, 112, end_if_p_pressed
	j initialize_char
end_if_p_pressed:

	beq $t2, 97, if_a_pressed   # ASCII code of 'a' is 0x61 or 97 in decimal
	beq $t2, 106, if_a_pressed
	j end_if_a_pressed
if_a_pressed:
	la $t0, char_status
	li $t1, 2
    sw $t1, 0($t0)
	jal f_move_left
	jal f_move_left
	jal f_move_left
	j end_if_keypress_happened

end_if_a_pressed:
	beq $t2, 100, if_d_pressed
	beq $t2, 108, if_d_pressed
	j if_jump_pressed  
if_d_pressed:
	la $t0, char_status
	li $t1, 1
    sw $t1, 0($t0)
	jal f_move_right
	jal f_move_right
	jal f_move_right
	j end_if_keypress_happened

if_jump_pressed:
	beq $t2, 32, do_jump
	beq $t2, 119, do_jump
	beq $t2, 105, do_jump
	j end_if_keypress_happened
	
do_jump:	
	la $t0, jump_counter
	lw $t1, 0($t0)
	beq $t1, 0, j_zero
	
	la $t0, djump_counter
	lw $t1, 0($t0)
	beq $t1, 0, double_j
	j end_if_keypress_happened
	
double_j:
	la $t0, djump_counter
	li $t1, 1
	sw $t1, 0($t0)
	la $t0, jump_counter
	li $t1, 3
	sw $t1, 0($t0)
	j end_if_keypress_happened

j_zero:
	jal f_move_up
	jal f_move_up
	jal f_move_up
	jal f_move_up

	
	la $t0, jump_counter
	li $t1, 2
    sw $t1, 0($t0)
	
	
end_if_keypress_happened:


if_damage_check:
	la $t0, damage_cooldown
    lw $t1, 0($t0)
    bne $t1, 0, decrement_damage_cooldown
	jal f_damage_check
	beq $v0, -1, damage_happened
	j end_if_damage_check
	
decrement_damage_cooldown:
	la $t0, damage_cooldown
    lw $t1, 0($t0)
    addi $t1, $t1, -1
    sw $t1, 0($t0)
    
    bne $t1, 0, end_if_damage_check
    li $s2, 0
    
    j end_if_damage_check
    
damage_happened:
	la $t0, char_health
    lw $t1, 0($t0)
    addi $t1, $t1, -1
    sw $t1, 0($t0)
    
    beq $t1, 0, game_over
    
    la $t0, damage_cooldown
    li $t1, 15
    sw $t1, 0($t0)
    
    li $s2, 0
    
    jal f_draw_health_bar

end_if_damage_check:

if_change_char_pos:   
    la $t0, char_pos
    lw $t1, 0($t0)

	beq $s2, 0, draw_char

	beq $s0, $t1, end_if_change_char_pos

draw_char:
	jal f_erase
    jal f_draw_char
    
end_if_change_char_pos:
    	
check_platform_below:
	jal f_on_platform
	bne $v0, 1, main_no_platform
	la $t0, gravity_counter
	li $t1, 0
    sw $t1, 0($t0)
    la $t0, jump_counter
	li $t1, 0
    sw $t1, 0($t0)
    la $t0, djump_counter
	li $t1, 0
    sw $t1, 0($t0)
    j end_main_while
    
main_no_platform:
	la $t0, jump_counter
	lw $t1, 0($t0)
	bne $t1, 0, end_main_while
	
	li $t1, -1
    sw $t1, 0($t0)
	
end_main_while:
	li $v0 32
	li $a0 40
	syscall

    j main_while
    
game_over:
	jal f_set_screen_black
        
END:

	li $v0, 1       
	li $a0, -1       # $integer to print
	syscall

    li $v0, 10 # terminate the program gracefully 
    syscall 


### GAME LOGIC FUNCTIONS ###

f_move_right:
	la $t0, char_pos
    lw $t0, 0($t0)
    addi $t0, $t0, -2544
    addi $t0, $t0, BASE_ADDRESS
    
    addi $t1, $t0, 4096
    li $t3, 0xFFFFFF # WHITE
    
    li $t4, 512
    li $t6, 508
    
while_f_move_right:
	lw $t2, 0($t0)
	
	div $t0, $t4
	mfhi $t5
	beq $t5, $t6, end_f_move_right
	
	beq $t2, $t3, end_if_right_white_orange
	
	j end_f_move_right
	
end_if_right_white_orange:
		
	addi $t0, $t0, 512 # increment $t2 to next row index
	bne $t0, $t1, while_f_move_right       
	

	la $t0, char_pos
    lw $t1, 0($t0)
    addi $t1, $t1, 4
    sw $t1, 0($t0)
	        
end_f_move_right:
	jr $ra  
	
	
f_move_up:
	la $t0, char_pos
    lw $t0, 0($t0)
    addi $t0, $t0, -3084
    addi $t0, $t0, BASE_ADDRESS
    
    addi $t1, $t0, 28
    li $t3, 0xFFFFFF # WHITE
    
while_f_move_up:
	lw $t2, 0($t0)
	
	beq $t2, $t3, end_if_up_white_orange
	
	j end_f_move_up
	
end_if_up_white_orange:
		
	addi $t0, $t0, 4 # increment $t2 to next col index
	bne $t0, $t1, while_f_move_up     
	

	la $t0, char_pos
    lw $t1, 0($t0)
    addi $t1, $t1, -512
    sw $t1, 0($t0)
	        
end_f_move_up:
	jr $ra  

f_move_left:
	la $t0, char_pos
    lw $t0, 0($t0)
    addi $t0, $t0, -2576
    addi $t0, $t0, BASE_ADDRESS
    
    addi $t1, $t0, 4096
    li $t3, 0xFFFFFF # WHITE
    
    li $t4, 512
    
while_f_move_left:
	lw $t2, 0($t0)
	
	div $t0, $t4
	mfhi $t5
	beq $t5, $zero, end_f_move_left
	
	beq $t2, $t3, end_if_left_white_orange
	
	j end_f_move_left
	
end_if_left_white_orange:
		
	addi $t0, $t0, 512 # increment $t2 to next row index
	bne $t0, $t1, while_f_move_left       
	

	la $t0, char_pos
    lw $t1, 0($t0)
    addi $t1, $t1, -4
    sw $t1, 0($t0)
	        
end_f_move_left:
	jr $ra  


f_move_down:
	la $t0, char_pos
    lw $t0, 0($t0)
    addi $t0, $t0, 1524
    addi $t0, $t0, BASE_ADDRESS
    
    addi $t1, $t0, 28
    li $t3, 0xFFFFFF # WHITE
    
while_f_move_down:
	lw $t2, 0($t0)
	
	beq $t2, $t3, end_if_down_white_orange
	
	j end_f_move_right
	
end_if_down_white_orange:
		
	addi $t0, $t0, 4 # increment $t2 to next col index
	bne $t0, $t1, while_f_move_down     
	

	la $t0, char_pos
    lw $t1, 0($t0)
    addi $t1, $t1, 512
    sw $t1, 0($t0)
	        
end_f_move_down:
	jr $ra
	
	
f_on_platform:
	la $t0, char_pos
    lw $t0, 0($t0)
    addi $t0, $t0, 1524
    addi $t0, $t0, BASE_ADDRESS
    
    addi $t1, $t0, 28
    li $t3, 0xFFFFFF # WHITE
    
while_f_on_platform:
	lw $t2, 0($t0)
	
	beq $t2, $t3, end_if_on_platform_white_orange
	
	li $v0, 1 #set v0 to 1 if on a platform
	
	jr $ra
	
end_if_on_platform_white_orange:
		
	addi $t0, $t0, 4 # increment $t2 to next col index
	bne $t0, $t1, while_f_on_platform     
	

	li $v0, 0 #set v0 to 0 if not on a platform
	jr $ra
	
	
f_damage_check:
	#v0 is set to -1 if there is damage
	
	la $t0, char_status
    lw $t1, 0($t0)
    
    la $t0, char_pos
    lw $t0, 0($t0)
    
    addi $t0, $t0, BASE_ADDRESS
	
if_damage_rw:
	bne $t1, 1, if_damage_lw

	addi $t0, $t0, -3084
	j start_check_damage
	
if_damage_lw:
	addi $t0, $t0, -3088
	
start_check_damage:
	addi $t2, $t0, 32
	
top_damage:
	lw $t3, 0($t0)
	beq $t3, CACTUS_GREEN, yes_damage
	beq $t3, UPPERBODY_ORANGE, yes_damage
	beq $t3, LOWERBODY_ORANGE, yes_damage
	beq $t3, LAVA_ORANGE, yes_damage
	addi $t0, $t0, 4
	bne $t0, $t2, top_damage
	
	addi $t0, $t0, -4
	addi $t2, $t0, 5120
	
right_damage:
	lw $t3, 0($t0)
	beq $t3, CACTUS_GREEN, yes_damage
	beq $t3, UPPERBODY_ORANGE, yes_damage
	beq $t3, LOWERBODY_ORANGE, yes_damage
	beq $t3, LAVA_ORANGE, yes_damage
	addi $t0, $t0, 512
	bne $t0, $t2, right_damage
	
	addi $t0, $t0, -512
	addi $t2, $t0, -32
	
bottom_damage:
	lw $t3, 0($t0)
	beq $t3, CACTUS_GREEN, yes_damage
	beq $t3, UPPERBODY_ORANGE, yes_damage
	beq $t3, LOWERBODY_ORANGE, yes_damage
	beq $t3, LAVA_ORANGE, yes_damage
	addi $t0, $t0, -4
	bne $t0, $t2, bottom_damage
	
	addi $t0, $t0, 4
	addi $t2, $t0, -5120
	
left_damage:
	lw $t3, 0($t0)
	beq $t3, CACTUS_GREEN, yes_damage
	beq $t3, UPPERBODY_ORANGE, yes_damage
	beq $t3, LOWERBODY_ORANGE, yes_damage
	beq $t3, LAVA_ORANGE, yes_damage
	addi $t0, $t0, -512
	bne $t0, $t2, left_damage

no_damage:
	li $v0, 0
	jr $ra	
	
yes_damage:
	li $v0, -1
	jr $ra

### DRAWING FUNCTIONS ###

f_set_screen:
    li $t0, BASE_ADDRESS # $t0 stores the base address for display
    li $t1, 0xFFFFFF # white
    addi $t2, $t0, 65536 # stores bottom right pixel index number + 4

while_set_screen:
    sw $t1, 0($t0) # set $t2 to white
    addi $t0, $t0, 4 # increment $t2 to next index
    bne $t0, $t2, while_set_screen

    jr $ra 

f_set_screen_black:
    li $t0, BASE_ADDRESS # $t0 stores the base address for display
    li $t1, 0x000000 # white
    addi $t2, $t0, 65536 # stores bottom right pixel index number + 4

while_set_screen_black:
    sw $t1, 0($t0) # set $t2 to white
    addi $t0, $t0, 4 # increment $t2 to next index
    bne $t0, $t2, while_set_screen_black

    jr $ra 


f_draw_rw:
	
	la $t0, sprite_walk_status
    lw $t1, 0($t0)
    addi $t2, $t1, 1
    sw $t2, 0($t0)
    li $t0, 3
    
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    bge $t1, $t0, rw_two

rw_one:
	la $t0, damage_cooldown
    lw $t1, 0($t0)
    beq $t1, 0, rw_one_no_damage
    jal f_draw_rw_one_d
    j end_if_f_draw_rw

rw_one_no_damage:
	jal f_draw_rw_one
	j end_if_f_draw_rw

rw_two:
	la $t0, damage_cooldown
    lw $t1, 0($t0)
    beq $t1, 0, rw_two_no_damage
    jal f_draw_rw_two_d
    j end_if_f_draw_rw
    
rw_two_no_damage:
	jal f_draw_rw_two

end_if_f_draw_rw:
	
	la $t0, sprite_walk_status
    lw $t1, 0($t0)
    li $t0, 6
    bne $t1, $t0, end_f_draw_rw
    la $t0, sprite_walk_status
    li $t1, 0
    sw $t1, 0($t0)
    
end_f_draw_rw:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
f_draw_lw:
	la $t0, sprite_walk_status
    lw $t1, 0($t0)
    addi $t2, $t1, 1
    sw $t2, 0($t0)
    li $t0, 3
    
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    bge $t1, $t0, lw_two

lw_one:
	la $t0, damage_cooldown
    lw $t1, 0($t0)
    beq $t1, 0, lw_one_no_damage
    jal f_draw_lw_one_d
    j end_if_f_draw_lw
lw_one_no_damage:
	jal f_draw_lw_one
	j end_if_f_draw_lw

lw_two:
	la $t0, damage_cooldown
    lw $t1, 0($t0)
    beq $t1, 0, lw_two_no_damage
    jal f_draw_lw_two_d
    j end_if_f_draw_lw
lw_two_no_damage:
	jal f_draw_lw_two

end_if_f_draw_lw:
	
	la $t0, sprite_walk_status
    lw $t1, 0($t0)
    li $t0, 6
    bne $t1, $t0, end_f_draw_lw
    la $t0, sprite_walk_status
    li $t1, 0
    sw $t1, 0($t0)
    
end_f_draw_lw:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
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
    addi $t0, $t0 -2560
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    sw $t2, -8($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    
rwone_row2:
    addi $t0, $t0 512
    
    sw $t4, 0($t0)
    sw $t1, -4($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    sw $t1, 12($t0)
    
rwone_row3:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    sw $t2, -8($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    sw $t1, 12($t0)
    
rwone_row4:
    addi $t0, $t0 512
    
    sw $t3, 0($t0)
    sw $t3, 4($t0)
    sw $t1, -4($t0)
    
rwone_row5:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)
    sw $t3, 4($t0)
    sw $t1, 8($t0)
    sw $t1, -4($t0)
    sw $t2, -8($t0)
    
rwone_row6:
    addi $t0, $t0 512
    
    sw $t3, 0($t0)
    sw $t3, 4($t0)
    sw $t1, -4($t0)
    
rwone_row7:
    addi $t0, $t0 512
    
    sw $t3, 0($t0)
    sw $t3, 4($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    
rwone_row8:
    addi $t0, $t0 512
    
    sw $t1, 4($t0)
    sw $t1, -4($t0)

    jr $ra
    

f_draw_rw_one_d:

    la $t0, char_pos
    lw $t0, 0($t0)
    addi $t0, $t0, BASE_ADDRESS
    
    li $t1, 0xFF0000 # body blue
    li $t2, 0xFF0000 # dark blue
    li $t3, 0xFF0000 # light blue
    li $t4, 0xFFFFFF # black
    
rwone_row1d:
    addi $t0, $t0 -2560
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    sw $t2, -8($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    
rwone_row2d:
    addi $t0, $t0 512
    
    sw $t4, 0($t0)
    sw $t1, -4($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    sw $t1, 12($t0)
    
rwone_row3d:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    sw $t2, -8($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    sw $t1, 12($t0)
    
rwone_row4d:
    addi $t0, $t0 512
    
    sw $t3, 0($t0)
    sw $t3, 4($t0)
    sw $t1, -4($t0)
    
rwone_row5d:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)
    sw $t3, 4($t0)
    sw $t1, 8($t0)
    sw $t1, -4($t0)
    sw $t2, -8($t0)
    
rwone_row6d:
    addi $t0, $t0 512
    
    sw $t3, 0($t0)
    sw $t3, 4($t0)
    sw $t1, -4($t0)
    
rwone_row7d:
    addi $t0, $t0 512
    
    sw $t3, 0($t0)
    sw $t3, 4($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    
rwone_row8d:
    addi $t0, $t0 512
    
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
    addi $t0, $t0 -2560
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    sw $t2, -8($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    
rwtwo_row2:
    addi $t0, $t0 512
    
    sw $t4, 0($t0)
    sw $t1, -4($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    sw $t1, 12($t0)
    
rwtwo_row3:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    sw $t2, -8($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    sw $t1, 12($t0)
    
rwtwo_row4:
    addi $t0, $t0 512
    
    sw $t3, 0($t0)
    sw $t3, 4($t0)
    sw $t1, -4($t0)
    
rwtwo_row5:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)
    sw $t3, 4($t0)
    sw $t1, 8($t0)
    sw $t1, -4($t0)
    sw $t2, -8($t0)
    
rwtwo_row6:
    addi $t0, $t0 512
    
    sw $t3, 0($t0)
    sw $t3, 4($t0)
    sw $t1, -4($t0)
    
rwtwo_row7:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)
    sw $t3, 4($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    
rwtwo_row8:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)

    jr $ra
    
    
f_draw_rw_two_d:

    la $t0, char_pos
    lw $t0, 0($t0)
    addi $t0, $t0, BASE_ADDRESS
    
    li $t1, 0xFF0000 # body blue
    li $t2, 0xFF0000 # dark blue
    li $t3, 0xFF0000 # light blue
    li $t4, 0xFFFFFF # black
    
rwtwo_row1d:
    addi $t0, $t0 -2560
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    sw $t2, -8($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    
rwtwo_row2d:
    addi $t0, $t0 512
    
    sw $t4, 0($t0)
    sw $t1, -4($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    sw $t1, 12($t0)
    
rwtwo_row3d:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    sw $t2, -8($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    sw $t1, 12($t0)
    
rwtwo_row4d:
    addi $t0, $t0 512
    
    sw $t3, 0($t0)
    sw $t3, 4($t0)
    sw $t1, -4($t0)
    
rwtwo_row5d:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)
    sw $t3, 4($t0)
    sw $t1, 8($t0)
    sw $t1, -4($t0)
    sw $t2, -8($t0)
    
rwtwo_row6d:
    addi $t0, $t0 512
    
    sw $t3, 0($t0)
    sw $t3, 4($t0)
    sw $t1, -4($t0)
    
rwtwo_row7d:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)
    sw $t3, 4($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    
rwtwo_row8d:
    addi $t0, $t0 512
    
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
    addi $t0, $t0 -2560
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    sw $t1, 4($t0)
    sw $t2, 8($t0)
    
lwone_row2:
    addi $t0, $t0 512
    
    sw $t4, 0($t0)
    sw $t1, 4($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    sw $t1, -12($t0)
    
lwone_row3:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)
    sw $t1, 4($t0)
    sw $t2, 8($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    sw $t1, -12($t0)
    
lwone_row4:
    addi $t0, $t0 512
    
    sw $t3, 0($t0)
    sw $t3, -4($t0)
    sw $t1, 4($t0)
    
lwone_row5:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)
    sw $t3, -4($t0)
    sw $t1, -8($t0)
    sw $t1, 4($t0)
    sw $t2, 8($t0)
    
lwone_row6:
    addi $t0, $t0 512
    
    sw $t3, 0($t0)
    sw $t3, -4($t0)
    sw $t1, 4($t0)
    
lwone_row7:
    addi $t0, $t0 512
    
    sw $t3, 0($t0)
    sw $t3, -4($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    
lwone_row8:
    addi $t0, $t0 512
    
    sw $t1, -4($t0)
    sw $t1, 4($t0)

    jr $ra
    
    
f_draw_lw_one_d:

    la $t0, char_pos
    lw $t0, 0($t0)
    addi $t0, $t0, BASE_ADDRESS
    
    li $t1, 0xFF0000 # body blue
    li $t2, 0xFF0000 # dark blue
    li $t3, 0xFF0000 # light blue
    li $t4, 0xFFFFFF # black
    
lwone_row1d:
    addi $t0, $t0 -2560
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    sw $t1, 4($t0)
    sw $t2, 8($t0)
    
lwone_row2d:
    addi $t0, $t0 512
    
    sw $t4, 0($t0)
    sw $t1, 4($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    sw $t1, -12($t0)
    
lwone_row3d:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)
    sw $t1, 4($t0)
    sw $t2, 8($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    sw $t1, -12($t0)
    
lwone_row4d:
    addi $t0, $t0 512
    
    sw $t3, 0($t0)
    sw $t3, -4($t0)
    sw $t1, 4($t0)
    
lwone_row5d:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)
    sw $t3, -4($t0)
    sw $t1, -8($t0)
    sw $t1, 4($t0)
    sw $t2, 8($t0)
    
lwone_row6d:
    addi $t0, $t0 512
    
    sw $t3, 0($t0)
    sw $t3, -4($t0)
    sw $t1, 4($t0)
    
lwone_row7d:
    addi $t0, $t0 512
    
    sw $t3, 0($t0)
    sw $t3, -4($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    
lwone_row8d:
    addi $t0, $t0 512
    
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
    addi $t0, $t0 -2560
    
    sw $t1, 0($t0)
    sw $t1, 4($t0)
    sw $t2, 8($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    
lwtwo_row2:
    addi $t0, $t0 512
    
    sw $t4, 0($t0)
    sw $t1, 4($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    sw $t1, -12($t0)
    
lwtwo_row3:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)
    sw $t1, 4($t0)
    sw $t2, 8($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    sw $t1, -12($t0)
    
lwtwo_row4:
    addi $t0, $t0 512
    
    sw $t3, 0($t0)
    sw $t3, -4($t0)
    sw $t1, 4($t0)
    
lwtwo_row5:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)
    sw $t3, -4($t0)
    sw $t1, -8($t0)
    sw $t1, 4($t0)
    sw $t2, 8($t0)
    
lwtwo_row6:
    addi $t0, $t0 512
    
    sw $t3, 0($t0)
    sw $t3, -4($t0)
    sw $t1, 4($t0)
    
lwtwo_row7:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)
    sw $t3, -4($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    
lwtwo_row8:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)

    jr $ra
    
f_draw_lw_two_d:

    la $t0, char_pos
    lw $t0, 0($t0)
    addi $t0, $t0, BASE_ADDRESS
    
    li $t1, 0xFF0000 # body blue
    li $t2, 0xFF0000 # dark blue
    li $t3, 0xFF0000 # light blue
    li $t4, 0xFFFFFF # black
    
lwtwo_row1d:
    addi $t0, $t0 -2560
    
    sw $t1, 0($t0)
    sw $t1, 4($t0)
    sw $t2, 8($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    
lwtwo_row2d:
    addi $t0, $t0 512
    
    sw $t4, 0($t0)
    sw $t1, 4($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    sw $t1, -12($t0)
    
lwtwo_row3d:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)
    sw $t1, 4($t0)
    sw $t2, 8($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    sw $t1, -12($t0)
    
lwtwo_row4d:
    addi $t0, $t0 512
    
    sw $t3, 0($t0)
    sw $t3, -4($t0)
    sw $t1, 4($t0)
    
lwtwo_row5d:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)
    sw $t3, -4($t0)
    sw $t1, -8($t0)
    sw $t1, 4($t0)
    sw $t2, 8($t0)
    
lwtwo_row6d:
    addi $t0, $t0 512
    
    sw $t3, 0($t0)
    sw $t3, -4($t0)
    sw $t1, 4($t0)
    
lwtwo_row7d:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)
    sw $t3, -4($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    
lwtwo_row8d:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)

    jr $ra    
    
f_erase_lw:

    #prev char position
    addi $t0, $s0, BASE_ADDRESS
    
    li $t1, 0xFFFFFF # white
    
elw_row1:
    addi $t0, $t0 -2560
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    
elw_row2:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)
    sw $t1, 4($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    sw $t1, -12($t0)
    
elw_row3:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    sw $t1, -12($t0)
    
elw_row4:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    sw $t1, 4($t0)
    
elw_row5:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    
elw_row6:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    sw $t1, 4($t0)
    
elw_row7:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    
elw_row8:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    sw $t1, 4($t0)

    jr $ra
    

f_erase_rw:
	
	#prev char position
    addi $t0, $s0, BASE_ADDRESS
    
    li $t1, 0xFFFFFF # white
    
erw_row1:
    addi $t0, $t0 -2560
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    
erw_row2:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    sw $t1, 12($t0)
    
erw_row3:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    sw $t1, 12($t0)
    
erw_row4:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    sw $t1, 4($t0)
    
erw_row5:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    
erw_row6:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    sw $t1, 4($t0)
    
erw_row7:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)
    sw $t1, 4($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    
erw_row8:
    addi $t0, $t0 512
    
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
    addi $t0, $t0 -2560
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    sw $t2, -8($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    
rc_row2:
    addi $t0, $t0 512
    
    sw $t4, 0($t0)
    sw $t1, -4($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    sw $t1, 12($t0)
    
rc_row3:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    sw $t2, -8($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    sw $t1, 12($t0)
    
rc_row4:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)
    sw $t3, 8($t0)
    sw $t1, 4($t0)
    sw $t2, -4($t0)
    
rc_row5:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    sw $t1, 12($t0)
    
rc_row6:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)
    sw $t3, 8($t0)
    sw $t1, 4($t0)
    
rc_row7:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    sw $t1, 12($t0)
    
rc_row8:
    addi $t0, $t0 512
    
    sw $t1, -4($t0)

    jr $ra
    
 
f_erase_rc:

    la $t0, char_pos
    lw $t0, 0($t0)
    addi $t0, $t0, BASE_ADDRESS
    
    li $t1, 0xFFFFFF # white
    
erc_row1:
    addi $t0, $t0 -2560
    
    sw $t1, 0($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    
erc_row2:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)
    sw $t1, 4($t0)
    sw $t1, -4($t0)
    sw $t1, 8($t0)
    sw $t1, 12($t0)
    
erc_row3:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    sw $t1, 12($t0)
    
erc_row4:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)
    sw $t1, 8($t0)
    sw $t1, -4($t0)
    sw $t1, 4($t0)
    
erc_row5:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    sw $t1, 12($t0)
    
erc_row6:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)
    sw $t1, 8($t0)
    sw $t1, 4($t0)
    
erc_row7:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    sw $t1, 12($t0)
    
erc_row8:
    addi $t0, $t0 512
    
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
    addi $t0, $t0 -2560
    
    sw $t1, 0($t0)
    sw $t1, 4($t0)
    sw $t2, 8($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    
lc_row2:
    addi $t0, $t0 512
    
    sw $t4, 0($t0)
    sw $t1, 4($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    sw $t1, -12($t0)
    
lc_row3:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)
    sw $t1, 4($t0)
    sw $t2, 8($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    sw $t1, -12($t0)
    
lc_row4:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)
    sw $t3, -8($t0)
    sw $t1, -4($t0)
    sw $t2, 4($t0)
    
lc_row5:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    sw $t1, -12($t0)
    
lc_row6:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)
    sw $t3, -8($t0)
    sw $t1, -4($t0)
    
lc_row7:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    sw $t1, -12($t0)
    
lc_row8:
    addi $t0, $t0 512
    
    sw $t1, 4($t0)

    jr $ra    
    
    
f_erase_lc:

    la $t0, char_pos
    lw $t0, 0($t0)
    addi $t0, $t0, BASE_ADDRESS
    
    li $t1, 0xFFFFFF # white
    
elc_row1:
    addi $t0, $t0 -2560
    
    sw $t1, 0($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    
elc_row2:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)
    sw $t1, 4($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    sw $t1, -12($t0)
    
elc_row3:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    sw $t1, -12($t0)
    
elc_row4:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)
    sw $t1, -8($t0)
    sw $t1, -4($t0)
    sw $t1, 4($t0)
    
elc_row5:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    sw $t1, -12($t0)
    
elc_row6:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)
    sw $t1, -8($t0)
    sw $t1, -4($t0)
    
elc_row7:
    addi $t0, $t0 512
    
    sw $t1, 0($t0)
    sw $t1, -4($t0)
    sw $t1, -8($t0)
    sw $t1, -12($t0)
    
elc_row8:
    addi $t0, $t0 512
    
    sw $t1, 4($t0)

    jr $ra    


f_erase:
    addi $sp, $sp, -4
    sw $ra, 0($sp)

if_erase_rw:
    li $t0, 1
    bne $s1, $t0, if_erase_lw
    jal f_erase_rw
    j end_f_erase

if_erase_lw:
    li $t0, 2
    bne $s1, $t0, if_erase_rw
    jal f_erase_lw
    j end_f_erase

if_erase_rc:
    li $t0, 3
    bne $s1, $t0, if_erase_lc
    jal f_erase_rc
    j end_f_erase

if_erase_lc:
    jal f_erase_lc

end_f_erase:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra


f_draw_char:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
	
	la $t0, char_status
    lw $t1, 0($t0)
	
if_draw_rw:
    li $t0, 1
    bne $t1, $t0, if_draw_lw
    jal f_draw_rw
    j end_f_draw

if_draw_lw:
    li $t0, 2
    bne $t1, $t0, if_draw_rw
    jal f_draw_lw
    j end_f_draw

if_draw_rc:
    li $t0, 3
    bne $t1, $t0, if_draw_lc
    jal f_draw_rc
    j end_f_draw

if_draw_lc:
    jal f_draw_lc

end_f_draw:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
    
f_draw_health_6:
	li $t0, HEALTH_BAR_POS
	addi $t0, $t0, BASE_ADDRESS
	
	li $t1, 0xFF0000 #red
	li $t2, 0xFFFFFF #white
	li $t3, 0x000000 #black
	
	sw $t3, 8($t0)
	sw $t3, 12($t0)
	sw $t3, 20($t0)
	sw $t3, 24($t0)
	addi $t0, $t0, 512
	
	sw $t3, 4($t0)
	sw $t2, 8($t0)
	sw $t1, 12($t0)
	sw $t3, 16($t0)
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	
	addi $t0, $t0, 28 
	addi $t4, $t0, 40 

while_h6_one:
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h6_one
	
	addi $t0, $t0, 4
	addi $t4, $t0, 40

while_h6_two:
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h6_two
	
	addi $t0, $t0, 4
	addi $t4, $t0, 40
	
while_h6_three:
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h6_three
	
	addi $t0, $t0, 356
	
	sw $t3, 0($t0)
	sw $t2, 4($t0)
	
	addi $t0, $t0, 8
	addi $t4, $t0, 24
	
while_h6_four:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h6_four
	
	sw $t3, 0($t0)
	sw $t2, 4($t0)
	addi $t0, $t0, 8
	addi $t4, $t0, 28
	
while_h6_five:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h6_five
	
	sw $t3, 0($t0)
	sw $t2, 4($t0)
	addi $t0, $t0, 8
	
	addi $t4, $t0, 36
	
while_h6_six:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h6_six
	
	sw $t3, 0($t0)
	sw $t2, 4($t0)
	addi $t0, $t0, 8
	
	addi $t4, $t0, 36
	
while_h6_seven:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h6_seven
	sw $t3, 0($t0)
	
	addi $t0, $t0, 360
	sw $t3, -4($t0)
	addi $t4, $t0, 28
	
while_h6_eight:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h6_eight
	
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	
	addi $t4, $t0, 120
	
while_h6_nine:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h6_nine
	
	sw $t3, 0($t0)
	addi $t0, $t0, 364
	
	sw $t3, -4($t0)
	addi $t4, $t0, 20
	
while_h6_ten:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h6_ten
	
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	
	addi $t4, $t0, 124
	
while_h6_elev:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h6_elev
	
	sw $t3, 0($t0)
	addi $t0, $t0, 364
	sw $t3, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t3, 16($t0)
	addi $t0, $t0, 20
	
	addi $t4, $t0, 40
	
while_h6_twel:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h6_twel
	
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	
	addi $t4, $t0, 40
	
while_h6_thirt:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h6_thirt
	
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	
	addi $t4, $t0, 40
	
while_h6_fourt:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h6_fourt
	
	sw $t3, 0($t0)
	addi $t0, $t0, 368
	sw $t3, 0($t0)
	sw $t1, 4($t0)
	addi $t0, $t0, 8
	
	addi $t4, $t0, 48
	
while_h6_fifte:
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h6_fifte
	
	addi $t0, $t0, 4
	
	addi $t4, $t0, 40
	
while_h6_sixte:
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h6_sixte
	
	addi $t0, $t0, 4
	addi $t4, $t0, 40
	
while_h6_sevent:
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h6_sevent
	addi $t0, $t0, 372
	sw $t3, 0($t0)
	
	jr $ra


f_draw_health_5:
	li $t0, HEALTH_BAR_POS
	addi $t0, $t0, BASE_ADDRESS
	
	li $t1, 0xFF0000 #red
	li $t2, 0xFFFFFF #white
	li $t3, 0x000000 #black
	
	sw $t3, 8($t0)
	sw $t3, 12($t0)
	sw $t3, 20($t0)
	sw $t3, 24($t0)
	addi $t0, $t0, 512
	
	sw $t3, 4($t0)
	sw $t2, 8($t0)
	sw $t1, 12($t0)
	sw $t3, 16($t0)
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	
	addi $t0, $t0, 28 
	addi $t4, $t0, 40 

while_h5_one:
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h5_one
	
	addi $t0, $t0, 4
	addi $t4, $t0, 40

while_h5_two:
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h5_two
	
	addi $t0, $t0, 4
	addi $t4, $t0, 40
	
while_h5_three:
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h5_three
	
	addi $t0, $t0, 356
	
	sw $t3, 0($t0)
	sw $t2, 4($t0)
	
	addi $t0, $t0, 8
	addi $t4, $t0, 24
	
while_h5_four:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h5_four
	
	sw $t3, 0($t0)
	sw $t2, 4($t0)
	addi $t0, $t0, 8
	addi $t4, $t0, 28
	
while_h5_five:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h5_five
	
	sw $t3, 0($t0)
	sw $t2, 4($t0)
	addi $t0, $t0, 8
	
	addi $t4, $t0, 36
	
while_h5_six:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h5_six
	
	sw $t3, 0($t0)
	sw $t2, 4($t0)
	addi $t0, $t0, 8
	
	addi $t4, $t0, 16
	
while_h5_seven:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h5_seven
	
	addi $t4, $t0, 20
	
while_h5_seven1:
	sw $t2, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h5_seven1
	sw $t3, 0($t0)
	
	addi $t0, $t0, 360
	sw $t3, -4($t0)
	addi $t4, $t0, 28
	
while_h5_eight:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h5_eight
	
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	
	addi $t4, $t0, 100
	
while_h5_nine:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h5_nine
	
	addi $t4, $t0, 20
	
while_h5_nine1:
	sw $t2, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h5_nine1
	
	sw $t3, 0($t0)
	addi $t0, $t0, 364
	
	sw $t3, -4($t0)
	addi $t4, $t0, 20
	
while_h5_ten:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h5_ten
	
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	
	addi $t4, $t0, 104
	
while_h5_elev:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h5_elev
	
	addi $t4, $t0, 20
	
while_h5_elev1:
	sw $t2, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h5_elev1
	
	sw $t3, 0($t0)
	addi $t0, $t0, 364
	sw $t3, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t3, 16($t0)
	addi $t0, $t0, 20
	
	addi $t4, $t0, 40
	
while_h5_twel:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h5_twel
	
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	
	addi $t4, $t0, 40
	
while_h5_thirt:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h5_thirt
	
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	
	addi $t4, $t0, 20
	
while_h5_fourt:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h5_fourt
	
	addi $t4, $t0, 20
	
while_h5_fourt1:
	sw $t2, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h5_fourt1
	
	sw $t3, 0($t0)
	addi $t0, $t0, 368
	sw $t3, 0($t0)
	sw $t1, 4($t0)
	addi $t0, $t0, 8
	
	addi $t4, $t0, 48
	
while_h5_fifte:
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h5_fifte
	
	addi $t0, $t0, 4
	
	addi $t4, $t0, 40
	
while_h5_sixte:
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h5_sixte
	
	addi $t0, $t0, 4
	addi $t4, $t0, 40
	
while_h5_sevent:
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h5_sevent
	addi $t0, $t0, 372
	sw $t3, 0($t0)
	
	jr $ra
	

f_draw_health_4:
	li $t0, HEALTH_BAR_POS
	addi $t0, $t0, BASE_ADDRESS
	
	li $t1, 0xFF0000 #red
	li $t2, 0xFFFFFF #white
	li $t3, 0x000000 #black
	
	sw $t3, 8($t0)
	sw $t3, 12($t0)
	sw $t3, 20($t0)
	sw $t3, 24($t0)
	addi $t0, $t0, 512
	
	sw $t3, 4($t0)
	sw $t2, 8($t0)
	sw $t1, 12($t0)
	sw $t3, 16($t0)
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	
	addi $t0, $t0, 28 
	addi $t4, $t0, 40 

while_h4_one:
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h4_one
	
	addi $t0, $t0, 4
	addi $t4, $t0, 40

while_h4_two:
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h4_two
	
	addi $t0, $t0, 4
	addi $t4, $t0, 40
	
while_h4_three:
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h4_three
	
	addi $t0, $t0, 356
	
	sw $t3, 0($t0)
	sw $t2, 4($t0)
	
	addi $t0, $t0, 8
	addi $t4, $t0, 24
	
while_h4_four:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h4_four
	
	sw $t3, 0($t0)
	sw $t2, 4($t0)
	addi $t0, $t0, 8
	addi $t4, $t0, 28
	
while_h4_five:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h4_five
	
	sw $t3, 0($t0)
	sw $t2, 4($t0)
	addi $t0, $t0, 8
	
	addi $t4, $t0, 36
	
while_h4_six:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h4_six
	
	sw $t3, 0($t0)
	sw $t2, 4($t0)
	addi $t0, $t0, 8
	
	addi $t4, $t0, 16
	
while_h4_seven:
	sw $t2, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h4_seven
	
	addi $t4, $t0, 20
	
while_h4_seven1:
	sw $t2, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h4_seven1
	sw $t3, 0($t0)
	
	addi $t0, $t0, 360
	sw $t3, -4($t0)
	addi $t4, $t0, 28
	
while_h4_eight:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h4_eight
	
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	
	addi $t4, $t0, 76
	
while_h4_nine:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h4_nine
	
	addi $t4, $t0, 44
	
while_h4_nine1:
	sw $t2, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h4_nine1
	
	sw $t3, 0($t0)
	addi $t0, $t0, 364
	
	sw $t3, -4($t0)
	addi $t4, $t0, 20
	
while_h4_ten:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h4_ten
	
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	
	addi $t4, $t0, 80
	
while_h4_elev:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h4_elev
	
	addi $t4, $t0, 44
	
while_h4_elev1:
	sw $t2, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h4_elev1
	
	sw $t3, 0($t0)
	addi $t0, $t0, 364
	sw $t3, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t3, 16($t0)
	addi $t0, $t0, 20
	
	addi $t4, $t0, 40
	
while_h4_twel:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h4_twel
	
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	
	addi $t4, $t0, 40
	
while_h4_thirt:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h4_thirt
	
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	
	addi $t4, $t0, 20
	
while_h4_fourt:
	sw $t2, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h4_fourt
	
	addi $t4, $t0, 20
	
while_h4_fourt1:
	sw $t2, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h4_fourt1
	
	sw $t3, 0($t0)
	addi $t0, $t0, 368
	sw $t3, 0($t0)
	sw $t1, 4($t0)
	addi $t0, $t0, 8
	
	addi $t4, $t0, 48
	
while_h4_fifte:
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h4_fifte
	
	addi $t0, $t0, 4
	
	addi $t4, $t0, 40
	
while_h4_sixte:
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h4_sixte
	
	addi $t0, $t0, 4
	addi $t4, $t0, 40
	
while_h4_sevent:
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h4_sevent
	addi $t0, $t0, 372
	sw $t3, 0($t0)
	
	jr $ra
	
	
f_draw_health_3:
	li $t0, HEALTH_BAR_POS
	addi $t0, $t0, BASE_ADDRESS
	
	li $t1, 0xFF0000 #red
	li $t2, 0xFFFFFF #white
	li $t3, 0x000000 #black
	
	sw $t3, 8($t0)
	sw $t3, 12($t0)
	sw $t3, 20($t0)
	sw $t3, 24($t0)
	addi $t0, $t0, 512
	
	sw $t3, 4($t0)
	sw $t2, 8($t0)
	sw $t1, 12($t0)
	sw $t3, 16($t0)
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	
	addi $t0, $t0, 28 
	addi $t4, $t0, 40 

while_h3_one:
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h3_one
	
	addi $t0, $t0, 4
	addi $t4, $t0, 40

while_h3_two:
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h3_two
	
	addi $t0, $t0, 4
	addi $t4, $t0, 40
	
while_h3_three:
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h3_three
	
	addi $t0, $t0, 356
	
	sw $t3, 0($t0)
	sw $t2, 4($t0)
	
	addi $t0, $t0, 8
	addi $t4, $t0, 24
	
while_h3_four:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h3_four
	
	sw $t3, 0($t0)
	sw $t2, 4($t0)
	addi $t0, $t0, 8
	addi $t4, $t0, 28
	
while_h3_five:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h3_five
	
	sw $t3, 0($t0)
	sw $t2, 4($t0)
	addi $t0, $t0, 8
	
	addi $t4, $t0, 16
	
while_h3_six:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h3_six
	
	addi $t4, $t0, 20
	
while_h3_six1:
	sw $t2, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h3_six1
	
	sw $t3, 0($t0)
	sw $t2, 4($t0)
	addi $t0, $t0, 8
	
	addi $t4, $t0, 16
	
while_h3_seven:
	sw $t2, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h3_seven
	
	addi $t4, $t0, 20
	
while_h3_seven1:
	sw $t2, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h3_seven1
	sw $t3, 0($t0)
	
	addi $t0, $t0, 360
	sw $t3, -4($t0)
	addi $t4, $t0, 28
	
while_h3_eight:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h3_eight
	
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	
	addi $t4, $t0, 56
	
while_h3_nine:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h3_nine
	
	addi $t4, $t0, 64
	
while_h3_nine1:
	sw $t2, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h3_nine1
	
	sw $t3, 0($t0)
	addi $t0, $t0, 364
	
	sw $t3, -4($t0)
	addi $t4, $t0, 20
	
while_h3_ten:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h3_ten
	
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	
	addi $t4, $t0, 60
	
while_h3_elev:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h3_elev
	
	addi $t4, $t0, 64
	
while_h3_elev1:
	sw $t2, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h3_elev1
	
	sw $t3, 0($t0)
	addi $t0, $t0, 364
	sw $t3, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t3, 16($t0)
	addi $t0, $t0, 20
	
	addi $t4, $t0, 40
	
while_h3_twel:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h3_twel
	
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	
	addi $t4, $t0, 20
	
while_h3_thirt:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h3_thirt
	
	addi $t4, $t0, 20
	
while_h3_thirt1:
	sw $t2, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h3_thirt1
	
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	
	addi $t4, $t0, 20
	
while_h3_fourt:
	sw $t2, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h3_fourt
	
	addi $t4, $t0, 20
	
while_h3_fourt1:
	sw $t2, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h3_fourt1
	
	sw $t3, 0($t0)
	addi $t0, $t0, 368
	sw $t3, 0($t0)
	sw $t1, 4($t0)
	addi $t0, $t0, 8
	
	addi $t4, $t0, 48
	
while_h3_fifte:
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h3_fifte
	
	addi $t0, $t0, 4
	
	addi $t4, $t0, 40
	
while_h3_sixte:
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h3_sixte
	
	addi $t0, $t0, 4
	addi $t4, $t0, 40
	
while_h3_sevent:
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h3_sevent
	addi $t0, $t0, 372
	sw $t3, 0($t0)
	
	jr $ra


f_draw_health_2:
	li $t0, HEALTH_BAR_POS
	addi $t0, $t0, BASE_ADDRESS
	
	li $t1, 0xFF0000 #red
	li $t2, 0xFFFFFF #white
	li $t3, 0x000000 #black
	
	sw $t3, 8($t0)
	sw $t3, 12($t0)
	sw $t3, 20($t0)
	sw $t3, 24($t0)
	addi $t0, $t0, 512
	
	sw $t3, 4($t0)
	sw $t2, 8($t0)
	sw $t1, 12($t0)
	sw $t3, 16($t0)
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	
	addi $t0, $t0, 28 
	addi $t4, $t0, 40 

while_h2_one:
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h2_one
	
	addi $t0, $t0, 4
	addi $t4, $t0, 40

while_h2_two:
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h2_two
	
	addi $t0, $t0, 4
	addi $t4, $t0, 40
	
while_h2_three:
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h2_three
	
	addi $t0, $t0, 356
	
	sw $t3, 0($t0)
	sw $t2, 4($t0)
	
	addi $t0, $t0, 8
	addi $t4, $t0, 24
	
while_h2_four:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h2_four
	
	sw $t3, 0($t0)
	sw $t2, 4($t0)
	addi $t0, $t0, 8
	addi $t4, $t0, 28
	
while_h2_five:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h2_five
	
	sw $t3, 0($t0)
	sw $t2, 4($t0)
	addi $t0, $t0, 8
	
	addi $t4, $t0, 16
	
while_h2_six:
	sw $t2, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h2_six

	addi $t4, $t0, 20
	
while_h2_six1:
	sw $t2, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h2_six1
	
	sw $t3, 0($t0)
	sw $t2, 4($t0)
	addi $t0, $t0, 8
	
	addi $t4, $t0, 16
	
while_h2_seven:
	sw $t2, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h2_seven
	
	addi $t4, $t0, 20
	
while_h2_seven1:
	sw $t2, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h2_seven1
	sw $t3, 0($t0)
	
	addi $t0, $t0, 360
	sw $t3, -4($t0)
	addi $t4, $t0, 28
	
while_h2_eight:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h2_eight
	
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	
	addi $t4, $t0, 32
	
while_h2_nine:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h2_nine
	
	addi $t4, $t0, 88
	
while_h2_nine1:
	sw $t2, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h2_nine1
	
	sw $t3, 0($t0)
	addi $t0, $t0, 364
	
	sw $t3, -4($t0)
	addi $t4, $t0, 20
	
while_h2_ten:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h2_ten
	
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	
	addi $t4, $t0, 36
	
while_h2_elev:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h2_elev
	
	addi $t4, $t0, 88
	
while_h2_elev1:
	sw $t2, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h2_elev1
	
	sw $t3, 0($t0)
	addi $t0, $t0, 364
	sw $t3, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t3, 16($t0)
	addi $t0, $t0, 20
	
	addi $t4, $t0, 40
	
while_h2_twel:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h2_twel
	
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	
	addi $t4, $t0, 20
	
while_h2_thirt:
	sw $t2, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h2_thirt
	
	addi $t4, $t0, 20
	
while_h2_thirt1:
	sw $t2, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h2_thirt1
	
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	
	addi $t4, $t0, 20
	
while_h2_fourt:
	sw $t2, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h2_fourt
	
	addi $t4, $t0, 20
	
while_h2_fourt1:
	sw $t2, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h2_fourt1
	
	sw $t3, 0($t0)
	addi $t0, $t0, 368
	sw $t3, 0($t0)
	sw $t1, 4($t0)
	addi $t0, $t0, 8
	
	addi $t4, $t0, 48
	
while_h2_fifte:
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h2_fifte
	
	addi $t0, $t0, 4
	
	addi $t4, $t0, 40
	
while_h2_sixte:
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h2_sixte
	
	addi $t0, $t0, 4
	addi $t4, $t0, 40
	
while_h2_sevent:
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h2_sevent
	addi $t0, $t0, 372
	sw $t3, 0($t0)
	
	jr $ra	
	
	
f_draw_health_1:
	li $t0, HEALTH_BAR_POS
	addi $t0, $t0, BASE_ADDRESS
	
	li $t1, 0xFF0000 #red
	li $t2, 0xFFFFFF #white
	li $t3, 0x000000 #black
	
	sw $t3, 8($t0)
	sw $t3, 12($t0)
	sw $t3, 20($t0)
	sw $t3, 24($t0)
	addi $t0, $t0, 512
	
	sw $t3, 4($t0)
	sw $t2, 8($t0)
	sw $t1, 12($t0)
	sw $t3, 16($t0)
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	
	addi $t0, $t0, 28 
	addi $t4, $t0, 40 

while_h1_one:
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h1_one
	
	addi $t0, $t0, 4
	addi $t4, $t0, 40

while_h1_two:
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h1_two
	
	addi $t0, $t0, 4
	addi $t4, $t0, 40
	
while_h1_three:
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h1_three
	
	addi $t0, $t0, 356
	
	sw $t3, 0($t0)
	sw $t2, 4($t0)
	
	addi $t0, $t0, 8
	addi $t4, $t0, 24
	
while_h1_four:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h1_four
	
	sw $t3, 0($t0)
	sw $t2, 4($t0)
	addi $t0, $t0, 8
	addi $t4, $t0, 8
	
while_h1_five:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h1_five
	addi $t4, $t0, 20
	
while_h1_five1:
	sw $t2, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h1_five1
	
	
	sw $t3, 0($t0)
	sw $t2, 4($t0)
	addi $t0, $t0, 8
	
	addi $t4, $t0, 16
	
while_h1_six:
	sw $t2, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h1_six

	addi $t4, $t0, 20
	
while_h1_six1:
	sw $t2, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h1_six1
	
	sw $t3, 0($t0)
	sw $t2, 4($t0)
	addi $t0, $t0, 8
	
	addi $t4, $t0, 16
	
while_h1_seven:
	sw $t2, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h1_seven
	
	addi $t4, $t0, 20
	
while_h1_seven1:
	sw $t2, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h1_seven1
	sw $t3, 0($t0)
	
	addi $t0, $t0, 360
	sw $t3, -4($t0)
	addi $t4, $t0, 28
	
while_h1_eight:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h1_eight
	
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	
	addi $t4, $t0, 12
	
while_h1_nine:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h1_nine
	
	addi $t4, $t0, 108
	
while_h1_nine1:
	sw $t2, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h1_nine1
	
	sw $t3, 0($t0)
	addi $t0, $t0, 364
	
	sw $t3, -4($t0)
	addi $t4, $t0, 20
	
while_h1_ten:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h1_ten
	
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	
	addi $t4, $t0, 16
	
while_h1_elev:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h1_elev
	
	addi $t4, $t0, 108
	
while_h1_elev1:
	sw $t2, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h1_elev1
	
	sw $t3, 0($t0)
	addi $t0, $t0, 364
	sw $t3, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t3, 16($t0)
	addi $t0, $t0, 20
	
	addi $t4, $t0, 20
	
while_h1_twel:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h1_twel
	
	addi $t4, $t0, 20
	
while_h1_twel1:
	sw $t2, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h1_twel1
	
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	
	addi $t4, $t0, 20
	
while_h1_thirt:
	sw $t2, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h1_thirt
	
	addi $t4, $t0, 20
	
while_h1_thirt1:
	sw $t2, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h1_thirt1
	
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	
	addi $t4, $t0, 20
	
while_h1_fourt:
	sw $t2, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h1_fourt
	
	addi $t4, $t0, 20
	
while_h1_fourt1:
	sw $t2, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h1_fourt1
	
	sw $t3, 0($t0)
	addi $t0, $t0, 368
	sw $t3, 0($t0)
	sw $t1, 4($t0)
	addi $t0, $t0, 8
	
	addi $t4, $t0, 48
	
while_h1_fifte:
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h1_fifte
	
	addi $t0, $t0, 4
	
	addi $t4, $t0, 40
	
while_h1_sixte:
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h1_sixte
	
	addi $t0, $t0, 4
	addi $t4, $t0, 40
	
while_h1_sevent:
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, while_h1_sevent
	addi $t0, $t0, 372
	sw $t3, 0($t0)
	
	jr $ra
	

f_draw_health_bar:
	la $t0, char_health
    lw $t1, 0($t0)
    
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
if_draw_hp6:
    bne $t1, 6, if_draw_hp5
    jal f_draw_health_6
    j end_f_draw_health_bar
    
if_draw_hp5:
    bne $t1, 5, if_draw_hp4
    jal f_draw_health_5
    j end_f_draw_health_bar
    
if_draw_hp4:
    bne $t1, 4, if_draw_hp3
    jal f_draw_health_4
    j end_f_draw_health_bar
    
if_draw_hp3:
    bne $t1, 3, if_draw_hp2
    jal f_draw_health_3
    j end_f_draw_health_bar
    
if_draw_hp2:
    bne $t1, 2, if_draw_hp1
    jal f_draw_health_2
    j end_f_draw_health_bar   
    
if_draw_hp1:
    bne $t1, 1, end_f_draw_health_bar
    jal f_draw_health_1
      
end_f_draw_health_bar:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	
	
f_draw_cactus_h1:
	addi $t0, $a0, BASE_ADDRESS #get cactus position from argument a0
	
	li $t1, CACTUS_GREEN
	
	sw $t1, -2048($t0)
	sw $t1, -2560($t0)
	sw $t1, -3072($t0)
	
	addi $t0, $t0, 4
	sw $t1, -1536($t0)
	
	addi $t0, $t0, 4
	addi $t2, $t0, -4608
	
while_cactus_h1_up:
	sw $t1, 0($t0)
	addi $t0, $t0, -512
	bne $t0, $t2, while_cactus_h1_up
	
	addi $t0, $t0, 516
	addi $t2, $t0, 4608
	
while_cactus_h1_down:
	sw $t1, 0($t0)
	addi $t0, $t0, 512
	bne $t0, $t2, while_cactus_h1_down
	
	addi $t0, $t0, -508
	sw $t1, -2048($t0)
	
	addi $t0, $t0, 4
	sw $t1, -3072($t0)
	sw $t1, -3584($t0)
	sw $t1, -2560($t0)
	
	jr $ra

	
f_draw_cactus_h2:
	addi $t0, $a0, BASE_ADDRESS #get cactus position from argument a0
	
	li $t1, CACTUS_GREEN
	
	sw $t1, -3072($t0)
	sw $t1, -3584($t0)
	sw $t1, -2560($t0)
	
	addi $t0, $t0, 4
	sw $t1, -2048($t0)
	
	addi $t0, $t0, 4
	addi $t2, $t0, -4608
	
while_cactus_h2_up:
	sw $t1, 0($t0)
	addi $t0, $t0, -512
	bne $t0, $t2, while_cactus_h2_up
	
	addi $t0, $t0, 516
	addi $t2, $t0, 4608
	
while_cactus_h2_down:
	sw $t1, 0($t0)
	addi $t0, $t0, 512
	bne $t0, $t2, while_cactus_h2_down
	
	addi $t0, $t0, -508
	sw $t1, -1536($t0)
	
	addi $t0, $t0, 4
	sw $t1, -2048($t0)
	sw $t1, -2560($t0)
	sw $t1, -3072($t0)
	
	jr $ra
	
	f_draw_cactus_h3:
	addi $t0, $a0, BASE_ADDRESS #get cactus position from argument a0
	
	li $t1, CACTUS_GREEN
	
	sw $t1, -2048($t0)
	sw $t1, -2560($t0)
	sw $t1, -3072($t0)
	
	addi $t0, $t0, 4
	sw $t1, -1536($t0)
	
	addi $t0, $t0, 4
	addi $t2, $t0, -4608
	
while_cactus_h3_up:
	sw $t1, 0($t0)
	addi $t0, $t0, -512
	bne $t0, $t2, while_cactus_h3_up
	
	addi $t0, $t0, 516
	addi $t2, $t0, 4608
	
while_cactus_h3_down:
	sw $t1, 0($t0)
	addi $t0, $t0, 512
	bne $t0, $t2, while_cactus_h3_down
	
	addi $t0, $t0, -508
	sw $t1, -1536($t0)
	
	addi $t0, $t0, 4
	sw $t1, -2048($t0)
	sw $t1, -2560($t0)
	sw $t1, -3072($t0)
	
	jr $ra
	
f_draw_plat:
	#position of platform passed thru register $a0
	addi $t0, $a0, BASE_ADDRESS
	
	li $t1, 0x967150
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t1, 16($t0)
	sw $t1, 20($t0)
	
	li $t1, 0xBA8C63
	addi $t0, $t0, -512
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t1, 16($t0)
	sw $t1, 20($t0)
	
	jr $ra
	
f_draw_egg:
#position of platform passed thru register $a0
	addi $t0, $a0, BASE_ADDRESS
	
	li $t2, 0xCDC199
	li $t1, 0xf4ebcb

	sw $t2, 4($t0)
	sw $t2, 8($t0)
	sw $t2, 12($t0)
	sw $t2, 16($t0)
	
	addi $t0, $t0, -512

	addi $t3, $t0, -3072
	
w_egg_body:
	sw $t2, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t1, 16($t0)
	sw $t1, 20($t0)	
	addi $t0, $t0, -512
	
	bne $t0, $t3, w_egg_body
	
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t1, 16($t0)
	
	jr $ra
	
	
draw_bird_lone:
	#position of bird passed thru register $a0
	addi $t0, $a0, BASE_ADDRESS
	li $t1, UPPERBODY_ORANGE
	li $t2, LOWERBODY_ORANGE
	
	addi $t0, $t0, -1536
	
	sw $t1, 0($t0)
	
	addi $t0, $t0, 512
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, -8($t0)
	
	addi $t0, $t0, 512
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, -8($t0)
	sw $t1, -12($t0)
	
	addi $t0, $t0, 512
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t1, 16($t0)
	sw $t1, -4($t0)
	sw $t1, -8($t0)
	sw $t1, -12($t0)
	sw $t1, -16($t0)
	
	addi $t0, $t0, 512
	sw $t2, 0($t0)
	sw $t2, 4($t0)
	sw $t2, 8($t0)
	
	jr $ra
			
draw_bird_ltwo:
	#position of bird passed thru register $a0
	addi $t0, $a0, BASE_ADDRESS
	li $t1, UPPERBODY_ORANGE
	li $t2, LOWERBODY_ORANGE
	
	addi $t0, $t0, -1024
	
	sw $t1, -8($t0)	
	
	addi $t0, $t0, 512
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, -8($t0)	
	sw $t1, -12($t0)
	
	addi $t0, $t0, 512
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t1, 16($t0)
	sw $t1, -4($t0)
	sw $t1, -8($t0)
	sw $t1, -12($t0)
	sw $t1, -16($t0)	
	
	addi $t0, $t0, 512
	sw $t2, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	
	addi $t0, $t0, 512
	sw $t2, 4($t0)
	sw $t1, 8($t0)
			
	addi $t0, $t0, 512
	sw $t2, 8($t0)
	
	jr $ra
	
draw_bird_rone:
	#position of bird passed thru register $a0
	addi $t0, $a0, BASE_ADDRESS
	li $t1, UPPERBODY_ORANGE
	li $t2, LOWERBODY_ORANGE
	
	addi $t0, $t0, -1536
	
	sw $t1, 0($t0)
	
	addi $t0, $t0, 512
	sw $t1, 0($t0)
	sw $t1, -4($t0)
	sw $t1, 8($t0)
	
	addi $t0, $t0, 512
	sw $t1, 0($t0)
	sw $t1, -4($t0)
	sw $t1, -8($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	
	addi $t0, $t0, 512
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t1, 16($t0)
	sw $t1, -4($t0)
	sw $t1, -8($t0)
	sw $t1, -12($t0)
	sw $t1, -16($t0)
	
	addi $t0, $t0, 512
	sw $t2, 0($t0)
	sw $t2, -4($t0)
	sw $t2, -8($t0)
	
	jr $ra
	
draw_bird_rtwo:
	#position of bird passed thru register $a0
	addi $t0, $a0, BASE_ADDRESS
	li $t1, UPPERBODY_ORANGE
	li $t2, LOWERBODY_ORANGE
	
	addi $t0, $t0, -1024
	
	sw $t1, 8($t0)	
	
	addi $t0, $t0, 512
	sw $t1, 0($t0)
	sw $t1, -4($t0)
	sw $t1, -8($t0)
	sw $t1, 8($t0)	
	sw $t1, 12($t0)
	
	addi $t0, $t0, 512
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t1, 16($t0)
	sw $t1, -4($t0)
	sw $t1, -8($t0)
	sw $t1, -12($t0)
	sw $t1, -16($t0)	
	
	addi $t0, $t0, 512
	sw $t2, 0($t0)
	sw $t1, -4($t0)
	sw $t1, -8($t0)
	
	addi $t0, $t0, 512
	sw $t2, -4($t0)
	sw $t1, -8($t0)
			
	addi $t0, $t0, 512
	sw $t2, -8($t0)
	
	jr $ra
	
f_draw_start_menu:
	li $t0, START_MENU_POS
	addi $t0, $t0, BASE_ADDRESS
	
	addi $t4, $t0, 0
	
	li $t1, 0xFFFFFF #WHITE
	
	addi $t0, $t0, 8
	addi $t2, $t0, 32
	
while_draw_sm1:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t2, while_draw_sm1
	
	addi $t0, $t0, 16
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	addi $t0, $t0, 40
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	addi $t0, $t0, 20
	
	addi $t2, $t0, 40
	
while_draw_sm2:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t2, while_draw_sm2
	
	addi $t0, $t0, 28
	addi $t2, $t0, 32
	
while_draw_sm3:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t2, while_draw_sm3
	
	addi $t0, $t0, 20
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	addi $t0, $t0, 36
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	addi $t0, $t0, 20
	addi $t2, $t0, 40
	
while_draw_sm4:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t2, while_draw_sm4
	
	addi $t4, $t4, 512
	addi $t0, $t4, 0
	
	addi $t0, $t0, 8
	addi $t2, $t0, 32
	
while_draw_sm5:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t2, while_draw_sm5
	
	addi $t0, $t0, 16
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	addi $t0, $t0, 40
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	addi $t0, $t0, 20
	
	addi $t2, $t0, 44
	
while_draw_sm6:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t2, while_draw_sm6
	
	addi $t0, $t0, 20
	addi $t2, $t0, 40
	
while_draw_sm7:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t2, while_draw_sm7
	
	addi $t0, $t0, 16
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	
	addi $t0, $t0, 36
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, -4($t0)
	
	addi $t0, $t0, 20
	addi $t2, $t0, 40
	
while_draw_sm8:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t2, while_draw_sm8
	
	addi $t4, $t4, 512
	addi $t0, $t4, 0	
	
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	addi $t0, $t0, 36
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	addi $t0, $t0, 20
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	addi $t0, $t0, 40
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	addi $t0, $t0, 20
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	addi $t0, $t0, 40
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	addi $t0, $t0, 20
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	addi $t0, $t0, 40
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	addi $t0, $t0, 20
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	
	addi $t0, $t0, 28
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	
	addi $t0, $t0, 28
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	addi $t4, $t4, 512
	addi $t0, $t4, 0
	
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	sw $t1, 36($t0)
	sw $t1, 40($t0)
	
	addi $t0, $t0, 56
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	addi $t0, $t0, 40
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	addi $t0, $t0, 20
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	addi $t0, $t0, 40
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	addi $t0, $t0, 20
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	addi $t0, $t0, 40
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	addi $t0, $t0, 20
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t1, 16($t0)
	
	addi $t0, $t0, 24
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t1, 16($t0)
	
	addi $t0, $t0, 32
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	addi $t4, $t4, 512
	addi $t0, $t4, 0
	
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	addi $t0, $t0, 56
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	addi $t0, $t0, 40
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	addi $t0, $t0, 20
	addi $t2, $t0, 44
	
while_draw_sm9:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t2, while_draw_sm9
	
	addi $t0, $t0, 16
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	addi $t0, $t0, 40
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	addi $t0, $t0, 20
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 20($t0)
	sw $t1, 12($t0)
	sw $t1, 16($t0)
	
	addi $t0, $t0, 24
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 12($t0)
	sw $t1, 16($t0)
	
	addi $t0, $t0, 32
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	addi $t0, $t0, 56
	addi $t2, $t0, 24
	
while_draw_sm10:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t2, while_draw_sm10
	
	addi $t0, $t0, 4
	sw $t1, 0($t0)
	sw $t1, 4($t0)

	addi $t0, $t0, 16
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	addi $t0, $t0, 12
	
	addi $t2, $t0, 20
	
while_draw_sm11:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t2, while_draw_sm11
	
	addi $t4, $t4, 512
	addi $t0, $t4, 0
	
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	addi $t0, $t0, 56
	addi $t2, $t0, 48
	
while_draw_sm12:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t2, while_draw_sm12
	
	addi $t0, $t0, 12
	addi $t2, $t0, 40
	
while_draw_sm13:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t2, while_draw_sm13
	
	addi $t0, $t0, 20
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	addi $t0, $t0, 40
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	addi $t0, $t0, 20
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 20($t0)
	sw $t1, 16($t0)
	
	addi $t0, $t0, 24
	sw $t1, 0($t0)

	sw $t1, 12($t0)
	sw $t1, 16($t0)
	
	addi $t0, $t0, 32
	addi $t2, $t0, 32
	
while_draw_sm14:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t2, while_draw_sm14
	
	addi $t0, $t0, 24
	addi $t2, $t0, 24
	
while_draw_sm15:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t2, while_draw_sm15
	
	addi $t0, $t0, 4
	sw $t1, 0($t0)
	sw $t1, 4($t0)

	addi $t0, $t0, 16
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	addi $t0, $t0, 12
	
	addi $t2, $t0, 20
	
while_draw_sm16:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t2, while_draw_sm16
	
	addi $t4, $t4, 512
	addi $t0, $t4, 0
	
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	addi $t0, $t0, 56
	addi $t2, $t0, 48
	
while_draw_sm17:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t2, while_draw_sm17
	
	addi $t0, $t0, 12
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	addi $t0, $t0, 20
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	
	addi $t0, $t0, 40
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	addi $t0, $t0, 40
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	addi $t0, $t0, 20
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	addi $t0, $t0, 36
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	addi $t0, $t0, 20
	addi $t2, $t0, 32
	
while_draw_sm18:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t2, while_draw_sm18
	
	addi $t0, $t0, 32
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	addi $t0, $t0, 8
	
	sw $t1, 12($t0)
	sw $t1, 16($t0)
	
	sw $t1, 28($t0)
	sw $t1, 32($t0)
	
	addi $t0, $t0, 40
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	addi $t4, $t4, 512
	addi $t0, $t4, 0
	
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	sw $t1, 56($t0)
	sw $t1, 60($t0)
	
	addi $t0, $t0, 96
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	addi $t0, $t0, 20
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	addi $t0, $t0, 24
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	
	addi $t0, $t0, 36
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	addi $t0, $t0, 40
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	addi $t0, $t0, 20
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	addi $t0, $t0, 36
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	addi $t0, $t0, 20
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	addi $t0, $t0, 64
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	addi $t0, $t0, 20
	addi $t2, $t0, 24
	
while_draw_sm19:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t2, while_draw_sm19
	
	addi $t0, $t0, 4
	addi $t2, $t0, 20
	
while_draw_sm20:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t2, while_draw_sm20
	
	addi $t4, $t4, 512
	addi $t0, $t4, 0
	
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	sw $t1, 36($t0)
	sw $t1, 40($t0)
	
	addi $t0, $t0, 56
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	addi $t0, $t0, 40
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	addi $t0, $t0, 20
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	addi $t0, $t0, 28
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	
	addi $t0, $t0, 32
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	addi $t0, $t0, 40
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	addi $t0, $t0, 20
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	addi $t0, $t0, 36
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	addi $t0, $t0, 20
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	addi $t0, $t0, 64
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	
	addi $t0, $t0, 20
	addi $t2, $t0, 24
	
while_draw_sm21:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t2, while_draw_sm21
	
	addi $t0, $t0, 4
	addi $t2, $t0, 20
	
while_draw_sm22:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t2, while_draw_sm22
	
	addi $t4, $t4, 512
	addi $t0, $t4, 0
	
	#Unfinished

	jr $ra
	
	
f_draw_level:
	addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    li $a0, 64812
    jal f_draw_egg
    
    li $a0, 33832
    jal draw_bird_rone
    
    li $a0, 19312
    jal draw_bird_ltwo
    
    li $a0, 61952
    jal f_draw_plat
    
    addi $a0, $a0, 24
    jal f_draw_plat
    
    li $a0, 59048
    jal f_draw_plat
    
    addi $a0, $a0, 24
    jal f_draw_plat
    
    li $a0, 56048
    jal f_draw_plat
    
    addi $a0, $a0, 24
    jal f_draw_plat
    
    li $a0, 43272
    jal f_draw_plat
    
    addi $a0, $a0, 24
    jal f_draw_plat
    
    li $a0, 52036
    jal f_draw_plat
    
    addi $a0, $a0, 24
    jal f_draw_plat
    
    li $a0, 37484
    jal f_draw_plat
    
    addi $a0, $a0, 24
    jal f_draw_plat
    
    addi $a0, $a0, 24
    jal f_draw_plat
    
    addi $a0, $a0, 24
    jal f_draw_plat
    
    addi $a0, $a0, 24
    jal f_draw_plat
    
    addi $a0, $a0, 24
    jal f_draw_plat
    
    
    li $a0, 24732
    jal f_draw_plat
    
    addi $a0, $a0, 24
    jal f_draw_plat
    
    addi $a0, $a0, 24
    jal f_draw_plat
    
    li $a0, 38828
    jal f_draw_plat
    
    li $a0, 49128
    jal f_draw_plat
    
    li $a0, 59308
    jal f_draw_plat
    
    li $a0, 62072
    jal f_draw_cactus_h2
    
    li $a0, 64152
    jal f_draw_cactus_h1
    
    addi $a0, $a0, 28
    jal f_draw_cactus_h3
    addi $a0, $a0, 28
    jal f_draw_cactus_h2
    
    li $a0, 64944
    jal f_draw_cactus_h1
    
    addi $a0, $a0, 28
    jal f_draw_cactus_h2
    addi $a0, $a0, 28
    jal f_draw_cactus_h1
    
    li $a0, 56100
    jal f_draw_cactus_h1
    
    li $a0, 23800
    jal f_draw_cactus_h1
    
    li $t0, BASE_ADDRESS # $t0 stores the base address for display
    
    addi $t0, $t0, 62464
    li $t1, 0xc2b280
    
    addi $t2, $t0, 148
    
w_sand1:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
    bne $t0, $t2, w_sand1

	addi $t0, $t0, 364
    
    addi $t2, $t0, 148
    
w_sand2:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
    bne $t0, $t2, w_sand2
    
	addi $t0, $t0, 364
    
    addi $t2, $t0, 152
    
w_sand3:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
    bne $t0, $t2, w_sand3
    
    addi $t0, $t0, 360
    
    addi $t2, $t0, 152
    
w_sand4:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
    bne $t0, $t2, w_sand4
    
    addi $t0, $t0, 360
    
    addi $t2, $t0, 236
    
w_sand5:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
    bne $t0, $t2, w_sand5
    
    addi $t0, $t0, 276
    
    addi $t2, $t0, 236
    
w_sand6:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
    bne $t0, $t2, w_sand6

    lw $ra, 0($sp)
    addi $sp, $sp, 4
    
 	li $t0, BASE_ADDRESS # $t0 stores the base address for display
    
    addi $t0, $t0, 22292
    li $t1, 0x009A17
    
    addi $t2, $t0, 160
    
w_grass:
	sw $t1, 0($t0)
	sw $t1, 512($t0)
	addi $t0, $t0, 4
    bne $t0, $t2, w_grass
    
    li $t0, BASE_ADDRESS # $t0 stores the base address for display
    
    addi $t0, $t0, 23316
    li $t1, 0x836539
    
    addi $t2, $t0, 160
    
w_dirt1:
	sw $t1, 0($t0)
	sw $t1, 512($t0)
	addi $t0, $t0, 4
    bne $t0, $t2, w_dirt1
    
    li $t0, BASE_ADDRESS # $t0 stores the base address for display
    
    addi $t0, $t0, 24312
    li $t1, 0x836539
    
    addi $t2, $t0, 188
    
w_dirt2:
	sw $t1, 0($t0)
	sw $t1, 512($t0)
	addi $t0, $t0, 4
    bne $t0, $t2, w_dirt2
    
	li $t0, BASE_ADDRESS # $t0 stores the base address for display
    
    addi $t0, $t0, 25336
    li $t1, 0x5B5036
    
    addi $t2, $t0, 188
    
w_rock1:
	sw $t1, 0($t0)
	sw $t1, 512($t0)
	addi $t0, $t0, 4
    bne $t0, $t2, w_rock1
    
    li $t0, BASE_ADDRESS # $t0 stores the base address for display
    
    addi $t0, $t0, 26380
    
    addi $t2, $t0, 168
    
w_rock2:
	sw $t1, 0($t0)
	sw $t1, 512($t0)
	addi $t0, $t0, 4
    bne $t0, $t2, w_rock2 
    
     li $t0, BASE_ADDRESS # $t0 stores the base address for display
    
    addi $t0, $t0, 27420
    
    addi $t2, $t0, 144
    
w_rock3:
	sw $t1, 0($t0)
	sw $t1, 512($t0)
	addi $t0, $t0, 4
    bne $t0, $t2, w_rock3
    
    li $t0, BASE_ADDRESS # $t0 stores the base address for display
    
    addi $t0, $t0, 28464
    
    addi $t2, $t0, 120
    
w_rock4:
	sw $t1, 0($t0)
	sw $t1, 512($t0)
	addi $t0, $t0, 4
    bne $t0, $t2, w_rock4
    
    li $t0, BASE_ADDRESS # $t0 stores the base address for display
    
    addi $t0, $t0, 29508
    
    addi $t2, $t0, 100
    
w_rock5:
	sw $t1, 0($t0)
	sw $t1, 512($t0)
	addi $t0, $t0, 4
    bne $t0, $t2, w_rock5
    
    li $t0, BASE_ADDRESS # $t0 stores the base address for display
    
    addi $t0, $t0, 30552
    
    addi $t2, $t0, 76
    
w_rock6:
	sw $t1, 0($t0)
	sw $t1, 512($t0)
	addi $t0, $t0, 4
    bne $t0, $t2, w_rock6
    
    li $t0, BASE_ADDRESS # $t0 stores the base address for display
    
    addi $t0, $t0, 31604
      
    addi $t2, $t0, 44
    
w_rock7:
	addi $t3, $t0, 0
	addi $t4, $t0, 7168
	
w_rocki7:
	sw $t1, 0($t3)
	addi $t3, $t3, 512
	bne $t3, $t4, w_rocki7
	
	addi $t0, $t0, 4
    bne $t0, $t2, w_rock7
    
    li $t0, BASE_ADDRESS # $t0 stores the base address for display
    
    addi $t0, $t0, 38772
      
    addi $t2, $t0, 36
    
w_rock8:
	addi $t3, $t0, 0
	addi $t4, $t0, 3584
	
w_rocki8:
	sw $t1, 0($t3)
	addi $t3, $t3, 512
	bne $t3, $t4, w_rocki8
	
	addi $t0, $t0, 4
    bne $t0, $t2, w_rock8
    
    li $t0, BASE_ADDRESS # $t0 stores the base address for display
    
    addi $t0, $t0, 42356
      
    addi $t2, $t0, 28
    
w_rock9:
	addi $t3, $t0, 0
	addi $t4, $t0, 10240
	
w_rocki9:
	sw $t1, 0($t3)
	addi $t3, $t3, 512
	bne $t3, $t4, w_rocki9
	
	addi $t0, $t0, 4
    bne $t0, $t2, w_rock9
    
    li $t0, BASE_ADDRESS # $t0 stores the base address for display
    
    addi $t0, $t0, 52548
      
    addi $t2, $t0, 68
    
w_rock10:
	addi $t3, $t0, 0
	addi $t4, $t0, 4096
	
w_rocki10:
	sw $t1, 0($t3)
	addi $t3, $t3, 512
	bne $t3, $t4, w_rocki10
	
	addi $t0, $t0, 4
    bne $t0, $t2, w_rock10
    
    li $t0, BASE_ADDRESS # $t0 stores the base address for display
    
    addi $t0, $t0, 56564
      
    addi $t2, $t0, 132
    
w_rock11:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
    bne $t0, $t2, w_rock11
    
    li $t0, BASE_ADDRESS # $t0 stores the base address for display
    
    addi $t0, $t0, 57076
      
    addi $t2, $t0, 124
    
w_rock12:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
    bne $t0, $t2, w_rock12
    
    li $t0, BASE_ADDRESS # $t0 stores the base address for display
    
    addi $t0, $t0, 57588
      
    addi $t2, $t0, 116
    
w_rock13:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
    bne $t0, $t2, w_rock13
    
    li $t0, BASE_ADDRESS # $t0 stores the base address for display
    
    addi $t0, $t0, 58100
      
    addi $t2, $t0, 108
    
w_rock14:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
    bne $t0, $t2, w_rock14
    
    li $t0, BASE_ADDRESS # $t0 stores the base address for display
    
    addi $t0, $t0, 58612
      
    addi $t2, $t0, 100
    
w_rock15:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
    bne $t0, $t2, w_rock15
    
    li $t0, BASE_ADDRESS # $t0 stores the base address for display
    
    addi $t0, $t0, 59124
      
    addi $t2, $t0, 92
    
w_rock16:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
    bne $t0, $t2, w_rock16
    
	li $t0, BASE_ADDRESS # $t0 stores the base address for display
    
    addi $t0, $t0, 59628
      
    addi $t2, $t0, 52
    
w_rock17:
	addi $t3, $t0, 0
	addi $t4, $t0, 5632
	
w_rocki17:
	sw $t1, 0($t3)
	addi $t3, $t3, 512
	bne $t3, $t4, w_rocki17
	
	addi $t0, $t0, 4
    bne $t0, $t2, w_rock17
    
    li $t0, BASE_ADDRESS # $t0 stores the base address for display
    
    addi $t0, $t0, 59680
    
    sw $t1, 0($t0)
    sw $t1, 4($t0)
    sw $t1, 512($t0)
    
    li $t0, BASE_ADDRESS # $t0 stores the base address for display
    
    addi $t0, $t0, 64288
    
    sw $t1, 0($t0)
    sw $t1, 516($t0)
    sw $t1, 512($t0)
    
	li $t0, BASE_ADDRESS # $t0 stores the base address for display
    
    addi $t0, $t0, 65260
      
    addi $t2, $t0, 276
    
w_rock18:
	sw $t1, 0($t0)
	addi $t0, $t0, 4
    bne $t0, $t2, w_rock18
    
    jr $ra



