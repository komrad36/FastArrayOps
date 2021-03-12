; /*******************************************************************
; *
; *    Author: Kareem Omar
; *    kareem.h.omar@gmail.com
; *    https://github.com/komrad36
; *
; *    Last updated Mar 12, 2021
; *******************************************************************/

bits 64section .textalign 64global FastContains16

FastContains16:
 vmovd       xmm0,edx
 vpbroadcastw ymm0,xmm0
 cmp         rsi,127
 ja          CASE_LARGE
 vpxor       xmm1,xmm1,xmm1
 lea         r9,[JUMP_TABLE]
 movzx       eax,word [r9+2*rsi]
 add         r9,rax
 mov         eax,esi
 lea         rsi,[rdi+2*rsi]
 and         al,-16
 lea         rdi,[rdi+2*rax]
 mov         r10b,1
 jmp         r9
times 23 db (0CCh)
JUMP_TABLE:
times  1 dw (  CASE_0 - JUMP_TABLE)
times  1 dw (  CASE_1 - JUMP_TABLE)
times  1 dw (  CASE_2 - JUMP_TABLE)
times  1 dw (  CASE_3 - JUMP_TABLE)
times  4 dw (  CASE_4 - JUMP_TABLE)
times  8 dw (  CASE_8 - JUMP_TABLE)
times 16 dw ( CASE_16 - JUMP_TABLE)
times 16 dw ( CASE_32 - JUMP_TABLE)
times 16 dw ( CASE_48 - JUMP_TABLE)
times 16 dw ( CASE_64 - JUMP_TABLE)
times 16 dw ( CASE_80 - JUMP_TABLE)
times 16 dw ( CASE_96 - JUMP_TABLE)
times 16 dw (CASE_112 - JUMP_TABLE)
CASE_112:
 vpcmpeqw    ymm1,ymm0,yword [rdi-224]
CASE_96:
 vpcmpeqw    ymm2,ymm0,yword [rdi-192]
 vpor        ymm1,ymm1,ymm2
CASE_80:
 vpcmpeqw    ymm2,ymm0,yword [rdi-160]
 vpor        ymm1,ymm1,ymm2
CASE_64:
 vpcmpeqw    ymm2,ymm0,yword [rdi-128]
 vpor        ymm1,ymm1,ymm2
CASE_48:
 vpcmpeqw    ymm2,ymm0,yword [rdi-96]
 vpor        ymm1,ymm1,ymm2
CASE_32:
 vpcmpeqw    ymm2,ymm0,yword [rdi-64]
 vpor        ymm1,ymm1,ymm2
CASE_16:
 vpcmpeqw    ymm2,ymm0,yword [rdi-32]
 vpor        ymm1,ymm1,ymm2
 vpcmpeqw    ymm2,ymm0,yword [rsi-32]
 vpor        ymm1,ymm1,ymm2
 vptest      ymm1,ymm1
 setnz       al
 ret
CASE_8:
 vpcmpeqw    xmm1,xmm0,oword [rdi]
 vpcmpeqw    xmm2,xmm0,oword [rsi-16]
 vpor        xmm1,xmm1,xmm2
 vptest      xmm1,xmm1
 setnz       al
 ret
CASE_4:
 vpbroadcastq xmm1,qword [rdi]
 vpcmpeqw    xmm1,xmm0,xmm1
 vpbroadcastq xmm2,qword [rsi-8]
 vpcmpeqw    xmm2,xmm0,xmm2
 vpor        xmm1,xmm1,xmm2
 vptest      xmm1,xmm1
 setnz       al
 ret
CASE_3:
 cmp         dx,word [rsi-6]
 sete        al
CASE_2:
 cmp         dx,word [rsi-4]
 cmove       eax,r10d
CASE_1:
 cmp         dx,word [rsi-2]
 cmove       eax,r10d
CASE_0:
 ret

CASE_LARGE:
 lea         rsi,[rdi+2*rsi]
 add         rdi,256

LOOP_TOP:
 vpcmpeqw    ymm1,ymm0,yword [rdi-256]
 vpcmpeqw    ymm2,ymm0,yword [rdi-224]
 vpor        ymm1,ymm1,ymm2
 vpcmpeqw    ymm3,ymm0,yword [rdi-192]
 vpcmpeqw    ymm4,ymm0,yword [rdi-160]
 vpor        ymm3,ymm3,ymm4
 vpor        ymm1,ymm1,ymm3
 vpcmpeqw    ymm2,ymm0,yword [rdi-128]
 vpcmpeqw    ymm3,ymm0,yword [rdi-96]
 vpor        ymm2,ymm2,ymm3
 vpcmpeqw    ymm4,ymm0,yword [rdi-64]
 vpcmpeqw    ymm5,ymm0,yword [rdi-32]
 vpor        ymm4,ymm4,ymm5
 vpor        ymm2,ymm2,ymm4
 vpor        ymm1,ymm1,ymm2
 vptest      ymm1,ymm1
 jnz         FOUND
 add         rdi,256
 cmp         rdi,rsi
 jb          LOOP_TOP

 vpcmpeqw    ymm1,ymm0,yword [rsi-256]
 vpcmpeqw    ymm2,ymm0,yword [rsi-224]
 vpor        ymm1,ymm1,ymm2
 vpcmpeqw    ymm3,ymm0,yword [rsi-192]
 vpcmpeqw    ymm4,ymm0,yword [rsi-160]
 vpor        ymm3,ymm3,ymm4
 vpor        ymm1,ymm1,ymm3
 vpcmpeqw    ymm2,ymm0,yword [rsi-128]
 vpcmpeqw    ymm3,ymm0,yword [rsi-96]
 vpor        ymm2,ymm2,ymm3
 vpcmpeqw    ymm4,ymm0,yword [rsi-64]
 vpcmpeqw    ymm5,ymm0,yword [rsi-32]
 vpor        ymm4,ymm4,ymm5
 vpor        ymm2,ymm2,ymm4
 vpor        ymm1,ymm1,ymm2
 vptest      ymm1,ymm1

FOUND:
 setnz       al
 ret
