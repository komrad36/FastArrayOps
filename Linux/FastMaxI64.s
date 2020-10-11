bits 64
section .text
align 64
global AsmFastMaxI64

AsmFastMaxI64:
 mov         eax,esi
 cmp         esi,32
 jae         CASE_LARGE
 vpcmpeqq	 ymm0,ymm0,ymm0
 vpsllq		 ymm0,ymm0,63
 lea		 r8,[JUMP_TABLE]
 movzx		 esi,byte [r8+rax]
 add		 r8,rsi
 vmovdqa	 ymm1,ymm0
 lea         rsi,[rdi+8*rax]
 and		 eax,-4
 lea         rdi,[rdi+8*rax]
 mov		 rax,08000000000000000h
 jmp         r8
JUMP_TABLE:
times 1 db ( CASE_0 - JUMP_TABLE)
times 1 db ( CASE_1 - JUMP_TABLE)
times 1 db ( CASE_2 - JUMP_TABLE)
times 1 db ( CASE_3 - JUMP_TABLE)
times 1 db ( CASE_4 - JUMP_TABLE)
times 1 db ( CASE_5 - JUMP_TABLE)
times 1 db ( CASE_6 - JUMP_TABLE)
times 1 db ( CASE_7 - JUMP_TABLE)
times 1 db ( CASE_8 - JUMP_TABLE)
times 1 db ( CASE_9 - JUMP_TABLE)
times 1 db (CASE_10 - JUMP_TABLE)
times 1 db (CASE_11 - JUMP_TABLE)
times 4 db (CASE_12 - JUMP_TABLE)
times 4 db (CASE_16 - JUMP_TABLE)
times 4 db (CASE_20 - JUMP_TABLE)
times 4 db (CASE_24 - JUMP_TABLE)
times 4 db (CASE_28 - JUMP_TABLE)
times 8 db (0CCh)
CASE_28:
 vmovdqu	 ymm0,yword [rdi-224]
CASE_24:
 vmovdqu	 ymm1,yword [rdi-192]
CASE_20:
 vmovdqu	 ymm2,yword [rdi-160]
 vpcmpgtq    ymm4,ymm2,ymm0
 vpblendvb   ymm0,ymm0,ymm2,ymm4
CASE_16:
 vmovdqu	 ymm2,yword [rdi-128]
 vpcmpgtq    ymm4,ymm2,ymm1
 vpblendvb   ymm1,ymm1,ymm2,ymm4
CASE_12:
 vmovdqu	 ymm2,yword [rdi-96]
 vpcmpgtq    ymm4,ymm2,ymm0
 vpblendvb   ymm0,ymm0,ymm2,ymm4
 vmovdqu	 ymm2,yword [rdi-64]
 vpcmpgtq    ymm4,ymm2,ymm1
 vpblendvb   ymm1,ymm1,ymm2,ymm4
 vmovdqu	 ymm2,yword [rdi-32]
 vpcmpgtq    ymm4,ymm2,ymm0
 vpblendvb   ymm0,ymm0,ymm2,ymm4
 vmovdqu	 ymm2,yword [rsi-32]
 vpcmpgtq    ymm4,ymm2,ymm1
 vpblendvb   ymm1,ymm1,ymm2,ymm4
 jmp GATHER_1
CASE_11:
 mov         rax,qword [rsi-88]
CASE_10:
 cmp         rax,qword [rsi-80]
 cmovl       rax,qword [rsi-80]
CASE_9:
 cmp         rax,qword [rsi-72]
 cmovl       rax,qword [rsi-72]
CASE_8:
 cmp         rax,qword [rsi-64]
 cmovl       rax,qword [rsi-64]
CASE_7:
 cmp         rax,qword [rsi-56]
 cmovl       rax,qword [rsi-56]
CASE_6:
 cmp         rax,qword [rsi-48]
 cmovl       rax,qword [rsi-48]
CASE_5:
 cmp         rax,qword [rsi-40]
 cmovl       rax,qword [rsi-40]
CASE_4:
 cmp         rax,qword [rsi-32]
 cmovl       rax,qword [rsi-32]
CASE_3:
 cmp         rax,qword [rsi-24]
 cmovl       rax,qword [rsi-24]
CASE_2:
 cmp         rax,qword [rsi-16]
 cmovl       rax,qword [rsi-16]
CASE_1:
 cmp         rax,qword [rsi-8]
 cmovl       rax,qword [rsi-8]
CASE_0:
 ret

