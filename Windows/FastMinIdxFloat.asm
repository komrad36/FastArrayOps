_TEXT$AsmFastMinIdxFloat SEGMENT ALIGN(64)

AsmFastMinIdxFloat PROC
 sub		 rsp,104
 vmovdqu     ymm4,ymmword ptr [SEQ]
 mov         eax,edx
 cmp         edx,64
 jae         CASE_LARGE
 vpcmpeqd    ymm0,ymm0,ymm0
 vpslld      ymm2,ymm0,3
 vmovdqa	 ymm3,ymm4
 vpcmpeqd    ymm1,ymm1,ymm1
 lea		 r8,JUMP_TABLE
 movzx		 edx,word ptr [r8+2*rax]
 add		 r8,rdx
 lea         rdx,[rcx+4*rax]
 mov		 r9d,eax
 and		 eax,-8
 lea         rcx,[rcx+4*rax]
 jmp         r8
SEQ:
dd 0,1,2,3,4,5,6,7
JUMP_TABLE:
dw 1 DUP ( CASE_0 - JUMP_TABLE)
dw 1 DUP ( CASE_1 - JUMP_TABLE)
dw 1 DUP ( CASE_2 - JUMP_TABLE)
dw 1 DUP ( CASE_3 - JUMP_TABLE)
dw 1 DUP ( CASE_4 - JUMP_TABLE)
dw 1 DUP ( CASE_5 - JUMP_TABLE)
dw 1 DUP ( CASE_6 - JUMP_TABLE)
dw 1 DUP ( CASE_7 - JUMP_TABLE)
dw 8 DUP ( CASE_8 - JUMP_TABLE)
dw 8 DUP (CASE_16 - JUMP_TABLE)
dw 8 DUP (CASE_24 - JUMP_TABLE)
dw 8 DUP (CASE_32 - JUMP_TABLE)
dw 8 DUP (CASE_40 - JUMP_TABLE)
dw 8 DUP (CASE_48 - JUMP_TABLE)
dw 8 DUP (CASE_56 - JUMP_TABLE)
CASE_56:
 vmovups     ymm1,ymmword ptr [rcx-224]
 vpsubd		 ymm4,ymm4,ymm2
CASE_48:
 vminps      ymm0,ymm1,ymmword ptr [rcx-192]
 vpcmpeqd    ymm1,ymm0,ymm1
 vpblendvb   ymm3,ymm4,ymm3,ymm1
 vpsubd		 ymm4,ymm4,ymm2
CASE_40:
 vminps      ymm1,ymm0,ymmword ptr [rcx-160]
 vpcmpeqd    ymm0,ymm0,ymm1
 vpblendvb   ymm3,ymm4,ymm3,ymm0
 vpsubd		 ymm4,ymm4,ymm2
CASE_32:
 vminps      ymm0,ymm1,ymmword ptr [rcx-128]
 vpcmpeqd    ymm1,ymm0,ymm1
 vpblendvb   ymm3,ymm4,ymm3,ymm1
 vpsubd		 ymm4,ymm4,ymm2
CASE_24:
 vminps      ymm1,ymm0,ymmword ptr [rcx-96]
 vpcmpeqd    ymm0,ymm0,ymm1
 vpblendvb   ymm3,ymm4,ymm3,ymm0
 vpsubd		 ymm4,ymm4,ymm2
CASE_16:
 vminps      ymm0,ymm1,ymmword ptr [rcx-64]
 vpcmpeqd    ymm1,ymm0,ymm1
 vpblendvb   ymm3,ymm4,ymm3,ymm1
 vpsubd		 ymm4,ymm4,ymm2
CASE_8:
 vminps      ymm1,ymm0,ymmword ptr [rcx-32]
 vpcmpeqd    ymm0,ymm0,ymm1
 vpblendvb   ymm3,ymm4,ymm3,ymm0
 lea		 ecx,[r9-8]
 vmovd		 xmm4,ecx
 vpbroadcastd ymm4,xmm4
 vpaddd		 ymm4,ymm4,ymmword ptr [SEQ]
 vminps      ymm0,ymm1,ymmword ptr [rdx-32]
 vpcmpeqd    ymm1,ymm0,ymm1
 vpblendvb   ymm2,ymm4,ymm3,ymm1
 vextractf128 xmm1,ymm0,1
 vextracti128 xmm3,ymm2,1
 vminps		 xmm0,xmm0,xmm1
 vpcmpeqd    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm2,xmm3,xmm1
 vmovhlps    xmm1,xmm0,xmm0
 vpunpckhqdq xmm3,xmm2,xmm2
 vminps		 xmm0,xmm0,xmm1
 vpcmpeqd    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm2,xmm3,xmm1
 vmovshdup   xmm1,xmm0
 vmovshdup   xmm3,xmm2
 vcmpgt_oqss xmm0,xmm0,xmm1
 vpblendvb   xmm0,xmm2,xmm3,xmm0
 vmovd       eax,xmm0
 add         rsp,104
 ret
