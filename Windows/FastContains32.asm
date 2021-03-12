; /*******************************************************************
; *
; *    Author: Kareem Omar
; *    kareem.h.omar@gmail.com
; *    https://github.com/komrad36
; *
; *    Last updated Mar 12, 2021
; *******************************************************************/

_TEXT$FastContains32 SEGMENT ALIGN(64)

FastContains32 PROC
 vmovd       xmm0,r8d
 vpbroadcastd ymm0,xmm0
 cmp         rdx,64
 jae         CASE_LARGE
 vpxor       xmm1,xmm1,xmm1
 lea         r9,JUMP_TABLE
 movzx       eax,byte ptr [r9+rdx]
 add         r9,rax
 mov         eax,edx
 lea         rdx,[rcx+4*rdx]
 and         al,-8
 lea         rcx,[rcx+4*rax]
 mov         r10b,1
 jmp         r9
db 21 DUP (0CCh)
JUMP_TABLE:
db 1 DUP ( CASE_0 - JUMP_TABLE)
db 1 DUP ( CASE_1 - JUMP_TABLE)
db 1 DUP ( CASE_2 - JUMP_TABLE)
db 1 DUP ( CASE_3 - JUMP_TABLE)
db 4 DUP ( CASE_4 - JUMP_TABLE)
db 8 DUP ( CASE_8 - JUMP_TABLE)
db 8 DUP (CASE_16 - JUMP_TABLE)
db 8 DUP (CASE_24 - JUMP_TABLE)
db 8 DUP (CASE_32 - JUMP_TABLE)
db 8 DUP (CASE_40 - JUMP_TABLE)
db 8 DUP (CASE_48 - JUMP_TABLE)
db 8 DUP (CASE_56 - JUMP_TABLE)
CASE_56:
 vpcmpeqd    ymm1,ymm0,ymmword ptr [rcx-224]
CASE_48:
 vpcmpeqd    ymm2,ymm0,ymmword ptr [rcx-192]
 vpor        ymm1,ymm1,ymm2
CASE_40:
 vpcmpeqd    ymm2,ymm0,ymmword ptr [rcx-160]
 vpor        ymm1,ymm1,ymm2
CASE_32:
 vpcmpeqd    ymm2,ymm0,ymmword ptr [rcx-128]
 vpor        ymm1,ymm1,ymm2
CASE_24:
 vpcmpeqd    ymm2,ymm0,ymmword ptr [rcx-96]
 vpor        ymm1,ymm1,ymm2
CASE_16:
 vpcmpeqd    ymm2,ymm0,ymmword ptr [rcx-64]
 vpor        ymm1,ymm1,ymm2
CASE_8:
 vpcmpeqd    ymm2,ymm0,ymmword ptr [rcx-32]
 vpor        ymm1,ymm1,ymm2
 vpcmpeqd    ymm2,ymm0,ymmword ptr [rdx-32]
 vpor        ymm1,ymm1,ymm2
 vptest      ymm1,ymm1
 setnz       al
 ret
CASE_4:
 vpcmpeqd    xmm1,xmm0,xmmword ptr [rcx]
 vpcmpeqd    xmm2,xmm0,xmmword ptr [rdx-16]
 vpor        xmm1,xmm1,xmm2
 vptest      xmm1,xmm1
 setnz       al
 ret
CASE_3:
 cmp         r8d,dword ptr [rdx-12]
 sete        al
CASE_2:
 cmp         r8d,dword ptr [rdx-8]
 cmove       eax,r10d
CASE_1:
 cmp         r8d,dword ptr [rdx-4]
 cmove       eax,r10d
CASE_0:
 ret

CASE_LARGE:
 lea         rdx,[rcx+4*rdx]
 add         rcx,256

LOOP_TOP:
 vpcmpeqd    ymm1,ymm0,ymmword ptr [rcx-256]
 vpcmpeqd    ymm2,ymm0,ymmword ptr [rcx-224]
 vpor        ymm1,ymm1,ymm2
 vpcmpeqd    ymm3,ymm0,ymmword ptr [rcx-192]
 vpcmpeqd    ymm4,ymm0,ymmword ptr [rcx-160]
 vpor        ymm3,ymm3,ymm4
 vpor        ymm1,ymm1,ymm3
 vpcmpeqd    ymm2,ymm0,ymmword ptr [rcx-128]
 vpcmpeqd    ymm3,ymm0,ymmword ptr [rcx-96]
 vpor        ymm2,ymm2,ymm3
 vpcmpeqd    ymm4,ymm0,ymmword ptr [rcx-64]
 vpcmpeqd    ymm5,ymm0,ymmword ptr [rcx-32]
 vpor        ymm4,ymm4,ymm5
 vpor        ymm2,ymm2,ymm4
 vpor        ymm1,ymm1,ymm2
 vptest      ymm1,ymm1
 jnz         FOUND
 add         rcx,256
 cmp         rcx,rdx
 jb          LOOP_TOP

 vpcmpeqd    ymm1,ymm0,ymmword ptr [rdx-256]
 vpcmpeqd    ymm2,ymm0,ymmword ptr [rdx-224]
 vpor        ymm1,ymm1,ymm2
 vpcmpeqd    ymm3,ymm0,ymmword ptr [rdx-192]
 vpcmpeqd    ymm4,ymm0,ymmword ptr [rdx-160]
 vpor        ymm3,ymm3,ymm4
 vpor        ymm1,ymm1,ymm3
 vpcmpeqd    ymm2,ymm0,ymmword ptr [rdx-128]
 vpcmpeqd    ymm3,ymm0,ymmword ptr [rdx-96]
 vpor        ymm2,ymm2,ymm3
 vpcmpeqd    ymm4,ymm0,ymmword ptr [rdx-64]
 vpcmpeqd    ymm5,ymm0,ymmword ptr [rdx-32]
 vpor        ymm4,ymm4,ymm5
 vpor        ymm2,ymm2,ymm4
 vpor        ymm1,ymm1,ymm2
 vptest      ymm1,ymm1

FOUND:
 setnz       al
 ret
FastContains32 ENDP

_TEXT$FastContains32 ENDS

END
