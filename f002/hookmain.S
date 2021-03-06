	# Let's hook into main() by overwriting the part that looks to see
	# if there is a command waiting in 0x4070 and have it jump here.
	# then when we're done replace the thing we overwrote!
	#
	# we stick a little counter in the bottom right of the screen, just a demo
	#
	
	# we can overwrite r30, r31, r26

	show_text_on_display = 0x12ec
	show_text_on_display2 = 0x12dc
	display_number_on_display = 0x12b8
	r26_is_random_number_between_0x8d_0x8e = 0xb58
	run_call_table = 0x790	

	rand3_time_on_min = 30
	rand3_time_on_max = 240
	rand3_time_off_min = 5
	rand3_time_off_max = 90
	
fave_modes:			; you have to have an even number or compiler will complain
	.byte 0x76, 0x77, 0x7b, 0x78, 0x83, 0x86, 0x81, 0x86, 0x81, 0x76, 0x86, 0x86
	# ETMODE_waves, ETMODE_stroke, ETMODE_rhythm, ETMODE_climb, ETMODE_orgasm, ETMODE_phase2, ETMODE_random2, ETMODE_phase2, ETMODE
	# _random2, ETMODE_waves,ETMODE_phase2

hookloopmain:	
	ldd r30, Y+19	; 61Hz (0x73-$4073-master-timer-lsb)
	andi r30, 0x0e	; run at ~7Hz
	cpi r30, 0x06
	brne nothingtodo

	ldd r30, Y+14		; 0x60+14 is a byte not used, use it for bit0-debug-enabled
	sbrc r30, 0		; skipif(!bit(r30,0))
	call display_debug_counter
	sbrc r30, 1		; skipif(!bit(r30,1))
	call rand3_mode
nothingtodo:	
	jmp goback

display_debug_counter:	
	ldd r30, Y+13		; $406D is "Menu State" 1 when in menu, 2 when running a program
	cpi r30, 0x02		; don't do anything when in a menu
	breq not_in_menu
	jmp goback

not_in_menu:	
	ldd r30, Y+15		; 0x60+15 is a byte not used in the ET fw, let's use it for our counter
	inc r30
	std Y+15, r30
	
	ldi r31, 77	        ; bottom line, far right
	call display_number_on_display		; parameter r31 (position), r30 (number from 0-255)

	ret

	# Our new rand1 mode is different to modes available on the box
	# we want to pick a mode from our favourites, and pick a random time to run that mode
	# at the end of the time we turn off the output for some random time
	# then loop back... continue until the mode is changed

	# so we need an event timer, we need to know what to do at the end of that time, and we need
	# to hook to turn off the mode. it would also be nice to display the countdown

	# Y+15 mem1 = 0? then we need to pick a time, pick a mode, change to the mode, store the mode#
	# else if time reached and mode != ff then set mode=ff, turn off, set timer
	# else if time reached and mode == ff then set to 0
	# a few times a second display "Countdown xx"

rand3_mode:
	ldd r26, Y+15		; our special memory location for current mode
	cpi r26, 0		; is it a 0?
	breq is_zero
	jmp check_time		
is_zero:			; pick a time, pick a mode, change to the mode, store the mode
	ldi r26, 0		; mode temp
	std Y+45, r26
	ldi r26, 10
	std Y+46, r26
	call r26_is_random_number_between_0x8d_0x8e
	ldi r30, lo8(fave_modes)
	ldi r31, hi8(fave_modes)
	add r30, r26 		; no carry
	adc r31, r29		; +0 with carry
	lpm r26, Z		; r0 = flash[r30:r31]
	dec r26
	
	std Y+15, r26
	#	call 0x604;  Function 0x604 changes mode without changing display

	std Y+27, r26
	ldi r30, 0x4
	call run_call_table
	ldi r30, 0x10		; change mode (restarts routine timer)
	call run_call_table

	ldi r26, rand3_time_on_min
	std Y+45, r26
	ldi r26, rand3_time_on_max
	std Y+46, r26
	call r26_is_random_number_between_0x8d_0x8e
	std Y+21, r26   ; store it
	
	jmp rand3_done

check_time:
	ldd r30, Y+41 ; Memory[[r28:r29]+41]; routine timer 0.953Hz
	ldd r31, Y+21 ; Memory[[r28:r29]+21]; time to change mode
	cp r31, r30
	brne rand3_done
	cpi r26, 0xff
	breq rand3_end_of_mute

	ldi r26, 0xff		; set mode to ff, turn off, set timer
	std Y+15, r26

	ldi r26, rand3_time_off_min
	std Y+45, r26
	ldi r26, rand3_time_off_max
	std Y+46, r26
	call r26_is_random_number_between_0x8d_0x8e

	std Y+21, r26   ; store it
	ldi r30, 0x18	; start a new routine with no output (restarts routine timer)
	call run_call_table

	out 0x18, r29 ; IO[PORTB] = 0 ; turn off the fets
	# Since the SPDR sends the *last* value we need to zero it out or A
	# channel will get a short pulse when our mute ends
	sts 0x205, r29
	sts 0x206, r29
	call 0x1496
	
	ldi r26, 0x64
	call show_text_on_display ; 8 spaces on RHS top line
	
	rjmp rand3_done

rand3_end_of_mute:
	ldi r31, 0
	std Y+15, r31
#	jmp rand3_done		

rand3_done:
	ldd r30, Y+13		; $406D is "Menu State" 1 when in menu, 2 when running a program
	cpi r30, 0x02		; don't do anything when in a menu, otherwise display our status msg
	brne goback

	ldi r26, 0x20
	call show_text_on_display2

	ldd r31, Y+41	; Memory[[r28:r29]+41]; routine timer 0.953Hz
	ldd r30, Y+21   ; Memory[[r28:r29]+21]; time to change mode
	sub r30, r31

	ldi r31, 77		; bottom line, farright
	call display_number_on_display

	ret
	
goback:	
	; stuff we overwrote that we have to do here now
	ldd r30, Y+16		; r30 = Memory[[r28:r29]+16]  is 0x4070
	cpi r30, 0x28		; cmp(r30, 0x28)
	brcc	omk		; if (!Carry) goto 0x444
	jmp 0x43e
omk:	jmp 0x444

	# Stuff below is compiled but not patched into the binary, any routines starting
	# with keyword "replace_" will cause our patch utility to add the compiled code
	# to the location that follows.  i.e. "replace_0x300: nop" would write a 0 to
	# 0x300 in the original firmware.
	
	# hook a little counter into bottom right of screen as a demo
replace_0x438:
	jmp hookloopmain

