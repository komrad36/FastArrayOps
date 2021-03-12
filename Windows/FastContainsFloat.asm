; /*******************************************************************
; *
; *    Author: Kareem Omar
; *    kareem.h.omar@gmail.com
; *    https://github.com/komrad36
; *
; *    Last updated Mar 12, 2021
; *******************************************************************/

_TEXT$FastContainsFloat SEGMENT ALIGN(64)

FastContainsFloat PROC
 vbroadcastss ymm0,xmm2
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
db 15 DUP (0CCh)
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
CASE_56:
 vcmpeqps    ymm1,ymm0,ymmword ptr [rcx-224]
CASE_48:
 vcmpeqps    ymm2,ymm0,ymmword ptr [rcx-192]
 vpor        ymm1,ymm1,ymm2
CASE_40:
 vcmpeqps    ymm2,ymm0,ymmword ptr [rcx-160]
 vpor        ymm1,ymm1,ymm2
CASE_32:
 vcmpeqps    ymm2,ymm0,ymmword ptr [rcx-128]
 vpor        ymm1,ymm1,ymm2
CASE_24:
 vcmpeqps    ymm2,ymm0,ymmword ptr [rcx-96]
 vpor        ymm1,ymm1,ymm2
CASE_16:
 vcmpeqps    ymm2,ymm0,ymmword ptr [rcx-64]
 vpor        ymm1,ymm1,ymm2
CASE_8:
 vcmpeqps    ymm2,ymm0,ymmword ptr [rcx-32]
 vpor        ymm1,ymm1,ymm2
 vcmpeqps    ymm2,ymm0,ymmword ptr [rdx-32]
 vpor        ymm1,ymm1,ymm2
 vptest      ymm1,ymm1
 setnz       al
 ret
CASE_7:
 vucomiss    xmm0,dword ptr [rdx-28]
 sete        al
CASE_6:
 vucomiss    xmm0,dword ptr [rdx-24]
 cmove       eax,r10d
CASE_5:
 vucomiss    xmm0,dword ptr [rdx-20]
 cmove       eax,r10d
CASE_4:
 vucomiss    xmm0,dword ptr [rdx-16]
 cmove       eax,r10d
CASE_3:
 vucomiss    xmm0,dword ptr [rdx-12]
 cmove       eax,r10d
CASE_2:
 vucomiss    xmm0,dword ptr [rdx-8]
 cmove       eax,r10d
CASE_1:
 vucomiss    xmm0,dword ptr [rdx-4]
 cmove       eax,r10d
CASE_0:
 ret

CASE_LARGE:
 lea         rdx,[rcx+4*rdx]
 add         rcx,256

LOOP_TOP:
 vcmpeqps    ymm1,ymm0,ymmword ptr [rcx-256]
 vcmpeqps    ymm2,ymm0,ymmword ptr [rcx-224]
 vpor        ymm1,ymm1,ymm2
 vcmpeqps    ymm3,ymm0,ymmword ptr [rcx-192]
 vcmpeqps    ymm4,ymm0,ymmword ptr [rcx-160]
 vpor        ymm3,ymm3,ymm4
 vpor        ymm1,ymm1,ymm3
 vcmpeqps    ymm2,ymm0,ymmword ptr [rcx-128]
 vcmpeqps    ymm3,ymm0,ymmword ptr [rcx-96]
 vpor        ymm2,ymm2,ymm3
 vcmpeqps    ymm4,ymm0,ymmword ptr [rcx-64]
 vcmpeqps    ymm5,ymm0,ymmword ptr [rcx-32]
 vpor        ymm4,ymm4,ymm5
 vpor        ymm2,ymm2,ymm4
 vpor        ymm1,ymm1,ymm2
 vptest      ymm1,ymm1
 jnz         FOUND
 add         rcx,256
 cmp         rcx,rdx
 jb          LOOP_TOP

 vcmpeqps    ymm1,ymm0,ymmword ptr [rdx-256]
 vcmpeqps    ymm2,ymm0,ymmword ptr [rdx-224]
 vpor        ymm1,ymm1,ymm2
 vcmpeqps    ymm3,ymm0,ymmword ptr [rdx-192]
 vcmpeqps    ymm4,ymm0,ymmword ptr [rdx-160]
 vpor        ymm3,ymm3,ymm4
 vpor        ymm1,ymm1,ymm3
 vcmpeqps    ymm2,ymm0,ymmword ptr [rdx-128]
 vcmpeqps    ymm3,ymm0,ymmword ptr [rdx-96]
 vpor        ymm2,ymm2,ymm3
 vcmpeqps    ymm4,ymm0,ymmword ptr [rdx-64]
 vcmpeqps    ymm5,ymm0,ymmword ptr [rdx-32]
 vpor        ymm4,ymm4,ymm5
 vpor        ymm2,ymm2,ymm4
 vpor        ymm1,ymm1,ymm2
 vptest      ymm1,ymm1

FOUND:
 setnz       al
 ret
FastContainsFloat ENDP

_TEXT$FastContainsFloat ENDS

END