CASE_LARGE:
 vmovdqu     ymm0,yword [rdi]
 vmovdqu     ymm1,yword [rdi+32]
 vmovdqu     ymm2,yword [rdi+64]
 vmovdqu     ymm3,yword [rdi+96]
 vmovdqu     ymm4,yword [rdi+128]
 vmovdqu     ymm5,yword [rdi+160]
 vmovdqu     ymm6,yword [rdi+192]
 vmovdqu     ymm7,yword [rdi+224]

 lea         rsi,[rdi+8*rax]
 add         rdi,512
 cmp         rdi,rsi
 jae         LOOP_END

 LOOP_TOP:
 vmovdqu	 ymm9,yword [rdi-256]
 vpcmpgtq    ymm8,ymm9,ymm0
 vpblendvb   ymm0,ymm0,ymm9,ymm8
 vmovdqu	 ymm9,yword [rdi-224]
 vpcmpgtq    ymm8,ymm9,ymm1
 vpblendvb   ymm1,ymm1,ymm9,ymm8
 vmovdqu	 ymm9,yword [rdi-192]
 vpcmpgtq    ymm8,ymm9,ymm2
 vpblendvb   ymm2,ymm2,ymm9,ymm8
 vmovdqu	 ymm9,yword [rdi-160]
 vpcmpgtq    ymm8,ymm9,ymm3
 vpblendvb   ymm3,ymm3,ymm9,ymm8
 vmovdqu	 ymm9,yword [rdi-128]
 vpcmpgtq    ymm8,ymm9,ymm4
 vpblendvb   ymm4,ymm4,ymm9,ymm8
 vmovdqu	 ymm9,yword [rdi-96]
 vpcmpgtq    ymm8,ymm9,ymm5
 vpblendvb   ymm5,ymm5,ymm9,ymm8
 vmovdqu	 ymm9,yword [rdi-64]
 vpcmpgtq    ymm8,ymm9,ymm6
 vpblendvb   ymm6,ymm6,ymm9,ymm8
 vmovdqu	 ymm9,yword [rdi-32]
 vpcmpgtq    ymm8,ymm9,ymm7
 vpblendvb   ymm7,ymm7,ymm9,ymm8

 add         rdi,256
 cmp         rdi,rsi
 jb          LOOP_TOP

 LOOP_END:
 vmovdqu	 ymm9,yword [rsi-256]
 vpcmpgtq    ymm8,ymm9,ymm0
 vpblendvb   ymm0,ymm0,ymm9,ymm8
 vmovdqu	 ymm9,yword [rsi-224]
 vpcmpgtq    ymm8,ymm9,ymm1
 vpblendvb   ymm1,ymm1,ymm9,ymm8
 vmovdqu	 ymm9,yword [rsi-192]
 vpcmpgtq    ymm8,ymm9,ymm2
 vpblendvb   ymm2,ymm2,ymm9,ymm8
 vmovdqu	 ymm9,yword [rsi-160]
 vpcmpgtq    ymm8,ymm9,ymm3
 vpblendvb   ymm3,ymm3,ymm9,ymm8
 vmovdqu	 ymm9,yword [rsi-128]
 vpcmpgtq    ymm8,ymm9,ymm4
 vpblendvb   ymm4,ymm4,ymm9,ymm8
 vmovdqu	 ymm9,yword [rsi-96]
 vpcmpgtq    ymm8,ymm9,ymm5
 vpblendvb   ymm5,ymm5,ymm9,ymm8
 vmovdqu	 ymm9,yword [rsi-64]
 vpcmpgtq    ymm8,ymm9,ymm6
 vpblendvb   ymm6,ymm6,ymm9,ymm8
 vmovdqu	 ymm9,yword [rsi-32]
 vpcmpgtq    ymm8,ymm9,ymm7
 vpblendvb   ymm7,ymm7,ymm9,ymm8

 vpcmpgtq    ymm8,ymm4,ymm0
 vpblendvb   ymm0,ymm0,ymm4,ymm8
 vpcmpgtq    ymm8,ymm5,ymm1
 vpblendvb   ymm1,ymm1,ymm5,ymm8
 vpcmpgtq    ymm8,ymm6,ymm2
 vpblendvb   ymm2,ymm2,ymm6,ymm8
 vpcmpgtq    ymm8,ymm7,ymm3
 vpblendvb   ymm3,ymm3,ymm7,ymm8

 vpcmpgtq    ymm4,ymm2,ymm0
 vpblendvb   ymm0,ymm0,ymm2,ymm4
 vpcmpgtq    ymm4,ymm3,ymm1
 vpblendvb   ymm1,ymm1,ymm3,ymm4

GATHER_1:
 vpcmpgtq    ymm4,ymm1,ymm0
 vpblendvb   ymm0,ymm0,ymm1,ymm4

 vextracti128 xmm1,ymm0,1
 vpcmpgtq    xmm2,xmm1,xmm0
 vpblendvb   xmm0,xmm0,xmm1,xmm2
 vpunpckhqdq xmm1,xmm0,xmm0
 vpcmpgtq    xmm2,xmm1,xmm0
 vpblendvb   xmm0,xmm0,xmm1,xmm2
 vmovq       rax,xmm0
 ret
