; /*******************************************************************
; *
; *    Author: Kareem Omar
; *    kareem.h.omar@gmail.com
; *    https://github.com/komrad36
; *
; *    Last updated Oct 11, 2020
; *******************************************************************/

_TEXT$FastMaxFloat SEGMENT ALIGN(64)

FastMaxFloat PROC
 mov         eax,edx
 cmp         edx,64
 jae         CASE_LARGE
 vpcmpeqd    ymm0,ymm0,ymm0
db 03Eh
 vpcmpeqd    ymm1,ymm1,ymm1
 lea         r8,JUMP_TABLE
 movzx       edx,byte ptr [r8+rax]
 add         r8,rdx
 lea         rdx,[rcx+4*rax]
 and         eax,-8
 lea         rcx,[rcx+4*rax]
 jmp         r8
JUMP_TABLE:
db 1 DUP ( CASE_0 - JUMP_TABLE)
db 1 DUP ( CASE_1 - JUMP_TABLE)
db 1 DUP ( CASE_2 - JUMP_TABLE)
db 1 DUP ( CASE_3 - JUMP_TABLE)
db 1 DUP ( CASE_4 - JUMP_TABLE)
db 1 DUP ( CASE_5 - JUMP_TABLE)
db 1 DUP ( CASE_6 - JUMP_TABLE)
db 1 DUP ( CASE_7 - JUMP_TABLE)
db 8 DUP ( CASE_8 - JUMP_TABLE)
db 8 DUP (CASE_16 - JUMP_TABLE)
db 8 DUP (CASE_24 - JUMP_TABLE)
db 8 DUP (CASE_32 - JUMP_TABLE)
db 8 DUP (CASE_40 - JUMP_TABLE)
db 8 DUP (CASE_48 - JUMP_TABLE)
db 8 DUP (CASE_56 - JUMP_TABLE)
db 18 DUP (0CCh)
CASE_56:
 vmovups     ymm0,ymmword ptr [rcx-224]
CASE_48:
 vmovups     ymm1,ymmword ptr [rcx-192]
CASE_40:
 vmaxps      ymm0,ymm0,ymmword ptr [rcx-160]
CASE_32:
 vmaxps      ymm1,ymm1,ymmword ptr [rcx-128]
CASE_24:
 vmaxps      ymm0,ymm0,ymmword ptr [rcx-96]
CASE_16:
 vmaxps      ymm1,ymm1,ymmword ptr [rcx-64]
CASE_8:
 vmaxps      ymm0,ymm0,ymmword ptr [rcx-32]
 vmaxps      ymm1,ymm1,ymmword ptr [rdx-32]
 vmaxps      ymm0,ymm0,ymm1
 vextractf128 xmm1,ymm0,1
 vmaxps      xmm0,xmm0,xmm1
 vmovhlps    xmm1,xmm0,xmm0
 vmaxps      xmm0,xmm0,xmm1
 vmovshdup   xmm1,xmm0
 vmaxss      xmm0,xmm0,xmm1
 ret
db 3 DUP (0CCh)
CASE_7:
 vmovss      xmm0,dword ptr [rdx-28]
CASE_6:
 vmaxss      xmm0,xmm0,dword ptr [rdx-24]
CASE_5:
 vmaxss      xmm0,xmm0,dword ptr [rdx-20]
CASE_4:
 vmaxss      xmm0,xmm0,dword ptr [rdx-16]
CASE_3:
 vmaxss      xmm0,xmm0,dword ptr [rdx-12]
CASE_2:
 vmaxss      xmm0,xmm0,dword ptr [rdx-8]
CASE_1:
 vmaxss      xmm0,xmm0,dword ptr [rdx-4]
CASE_0:
 ret

CASE_LARGE:
 vmovups     ymm0,ymmword ptr [rcx]
 vmovups     ymm1,ymmword ptr [rcx+32]
 vmovups     ymm2,ymmword ptr [rcx+64]
 vmovups     ymm3,ymmword ptr [rcx+96]
 vmovups     ymm4,ymmword ptr [rcx+128]
 vmovups     ymm5,ymmword ptr [rcx+160]
 vmovaps     xmmword ptr [rsp+8],xmm6
 vmovups     ymm6,ymmword ptr [rcx+192]
 vmovaps     xmmword ptr [rsp+24],xmm7
 vmovups     ymm7,ymmword ptr [rcx+224]

 lea         rdx,[rcx+4*rax]
 add         rcx,512
 cmp         rcx,rdx
 jae         LOOP_END

LOOP_TOP:
 vmaxps      ymm0,ymm0,ymmword ptr [rcx-256]
 vmaxps      ymm1,ymm1,ymmword ptr [rcx-224]
 vmaxps      ymm2,ymm2,ymmword ptr [rcx-192]
 vmaxps      ymm3,ymm3,ymmword ptr [rcx-160]
 vmaxps      ymm4,ymm4,ymmword ptr [rcx-128]
 vmaxps      ymm5,ymm5,ymmword ptr [rcx-96]
 vmaxps      ymm6,ymm6,ymmword ptr [rcx-64]
 vmaxps      ymm7,ymm7,ymmword ptr [rcx-32]
 add         rcx,256
 cmp         rcx,rdx
 jb          LOOP_TOP

LOOP_END:
 vmaxps      ymm0,ymm0,ymmword ptr [rdx-256]
 vmaxps      ymm1,ymm1,ymmword ptr [rdx-224]
 vmaxps      ymm2,ymm2,ymmword ptr [rdx-192]
 vmaxps      ymm3,ymm3,ymmword ptr [rdx-160]
 vmaxps      ymm4,ymm4,ymmword ptr [rdx-128]
 vmaxps      ymm5,ymm5,ymmword ptr [rdx-96]
 vmaxps      ymm6,ymm6,ymmword ptr [rdx-64]
 vmaxps      ymm7,ymm7,ymmword ptr [rdx-32]

 vmaxps      ymm2,ymm2,ymm6
 vmovaps     xmm6,xmmword ptr [rsp+8]
 vmaxps      ymm3,ymm3,ymm7
 vmovaps     xmm7,xmmword ptr [rsp+24]
 vmaxps      ymm0,ymm0,ymm4
 vmaxps      ymm1,ymm1,ymm5

 vmaxps      ymm0,ymm0,ymm2
 vmaxps      ymm1,ymm1,ymm3

 vmaxps      ymm0,ymm0,ymm1

 vextractf128 xmm1,ymm0,1
 vmaxps      xmm0,xmm0,xmm1
 vmovhlps    xmm1,xmm0,xmm0
 vmaxps      xmm0,xmm0,xmm1
 vmovshdup   xmm1,xmm0
 vmaxss      xmm0,xmm0,xmm1
 ret
FastMaxFloat ENDP

_TEXT$FastMaxFloat ENDS

END