CASE_7:
 vmovss      xmm0,dword ptr [rdx-28]
CASE_6:
 vucomiss    xmm0,dword ptr [rdx-24]
 lea		 ecx,[r9-6]
 cmova		 eax,ecx
 vminss      xmm0,xmm0,dword ptr [rdx-24]
CASE_5:
 vucomiss    xmm0,dword ptr [rdx-20]
 lea		 ecx,[r9-5]
 cmova		 eax,ecx
 vminss      xmm0,xmm0,dword ptr [rdx-20]
CASE_4:
 vucomiss    xmm0,dword ptr [rdx-16]
 lea		 ecx,[r9-4]
 cmova		 eax,ecx
 vminss      xmm0,xmm0,dword ptr [rdx-16]
CASE_3:
 vucomiss    xmm0,dword ptr [rdx-12]
 lea		 ecx,[r9-3]
 cmova		 eax,ecx
 vminss      xmm0,xmm0,dword ptr [rdx-12]
CASE_2:
 vucomiss    xmm0,dword ptr [rdx-8]
 lea		 ecx,[r9-2]
 cmova		 eax,ecx
 vminss      xmm0,xmm0,dword ptr [rdx-8]
CASE_1:
 vucomiss    xmm0,dword ptr [rdx-4]
 lea		 ecx,[r9-1]
 cmova		 eax,ecx
CASE_0:
 add         rsp,104
 ret

CASE_LARGE:
 ; best indices
 vmovdqa     ymm5,ymm4
 vmovaps     xmmword ptr [rsp],xmm6
 vmovdqa     ymm6,ymm4
 vmovaps     xmmword ptr [rsp+16],xmm7
 vmovdqa     ymm7,ymm4
 vmovaps     xmmword ptr [rsp+32],xmm8
 vmovdqa     ymm8,ymm4

 ; increment
 vmovaps     xmmword ptr [rsp+48],xmm9
 vpcmpeqd    ymm9,ymm9,ymm9
 vpslld      ymm9,ymm9,5

 ; best values
 vmovaps     xmmword ptr [rsp+64],xmm10
 vmovups     ymm10,ymmword ptr [rcx]
 vmovaps     xmmword ptr [rsp+80],xmm11
 vmovups     ymm11,ymmword ptr [rcx+32]
 vmovaps     xmmword ptr [rsp+112],xmm12
 vmovups     ymm12,ymmword ptr [rcx+64]
 vmovaps     xmmword ptr [rsp+128],xmm13
 vmovups     ymm13,ymmword ptr [rcx+96]

 vpsubd      ymm4,ymm4,ymm9

 vminps      ymm0,ymm10,ymmword ptr [rcx+128]
 vminps      ymm1,ymm11,ymmword ptr [rcx+160]
 vminps      ymm2,ymm12,ymmword ptr [rcx+192]
 vminps      ymm3,ymm13,ymmword ptr [rcx+224]
 vpcmpeqd    ymm10,ymm0,ymm10
 vpblendvb   ymm5,ymm4,ymm5,ymm10
 vpcmpeqd    ymm11,ymm1,ymm11
 vpblendvb   ymm6,ymm4,ymm6,ymm11
 vpcmpeqd    ymm12,ymm2,ymm12
 vpblendvb   ymm7,ymm4,ymm7,ymm12
 vpcmpeqd    ymm13,ymm3,ymm13
 vpblendvb   ymm8,ymm4,ymm8,ymm13

 vpsubd      ymm4,ymm4,ymm9

 lea         rdx,[rcx+4*rax]
 add         rcx,512
 cmp         rcx,rdx
 jae         LOOP_END

LOOP_TOP:
 vminps      ymm10,ymm0,ymmword ptr [rcx-256]
 vminps      ymm11,ymm1,ymmword ptr [rcx-224]
 vminps      ymm12,ymm2,ymmword ptr [rcx-192]
 vminps      ymm13,ymm3,ymmword ptr [rcx-160]
 vpcmpeqd    ymm0,ymm0,ymm10
 vpblendvb   ymm5,ymm4,ymm5,ymm0
 vminps      ymm0,ymm10,ymmword ptr [rcx-128]
 vpcmpeqd    ymm1,ymm1,ymm11
 vpblendvb   ymm6,ymm4,ymm6,ymm1
 vminps      ymm1,ymm11,ymmword ptr [rcx-96]
 vpcmpeqd    ymm2,ymm2,ymm12
 vpblendvb   ymm7,ymm4,ymm7,ymm2
 vminps      ymm2,ymm12,ymmword ptr [rcx-64]
 vpcmpeqd    ymm3,ymm3,ymm13
 vpblendvb   ymm8,ymm4,ymm8,ymm3
 vminps      ymm3,ymm13,ymmword ptr [rcx-32]
 vpsubd      ymm4,ymm4,ymm9
 vpcmpeqd    ymm10,ymm0,ymm10
 vpblendvb   ymm5,ymm4,ymm5,ymm10
 vpcmpeqd    ymm11,ymm1,ymm11
 vpblendvb   ymm6,ymm4,ymm6,ymm11
 vpcmpeqd    ymm12,ymm2,ymm12
 vpblendvb   ymm7,ymm4,ymm7,ymm12
 vpcmpeqd    ymm13,ymm3,ymm13
 vpblendvb   ymm8,ymm4,ymm8,ymm13

 vpsubd      ymm4,ymm4,ymm9
 add         rcx,256
 cmp         rcx,rdx
 jb          LOOP_TOP

