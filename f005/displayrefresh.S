	# Change display status screen refresh to ~7Hz instead of ~60Hz
	# to stop occasional flickering

replace_0x45e:
	andi r26, 0x3f
	
