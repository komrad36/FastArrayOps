bits 64
section .text
align 64
global AsmFastMaxU64

AsmFastMaxU64:
 vpcmpeqd	 ymm1,ymm1,ymm1
 mov         eax,esi
 vpsllq		 ymm0,ymm1,63
 cmp         esi,32
 jae         CASE_LARGE
 vmovdqa	 ymm1,ymm0
 vmovdqa	 ymm2,ymm0
 lea		 r8,[JUMP_TABLE]
 movzx		 esi,byte [r8+rax]
 add		 r8,rsi
 lea         rsi,[rdi+8*rax]
 and		 eax,-4
 lea         rdi,[rdi+8*rax]
 xor		 eax,eax
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
CASE_28:
 vpxor		 ymm1,ymm0,yword [rdi-224]
CASE_24:
 vpxor   	 ymm2,ymm0,yword [rdi-192]
CASE_20:
 vpxor   	 ymm3,ymm0,yword [rdi-160]
 vpcmpgtq    ymm4,ymm3,ymm1
 vpblendvb   ymm1,ymm1,ymm3,ymm4
CASE_16:
 vpxor   	 ymm3,ymm0,yword [rdi-128]
 vpcmpgtq    ymm4,ymm3,ymm2
 vpblendvb   ymm2,ymm2,ymm3,ymm4
CASE_12:
 vpxor   	 ymm3,ymm0,yword [rdi-96]
 vpcmpgtq    ymm4,ymm3,ymm1
 vpblendvb   ymm1,ymm1,ymm3,ymm4
 vpxor   	 ymm3,ymm0,yword [rdi-64]
 vpcmpgtq    ymm4,ymm3,ymm2
 vpblendvb   ymm2,ymm2,ymm3,ymm4
 vpxor   	 ymm3,ymm0,yword [rdi-32]
 vpcmpgtq    ymm4,ymm3,ymm1
 vpblendvb   ymm1,ymm1,ymm3,ymm4
 vpxor   	 ymm3,ymm0,yword [rsi-32]
 vpcmpgtq    ymm4,ymm3,ymm2
 vpblendvb   ymm2,ymm2,ymm3,ymm4
 jmp		 GATHER_1
CASE_11:
 mov         rax,qword [rsi-88]
CASE_10:
 cmp         rax,qword [rsi-80]
 cmovb       rax,qword [rsi-80]
CASE_9:
 cmp         rax,qword [rsi-72]
 cmovb       rax,qword [rsi-72]
CASE_8:
 cmp         rax,qword [rsi-64]
 cmovb       rax,qword [rsi-64]
CASE_7:
 cmp         rax,qword [rsi-56]
 cmovb       rax,qword [rsi-56]
CASE_6:
 cmp         rax,qword [rsi-48]
 cmovb       rax,qword [rsi-48]
CASE_5:
 cmp         rax,qword [rsi-40]
 cmovb       rax,qword [rsi-40]
CASE_4:
 cmp         rax,qword [rsi-32]
 cmovb       rax,qword [rsi-32]
CASE_3:
 cmp         rax,qword [rsi-24]
 cmovb       rax,qword [rsi-24]
CASE_2:
 cmp         rax,qword [rsi-16]
 cmovb       rax,qword [rsi-16]
CASE_1:
 cmp         rax,qword [rsi-8]
 cmovb       rax,qword [rsi-8]
CASE_0:
 ret

times 26 db (0CCh)

