; /*******************************************************************
; *
; *    Author: Kareem Omar
; *    kareem.h.omar@gmail.com
; *    https://github.com/komrad36
; *
; *    Last updated Mar 12, 2021
; *******************************************************************/

bits 64section .textalign 64global FastFindDouble

FastFindDouble:
 vbroadcastsd ymm0,xmm0
 cmp         rsi,32
 jae         CASE_LARGE
 lea         r9,[JUMP_TABLE]
 movzx       eax,byte [r9+rsi]
 add         r9,rax
 xor         eax,eax
 lea         r10,[rax-1]
 jmp         r9
times 4 db (0CCh)
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
 vcmpeqpd    ymm1,ymm0,yword [rdi]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 add         eax,4
CASE_24:
 vcmpeqpd    ymm1,ymm0,yword [rdi+8*rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 add         eax,4
CASE_20:
 vcmpeqpd    ymm1,ymm0,yword [rdi+8*rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 add         eax,4
CASE_16:
 vcmpeqpd    ymm1,ymm0,yword [rdi+8*rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 add         eax,4
CASE_12:
 vcmpeqpd    ymm1,ymm0,yword [rdi+8*rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 add         eax,4
CASE_8:
 vcmpeqpd    ymm1,ymm0,yword [rdi+8*rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 add         eax,4
CASE_4:
 vcmpeqpd    ymm1,ymm0,yword [rdi+8*rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 lea         eax,[rsi-4]
 vcmpeqpd    ymm1,ymm0,yword [rdi+8*rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 mov         rax,r10
 ret
CASE_3:
 vucomisd    xmm0,qword [rdi]
 je          FOUND_SMALL_SCALAR
 inc         eax
CASE_2:
 vucomisd    xmm0,qword [rdi+8*rax]
 je          FOUND_SMALL_SCALAR
 inc         eax
CASE_1:
 vucomisd    xmm0,qword [rdi+8*rax]
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

 mov         rdi,rsi

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

 mov         rax,-1
 ret

FOUND:
 vcmpeqpd    ymm1,ymm0,yword [rdi-256]
 vmovmskpd   eax,ymm1
 vcmpeqpd    ymm1,ymm0,yword [rdi-224]
 vmovmskpd   esi,ymm1
 shl         esi,4
 or          eax,esi
 vcmpeqpd    ymm1,ymm0,yword [rdi-192]
 vmovmskpd   esi,ymm1
 vcmpeqpd    ymm1,ymm0,yword [rdi-160]
 vmovmskpd   edx,ymm1
 shl         edx,4
 or          esi,edx
 shl         esi,8
 or          eax,esi
 vcmpeqpd    ymm1,ymm0,yword [rdi-128]
 vmovmskpd   esi,ymm1
 vcmpeqpd    ymm1,ymm0,yword [rdi-96]
 vmovmskpd   edx,ymm1
 shl         edx,4
 or          esi,edx
 vcmpeqpd    ymm1,ymm0,yword [rdi-64]
 vmovmskpd   edx,ymm1
 vcmpeqpd    ymm1,ymm0,yword [rdi-32]
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
