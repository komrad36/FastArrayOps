; /*******************************************************************
; *
; *    Author: Kareem Omar
; *    kareem.h.omar@gmail.com
; *    https://github.com/komrad36
; *
; *    Last updated Mar 12, 2021
; *******************************************************************/

_TEXT$FastContains8 SEGMENT ALIGN(64)

FastContains8 PROC
 vmovd       xmm0,r8d
 vpbroadcastb ymm0,xmm0
 cmp         rdx,256
 jae         CASE_LARGE
 vpxor       xmm1,xmm1,xmm1
 lea         r9,JUMP_TABLE
 movzx       eax,word ptr [r9+2*rdx]
 add         r9,rax
 mov         eax,edx
 add         rdx,rcx
 and         al,-32
 add         rcx,rax
 mov         r10b,1
 jmp         r9
db 26 DUP (0CCh)
JUMP_TABLE:
dw  1 DUP (  CASE_0 - JUMP_TABLE)
dw  1 DUP (  CASE_1 - JUMP_TABLE)
dw  1 DUP (  CASE_2 - JUMP_TABLE)
dw  1 DUP (  CASE_3 - JUMP_TABLE)
dw  4 DUP (  CASE_4 - JUMP_TABLE)
dw  8 DUP (  CASE_8 - JUMP_TABLE)
dw 16 DUP ( CASE_16 - JUMP_TABLE)
dw 32 DUP ( CASE_32 - JUMP_TABLE)
dw 32 DUP ( CASE_64 - JUMP_TABLE)
dw 32 DUP ( CASE_96 - JUMP_TABLE)
dw 32 DUP (CASE_128 - JUMP_TABLE)
dw 32 DUP (CASE_160 - JUMP_TABLE)
dw 32 DUP (CASE_192 - JUMP_TABLE)
dw 32 DUP (CASE_224 - JUMP_TABLE)
CASE_224:
 vpcmpeqb    ymm1,ymm0,ymmword ptr [rcx-224]
CASE_192:
 vpcmpeqb    ymm2,ymm0,ymmword ptr [rcx-192]
 vpor        ymm1,ymm1,ymm2
CASE_160:
 vpcmpeqb    ymm2,ymm0,ymmword ptr [rcx-160]
 vpor        ymm1,ymm1,ymm2
CASE_128:
 vpcmpeqb    ymm2,ymm0,ymmword ptr [rcx-128]
 vpor        ymm1,ymm1,ymm2
CASE_96:
 vpcmpeqb    ymm2,ymm0,ymmword ptr [rcx-96]
 vpor        ymm1,ymm1,ymm2
CASE_64:
 vpcmpeqb    ymm2,ymm0,ymmword ptr [rcx-64]
 vpor        ymm1,ymm1,ymm2
CASE_32:
 vpcmpeqb    ymm2,ymm0,ymmword ptr [rcx-32]
 vpor        ymm1,ymm1,ymm2
 vpcmpeqb    ymm2,ymm0,ymmword ptr [rdx-32]
 vpor        ymm1,ymm1,ymm2
 vptest      ymm1,ymm1
 setnz       al
 ret
CASE_16:
 vpcmpeqb    xmm1,xmm0,xmmword ptr [rcx]
 vpcmpeqb    xmm2,xmm0,xmmword ptr [rdx-16]
 vpor        xmm1,xmm1,xmm2
 vptest      xmm1,xmm1
 setnz       al
 ret
CASE_8:
 vpbroadcastq xmm1,qword ptr [rcx]
 vpcmpeqb    xmm1,xmm0,xmm1
 vpbroadcastq xmm2,qword ptr [rdx-8]
 vpcmpeqb    xmm2,xmm0,xmm2
 vpor        xmm1,xmm1,xmm2
 vptest      xmm1,xmm1
 setnz       al
 ret
CASE_4:
 vpbroadcastd xmm1,dword ptr [rcx]
 vpcmpeqb    xmm1,xmm0,xmm1
 vpbroadcastd xmm2,dword ptr [rdx-4]
 vpcmpeqb    xmm2,xmm0,xmm2
 vpor        xmm1,xmm1,xmm2
 vptest      xmm1,xmm1
 setnz       al
 ret
CASE_3:
 cmp         r8b,byte ptr [rdx-3]
 sete        al
CASE_2:
 cmp         r8b,byte ptr [rdx-2]
 cmove       eax,r10d
CASE_1:
 cmp         r8b,byte ptr [rdx-1]
 cmove       eax,r10d
CASE_0:
 ret

CASE_LARGE:
 add         rdx,rcx
 add         rcx,256

LOOP_TOP:
 vpcmpeqb    ymm1,ymm0,ymmword ptr [rcx-256]
 vpcmpeqb    ymm2,ymm0,ymmword ptr [rcx-224]
 vpor        ymm1,ymm1,ymm2
 vpcmpeqb    ymm3,ymm0,ymmword ptr [rcx-192]
 vpcmpeqb    ymm4,ymm0,ymmword ptr [rcx-160]
 vpor        ymm3,ymm3,ymm4
 vpor        ymm1,ymm1,ymm3
 vpcmpeqb    ymm2,ymm0,ymmword ptr [rcx-128]
 vpcmpeqb    ymm3,ymm0,ymmword ptr [rcx-96]
 vpor        ymm2,ymm2,ymm3
 vpcmpeqb    ymm4,ymm0,ymmword ptr [rcx-64]
 vpcmpeqb    ymm5,ymm0,ymmword ptr [rcx-32]
 vpor        ymm4,ymm4,ymm5
 vpor        ymm2,ymm2,ymm4
 vpor        ymm1,ymm1,ymm2
 vptest      ymm1,ymm1
 jnz         FOUND
 add         rcx,256
 cmp         rcx,rdx
 jb          LOOP_TOP

 vpcmpeqb    ymm1,ymm0,ymmword ptr [rdx-256]
 vpcmpeqb    ymm2,ymm0,ymmword ptr [rdx-224]
 vpor        ymm1,ymm1,ymm2
 vpcmpeqb    ymm3,ymm0,ymmword ptr [rdx-192]
 vpcmpeqb    ymm4,ymm0,ymmword ptr [rdx-160]
 vpor        ymm3,ymm3,ymm4
 vpor        ymm1,ymm1,ymm3
 vpcmpeqb    ymm2,ymm0,ymmword ptr [rdx-128]
 vpcmpeqb    ymm3,ymm0,ymmword ptr [rdx-96]
 vpor        ymm2,ymm2,ymm3
 vpcmpeqb    ymm4,ymm0,ymmword ptr [rdx-64]
 vpcmpeqb    ymm5,ymm0,ymmword ptr [rdx-32]
 vpor        ymm4,ymm4,ymm5
 vpor        ymm2,ymm2,ymm4
 vpor        ymm1,ymm1,ymm2
 vptest      ymm1,ymm1

FOUND:
 setnz       al
 ret
FastContains8 ENDP

_TEXT$FastContains8 ENDS

END
