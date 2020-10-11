bits 64
section .text
align 64
global AsmFastMinI32

AsmFastMinI32:
 mov         eax,esi
 cmp         esi,32
 jae         CASE_LARGE
 vpcmpeqd    ymm0,ymm0,ymm0
 vpsrld      ymm0,ymm0,1
 lea         r8,[JUMP_TABLE]
 movzx       esi,byte [r8+rax]
 add         r8,rsi
 lea         rsi,[rdi+4*rax]
 and         eax,-8
 lea         rdi,[rdi+4*rax]
 mov         eax,07FFFFFFFh
 jmp         r8
JUMP_TABLE:
times 1 db ( CASE_0 - JUMP_TABLE)
times 1 db ( CASE_1 - JUMP_TABLE)
times 1 db ( CASE_2 - JUMP_TABLE)
times 1 db ( CASE_3 - JUMP_TABLE)
times 4 db ( CASE_4 - JUMP_TABLE)
times 8 db ( CASE_8 - JUMP_TABLE)
times 8 db (CASE_16 - JUMP_TABLE)
times 8 db (CASE_24 - JUMP_TABLE)
times 45 db (0CCh)
CASE_24:
 vmovdqu     ymm0,yword [rdi-96]
CASE_16:
 vpminsd     ymm0,ymm0,yword [rdi-64]
CASE_8:
 vpminsd     ymm0,ymm0,yword [rdi-32]
 vpminsd     ymm0,ymm0,yword [rsi-32]
 vextracti128 xmm1,ymm0,1
 vpminsd     xmm0,xmm0,xmm1
 vpunpckhqdq xmm1,xmm0,xmm0
 vpminsd     xmm0,xmm0,xmm1
 vmovshdup   xmm1,xmm0
 vpminsd     xmm0,xmm0,xmm1
 vmovd       eax,xmm0
 ret
times 4 db (0CCh)
CASE_4:
 vmovdqu     xmm0,oword [rdi]
 vpminsd     xmm0,xmm0,oword [rsi-16]
 vpunpckhqdq xmm1,xmm0,xmm0
 vpminsd     xmm0,xmm0,xmm1
 vmovshdup   xmm1,xmm0
 vpminsd     xmm0,xmm0,xmm1
 vmovd       eax,xmm0
 ret
CASE_3:
 mov         eax,dword [rsi-12]
CASE_2:
 cmp         eax,dword [rsi-8]
 cmovg       eax,dword [rsi-8]
CASE_1:
 cmp         eax,dword [rsi-4]
 cmovg       eax,dword [rsi-4]
CASE_0:
 ret

times 50 db (0CCh)

CASE_LARGE:
 vmovdqu     ymm0,yword [rdi]
 vmovdqu     ymm1,yword [rdi+32]
 vmovdqu     ymm2,yword [rdi+64]
 vmovdqu     ymm3,yword [rdi+96]

 lea         rsi,[rdi+4*rax]
 add         rdi,256
 cmp         rdi,rsi
 jae         LOOP_END

LOOP_TOP:
 vpminsd     ymm0,ymm0,yword [rdi-128]
 vpminsd     ymm1,ymm1,yword [rdi-96]
 vpminsd     ymm2,ymm2,yword [rdi-64]
 vpminsd     ymm3,ymm3,yword [rdi-32]
 sub         rdi,-128
 cmp         rdi,rsi
 jb          LOOP_TOP

LOOP_END:
 vpminsd     ymm0,ymm0,yword [rsi-128]
 vpminsd     ymm1,ymm1,yword [rsi-96]
 vpminsd     ymm2,ymm2,yword [rsi-64]
 vpminsd     ymm3,ymm3,yword [rsi-32]

 vpminsd     ymm0,ymm0,ymm2
 vpminsd     ymm1,ymm1,ymm3

 vpminsd     ymm0,ymm0,ymm1

 vextracti128 xmm1,ymm0,1
 vpminsd     xmm0,xmm0,xmm1
 vpunpckhqdq xmm1,xmm0,xmm0
 vpminsd     xmm0,xmm0,xmm1
 vmovshdup   xmm1,xmm0
 vpminsd     xmm0,xmm0,xmm1
 vmovd       eax,xmm0
 ret
