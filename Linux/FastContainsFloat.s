; /*******************************************************************
; *
; *    Author: Kareem Omar
; *    kareem.h.omar@gmail.com
; *    https://github.com/komrad36
; *
; *    Last updated Mar 12, 2021
; *******************************************************************/

bits 64section .textalign 64global FastContainsFloat

FastContainsFloat:
 vbroadcastss ymm0,xmm0
 cmp         rsi,64
 jae         CASE_LARGE
 vpxor       xmm1,xmm1,xmm1
 lea         r9,[JUMP_TABLE]
 movzx       eax,byte [r9+rsi]
 add         r9,rax
 mov         eax,esi
 lea         rsi,[rdi+4*rsi]
 and         al,-8
 lea         rdi,[rdi+4*rax]
 mov         r10b,1
 jmp         r9
times 23 db (0CCh)
JUMP_TABLE:
times 1 db ( CASE_0 - JUMP_TABLE)
times 1 db ( CASE_1 - JUMP_TABLE)
times 1 db ( CASE_2 - JUMP_TABLE)
times 1 db ( CASE_3 - JUMP_TABLE)
times 1 db ( CASE_4 - JUMP_TABLE)
times 1 db ( CASE_5 - JUMP_TABLE)
times 1 db ( CASE_6 - JUMP_TABLE)
times 1 db ( CASE_7 - JUMP_TABLE)
times 8 db ( CASE_8 - JUMP_TABLE)
times 8 db (CASE_16 - JUMP_TABLE)
times 8 db (CASE_24 - JUMP_TABLE)
times 8 db (CASE_32 - JUMP_TABLE)
times 8 db (CASE_40 - JUMP_TABLE)
times 8 db (CASE_48 - JUMP_TABLE)
times 8 db (CASE_56 - JUMP_TABLE)
CASE_56:
 vcmpeqps    ymm1,ymm0,yword [rdi-224]
CASE_48:
 vcmpeqps    ymm2,ymm0,yword [rdi-192]
 vpor        ymm1,ymm1,ymm2
CASE_40:
 vcmpeqps    ymm2,ymm0,yword [rdi-160]
 vpor        ymm1,ymm1,ymm2
CASE_32:
 vcmpeqps    ymm2,ymm0,yword [rdi-128]
 vpor        ymm1,ymm1,ymm2
CASE_24:
 vcmpeqps    ymm2,ymm0,yword [rdi-96]
 vpor        ymm1,ymm1,ymm2
CASE_16:
 vcmpeqps    ymm2,ymm0,yword [rdi-64]
 vpor        ymm1,ymm1,ymm2
CASE_8:
 vcmpeqps    ymm2,ymm0,yword [rdi-32]
 vpor        ymm1,ymm1,ymm2
 vcmpeqps    ymm2,ymm0,yword [rsi-32]
 vpor        ymm1,ymm1,ymm2
 vptest      ymm1,ymm1
 setnz       al
 ret
CASE_7:
 vucomiss    xmm0,dword [rsi-28]
 sete        al
CASE_6:
 vucomiss    xmm0,dword [rsi-24]
 cmove       eax,r10d
CASE_5:
 vucomiss    xmm0,dword [rsi-20]
 cmove       eax,r10d
CASE_4:
 vucomiss    xmm0,dword [rsi-16]
 cmove       eax,r10d
CASE_3:
 vucomiss    xmm0,dword [rsi-12]
 cmove       eax,r10d
CASE_2:
 vucomiss    xmm0,dword [rsi-8]
 cmove       eax,r10d
CASE_1:
 vucomiss    xmm0,dword [rsi-4]
 cmove       eax,r10d
CASE_0:
 ret

CASE_LARGE:
 lea         rsi,[rdi+4*rsi]
 add         rdi,256

LOOP_TOP:
 vcmpeqps    ymm1,ymm0,yword [rdi-256]
 vcmpeqps    ymm2,ymm0,yword [rdi-224]
 vpor        ymm1,ymm1,ymm2
 vcmpeqps    ymm3,ymm0,yword [rdi-192]
 vcmpeqps    ymm4,ymm0,yword [rdi-160]
 vpor        ymm3,ymm3,ymm4
 vpor        ymm1,ymm1,ymm3
 vcmpeqps    ymm2,ymm0,yword [rdi-128]
 vcmpeqps    ymm3,ymm0,yword [rdi-96]
 vpor        ymm2,ymm2,ymm3
 vcmpeqps    ymm4,ymm0,yword [rdi-64]
 vcmpeqps    ymm5,ymm0,yword [rdi-32]
 vpor        ymm4,ymm4,ymm5
 vpor        ymm2,ymm2,ymm4
 vpor        ymm1,ymm1,ymm2
 vptest      ymm1,ymm1
 jnz         FOUND
 add         rdi,256
 cmp         rdi,rsi
 jb          LOOP_TOP

 vcmpeqps    ymm1,ymm0,yword [rsi-256]
 vcmpeqps    ymm2,ymm0,yword [rsi-224]
 vpor        ymm1,ymm1,ymm2
 vcmpeqps    ymm3,ymm0,yword [rsi-192]
 vcmpeqps    ymm4,ymm0,yword [rsi-160]
 vpor        ymm3,ymm3,ymm4
 vpor        ymm1,ymm1,ymm3
 vcmpeqps    ymm2,ymm0,yword [rsi-128]
 vcmpeqps    ymm3,ymm0,yword [rsi-96]
 vpor        ymm2,ymm2,ymm3
 vcmpeqps    ymm4,ymm0,yword [rsi-64]
 vcmpeqps    ymm5,ymm0,yword [rsi-32]
 vpor        ymm4,ymm4,ymm5
 vpor        ymm2,ymm2,ymm4
 vpor        ymm1,ymm1,ymm2
 vptest      ymm1,ymm1

FOUND:
 setnz       al
 ret
