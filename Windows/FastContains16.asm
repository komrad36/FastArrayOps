; /*******************************************************************
; *
; *    Author: Kareem Omar
; *    kareem.h.omar@gmail.com
; *    https://github.com/komrad36
; *
; *    Last updated Mar 12, 2021
; *******************************************************************/

_TEXT$FastContains16 SEGMENT ALIGN(64)

FastContains16 PROC
 vmovd       xmm0,r8d
 vpbroadcastw ymm0,xmm0
 cmp         rdx,127
 ja          CASE_LARGE
 vpxor       xmm1,xmm1,xmm1
 lea         r9,JUMP_TABLE
 movzx       eax,word ptr [r9+2*rdx]
 add         r9,rax
 mov         eax,edx
 lea         rdx,[rcx+2*rdx]
 and         al,-16
 lea         rcx,[rcx+2*rax]
 mov         r10b,1
 jmp         r9
db 27 DUP (0CCh)
JUMP_TABLE:
dw  1 DUP (  CASE_0 - JUMP_TABLE)
dw  1 DUP (  CASE_1 - JUMP_TABLE)
dw  1 DUP (  CASE_2 - JUMP_TABLE)
dw  1 DUP (  CASE_3 - JUMP_TABLE)
dw  4 DUP (  CASE_4 - JUMP_TABLE)
dw  8 DUP (  CASE_8 - JUMP_TABLE)
dw 16 DUP ( CASE_16 - JUMP_TABLE)
dw 16 DUP ( CASE_32 - JUMP_TABLE)
dw 16 DUP ( CASE_48 - JUMP_TABLE)
dw 16 DUP ( CASE_64 - JUMP_TABLE)
dw 16 DUP ( CASE_80 - JUMP_TABLE)
dw 16 DUP ( CASE_96 - JUMP_TABLE)
dw 16 DUP (CASE_112 - JUMP_TABLE)
CASE_112:
 vpcmpeqw    ymm1,ymm0,ymmword ptr [rcx-224]
CASE_96:
 vpcmpeqw    ymm2,ymm0,ymmword ptr [rcx-192]
 vpor        ymm1,ymm1,ymm2
CASE_80:
 vpcmpeqw    ymm2,ymm0,ymmword ptr [rcx-160]
 vpor        ymm1,ymm1,ymm2
CASE_64:
 vpcmpeqw    ymm2,ymm0,ymmword ptr [rcx-128]
 vpor        ymm1,ymm1,ymm2
CASE_48:
 vpcmpeqw    ymm2,ymm0,ymmword ptr [rcx-96]
 vpor        ymm1,ymm1,ymm2
CASE_32:
 vpcmpeqw    ymm2,ymm0,ymmword ptr [rcx-64]
 vpor        ymm1,ymm1,ymm2
CASE_16:
 vpcmpeqw    ymm2,ymm0,ymmword ptr [rcx-32]
 vpor        ymm1,ymm1,ymm2
 vpcmpeqw    ymm2,ymm0,ymmword ptr [rdx-32]
 vpor        ymm1,ymm1,ymm2
 vptest      ymm1,ymm1
 setnz       al
 ret
CASE_8:
 vpcmpeqw    xmm1,xmm0,xmmword ptr [rcx]
 vpcmpeqw    xmm2,xmm0,xmmword ptr [rdx-16]
 vpor        xmm1,xmm1,xmm2
 vptest      xmm1,xmm1
 setnz       al
 ret
CASE_4:
 vpbroadcastq xmm1,qword ptr [rcx]
 vpcmpeqw    xmm1,xmm0,xmm1
 vpbroadcastq xmm2,qword ptr [rdx-8]
 vpcmpeqw    xmm2,xmm0,xmm2
 vpor        xmm1,xmm1,xmm2
 vptest      xmm1,xmm1
 setnz       al
 ret
CASE_3:
 cmp         r8w,word ptr [rdx-6]
 sete        al
CASE_2:
 cmp         r8w,word ptr [rdx-4]
 cmove       eax,r10d
CASE_1:
 cmp         r8w,word ptr [rdx-2]
 cmove       eax,r10d
CASE_0:
 ret

CASE_LARGE:
 lea         rdx,[rcx+2*rdx]
 add         rcx,256

LOOP_TOP:
 vpcmpeqw    ymm1,ymm0,ymmword ptr [rcx-256]
 vpcmpeqw    ymm2,ymm0,ymmword ptr [rcx-224]
 vpor        ymm1,ymm1,ymm2
 vpcmpeqw    ymm3,ymm0,ymmword ptr [rcx-192]
 vpcmpeqw    ymm4,ymm0,ymmword ptr [rcx-160]
 vpor        ymm3,ymm3,ymm4
 vpor        ymm1,ymm1,ymm3
 vpcmpeqw    ymm2,ymm0,ymmword ptr [rcx-128]
 vpcmpeqw    ymm3,ymm0,ymmword ptr [rcx-96]
 vpor        ymm2,ymm2,ymm3
 vpcmpeqw    ymm4,ymm0,ymmword ptr [rcx-64]
 vpcmpeqw    ymm5,ymm0,ymmword ptr [rcx-32]
 vpor        ymm4,ymm4,ymm5
 vpor        ymm2,ymm2,ymm4
 vpor        ymm1,ymm1,ymm2
 vptest      ymm1,ymm1
 jnz         FOUND
 add         rcx,256
 cmp         rcx,rdx
 jb          LOOP_TOP

 vpcmpeqw    ymm1,ymm0,ymmword ptr [rdx-256]
 vpcmpeqw    ymm2,ymm0,ymmword ptr [rdx-224]
 vpor        ymm1,ymm1,ymm2
 vpcmpeqw    ymm3,ymm0,ymmword ptr [rdx-192]
 vpcmpeqw    ymm4,ymm0,ymmword ptr [rdx-160]
 vpor        ymm3,ymm3,ymm4
 vpor        ymm1,ymm1,ymm3
 vpcmpeqw    ymm2,ymm0,ymmword ptr [rdx-128]
 vpcmpeqw    ymm3,ymm0,ymmword ptr [rdx-96]
 vpor        ymm2,ymm2,ymm3
 vpcmpeqw    ymm4,ymm0,ymmword ptr [rdx-64]
 vpcmpeqw    ymm5,ymm0,ymmword ptr [rdx-32]
 vpor        ymm4,ymm4,ymm5
 vpor        ymm2,ymm2,ymm4
 vpor        ymm1,ymm1,ymm2
 vptest      ymm1,ymm1

FOUND:
 setnz       al
 ret
FastContains16 ENDP

_TEXT$FastContains16 ENDS

END
