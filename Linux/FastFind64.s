; /*******************************************************************
; *
; *    Author: Kareem Omar
; *    kareem.h.omar@gmail.com
; *    https://github.com/komrad36
; *
; *    Last updated Mar 12, 2021
; *******************************************************************/

bits 64section .textalign 64global FastFind64

FastFind64:
 vmovq       xmm0,rdx
 vpbroadcastq ymm0,xmm0
 cmp         rsi,32
 jae         CASE_LARGE
 lea         r9,[JUMP_TABLE]
 movzx       eax,byte [r9+rsi]
 add         r9,rax
 xor         eax,eax
 lea         r10,[rax-1]
 jmp         r9
times 31 db (0CCh)
JUMP_TABLE:
times 1 db ( CASE_0 - JUMP_TABLE)
times 1 db ( CASE_1 - JUMP_TABLE)
times 1 db ( CASE_2 - JUMP_TABLE)
times 1 db ( CASE_3 - JUMP_TABLE)
times 4 db ( CASE_4 - JUMP_TABLE)
times 4 db ( CASE_8 - JUMP_TABLE)
times 4 db (CASE_12 - JUMP_TABLE)
times 4 db (CASE_16 - JUMP_TABLE)
times 4 db (CASE_20 - JUMP_TABLE)
times 4 db (CASE_24 - JUMP_TABLE)
times 4 db (CASE_28 - JUMP_TABLE)
CASE_28:
 vpcmpeqq    ymm1,ymm0,yword [rdi]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 add         eax,4
CASE_24:
 vpcmpeqq    ymm1,ymm0,yword [rdi+8*rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 add         eax,4
CASE_20:
 vpcmpeqq    ymm1,ymm0,yword [rdi+8*rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 add         eax,4
CASE_16:
 vpcmpeqq    ymm1,ymm0,yword [rdi+8*rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 add         eax,4
CASE_12:
 vpcmpeqq    ymm1,ymm0,yword [rdi+8*rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 add         eax,4
CASE_8:
 vpcmpeqq    ymm1,ymm0,yword [rdi+8*rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 add         eax,4
CASE_4:
 vpcmpeqq    ymm1,ymm0,yword [rdi+8*rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 lea         eax,[rsi-4]
 vpcmpeqq    ymm1,ymm0,yword [rdi+8*rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 mov         rax,r10
 ret
CASE_3:
 cmp         edx,dword [rdi]
 je          FOUND_SMALL_SCALAR
 inc         eax
CASE_2:
 cmp         edx,dword [rdi+8*rax]
 je          FOUND_SMALL_SCALAR
 inc         eax
CASE_1:
 cmp         edx,dword [rdi+8*rax]
 je          FOUND_SMALL_SCALAR
CASE_0:
 mov         rax,r10
FOUND_SMALL_SCALAR:
 ret

FOUND_SMALL:
 vmovmskpd   edi,ymm1
 tzcnt       edi,edi
 add         eax,edi
 ret

CASE_LARGE:
 lea         rsi,[rdi+8*rsi]
 add         rdi,256
 mov         r10,rdi

LOOP_TOP:
 vpcmpeqq    ymm1,ymm0,yword [rdi-256]
 vpcmpeqq    ymm2,ymm0,yword [rdi-224]
 vpor        ymm1,ymm1,ymm2
 vpcmpeqq    ymm3,ymm0,yword [rdi-192]
 vpcmpeqq    ymm4,ymm0,yword [rdi-160]
 vpor        ymm3,ymm3,ymm4
 vpor        ymm1,ymm1,ymm3
 vpcmpeqq    ymm2,ymm0,yword [rdi-128]
 vpcmpeqq    ymm3,ymm0,yword [rdi-96]
 vpor        ymm2,ymm2,ymm3
 vpcmpeqq    ymm4,ymm0,yword [rdi-64]
 vpcmpeqq    ymm5,ymm0,yword [rdi-32]
 vpor        ymm4,ymm4,ymm5
 vpor        ymm2,ymm2,ymm4
 vpor        ymm1,ymm1,ymm2
 vptest      ymm1,ymm1
 jnz         FOUND
 add         rdi,256
 cmp         rdi,rsi
 jb          LOOP_TOP

 mov         rdi,rsi

 vpcmpeqq    ymm1,ymm0,yword [rdi-256]
 vpcmpeqq    ymm2,ymm0,yword [rdi-224]
 vpor        ymm1,ymm1,ymm2
 vpcmpeqq    ymm3,ymm0,yword [rdi-192]
 vpcmpeqq    ymm4,ymm0,yword [rdi-160]
 vpor        ymm3,ymm3,ymm4
 vpor        ymm1,ymm1,ymm3
 vpcmpeqq    ymm2,ymm0,yword [rdi-128]
 vpcmpeqq    ymm3,ymm0,yword [rdi-96]
 vpor        ymm2,ymm2,ymm3
 vpcmpeqq    ymm4,ymm0,yword [rdi-64]
 vpcmpeqq    ymm5,ymm0,yword [rdi-32]
 vpor        ymm4,ymm4,ymm5
 vpor        ymm2,ymm2,ymm4
 vpor        ymm1,ymm1,ymm2
 vptest      ymm1,ymm1
 jnz         FOUND

 mov         rax,-1
 ret

FOUND:
 vpcmpeqq    ymm1,ymm0,yword [rdi-256]
 vmovmskpd   eax,ymm1
 vpcmpeqq    ymm1,ymm0,yword [rdi-224]
 vmovmskpd   esi,ymm1
 shl         esi,4
 or          eax,esi
 vpcmpeqq    ymm1,ymm0,yword [rdi-192]
 vmovmskpd   esi,ymm1
 vpcmpeqq    ymm1,ymm0,yword [rdi-160]
 vmovmskpd   edx,ymm1
 shl         edx,4
 or          esi,edx
 shl         esi,8
 or          eax,esi
 vpcmpeqq    ymm1,ymm0,yword [rdi-128]
 vmovmskpd   esi,ymm1
 vpcmpeqq    ymm1,ymm0,yword [rdi-96]
 vmovmskpd   edx,ymm1
 shl         edx,4
 or          esi,edx
 vpcmpeqq    ymm1,ymm0,yword [rdi-64]
 vmovmskpd   edx,ymm1
 vpcmpeqq    ymm1,ymm0,yword [rdi-32]
 vmovmskpd   r9d,ymm1
 shl         r9d,4
 or          edx,r9d
 shl         edx,8
 or          esi,edx
 shl         esi,16
 or          eax,esi
 tzcnt       eax,eax
 sub         rdi,r10
 shr         rdi,3
 add         rax,rdi
 ret
