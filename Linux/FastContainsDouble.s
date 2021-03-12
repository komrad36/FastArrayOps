; /*******************************************************************
; *
; *    Author: Kareem Omar
; *    kareem.h.omar@gmail.com
; *    https://github.com/komrad36
; *
; *    Last updated Mar 12, 2021
; *******************************************************************/

bits 64section .textalign 64global FastContainsDouble

FastContainsDouble:
 vbroadcastsd ymm0,xmm0
 cmp         rsi,32
 jae         CASE_LARGE
 vpxor       xmm1,xmm1,xmm1
 lea         r9,[JUMP_TABLE]
 movzx       eax,byte [r9+rsi]
 add         r9,rax
 mov         eax,esi
 lea         rsi,[rdi+8*rsi]
 and         al,-4
 lea         rdi,[rdi+8*rax]
 xor         al,al
 mov         r10b,1
 jmp         r9
times 13 db (0CCh)
JUMP_TABLE:
times 1 db ( CASE_0 - JUMP_TABLE)
times 1 db ( CASE_1 - JUMP_TABLE)
times 1 db ( CASE_2 - JUMP_TABLE)
times 1 db ( CASE_3 - JUMP_TABLE)
times 1 db ( CASE_4 - JUMP_TABLE)
times 1 db ( CASE_5 - JUMP_TABLE)
times 1 db ( CASE_6 - JUMP_TABLE)
times 1 db ( CASE_7 - JUMP_TABLE)
times 4 db ( CASE_8 - JUMP_TABLE)
times 4 db (CASE_12 - JUMP_TABLE)
times 4 db (CASE_16 - JUMP_TABLE)
times 4 db (CASE_20 - JUMP_TABLE)
times 4 db (CASE_24 - JUMP_TABLE)
times 4 db (CASE_28 - JUMP_TABLE)
CASE_28:
 vcmpeqpd    ymm1,ymm0,yword [rdi-224]
CASE_24:
 vcmpeqpd    ymm2,ymm0,yword [rdi-192]
 vpor        ymm1,ymm1,ymm2
CASE_20:
 vcmpeqpd    ymm2,ymm0,yword [rdi-160]
 vpor        ymm1,ymm1,ymm2
CASE_16:
 vcmpeqpd    ymm2,ymm0,yword [rdi-128]
 vpor        ymm1,ymm1,ymm2
CASE_12:
 vcmpeqpd    ymm2,ymm0,yword [rdi-96]
 vpor        ymm1,ymm1,ymm2
CASE_8:
 vcmpeqpd    ymm2,ymm0,yword [rdi-64]
 vpor        ymm1,ymm1,ymm2
 vcmpeqpd    ymm2,ymm0,yword [rdi-32]
 vpor        ymm1,ymm1,ymm2
 vcmpeqpd    ymm2,ymm0,yword [rsi-32]
 vpor        ymm1,ymm1,ymm2
 vptest      ymm1,ymm1
 setnz       al
 ret
CASE_7:
 vucomisd    xmm0,qword [rsi-56]
 sete        al
CASE_6:
 vucomisd    xmm0,qword [rsi-48]
 cmove       eax,r10d
CASE_5:
 vucomisd    xmm0,qword [rsi-40]
 cmove       eax,r10d
CASE_4:
 vucomisd    xmm0,qword [rsi-32]
 cmove       eax,r10d
CASE_3:
 vucomisd    xmm0,qword [rsi-24]
 cmove       eax,r10d
CASE_2:
 vucomisd    xmm0,qword [rsi-16]
 cmove       eax,r10d
CASE_1:
 vucomisd    xmm0,qword [rsi-8]
 cmove       eax,r10d
CASE_0:
 ret

CASE_LARGE:
 lea         rsi,[rdi+8*rsi]
 add         rdi,256

LOOP_TOP:
 vcmpeqpd    ymm1,ymm0,yword [rdi-256]
 vcmpeqpd    ymm2,ymm0,yword [rdi-224]
 vpor        ymm1,ymm1,ymm2
 vcmpeqpd    ymm3,ymm0,yword [rdi-192]
 vcmpeqpd    ymm4,ymm0,yword [rdi-160]
 vpor        ymm3,ymm3,ymm4
 vpor        ymm1,ymm1,ymm3
 vcmpeqpd    ymm2,ymm0,yword [rdi-128]
 vcmpeqpd    ymm3,ymm0,yword [rdi-96]
 vpor        ymm2,ymm2,ymm3
 vcmpeqpd    ymm4,ymm0,yword [rdi-64]
 vcmpeqpd    ymm5,ymm0,yword [rdi-32]
 vpor        ymm4,ymm4,ymm5
 vpor        ymm2,ymm2,ymm4
 vpor        ymm1,ymm1,ymm2
 vptest      ymm1,ymm1
 jnz         FOUND
 add         rdi,256
 cmp         rdi,rsi
 jb          LOOP_TOP

 vcmpeqpd    ymm1,ymm0,yword [rsi-256]
 vcmpeqpd    ymm2,ymm0,yword [rsi-224]
 vpor        ymm1,ymm1,ymm2
 vcmpeqpd    ymm3,ymm0,yword [rsi-192]
 vcmpeqpd    ymm4,ymm0,yword [rsi-160]
 vpor        ymm3,ymm3,ymm4
 vpor        ymm1,ymm1,ymm3
 vcmpeqpd    ymm2,ymm0,yword [rsi-128]
 vcmpeqpd    ymm3,ymm0,yword [rsi-96]
 vpor        ymm2,ymm2,ymm3
 vcmpeqpd    ymm4,ymm0,yword [rsi-64]
 vcmpeqpd    ymm5,ymm0,yword [rsi-32]
 vpor        ymm4,ymm4,ymm5
 vpor        ymm2,ymm2,ymm4
 vpor        ymm1,ymm1,ymm2
 vptest      ymm1,ymm1

FOUND:
 setnz       al
 ret
