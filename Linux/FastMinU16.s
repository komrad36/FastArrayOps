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
global FastMinU16

FastMinU16:
 mov         eax,esi
 cmp         esi,64
 jae         CASE_LARGE
 vpcmpeqd    ymm0,ymm0,ymm0
 lea         r8,[JUMP_TABLE]
 movzx       esi,byte [r8+rax]
db 03Eh, 03Eh
 add         r8,rsi
 lea         rsi,[rdi+2*rax]
 and         eax,-16
 lea         rdi,[rdi+2*rax]
 mov         ax,-1
 jmp         r8
JUMP_TABLE:
times  1 db ( CASE_0 - JUMP_TABLE)
times  1 db ( CASE_1 - JUMP_TABLE)
times  1 db ( CASE_2 - JUMP_TABLE)
times  1 db ( CASE_3 - JUMP_TABLE)
times  4 db ( CASE_4 - JUMP_TABLE)
times  8 db ( CASE_8 - JUMP_TABLE)
times 16 db (CASE_16 - JUMP_TABLE)
times 16 db (CASE_32 - JUMP_TABLE)
times 16 db (CASE_48 - JUMP_TABLE)
times 3 db (0CCh)
CASE_48:
 vmovdqu     ymm0,yword [rdi-96]
CASE_32:
 vpminuw     ymm0,ymm0,yword [rdi-64]
CASE_16:
 vpminuw     ymm0,ymm0,yword [rdi-32]
 vpminuw     ymm0,ymm0,yword [rsi-32]
 vextracti128 xmm1,ymm0,1
 vpminuw     xmm0,xmm0,xmm1
 vpunpckhqdq xmm1,xmm0,xmm0
 vpminuw     xmm0,xmm0,xmm1
 vmovshdup   xmm1,xmm0
 vpminuw     xmm0,xmm0,xmm1
 vpshuflw    xmm1,xmm0,225
 vpminuw     xmm0,xmm0,xmm1
 vmovd       eax,xmm0
 ret
times 12 db (0CCh)
CASE_8:
 vmovdqu     xmm0,oword [rdi]
 vpminuw     xmm0,xmm0,oword [rsi-16]
 vpunpckhqdq xmm1,xmm0,xmm0
 vpminuw     xmm0,xmm0,xmm1
 vmovshdup   xmm1,xmm0
 vpminuw     xmm0,xmm0,xmm1
 vpshuflw    xmm1,xmm0,225
 vpminuw     xmm0,xmm0,xmm1
 vmovd       eax,xmm0
 ret
times 1 db (0CCh)
CASE_4:
 vmovq       xmm0,qword [rdi]
 vmovq       xmm1,qword [rsi-8]
 vpminuw     xmm0,xmm0,xmm1
 vmovshdup   xmm1,xmm0
 vpminuw     xmm0,xmm0,xmm1
 vpshuflw    xmm1,xmm0,225
 vpminuw     xmm0,xmm0,xmm1
 vmovd       eax,xmm0
 ret
CASE_3:
 mov         ax,word [rsi-6]
CASE_2:
 cmp         ax,word [rsi-4]
 cmova       ax,word [rsi-4]
CASE_1:
 cmp         ax,word [rsi-2]
 cmova       ax,word [rsi-2]
CASE_0:
 ret

CASE_LARGE:
 vmovdqu     ymm0,yword [rdi]
 vmovdqu     ymm1,yword [rdi+32]
 vmovdqu     ymm2,yword [rdi+64]
 vmovdqu     ymm3,yword [rdi+96]

 lea         rsi,[rdi+2*rax]
 add         rdi,256
 cmp         rdi,rsi
 jae         LOOP_END

LOOP_TOP:
 vpminuw     ymm0,ymm0,yword [rdi-128]
 vpminuw     ymm1,ymm1,yword [rdi-96]
 vpminuw     ymm2,ymm2,yword [rdi-64]
 vpminuw     ymm3,ymm3,yword [rdi-32]
 sub         rdi,-128
 cmp         rdi,rsi
 jb          LOOP_TOP

LOOP_END:
 vpminuw     ymm0,ymm0,yword [rsi-128]
 vpminuw     ymm1,ymm1,yword [rsi-96]
 vpminuw     ymm2,ymm2,yword [rsi-64]
 vpminuw     ymm3,ymm3,yword [rsi-32]

 vpminuw     ymm0,ymm0,ymm2
 vpminuw     ymm1,ymm1,ymm3

 vpminuw     ymm0,ymm0,ymm1

 vextracti128 xmm1,ymm0,1
 vpminuw     xmm0,xmm0,xmm1
 vpunpckhqdq xmm1,xmm0,xmm0
 vpminuw     xmm0,xmm0,xmm1
 vmovshdup   xmm1,xmm0
 vpminuw     xmm0,xmm0,xmm1
 vpshuflw    xmm1,xmm0,225
 vpminuw     xmm0,xmm0,xmm1
 vmovd       eax,xmm0
 ret
