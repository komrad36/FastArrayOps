; /*******************************************************************
; *
; *    Author: Kareem Omar
; *    kareem.h.omar@gmail.com
; *    https://github.com/komrad36
; *
; *    Last updated Mar 12, 2021
; *******************************************************************/

_TEXT$FastContainsDouble SEGMENT ALIGN(64)

FastContainsDouble PROC
 vbroadcastsd ymm0,xmm2
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
 xor         al,al
 mov         r10b,1
 jmp         r9
JUMP_TABLE:
db 1 DUP ( CASE_0 - JUMP_TABLE)
db 1 DUP ( CASE_1 - JUMP_TABLE)
db 1 DUP ( CASE_2 - JUMP_TABLE)
db 1 DUP ( CASE_3 - JUMP_TABLE)
db 1 DUP ( CASE_4 - JUMP_TABLE)
db 1 DUP ( CASE_5 - JUMP_TABLE)
db 1 DUP ( CASE_6 - JUMP_TABLE)
db 1 DUP ( CASE_7 - JUMP_TABLE)
db 4 DUP ( CASE_8 - JUMP_TABLE)
db 4 DUP (CASE_12 - JUMP_TABLE)
db 4 DUP (CASE_16 - JUMP_TABLE)
db 4 DUP (CASE_20 - JUMP_TABLE)
db 4 DUP (CASE_24 - JUMP_TABLE)
db 4 DUP (CASE_28 - JUMP_TABLE)
CASE_28:
 vcmpeqpd    ymm1,ymm0,ymmword ptr [rcx-224]
CASE_24:
 vcmpeqpd    ymm2,ymm0,ymmword ptr [rcx-192]
 vpor        ymm1,ymm1,ymm2
CASE_20:
 vcmpeqpd    ymm2,ymm0,ymmword ptr [rcx-160]
 vpor        ymm1,ymm1,ymm2
CASE_16:
 vcmpeqpd    ymm2,ymm0,ymmword ptr [rcx-128]
 vpor        ymm1,ymm1,ymm2
CASE_12:
 vcmpeqpd    ymm2,ymm0,ymmword ptr [rcx-96]
 vpor        ymm1,ymm1,ymm2
CASE_8:
 vcmpeqpd    ymm2,ymm0,ymmword ptr [rcx-64]
 vpor        ymm1,ymm1,ymm2
 vcmpeqpd    ymm2,ymm0,ymmword ptr [rcx-32]
 vpor        ymm1,ymm1,ymm2
 vcmpeqpd    ymm2,ymm0,ymmword ptr [rdx-32]
 vpor        ymm1,ymm1,ymm2
 vptest      ymm1,ymm1
 setnz       al
 ret
CASE_7:
 vucomisd    xmm0,qword ptr [rdx-56]
 sete        al
CASE_6:
 vucomisd    xmm0,qword ptr [rdx-48]
 cmove       eax,r10d
CASE_5:
 vucomisd    xmm0,qword ptr [rdx-40]
 cmove       eax,r10d
CASE_4:
 vucomisd    xmm0,qword ptr [rdx-32]
 cmove       eax,r10d
CASE_3:
 vucomisd    xmm0,qword ptr [rdx-24]
 cmove       eax,r10d
CASE_2:
 vucomisd    xmm0,qword ptr [rdx-16]
 cmove       eax,r10d
CASE_1:
 vucomisd    xmm0,qword ptr [rdx-8]
 cmove       eax,r10d
CASE_0:
 ret

CASE_LARGE:
 lea         rdx,[rcx+8*rdx]
 add         rcx,256

LOOP_TOP:
 vcmpeqpd    ymm1,ymm0,ymmword ptr [rcx-256]
 vcmpeqpd    ymm2,ymm0,ymmword ptr [rcx-224]
 vpor        ymm1,ymm1,ymm2
 vcmpeqpd    ymm3,ymm0,ymmword ptr [rcx-192]
 vcmpeqpd    ymm4,ymm0,ymmword ptr [rcx-160]
 vpor        ymm3,ymm3,ymm4
 vpor        ymm1,ymm1,ymm3
 vcmpeqpd    ymm2,ymm0,ymmword ptr [rcx-128]
 vcmpeqpd    ymm3,ymm0,ymmword ptr [rcx-96]
 vpor        ymm2,ymm2,ymm3
 vcmpeqpd    ymm4,ymm0,ymmword ptr [rcx-64]
 vcmpeqpd    ymm5,ymm0,ymmword ptr [rcx-32]
 vpor        ymm4,ymm4,ymm5
 vpor        ymm2,ymm2,ymm4
 vpor        ymm1,ymm1,ymm2
 vptest      ymm1,ymm1
 jnz         FOUND
 add         rcx,256
 cmp         rcx,rdx
 jb          LOOP_TOP

 vcmpeqpd    ymm1,ymm0,ymmword ptr [rdx-256]
 vcmpeqpd    ymm2,ymm0,ymmword ptr [rdx-224]
 vpor        ymm1,ymm1,ymm2
 vcmpeqpd    ymm3,ymm0,ymmword ptr [rdx-192]
 vcmpeqpd    ymm4,ymm0,ymmword ptr [rdx-160]
 vpor        ymm3,ymm3,ymm4
 vpor        ymm1,ymm1,ymm3
 vcmpeqpd    ymm2,ymm0,ymmword ptr [rdx-128]
 vcmpeqpd    ymm3,ymm0,ymmword ptr [rdx-96]
 vpor        ymm2,ymm2,ymm3
 vcmpeqpd    ymm4,ymm0,ymmword ptr [rdx-64]
 vcmpeqpd    ymm5,ymm0,ymmword ptr [rdx-32]
 vpor        ymm4,ymm4,ymm5
 vpor        ymm2,ymm2,ymm4
 vpor        ymm1,ymm1,ymm2
 vptest      ymm1,ymm1

FOUND:
 setnz       al
 ret
FastContainsDouble ENDP

_TEXT$FastContainsDouble ENDS

END
