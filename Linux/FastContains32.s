; /*******************************************************************
; *
; *    Author: Kareem Omar
; *    kareem.h.omar@gmail.com
; *    https://github.com/komrad36
; *
; *    Last updated Mar 12, 2021
; *******************************************************************/

bits 64section .textalign 64global FastContains32

FastContains32:
 vmovd       xmm0,edx
 vpbroadcastd ymm0,xmm0
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
times 4 db (0CCh)
JUMP_TABLE:
times 1 db ( CASE_0 - JUMP_TABLE)
times 1 db ( CASE_1 - JUMP_TABLE)
times 1 db ( CASE_2 - JUMP_TABLE)
times 1 db ( CASE_3 - JUMP_TABLE)
times 4 db ( CASE_4 - JUMP_TABLE)
times 8 db ( CASE_8 - JUMP_TABLE)
times 8 db (CASE_16 - JUMP_TABLE)
times 8 db (CASE_24 - JUMP_TABLE)
times 8 db (CASE_32 - JUMP_TABLE)
times 8 db (CASE_40 - JUMP_TABLE)
times 8 db (CASE_48 - JUMP_TABLE)
times 8 db (CASE_56 - JUMP_TABLE)
CASE_56:
 vpcmpeqd    ymm1,ymm0,yword [rdi-224]
CASE_48:
 vpcmpeqd    ymm2,ymm0,yword [rdi-192]
 vpor        ymm1,ymm1,ymm2
CASE_40:
 vpcmpeqd    ymm2,ymm0,yword [rdi-160]
 vpor        ymm1,ymm1,ymm2
CASE_32:
 vpcmpeqd    ymm2,ymm0,yword [rdi-128]
 vpor        ymm1,ymm1,ymm2
CASE_24:
 vpcmpeqd    ymm2,ymm0,yword [rdi-96]
 vpor        ymm1,ymm1,ymm2
CASE_16:
 vpcmpeqd    ymm2,ymm0,yword [rdi-64]
 vpor        ymm1,ymm1,ymm2
CASE_8:
 vpcmpeqd    ymm2,ymm0,yword [rdi-32]
 vpor        ymm1,ymm1,ymm2
 vpcmpeqd    ymm2,ymm0,yword [rsi-32]
 vpor        ymm1,ymm1,ymm2
 vptest      ymm1,ymm1
 setnz       al
 ret
CASE_4:
 vpcmpeqd    xmm1,xmm0,oword [rdi]
 vpcmpeqd    xmm2,xmm0,oword [rsi-16]
 vpor        xmm1,xmm1,xmm2
 vptest      xmm1,xmm1
 setnz       al
 ret
CASE_3:
 cmp         edx,dword [rsi-12]
 sete        al
CASE_2:
 cmp         edx,dword [rsi-8]
 cmove       eax,r10d
CASE_1:
 cmp         edx,dword [rsi-4]
 cmove       eax,r10d
CASE_0:
 ret

CASE_LARGE:
 lea         rsi,[rdi+4*rsi]
 add         rdi,256

LOOP_TOP:
 vpcmpeqd    ymm1,ymm0,yword [rdi-256]
 vpcmpeqd    ymm2,ymm0,yword [rdi-224]
 vpor        ymm1,ymm1,ymm2
 vpcmpeqd    ymm3,ymm0,yword [rdi-192]
 vpcmpeqd    ymm4,ymm0,yword [rdi-160]
 vpor        ymm3,ymm3,ymm4
 vpor        ymm1,ymm1,ymm3
 vpcmpeqd    ymm2,ymm0,yword [rdi-128]
 vpcmpeqd    ymm3,ymm0,yword [rdi-96]
 vpor        ymm2,ymm2,ymm3
 vpcmpeqd    ymm4,ymm0,yword [rdi-64]
 vpcmpeqd    ymm5,ymm0,yword [rdi-32]
 vpor        ymm4,ymm4,ymm5
 vpor        ymm2,ymm2,ymm4
 vpor        ymm1,ymm1,ymm2
 vptest      ymm1,ymm1
 jnz         FOUND
 add         rdi,256
 cmp         rdi,rsi
 jb          LOOP_TOP

 vpcmpeqd    ymm1,ymm0,yword [rsi-256]
 vpcmpeqd    ymm2,ymm0,yword [rsi-224]
 vpor        ymm1,ymm1,ymm2
 vpcmpeqd    ymm3,ymm0,yword [rsi-192]
 vpcmpeqd    ymm4,ymm0,yword [rsi-160]
 vpor        ymm3,ymm3,ymm4
 vpor        ymm1,ymm1,ymm3
 vpcmpeqd    ymm2,ymm0,yword [rsi-128]
 vpcmpeqd    ymm3,ymm0,yword [rsi-96]
 vpor        ymm2,ymm2,ymm3
 vpcmpeqd    ymm4,ymm0,yword [rsi-64]
 vpcmpeqd    ymm5,ymm0,yword [rsi-32]
 vpor        ymm4,ymm4,ymm5
 vpor        ymm2,ymm2,ymm4
 vpor        ymm1,ymm1,ymm2
 vptest      ymm1,ymm1

FOUND:
 setnz       al
 ret
