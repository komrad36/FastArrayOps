; /*******************************************************************
; *
; *    Author: Kareem Omar
; *    kareem.h.omar@gmail.com
; *    https://github.com/komrad36
; *
; *    Last updated Mar 12, 2021
; *******************************************************************/

_TEXT$FastContains64 SEGMENT ALIGN(64)

FastContains64 PROC
 vmovq       xmm0,r8
 vpbroadcastq ymm0,xmm0
 cmp         rdx,32
 jae         CASE_LARGE
 vpxor       xmm1,xmm1,xmm1
 lea         r9,JUMP_TABLE
 movzx       eax,byte ptr [r9+rdx]
 add         r9,rax
 mov         eax,edx
 lea         rdx,[rcx+8*rdx]
 and         al,-4
 lea         rcx,[rcx+8*rax]
 mov         r10b,1
 jmp         r9
db 15 DUP (0CCh)
JUMP_TABLE:
db 1 DUP ( CASE_0 - JUMP_TABLE)
db 1 DUP ( CASE_1 - JUMP_TABLE)
db 1 DUP ( CASE_2 - JUMP_TABLE)
db 1 DUP ( CASE_3 - JUMP_TABLE)
db 4 DUP ( CASE_4 - JUMP_TABLE)
db 4 DUP ( CASE_8 - JUMP_TABLE)
db 4 DUP (CASE_12 - JUMP_TABLE)
db 4 DUP (CASE_16 - JUMP_TABLE)
db 4 DUP (CASE_20 - JUMP_TABLE)
db 4 DUP (CASE_24 - JUMP_TABLE)
db 4 DUP (CASE_28 - JUMP_TABLE)
CASE_28:
 vpcmpeqq    ymm1,ymm0,ymmword ptr [rcx-224]
CASE_24:
 vpcmpeqq    ymm2,ymm0,ymmword ptr [rcx-192]
 vpor        ymm1,ymm1,ymm2
CASE_20:
 vpcmpeqq    ymm2,ymm0,ymmword ptr [rcx-160]
 vpor        ymm1,ymm1,ymm2
CASE_16:
 vpcmpeqq    ymm2,ymm0,ymmword ptr [rcx-128]
 vpor        ymm1,ymm1,ymm2
CASE_12:
 vpcmpeqq    ymm2,ymm0,ymmword ptr [rcx-96]
 vpor        ymm1,ymm1,ymm2
CASE_8:
 vpcmpeqq    ymm2,ymm0,ymmword ptr [rcx-64]
 vpor        ymm1,ymm1,ymm2
CASE_4:
 vpcmpeqq    ymm2,ymm0,ymmword ptr [rcx-32]
 vpor        ymm1,ymm1,ymm2
 vpcmpeqq    ymm2,ymm0,ymmword ptr [rdx-32]
 vpor        ymm1,ymm1,ymm2
 vptest      ymm1,ymm1
 setnz       al
 ret
CASE_3:
 cmp         r8,qword ptr [rdx-24]
 sete        al
CASE_2:
 cmp         r8,qword ptr [rdx-16]
 cmove       eax,r10d
CASE_1:
 cmp         r8,qword ptr [rdx-8]
 cmove       eax,r10d
CASE_0:
 ret

CASE_LARGE:
 lea         rdx,[rcx+8*rdx]
 add         rcx,256

LOOP_TOP:
 vpcmpeqq    ymm1,ymm0,ymmword ptr [rcx-256]
 vpcmpeqq    ymm2,ymm0,ymmword ptr [rcx-224]
 vpor        ymm1,ymm1,ymm2
 vpcmpeqq    ymm3,ymm0,ymmword ptr [rcx-192]
 vpcmpeqq    ymm4,ymm0,ymmword ptr [rcx-160]
 vpor        ymm3,ymm3,ymm4
 vpor        ymm1,ymm1,ymm3
 vpcmpeqq    ymm2,ymm0,ymmword ptr [rcx-128]
 vpcmpeqq    ymm3,ymm0,ymmword ptr [rcx-96]
 vpor        ymm2,ymm2,ymm3
 vpcmpeqq    ymm4,ymm0,ymmword ptr [rcx-64]
 vpcmpeqq    ymm5,ymm0,ymmword ptr [rcx-32]
 vpor        ymm4,ymm4,ymm5
 vpor        ymm2,ymm2,ymm4
 vpor        ymm1,ymm1,ymm2
 vptest      ymm1,ymm1
 jnz         FOUND
 add         rcx,256
 cmp         rcx,rdx
 jb          LOOP_TOP

 vpcmpeqq    ymm1,ymm0,ymmword ptr [rdx-256]
 vpcmpeqq    ymm2,ymm0,ymmword ptr [rdx-224]
 vpor        ymm1,ymm1,ymm2
 vpcmpeqq    ymm3,ymm0,ymmword ptr [rdx-192]
 vpcmpeqq    ymm4,ymm0,ymmword ptr [rdx-160]
 vpor        ymm3,ymm3,ymm4
 vpor        ymm1,ymm1,ymm3
 vpcmpeqq    ymm2,ymm0,ymmword ptr [rdx-128]
 vpcmpeqq    ymm3,ymm0,ymmword ptr [rdx-96]
 vpor        ymm2,ymm2,ymm3
 vpcmpeqq    ymm4,ymm0,ymmword ptr [rdx-64]
 vpcmpeqq    ymm5,ymm0,ymmword ptr [rdx-32]
 vpor        ymm4,ymm4,ymm5
 vpor        ymm2,ymm2,ymm4
 vpor        ymm1,ymm1,ymm2
 vptest      ymm1,ymm1

FOUND:
 setnz       al
 ret
FastContains64 ENDP

_TEXT$FastContains64 ENDS

END