CASE_LARGE:
 vpxor       ymm1,ymm0,yword [rdi]
 vpxor       ymm2,ymm0,yword [rdi+32]
 vpxor       ymm3,ymm0,yword [rdi+64]
 vpxor       ymm4,ymm0,yword [rdi+96]
 vpxor       ymm5,ymm0,yword [rdi+128]
 vpxor       ymm6,ymm0,yword [rdi+160]
 vpxor       ymm7,ymm0,yword [rdi+192]
 vpxor       ymm8,ymm0,yword [rdi+224]

 lea         rsi,[rdi+8*rax]
 add         rdi,512
 cmp         rdi,rsi
 jae         LOOP_END

 LOOP_TOP:
 vpxor   	 ymm9,ymm0,yword [rdi-256]
 vpcmpgtq    ymm10,ymm9,ymm1
 vpblendvb   ymm1,ymm1,ymm9,ymm10
 vpxor   	 ymm9,ymm0,yword [rdi-224]
 vpcmpgtq    ymm10,ymm9,ymm2
 vpblendvb   ymm2,ymm2,ymm9,ymm10
 vpxor   	 ymm9,ymm0,yword [rdi-192]
 vpcmpgtq    ymm10,ymm9,ymm3
 vpblendvb   ymm3,ymm3,ymm9,ymm10
 vpxor   	 ymm9,ymm0,yword [rdi-160]
 vpcmpgtq    ymm10,ymm9,ymm4
 vpblendvb   ymm4,ymm4,ymm9,ymm10
 vpxor   	 ymm9,ymm0,yword [rdi-128]
 vpcmpgtq    ymm10,ymm9,ymm5
 vpblendvb   ymm5,ymm5,ymm9,ymm10
 vpxor   	 ymm9,ymm0,yword [rdi-96]
 vpcmpgtq    ymm10,ymm9,ymm6
 vpblendvb   ymm6,ymm6,ymm9,ymm10
 vpxor   	 ymm9,ymm0,yword [rdi-64]
 vpcmpgtq    ymm10,ymm9,ymm7
 vpblendvb   ymm7,ymm7,ymm9,ymm10
 vpxor   	 ymm9,ymm0,yword [rdi-32]
 vpcmpgtq    ymm10,ymm9,ymm8
 vpblendvb   ymm8,ymm8,ymm9,ymm10
 add         rdi,256
 cmp         rdi,rsi
 jb          LOOP_TOP

 LOOP_END:
 vpxor   	 ymm9,ymm0,yword [rsi-256]
 vpcmpgtq    ymm10,ymm9,ymm1
 vpblendvb   ymm1,ymm1,ymm9,ymm10
 vpxor   	 ymm9,ymm0,yword [rsi-224]
 vpcmpgtq    ymm10,ymm9,ymm2
 vpblendvb   ymm2,ymm2,ymm9,ymm10
 vpxor   	 ymm9,ymm0,yword [rsi-192]
 vpcmpgtq    ymm10,ymm9,ymm3
 vpblendvb   ymm3,ymm3,ymm9,ymm10
 vpxor   	 ymm9,ymm0,yword [rsi-160]
 vpcmpgtq    ymm10,ymm9,ymm4
 vpblendvb   ymm4,ymm4,ymm9,ymm10
 vpxor   	 ymm9,ymm0,yword [rsi-128]
 vpcmpgtq    ymm10,ymm9,ymm5
 vpblendvb   ymm5,ymm5,ymm9,ymm10
 vpxor   	 ymm9,ymm0,yword [rsi-96]
 vpcmpgtq    ymm10,ymm9,ymm6
 vpblendvb   ymm6,ymm6,ymm9,ymm10
 vpxor   	 ymm9,ymm0,yword [rsi-64]
 vpcmpgtq    ymm10,ymm9,ymm7
 vpblendvb   ymm7,ymm7,ymm9,ymm10
 vpxor   	 ymm9,ymm0,yword [rsi-32]
 vpcmpgtq    ymm10,ymm9,ymm8
 vpblendvb   ymm8,ymm8,ymm9,ymm10

 vpcmpgtq    ymm0,ymm8,ymm4
 vpblendvb   ymm4,ymm4,ymm8,ymm0
 vpcmpgtq    ymm0,ymm7,ymm3
 vpblendvb   ymm3,ymm3,ymm7,ymm0
 vpcmpgtq    ymm0,ymm6,ymm2
 vpblendvb   ymm2,ymm2,ymm6,ymm0
 vpcmpgtq    ymm0,ymm5,ymm1
 vpblendvb   ymm1,ymm1,ymm5,ymm0

 vpcmpgtq    ymm0,ymm3,ymm1
 vpblendvb   ymm1,ymm1,ymm3,ymm0
 vpcmpgtq    ymm0,ymm4,ymm2
 vpblendvb   ymm2,ymm2,ymm4,ymm0

 GATHER_1:
 vpcmpgtq    ymm0,ymm2,ymm1
 vpblendvb   ymm1,ymm1,ymm2,ymm0

 vextracti128 xmm2,ymm1,1
 vpcmpgtq    xmm0,xmm2,xmm1
 vpblendvb   xmm1,xmm1,xmm2,xmm0
 vpshufd     xmm2,xmm1,78
 vpcmpgtq    xmm0,xmm2,xmm1
 vpblendvb   xmm1,xmm1,xmm2,xmm0
 vmovq       rax,xmm1
 btc		 rax,63
 ret
