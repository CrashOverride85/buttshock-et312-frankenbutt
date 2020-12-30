# Buttshock - Frankenfirmware 

## m005 for mk box

Patches

- changeversion: changes startup message from v1.6 to m005, name, and arrows
- removerandomxor: box will always pick 0 as it's xor communication key
- serialdumpmemory: box will allow serial to dump more of the flash memory on request
- fixknobscaling: A and B levels now display smoothly 0-99 with no missing numbers
- newmenu; adds a new sub menu "More Options", moves Link Slave to that menu
- hookmain: adds a new mode "Random 3" kind of a combination of torment and random1 to the new options menu,
  adds a new mode "Random 4" which turns on with a random mode for 40ish seconds, then off for 20ish seconds

## License

All original code and documentation is
covered under the following BSD license:

    Copyright (c) 2016, The Buttshock Project
    All rights reserved.

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:
        * Redistributions of source code must retain the above copyright
          notice, this list of conditions and the following disclaimer.
        * Redistributions in binary form must reproduce the above copyright
          notice, this list of conditions and the following disclaimer in the
          documentation and/or other materials provided with the distribution.
        * Neither the name of The Buttshock Project nor the names of
          its contributors may be used to endorse or promote products
          derived from this software without specific prior written
          permission.

    THIS SOFTWARE IS PROVIDED BY The Buttshock Project ''AS IS'' AND
    ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
    THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
    PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Kyle
    Machulis/Nonpolynomial Labs BE LIABLE FOR ANY DIRECT, INDIRECT,
    INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
    (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
    SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
    HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
    CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
    OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
    EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE

