; /*******************************************************************
; *
; *    Author: Kareem Omar
; *    kareem.h.omar@gmail.com
; *    https://github.com/komrad36
; *
; *    Last updated Mar 12, 2021
; *******************************************************************/

bits 64section .textalign 64global FastFind8

FastFind8:
 vmovd       xmm0,edx
 vpbroadcastb ymm0,xmm0
 cmp         rsi,256
 jae         CASE_LARGE
 lea         r9,[JUMP_TABLE]
 movzx       eax,word [r9+2*rsi]
 add         r9,rax
 xor         eax,eax
 lea         r10,[rax-1]
 jmp         r9
times 10 db (0CCh)
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
 vpcmpeqb    ymm1,ymm0,yword [rdi]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 add         eax,32
CASE_192:
 vpcmpeqb    ymm1,ymm0,yword [rdi+rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 add         eax,32
CASE_160:
 vpcmpeqb    ymm1,ymm0,yword [rdi+rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 add         eax,32
CASE_128:
 vpcmpeqb    ymm1,ymm0,yword [rdi+rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 add         eax,32
CASE_96:
 vpcmpeqb    ymm1,ymm0,yword [rdi+rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 add         eax,32
CASE_64:
 vpcmpeqb    ymm1,ymm0,yword [rdi+rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 add         eax,32
CASE_32:
 vpcmpeqb    ymm1,ymm0,yword [rdi+rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 lea         eax,[rsi-32]
 vpcmpeqb    ymm1,ymm0,yword [rdi+rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 mov         rax,r10
 ret
CASE_16:
 vpcmpeqb    xmm1,xmm0,oword [rdi]
 vptest      xmm1,xmm1
 jnz         FOUND_SMALL
 lea         eax,[rsi-16]
 vpcmpeqb    xmm1,xmm0,oword [rdi+rax]
 vptest      xmm1,xmm1
 jnz         FOUND_SMALL
 mov         rax,r10
 ret
CASE_8:
 vpbroadcastq xmm1,qword [rdi]
 vpcmpeqb    xmm1,xmm0,xmm1
 vptest      xmm1,xmm1
 jnz         FOUND_SMALL
 lea         eax,[rsi-8]
 vpbroadcastq xmm1,qword [rdi+rax]
 vpcmpeqb    xmm1,xmm0,xmm1
 vptest      xmm1,xmm1
 jnz         FOUND_SMALL
 mov         rax,r10
 ret
CASE_4:
 vpbroadcastd xmm1,dword [rdi]
 vpcmpeqb    xmm1,xmm0,xmm1
 vptest      xmm1,xmm1
 jnz         FOUND_SMALL
 lea         eax,[rsi-4]
 vpbroadcastd xmm1,dword [rdi+rax]
 vpcmpeqb    xmm1,xmm0,xmm1
 vptest      xmm1,xmm1
 jnz         FOUND_SMALL
 mov         rax,r10
 ret
CASE_3:
 cmp         dl,byte [rdi]
 je          FOUND_SMALL_SCALAR
 inc         eax
CASE_2:
 cmp         dl,byte [rdi+rax]
 je          FOUND_SMALL_SCALAR
 inc         eax
CASE_1:
 cmp         dl,byte [rdi+rax]
 je          FOUND_SMALL_SCALAR
CASE_0:
 mov         rax,r10
FOUND_SMALL_SCALAR:
 ret

FOUND_SMALL:
 vpmovmskb   edi,ymm1
 tzcnt       edi,edi
 add         eax,edi
 ret

CASE_LARGE:
 lea         rsi,[rdi+rsi]
 add         rdi,256
 mov         r11,rdi

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

 mov         rdi,rsi

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

 mov         rax,-1
 ret

FOUND:
 vpcmpeqb    ymm1,ymm0,yword [rdi-256]
 vpmovmskb   eax,ymm1
 vpcmpeqb    ymm1,ymm0,yword [rdi-224]
 vpmovmskb   esi,ymm1
 shl         rsi,32
 or          rax,rsi
 vpcmpeqb    ymm1,ymm0,yword [rdi-192]
 vpmovmskb   esi,ymm1
 vpcmpeqb    ymm1,ymm0,yword [rdi-160]
 vpmovmskb   edx,ymm1
 shl         rdx,32
 or          rsi,rdx
 vpcmpeqb    ymm1,ymm0,yword [rdi-128]
 vpmovmskb   edx,ymm1
 vpcmpeqb    ymm1,ymm0,yword [rdi-96]
 vpmovmskb   r9d,ymm1
 shl         r9,32
 or          rdx,r9
 vpcmpeqb    ymm1,ymm0,yword [rdi-64]
 vpmovmskb   r9d,ymm1
 vpcmpeqb    ymm1,ymm0,yword [rdi-32]
 vpmovmskb   r10d,ymm1
 shl         r10,32
 or          r9,r10
 tzcnt       r9,r9
 add         r9b,192
 tzcnt       rdx,rdx
 lea         edx,[rdx+128]
 cmovnc      r9d,edx
 tzcnt       rsi,rsi
 lea         esi,[rsi+64]
 cmovnc      r9d,esi
 tzcnt       rax,rax
 cmovc       eax,r9d
 sub         rdi,r11
 add         rax,rdi
 ret
