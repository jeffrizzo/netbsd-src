; mc88110 __gmpn_sub_n -- Subtract two limb vectors of the same length > 0 and
; store difference in a third limb vector.

; Copyright 1995, 1996, 2000 Free Software Foundation, Inc.

; This file is part of the GNU MP Library.

; The GNU MP Library is free software; you can redistribute it and/or modify
; it under the terms of the GNU Lesser General Public License as published by
; the Free Software Foundation; either version 3 of the License, or (at your
; option) any later version.

; The GNU MP Library is distributed in the hope that it will be useful, but
; WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
; or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
; License for more details.

; You should have received a copy of the GNU Lesser General Public License
; along with the GNU MP Library.  If not, see http://www.gnu.org/licenses/.


; INPUT PARAMETERS
#define res_ptr	r2
#define s1_ptr	r3
#define s2_ptr	r4
#define size	r5

#include "sysdep.h"

	text
	align	16
	global	C_SYMBOL_NAME(__gmpn_sub_n)
C_SYMBOL_NAME(__gmpn_sub_n):
	subu.co	 r0,r0,r0		; set cy flag
	xor	 r12,s2_ptr,res_ptr
	bb1	 2,r12,L1
; **  V1a  **
L0:	bb0	 2,res_ptr,L_v1		; branch if res_ptr is aligned
/* Add least significant limb separately to align res_ptr and s2_ptr */
	ld	 r10,s1_ptr,0
	addu	 s1_ptr,s1_ptr,4
	ld	 r8,s2_ptr,0
	addu	 s2_ptr,s2_ptr,4
	subu	 size,size,1
	subu.co	 r6,r10,r8
	st	 r6,res_ptr,0
	addu	 res_ptr,res_ptr,4
L_v1:	cmp	 r12,size,2
	bb1	 lt,r12,Lend2

	ld	 r10,s1_ptr,0
	ld	 r12,s1_ptr,4
	ld.d	 r8,s2_ptr,0
	subu	 size,size,10
	bcnd	 lt0,size,Lfin1
/* Add blocks of 8 limbs until less than 8 limbs remain */
	align	 8
Loop1:	subu	 size,size,8
	subu.cio r6,r10,r8
	ld	 r10,s1_ptr,8
	subu.cio r7,r12,r9
	ld	 r12,s1_ptr,12
	ld.d	 r8,s2_ptr,8
	st.d	 r6,res_ptr,0
	subu.cio r6,r10,r8
	ld	 r10,s1_ptr,16
	subu.cio r7,r12,r9
	ld	 r12,s1_ptr,20
	ld.d	 r8,s2_ptr,16
	st.d	 r6,res_ptr,8
	subu.cio r6,r10,r8
	ld	 r10,s1_ptr,24
	subu.cio r7,r12,r9
	ld	 r12,s1_ptr,28
	ld.d	 r8,s2_ptr,24
	st.d	 r6,res_ptr,16
	subu.cio r6,r10,r8
	ld	 r10,s1_ptr,32
	subu.cio r7,r12,r9
	ld	 r12,s1_ptr,36
	addu	 s1_ptr,s1_ptr,32
	ld.d	 r8,s2_ptr,32
	addu	 s2_ptr,s2_ptr,32
	st.d	 r6,res_ptr,24
	addu	 res_ptr,res_ptr,32
	bcnd	 ge0,size,Loop1

Lfin1:	addu	 size,size,8-2
	bcnd	 lt0,size,Lend1
/* Add blocks of 2 limbs until less than 2 limbs remain */
Loope1:	subu.cio r6,r10,r8
	ld	 r10,s1_ptr,8
	subu.cio r7,r12,r9
	ld	 r12,s1_ptr,12
	ld.d	 r8,s2_ptr,8
	st.d	 r6,res_ptr,0
	subu	 size,size,2
	addu	 s1_ptr,s1_ptr,8
	addu	 s2_ptr,s2_ptr,8
	addu	 res_ptr,res_ptr,8
	bcnd	 ge0,size,Loope1
Lend1:	subu.cio r6,r10,r8
	subu.cio r7,r12,r9
	st.d	 r6,res_ptr,0

	bb0	 0,size,Lret1
/* Add last limb */
	ld	 r10,s1_ptr,8
	ld	 r8,s2_ptr,8
	subu.cio r6,r10,r8
	st	 r6,res_ptr,8

Lret1:	addu.ci r2,r0,r0		; return carry-out from most sign. limb
	jmp.n	 r1
	 xor	r2,r2,1

L1:	xor	 r12,s1_ptr,res_ptr
	bb1	 2,r12,L2
; **  V1b  **
	bb0	 2,res_ptr,L_v1b	; branch if res_ptr is aligned
/* Add least significant limb separately to align res_ptr and s1_ptr */
	ld	 r10,s2_ptr,0
	addu	 s2_ptr,s2_ptr,4
	ld	 r8,s1_ptr,0
	addu	 s1_ptr,s1_ptr,4
	subu	 size,size,1
	subu.co	 r6,r8,r10
	st	 r6,res_ptr,0
	addu	 res_ptr,res_ptr,4
L_v1b:	cmp	 r12,size,2
	bb1	 lt,r12,Lend2

	ld	 r10,s2_ptr,0
	ld	 r12,s2_ptr,4
	ld.d	 r8,s1_ptr,0
	subu	 size,size,10
	bcnd	 lt0,size,Lfin1b
/* Add blocks of 8 limbs until less than 8 limbs remain */
	align	 8
