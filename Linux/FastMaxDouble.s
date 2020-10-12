; /*******************************************************************
; *
; *    Author: Kareem Omar
; *    kareem.h.omar@gmail.com
; *    https://github.com/komrad36
; *
; *    Last updated Oct 11, 2020
; *******************************************************************/

bits 64
section .text
align 64
global FastMaxDouble

FastMaxDouble:
 mov         eax,esi
 cmp         esi,32
 jae         CASE_LARGE
 vpcmpeqd    ymm0,ymm0,ymm0
db 03Eh
 vpcmpeqd    ymm1,ymm1,ymm1
 lea         r8,[JUMP_TABLE]
 movzx       esi,byte [r8+rax]
 add         r8,rsi
 lea         rsi,[rdi+8*rax]
 and         eax,-4
 lea         rdi,[rdi+8*rax]
 jmp         r8
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
times 31 db (0CCh)
CASE_28:
 vmovupd     ymm0,yword [rdi-224]
CASE_24:
 vmovupd     ymm1,yword [rdi-192]
CASE_20:
 vmaxpd      ymm0,ymm0,yword [rdi-160]
CASE_16:
 vmaxpd      ymm1,ymm1,yword [rdi-128]
CASE_12:
 vmaxpd      ymm0,ymm0,yword [rdi-96]
CASE_8:
 vmaxpd      ymm1,ymm1,yword [rdi-64]
 vmaxpd      ymm0,ymm0,yword [rdi-32]
 vmaxpd      ymm1,ymm1,yword [rsi-32]
 vmaxpd      ymm0,ymm0,ymm1
 vextractf128 xmm1,ymm0,1
 vmaxpd      xmm0,xmm0,xmm1
 vpermilpd   xmm1,xmm0,1
 vmaxsd      xmm0,xmm0,xmm1
 ret
times 8 db (0CCh)
CASE_7:
 vmovsd      xmm0,qword [rsi-56]
CASE_6:
 vmaxsd      xmm0,xmm0,qword [rsi-48]
CASE_5:
 vmaxsd      xmm0,xmm0,qword [rsi-40]
CASE_4:
 vmaxsd      xmm0,xmm0,qword [rsi-32]
CASE_3:
 vmaxsd      xmm0,xmm0,qword [rsi-24]
CASE_2:
 vmaxsd      xmm0,xmm0,qword [rsi-16]
CASE_1:
 vmaxsd      xmm0,xmm0,qword [rsi-8]
CASE_0:
 ret

times 13 db (0CCh)

CASE_LARGE:
 vmovupd     ymm0,yword [rdi]
 vmovupd     ymm1,yword [rdi+32]
 vmovupd     ymm2,yword [rdi+64]
 vmovupd     ymm3,yword [rdi+96]
 vmovupd     ymm4,yword [rdi+128]
 vmovupd     ymm5,yword [rdi+160]
 vmovupd     ymm6,yword [rdi+192]
 vmovupd     ymm7,yword [rdi+224]

 lea         rsi,[rdi+8*rax]
 add         rdi,512
 cmp         rdi,rsi
 jae         LOOP_END

LOOP_TOP:
 vmaxpd      ymm0,ymm0,yword [rdi-256]
 vmaxpd      ymm1,ymm1,yword [rdi-224]
 vmaxpd      ymm2,ymm2,yword [rdi-192]
 vmaxpd      ymm3,ymm3,yword [rdi-160]
 vmaxpd      ymm4,ymm4,yword [rdi-128]
 vmaxpd      ymm5,ymm5,yword [rdi-96]
 vmaxpd      ymm6,ymm6,yword [rdi-64]
 vmaxpd      ymm7,ymm7,yword [rdi-32]
 add         rdi,256
 cmp         rdi,rsi
 jb          LOOP_TOP

LOOP_END:
 vmaxpd      ymm0,ymm0,yword [rsi-256]
 vmaxpd      ymm1,ymm1,yword [rsi-224]
 vmaxpd      ymm2,ymm2,yword [rsi-192]
 vmaxpd      ymm3,ymm3,yword [rsi-160]
 vmaxpd      ymm4,ymm4,yword [rsi-128]
 vmaxpd      ymm5,ymm5,yword [rsi-96]
 vmaxpd      ymm6,ymm6,yword [rsi-64]
 vmaxpd      ymm7,ymm7,yword [rsi-32]

 vmaxpd      ymm2,ymm2,ymm6
 vmaxpd      ymm3,ymm3,ymm7
 vmaxpd      ymm0,ymm0,ymm4
 vmaxpd      ymm1,ymm1,ymm5

 vmaxpd      ymm0,ymm0,ymm2
 vmaxpd      ymm1,ymm1,ymm3

 vmaxpd      ymm0,ymm0,ymm1

 vextractf128 xmm1,ymm0,1
 vmaxpd      xmm0,xmm0,xmm1
 vpermilpd   xmm1,xmm0,1
 vmaxsd      xmm0,xmm0,xmm1
 ret
