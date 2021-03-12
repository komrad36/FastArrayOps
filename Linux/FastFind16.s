; /*******************************************************************
; *
; *    Author: Kareem Omar
; *    kareem.h.omar@gmail.com
; *    https://github.com/komrad36
; *
; *    Last updated Mar 12, 2021
; *******************************************************************/

bits 64section .textalign 64global FastFind16

FastFind16:
 vmovd       xmm0,edx
 vpbroadcastw ymm0,xmm0
 cmp         rsi,127
 ja          CASE_LARGE
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
times 16 dw ( CASE_32 - JUMP_TABLE)
times 16 dw ( CASE_48 - JUMP_TABLE)
times 16 dw ( CASE_64 - JUMP_TABLE)
times 16 dw ( CASE_80 - JUMP_TABLE)
times 16 dw ( CASE_96 - JUMP_TABLE)
times 16 dw (CASE_112 - JUMP_TABLE)
CASE_112:
 vpcmpeqw    ymm1,ymm0,yword [rdi]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 add         eax,16
CASE_96:
 vpcmpeqw    ymm1,ymm0,yword [rdi+2*rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 add         eax,16
CASE_80:
 vpcmpeqw    ymm1,ymm0,yword [rdi+2*rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 add         eax,16
CASE_64:
 vpcmpeqw    ymm1,ymm0,yword [rdi+2*rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 add         eax,16
CASE_48:
 vpcmpeqw    ymm1,ymm0,yword [rdi+2*rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 add         eax,16
CASE_32:
 vpcmpeqw    ymm1,ymm0,yword [rdi+2*rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 add         eax,16
CASE_16:
 vpcmpeqw    ymm1,ymm0,yword [rdi+2*rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 lea         eax,[rsi-16]
 vpcmpeqw    ymm1,ymm0,yword [rdi+2*rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 mov         rax,r10
 ret
CASE_8:
 vpcmpeqw    xmm1,xmm0,oword [rdi]
 vptest      xmm1,xmm1
 jnz         FOUND_SMALL
 lea         eax,[rsi-8]
 vpcmpeqw    xmm1,xmm0,oword [rdi+2*rax]
 vptest      xmm1,xmm1
 jnz         FOUND_SMALL
 mov         rax,r10
 ret
CASE_4:
 vpbroadcastq xmm1,qword [rdi]
 vpcmpeqw    xmm1,xmm0,xmm1
 vptest      xmm1,xmm1
 jnz         FOUND_SMALL
 lea         eax,[rsi-4]
 vpbroadcastq xmm1,qword [rdi+2*rax]
 vpcmpeqw    xmm1,xmm0,xmm1
 vptest      xmm1,xmm1
 jnz         FOUND_SMALL
 mov         rax,r10
 ret
CASE_3:
 cmp         dx,word [rdi]
 je          FOUND_SMALL_SCALAR
 inc         eax
CASE_2:
 cmp         dx,word [rdi+2*rax]
 je          FOUND_SMALL_SCALAR
 inc         eax
CASE_1:
 cmp         dx,word [rdi+2*rax]
 je          FOUND_SMALL_SCALAR
CASE_0:
 mov         rax,r10
FOUND_SMALL_SCALAR:
 ret

FOUND_SMALL:
 vpmovmskb   edi,ymm1
 tzcnt       edi,edi
 shr         edi,1
 add         eax,edi
 ret

CASE_LARGE:
 lea         rsi,[rdi+2*rsi]
 add         rdi,256
 mov         r11,rdi

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

 mov         rdi,rsi

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

 mov         rax,-1
 ret

FOUND:
 vpcmpeqw    ymm1,ymm0,yword [rdi-256]
 vpmovmskb   eax,ymm1
 vpcmpeqw    ymm1,ymm0,yword [rdi-224]
 vpmovmskb   esi,ymm1
 shl         rsi,32
 or          rax,rsi
 vpcmpeqw    ymm1,ymm0,yword [rdi-192]
 vpmovmskb   esi,ymm1
 vpcmpeqw    ymm1,ymm0,yword [rdi-160]
 vpmovmskb   edx,ymm1
 shl         rdx,32
 or          rsi,rdx
 vpcmpeqw    ymm1,ymm0,yword [rdi-128]
 vpmovmskb   edx,ymm1
 vpcmpeqw    ymm1,ymm0,yword [rdi-96]
 vpmovmskb   r9d,ymm1
 shl         r9,32
 or          rdx,r9
 vpcmpeqw    ymm1,ymm0,yword [rdi-64]
 vpmovmskb   r9d,ymm1
 vpcmpeqw    ymm1,ymm0,yword [rdi-32]
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
 shr         rax,1
 ret
