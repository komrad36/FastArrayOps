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
global FastMaxI8

FastMaxI8:
 mov         eax,esi
 cmp         esi,127
 ja          CASE_LARGE
 lea         r8,[JUMP_TARGETS]
 movzx       esi,byte [r8+rax-(JUMP_TARGETS-JUMP_TABLE)]
db 03Eh
 add         r8,rsi
 lea         rsi,[rdi+rax]
 and         eax,-32
 add         rdi,rax
 vpcmpeqd    ymm0,ymm0,ymm0
 vpxor       xmm1,xmm1,xmm1
 vpavgb      ymm0,ymm0,ymm1
 mov         al,080h
 jmp         r8
times 11 db (0CCh)
JUMP_TABLE:
times  1 db ( CASE_0 - JUMP_TARGETS)
times  1 db ( CASE_1 - JUMP_TARGETS)
times  1 db ( CASE_2 - JUMP_TARGETS)
times  1 db ( CASE_3 - JUMP_TARGETS)
times  4 db ( CASE_4 - JUMP_TARGETS)
times  8 db ( CASE_8 - JUMP_TARGETS)
times 16 db (CASE_16 - JUMP_TARGETS)
times 32 db (CASE_32 - JUMP_TARGETS)
times 32 db (CASE_64 - JUMP_TARGETS)
times 32 db (CASE_96 - JUMP_TARGETS)
JUMP_TARGETS:
CASE_96:
 vmovdqu     ymm0,yword [rdi-96]
CASE_64:
 vpmaxsb     ymm0,ymm0,yword [rdi-64]
CASE_32:
 vpmaxsb     ymm0,ymm0,yword [rdi-32]
 vpmaxsb     ymm0,ymm0,yword [rsi-32]
 vextracti128 xmm1,ymm0,1
 vpmaxsb     xmm0,xmm0,xmm1
 vpunpckhqdq xmm1,xmm0,xmm0
 vpmaxsb     xmm0,xmm0,xmm1
 vmovshdup   xmm1,xmm0
 vpmaxsb     xmm0,xmm0,xmm1
 vpshuflw    xmm1,xmm0,225
 vpmaxsb     xmm0,xmm0,xmm1
 vpsrldq     xmm1,xmm0,1
 vpmaxsb     xmm0,xmm0,xmm1
 vmovd       eax,xmm0
 ret
times 1 db (0CCh)
CASE_16:
 vmovdqu     xmm0,oword [rdi]
 vpmaxsb     xmm0,xmm0,oword [rsi-16]
 vpunpckhqdq xmm1,xmm0,xmm0
 vpmaxsb     xmm0,xmm0,xmm1
 vmovshdup   xmm1,xmm0
 vpmaxsb     xmm0,xmm0,xmm1
 vpshuflw    xmm1,xmm0,225
 vpmaxsb     xmm0,xmm0,xmm1
 vpsrldq     xmm1,xmm0,1
 vpmaxsb     xmm0,xmm0,xmm1
 vmovd       eax,xmm0
 ret
times 2 db (0CCh)
CASE_8:
 vmovq       xmm0,qword [rdi]
 vmovq       xmm1,qword [rsi-8]
 vpmaxsb     xmm0,xmm0,xmm1
 vmovshdup   xmm1,xmm0
 vpmaxsb     xmm0,xmm0,xmm1
 vpshuflw    xmm1,xmm0,225
 vpmaxsb     xmm0,xmm0,xmm1
 vpsrldq     xmm1,xmm0,1
 vpmaxsb     xmm0,xmm0,xmm1
 vmovd       eax,xmm0
 ret
times 10 db (0CCh)
CASE_4:
 vmovd       xmm0,dword [rdi]
 vmovd       xmm1,dword [rsi-4]
 vpmaxsb     xmm0,xmm0,xmm1
 vpshuflw    xmm1,xmm0,225
 vpmaxsb     xmm0,xmm0,xmm1
 vpsrldq     xmm1,xmm0,1
 vpmaxsb     xmm0,xmm0,xmm1
 vmovd       eax,xmm0
 ret
CASE_3:
 mov         al,byte [rsi-3]
CASE_2:
 mov         cl,byte [rsi-2]
 cmp         al,cl
 cmovl       eax,ecx
CASE_1:
 mov         cl,byte [rsi-1]
 cmp         al,cl
 cmovl       eax,ecx
CASE_0:
 ret

times 39 db (0CCh)

CASE_LARGE:
 vmovdqu     ymm0,yword [rdi]
 vmovdqu     ymm1,yword [rdi+32]
 vmovdqu     ymm2,yword [rdi+64]
 vmovdqu     ymm3,yword [rdi+96]

 lea         rsi,[rdi+rax]
 add         rdi,256
 cmp         rdi,rsi
 jae         LOOP_END

LOOP_TOP:
 vpmaxsb     ymm0,ymm0,yword [rdi-128]
 vpmaxsb     ymm1,ymm1,yword [rdi-96]
 vpmaxsb     ymm2,ymm2,yword [rdi-64]
 vpmaxsb     ymm3,ymm3,yword [rdi-32]
 sub         rdi,-128
 cmp         rdi,rsi
 jb          LOOP_TOP

LOOP_END:
 vpmaxsb     ymm0,ymm0,yword [rsi-128]
 vpmaxsb     ymm1,ymm1,yword [rsi-96]
 vpmaxsb     ymm2,ymm2,yword [rsi-64]
 vpmaxsb     ymm3,ymm3,yword [rsi-32]

 vpmaxsb     ymm0,ymm0,ymm2
 vpmaxsb     ymm1,ymm1,ymm3

 vpmaxsb     ymm0,ymm0,ymm1

 vextracti128 xmm1,ymm0,1
 vpmaxsb     xmm0,xmm0,xmm1
 vpunpckhqdq xmm1,xmm0,xmm0
 vpmaxsb     xmm0,xmm0,xmm1
 vmovshdup   xmm1,xmm0
 vpmaxsb     xmm0,xmm0,xmm1
 vpshuflw    xmm1,xmm0,225
 vpmaxsb     xmm0,xmm0,xmm1
 vpsrldq     xmm1,xmm0,1
 vpmaxsb     xmm0,xmm0,xmm1
 vmovd       eax,xmm0
 ret
