; /*******************************************************************
; *
; *    Author: Kareem Omar
; *    kareem.h.omar@gmail.com
; *    https://github.com/komrad36
; *
; *    Last updated Mar 12, 2021
; *******************************************************************/

bits 64section .textalign 64global FastContains8

FastContains8:
 vmovd       xmm0,edx
 vpbroadcastb ymm0,xmm0
 cmp         rsi,256
 jae         CASE_LARGE
 vpxor       xmm1,xmm1,xmm1
 lea         r9,[JUMP_TABLE]
 movzx       eax,word [r9+2*rsi]
 add         r9,rax
 mov         eax,esi
 add         rsi,rdi
 and         al,-32
 add         rdi,rax
 mov         r10b,1
 jmp         r9
times 15 db (0CCh)
JUMP_TABLE:
times  1 dw (  CASE_0 - JUMP_TABLE)
times  1 dw (  CASE_1 - JUMP_TABLE)
times  1 dw (  CASE_2 - JUMP_TABLE)
times  1 dw (  CASE_3 - JUMP_TABLE)
times  4 dw (  CASE_4 - JUMP_TABLE)
times  8 dw (  CASE_8 - JUMP_TABLE)
times 16 dw ( CASE_16 - JUMP_TABLE)
times 32 dw ( CASE_32 - JUMP_TABLE)
times 32 dw ( CASE_64 - JUMP_TABLE)
times 32 dw ( CASE_96 - JUMP_TABLE)
times 32 dw (CASE_128 - JUMP_TABLE)
times 32 dw (CASE_160 - JUMP_TABLE)
times 32 dw (CASE_192 - JUMP_TABLE)
times 32 dw (CASE_224 - JUMP_TABLE)
CASE_224:
 vpcmpeqb    ymm1,ymm0,yword [rdi-224]
CASE_192:
 vpcmpeqb    ymm2,ymm0,yword [rdi-192]
 vpor        ymm1,ymm1,ymm2
CASE_160:
 vpcmpeqb    ymm2,ymm0,yword [rdi-160]
 vpor        ymm1,ymm1,ymm2
CASE_128:
 vpcmpeqb    ymm2,ymm0,yword [rdi-128]
 vpor        ymm1,ymm1,ymm2
CASE_96:
 vpcmpeqb    ymm2,ymm0,yword [rdi-96]
 vpor        ymm1,ymm1,ymm2
CASE_64:
 vpcmpeqb    ymm2,ymm0,yword [rdi-64]
 vpor        ymm1,ymm1,ymm2
CASE_32:
 vpcmpeqb    ymm2,ymm0,yword [rdi-32]
 vpor        ymm1,ymm1,ymm2
 vpcmpeqb    ymm2,ymm0,yword [rsi-32]
 vpor        ymm1,ymm1,ymm2
 vptest      ymm1,ymm1
 setnz       al
 ret
CASE_16:
 vpcmpeqb    xmm1,xmm0,oword [rdi]
 vpcmpeqb    xmm2,xmm0,oword [rsi-16]
 vpor        xmm1,xmm1,xmm2
 vptest      xmm1,xmm1
 setnz       al
 ret
CASE_8:
 vpbroadcastq xmm1,qword [rdi]
 vpcmpeqb    xmm1,xmm0,xmm1
 vpbroadcastq xmm2,qword [rsi-8]
 vpcmpeqb    xmm2,xmm0,xmm2
 vpor        xmm1,xmm1,xmm2
 vptest      xmm1,xmm1
 setnz       al
 ret
CASE_4:
 vpbroadcastd xmm1,dword [rdi]
 vpcmpeqb    xmm1,xmm0,xmm1
 vpbroadcastd xmm2,dword [rsi-4]
 vpcmpeqb    xmm2,xmm0,xmm2
 vpor        xmm1,xmm1,xmm2
 vptest      xmm1,xmm1
 setnz       al
 ret
CASE_3:
 cmp         dl,byte [rsi-3]
 sete        al
CASE_2:
 cmp         dl,byte [rsi-2]
 cmove       eax,r10d
CASE_1:
 cmp         dl,byte [rsi-1]
 cmove       eax,r10d
CASE_0:
 ret

CASE_LARGE:
 add         rsi,rdi
 add         rdi,256

LOOP_TOP:
 vpcmpeqb    ymm1,ymm0,yword [rdi-256]
 vpcmpeqb    ymm2,ymm0,yword [rdi-224]
 vpor        ymm1,ymm1,ymm2
 vpcmpeqb    ymm3,ymm0,yword [rdi-192]
 vpcmpeqb    ymm4,ymm0,yword [rdi-160]
 vpor        ymm3,ymm3,ymm4
 vpor        ymm1,ymm1,ymm3
 vpcmpeqb    ymm2,ymm0,yword [rdi-128]
 vpcmpeqb    ymm3,ymm0,yword [rdi-96]
 vpor        ymm2,ymm2,ymm3
 vpcmpeqb    ymm4,ymm0,yword [rdi-64]
 vpcmpeqb    ymm5,ymm0,yword [rdi-32]
 vpor        ymm4,ymm4,ymm5
 vpor        ymm2,ymm2,ymm4
 vpor        ymm1,ymm1,ymm2
 vptest      ymm1,ymm1
 jnz         FOUND
 add         rdi,256
 cmp         rdi,rsi
 jb          LOOP_TOP

 vpcmpeqb    ymm1,ymm0,yword [rsi-256]
 vpcmpeqb    ymm2,ymm0,yword [rsi-224]
 vpor        ymm1,ymm1,ymm2
 vpcmpeqb    ymm3,ymm0,yword [rsi-192]
 vpcmpeqb    ymm4,ymm0,yword [rsi-160]
 vpor        ymm3,ymm3,ymm4
 vpor        ymm1,ymm1,ymm3
 vpcmpeqb    ymm2,ymm0,yword [rsi-128]
 vpcmpeqb    ymm3,ymm0,yword [rsi-96]
 vpor        ymm2,ymm2,ymm3
 vpcmpeqb    ymm4,ymm0,yword [rsi-64]
 vpcmpeqb    ymm5,ymm0,yword [rsi-32]
 vpor        ymm4,ymm4,ymm5
 vpor        ymm2,ymm2,ymm4
 vpor        ymm1,ymm1,ymm2
 vptest      ymm1,ymm1

FOUND:
 setnz       al
 ret