Loop1b:	subu	 size,size,8
	subu.cio r6,r8,r10
	ld	 r10,s2_ptr,8
	subu.cio r7,r9,r12
	ld	 r12,s2_ptr,12
	ld.d	 r8,s1_ptr,8
	st.d	 r6,res_ptr,0
	subu.cio r6,r8,r10
	ld	 r10,s2_ptr,16
	subu.cio r7,r9,r12
	ld	 r12,s2_ptr,20
	ld.d	 r8,s1_ptr,16
	st.d	 r6,res_ptr,8
	subu.cio r6,r8,r10
	ld	 r10,s2_ptr,24
	subu.cio r7,r9,r12
	ld	 r12,s2_ptr,28
	ld.d	 r8,s1_ptr,24
	st.d	 r6,res_ptr,16
	subu.cio r6,r8,r10
	ld	 r10,s2_ptr,32
	subu.cio r7,r9,r12
	ld	 r12,s2_ptr,36
	addu	 s2_ptr,s2_ptr,32
	ld.d	 r8,s1_ptr,32
	addu	 s1_ptr,s1_ptr,32
	st.d	 r6,res_ptr,24
	addu	 res_ptr,res_ptr,32
	bcnd	 ge0,size,Loop1b

Lfin1b:	addu	 size,size,8-2
	bcnd	 lt0,size,Lend1b
/* Add blocks of 2 limbs until less than 2 limbs remain */
Loope1b:subu.cio r6,r8,r10
	ld	 r10,s2_ptr,8
	subu.cio r7,r9,r12
	ld	 r12,s2_ptr,12
	ld.d	 r8,s1_ptr,8
	st.d	 r6,res_ptr,0
	subu	 size,size,2
	addu	 s1_ptr,s1_ptr,8
	addu	 s2_ptr,s2_ptr,8
	addu	 res_ptr,res_ptr,8
	bcnd	 ge0,size,Loope1b
Lend1b:	subu.cio r6,r8,r10
	subu.cio r7,r9,r12
	st.d	 r6,res_ptr,0

	bb0	 0,size,Lret1b
/* Add last limb */
	ld	 r10,s2_ptr,8
	ld	 r8,s1_ptr,8
	subu.cio r6,r8,r10
	st	 r6,res_ptr,8

Lret1b:	addu.ci r2,r0,r0		; return carry-out from most sign. limb
	jmp.n	 r1
	 xor	r2,r2,1

; **  V2  **
/* If we come here, the alignment of s1_ptr and res_ptr as well as the
   alignment of s2_ptr and res_ptr differ.  Since there are only two ways
   things can be aligned (that we care about) we now know that the alignment
   of s1_ptr and s2_ptr are the same.  */

L2:	cmp	 r12,size,1
	bb1	 eq,r12,Ljone
	bb0	 2,s1_ptr,L_v2		; branch if s1_ptr is aligned
/* Add least significant limb separately to align res_ptr and s2_ptr */
	ld	 r10,s1_ptr,0
	addu	 s1_ptr,s1_ptr,4
	ld	 r8,s2_ptr,0
	addu	 s2_ptr,s2_ptr,4
	subu	 size,size,1
	subu.co	 r6,r10,r8
	st	 r6,res_ptr,0
	addu	 res_ptr,res_ptr,4

L_v2:	subu	 size,size,8
	bcnd	 lt0,size,Lfin2
/* Add blocks of 8 limbs until less than 8 limbs remain */
	align	 8
Loop2:	subu	 size,size,8
	ld.d	 r8,s1_ptr,0
	ld.d	 r6,s2_ptr,0
	subu.cio r8,r8,r6
	st	 r8,res_ptr,0
	subu.cio r9,r9,r7
	st	 r9,res_ptr,4
	ld.d	 r8,s1_ptr,8
	ld.d	 r6,s2_ptr,8
	subu.cio r8,r8,r6
	st	 r8,res_ptr,8
	subu.cio r9,r9,r7
	st	 r9,res_ptr,12
	ld.d	 r8,s1_ptr,16
	ld.d	 r6,s2_ptr,16
	subu.cio r8,r8,r6
	st	 r8,res_ptr,16
	subu.cio r9,r9,r7
	st	 r9,res_ptr,20
	ld.d	 r8,s1_ptr,24
	ld.d	 r6,s2_ptr,24
	subu.cio r8,r8,r6
	st	 r8,res_ptr,24
	subu.cio r9,r9,r7
	st	 r9,res_ptr,28
	addu	 s1_ptr,s1_ptr,32
	addu	 s2_ptr,s2_ptr,32
	addu	 res_ptr,res_ptr,32
	bcnd	 ge0,size,Loop2

Lfin2:	addu	 size,size,8-2
	bcnd	 lt0,size,Lend2
Loope2:	ld.d	 r8,s1_ptr,0
	ld.d	 r6,s2_ptr,0
	subu.cio r8,r8,r6
	st	 r8,res_ptr,0
	subu.cio r9,r9,r7
	st	 r9,res_ptr,4
	subu	 size,size,2
	addu	 s1_ptr,s1_ptr,8
	addu	 s2_ptr,s2_ptr,8
	addu	 res_ptr,res_ptr,8
	bcnd	 ge0,size,Loope2
Lend2:	bb0	 0,size,Lret2
/* Add last limb */
Ljone:	ld	 r10,s1_ptr,0
	ld	 r8,s2_ptr,0
	subu.cio r6,r10,r8
	st	 r6,res_ptr,0

Lret2:	addu.ci r2,r0,r0		; return carry-out from most sign. limb
	jmp.n	 r1
	 xor	r2,r2,1