LOOP_END:
 sub		 eax,64
 vmovd		 xmm4,eax
 vpbroadcastd ymm4,xmm4
 vpaddd		 ymm4,ymm4,ymmword ptr [SEQ]

 vminps      ymm10,ymm0,ymmword ptr [rdx-256]
 vminps      ymm11,ymm1,ymmword ptr [rdx-224]
 vminps      ymm12,ymm2,ymmword ptr [rdx-192]
 vminps      ymm13,ymm3,ymmword ptr [rdx-160]
 vpcmpeqd    ymm0,ymm0,ymm10
 vpblendvb   ymm5,ymm4,ymm5,ymm0
 vminps      ymm0,ymm10,ymmword ptr [rdx-128]
 vpcmpeqd    ymm1,ymm1,ymm11
 vpblendvb   ymm6,ymm4,ymm6,ymm1
 vminps      ymm1,ymm11,ymmword ptr [rdx-96]
 vpcmpeqd    ymm2,ymm2,ymm12
 vpblendvb   ymm7,ymm4,ymm7,ymm2
 vminps      ymm2,ymm12,ymmword ptr [rdx-64]
 vpcmpeqd    ymm3,ymm3,ymm13
 vpblendvb   ymm8,ymm4,ymm8,ymm3
 vminps      ymm3,ymm13,ymmword ptr [rdx-32]
 vpsubd      ymm4,ymm4,ymm9
 vpcmpeqd    ymm13,ymm3,ymm13
 vpblendvb   ymm8,ymm4,ymm8,ymm13
 vmovaps     xmm13,xmmword ptr [rsp+128]
 vpcmpeqd    ymm12,ymm2,ymm12
 vpblendvb   ymm7,ymm4,ymm7,ymm12
 vmovaps     xmm12,xmmword ptr [rsp+112]
 vpcmpeqd    ymm11,ymm1,ymm11
 vpblendvb   ymm6,ymm4,ymm6,ymm11
 vmovaps     xmm11,xmmword ptr [rsp+80]
 vpcmpeqd    ymm10,ymm0,ymm10
 vpblendvb   ymm5,ymm4,ymm5,ymm10
 vmovaps     xmm10,xmmword ptr [rsp+64]

 vpsrad      ymm4,ymm9,1
 vmovaps     xmm9,xmmword ptr [rsp+48]

 vminps      ymm1,ymm1,ymm3
 vpcmpeqd    ymm3,ymm1,ymm3
 vpsubd      ymm8,ymm8,ymm4
 vpblendvb   ymm6,ymm6,ymm8,ymm3
 vmovaps     xmm8,xmmword ptr [rsp+32]

 vminps      ymm0,ymm0,ymm2
 vpcmpeqd    ymm2,ymm0,ymm2
 vpsubd      ymm7,ymm7,ymm4
 vpblendvb   ymm5,ymm5,ymm7,ymm2
 vmovaps     xmm7,xmmword ptr [rsp+16]

 vpsrad      ymm4,ymm4,1

 vminps      ymm0,ymm0,ymm1
 vpcmpeqd    ymm1,ymm0,ymm1
 vpsubd      ymm6,ymm6,ymm4
 vpblendvb   ymm2,ymm5,ymm6,ymm1
 vmovaps     xmm6,xmmword ptr [rsp]

 vextractf128 xmm1,ymm0,1
 vextracti128 xmm3,ymm2,1

 vminps		 xmm0,xmm0,xmm1
 vpcmpeqd    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm2,xmm3,xmm1

 vmovhlps    xmm1,xmm0,xmm0
 vpunpckhqdq xmm3,xmm2,xmm2

 vminps		 xmm0,xmm0,xmm1
 vpcmpeqd    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm2,xmm3,xmm1

 vmovshdup   xmm1,xmm0
 vmovshdup   xmm3,xmm2

 vcmpgt_oqss xmm0,xmm0,xmm1
 vpblendvb   xmm0,xmm2,xmm3,xmm0
 vmovd       eax,xmm0

 add         rsp,104
 ret
AsmFastMinIdxFloat ENDP

_TEXT$AsmFastMinIdxFloat ENDS

END
