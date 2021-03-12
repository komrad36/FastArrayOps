; /*******************************************************************
; *
; *    Author: Kareem Omar
; *    kareem.h.omar@gmail.com
; *    https://github.com/komrad36
; *
; *    Last updated Mar 12, 2021
; *******************************************************************/

bits 64section .textalign 64global FastFind32

FastFind32:
 vmovd       xmm0,edx
 vpbroadcastd ymm0,xmm0
 cmp         rsi,64
 jae         CASE_LARGE
 lea         r9,[JUMP_TABLE]
 movzx       eax,byte [r9+rsi]
 add         r9,rax
 xor         eax,eax
 lea         r10,[rax-1]
 jmp         r9
times 12 db (0CCh)
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
 vpcmpeqd    ymm1,ymm0,yword [rdi]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 add         eax,8
CASE_48:
 vpcmpeqd    ymm1,ymm0,yword [rdi+4*rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 add         eax,8
CASE_40:
 vpcmpeqd    ymm1,ymm0,yword [rdi+4*rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 add         eax,8
CASE_32:
 vpcmpeqd    ymm1,ymm0,yword [rdi+4*rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 add         eax,8
CASE_24:
 vpcmpeqd    ymm1,ymm0,yword [rdi+4*rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 add         eax,8
CASE_16:
 vpcmpeqd    ymm1,ymm0,yword [rdi+4*rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 add         eax,8
CASE_8:
 vpcmpeqd    ymm1,ymm0,yword [rdi+4*rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 lea         eax,[rsi-8]
 vpcmpeqd    ymm1,ymm0,yword [rdi+4*rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 mov         rax,r10
 ret
CASE_4:
 vpcmpeqd    xmm1,xmm0,oword [rdi]
 vptest      xmm1,xmm1
 jnz         FOUND_SMALL
 lea         eax,[rsi-4]
 vpcmpeqd    xmm1,xmm0,oword [rdi+4*rax]
 vptest      xmm1,xmm1
 jnz         FOUND_SMALL
 mov         rax,r10
 ret
CASE_3:
 cmp         edx,dword [rdi]
 je          FOUND_SMALL_SCALAR
 inc         eax
CASE_2:
 cmp         edx,dword [rdi+4*rax]
 je          FOUND_SMALL_SCALAR
 inc         eax
CASE_1:
 cmp         edx,dword [rdi+4*rax]
 je          FOUND_SMALL_SCALAR
CASE_0:
 mov         rax,r10
FOUND_SMALL_SCALAR:
 ret

FOUND_SMALL:
 vmovmskps   edi,ymm1
 tzcnt       edi,edi
 add         eax,edi
 ret

CASE_LARGE:
 lea         rsi,[rdi+4*rsi]
 add         rdi,256
 mov         r10,rdi

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

 mov         rdi,rsi

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

 mov         rax,-1
 ret

FOUND:
 vpcmpeqd    ymm1,ymm0,yword [rdi-256]
 vmovmskps   eax,ymm1
 vpcmpeqd    ymm1,ymm0,yword [rdi-224]
 vmovmskps   esi,ymm1
 shl         esi,8
 or          eax,esi
 vpcmpeqd    ymm1,ymm0,yword [rdi-192]
 vmovmskps   esi,ymm1
 vpcmpeqd    ymm1,ymm0,yword [rdi-160]
 vmovmskps   edx,ymm1
 shl         edx,8
 or          esi,edx
 shl         esi,16
 or          eax,esi
 vpcmpeqd    ymm1,ymm0,yword [rdi-128]
 vmovmskps   esi,ymm1
 vpcmpeqd    ymm1,ymm0,yword [rdi-96]
 vmovmskps   edx,ymm1
 shl         edx,8
 or          esi,edx
 vpcmpeqd    ymm1,ymm0,yword [rdi-64]
 vmovmskps   edx,ymm1
 vpcmpeqd    ymm1,ymm0,yword [rdi-32]
 vmovmskps   r9d,ymm1
 shl         r9d,8
 or          edx,r9d
 shl         edx,16
 or          esi,edx
 shl         rsi,32
 or          rax,rsi
 tzcnt       rax,rax
 sub         rdi,r10
 shr         rdi,2
 add         rax,rdi
 ret
