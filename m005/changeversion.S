	# replace the V1.6 on startup screen with our own ID

	.org 0x3000
	
replace_0x1ce4:
	.ascii "M005"

replace_0x1cf8:
	.ascii "        MK-312 T"

	# Display the B between 2 and T if we have a battery
replace_0x180c:
	ldi r31, 0x0e
	
	# Different LCD arrows

replace_0x1d18:
	.byte 0x7f
	.ascii " "
	.byte 0x7e

replace_0x1d2e:
	.byte 0x7f
	.ascii " "
	.byte 0x7e

replace_0x1dc1:
	.byte 0x7f
	.byte 0x7e



