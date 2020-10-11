bits 64
section .text
align 64
global AsmFastMaxIdxI64

AsmFastMaxIdxI64:
 mov         eax,esi
 cmp         esi,16
 jae         CASE_LARGE
 lea		 r8,[JUMP_TABLE]
 movzx		 r9d,byte [r8+rax]
 add		 r8,r9
 lea         r9,[rdi+8*rax]
 mov		 r10,08000000000000000h
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
times 1 db (CASE_12 - JUMP_TABLE)
times 1 db (CASE_13 - JUMP_TABLE)
times 1 db (CASE_14 - JUMP_TABLE)
times 1 db (CASE_15 - JUMP_TABLE)
CASE_15:
 mov		 r10,qword [r9-120]
CASE_14:
 lea		 ecx,[rsi-14]
 cmp		 r10,qword [r9-112]
 cmovl		 r10,qword [r9-112]
 cmovl		 eax,ecx
CASE_13:
 lea		 ecx,[rsi-13]
 cmp		 r10,qword [r9-104]
 cmovl		 r10,qword [r9-104]
 cmovl		 eax,ecx
CASE_12:
 lea		 ecx,[rsi-12]
 cmp		 r10,qword [r9-96]
 cmovl		 r10,qword [r9-96]
 cmovl		 eax,ecx
CASE_11:
 lea		 ecx,[rsi-11]
 cmp		 r10,qword [r9-88]
 cmovl		 r10,qword [r9-88]
 cmovl		 eax,ecx
CASE_10:
 lea		 ecx,[rsi-10]
 cmp		 r10,qword [r9-80]
 cmovl		 r10,qword [r9-80]
 cmovl		 eax,ecx
CASE_9:
 lea		 ecx,[rsi-9]
 cmp		 r10,qword [r9-72]
 cmovl		 r10,qword [r9-72]
 cmovl		 eax,ecx
CASE_8:
 lea		 ecx,[rsi-8]
 cmp		 r10,qword [r9-64]
 cmovl		 r10,qword [r9-64]
 cmovl		 eax,ecx
CASE_7:
 lea		 ecx,[rsi-7]
 cmp		 r10,qword [r9-56]
 cmovl		 r10,qword [r9-56]
 cmovl		 eax,ecx
CASE_6:
 lea		 ecx,[rsi-6]
 cmp		 r10,qword [r9-48]
 cmovl		 r10,qword [r9-48]
 cmovl		 eax,ecx
CASE_5:
 lea		 ecx,[rsi-5]
 cmp		 r10,qword [r9-40]
 cmovl		 r10,qword [r9-40]
 cmovl		 eax,ecx
CASE_4:
 lea		 ecx,[rsi-4]
 cmp		 r10,qword [r9-32]
 cmovl		 r10,qword [r9-32]
 cmovl		 eax,ecx
CASE_3:
 lea		 ecx,[rsi-3]
 cmp		 r10,qword [r9-24]
 cmovl		 r10,qword [r9-24]
 cmovl		 eax,ecx
CASE_2:
 lea		 ecx,[rsi-2]
 cmp		 r10,qword [r9-16]
 cmovl		 r10,qword [r9-16]
 cmovl		 eax,ecx
CASE_1:
 lea		 ecx,[rsi-1]
 cmp		 r10,qword [r9-8]
 cmovl		 eax,ecx
CASE_0:
 ret

PACKED_SEQ:
dd 0, 1, 4, 5, 2, 3, 6, 7

CASE_LARGE:
 vmovdqu     ymm4,yword [PACKED_SEQ]

 ; best values
 vmovdqu     ymm0,yword [rdi]
 vmovdqu     ymm1,yword [rdi+32]
 vmovdqu     ymm2,yword [rdi+64]
 vmovdqu     ymm3,yword [rdi+96]

 ; best indices
 vmovdqa     ymm5,ymm4
 vmovdqa     ymm6,ymm4

 ; increment
 vpcmpeqd    ymm7,ymm7,ymm7
 vpslld      ymm7,ymm7,4

 vpsubd      ymm4,ymm4,ymm7

 lea         rsi,[rdi+8*rax]
 add         rdi,256
 cmp         rdi,rsi
 jae         LOOP_END

LOOP_TOP:
 vmovdqu     ymm8,yword [rdi-128]
 vpcmpgtq    ymm9,ymm8,ymm0
 vpblendvb   ymm0,ymm0,ymm8,ymm9
 vmovdqu     ymm8,yword [rdi-96]
 vpcmpgtq    ymm10,ymm8,ymm1
 vpblendvb   ymm1,ymm1,ymm8,ymm10
 vpackssdw   ymm9,ymm9,ymm10
 vpblendvb   ymm5,ymm5,ymm4,ymm9

 vmovdqu     ymm8,yword [rdi-64]
 vpcmpgtq    ymm9,ymm8,ymm2
 vpblendvb   ymm2,ymm2,ymm8,ymm9
 vmovdqu     ymm8,yword [rdi-32]
 vpcmpgtq    ymm10,ymm8,ymm3
 vpblendvb   ymm3,ymm3,ymm8,ymm10
 vpackssdw   ymm9,ymm9,ymm10
 vpblendvb   ymm6,ymm6,ymm4,ymm9

 vpsubd      ymm4,ymm4,ymm7

 sub         rdi,-128
 cmp         rdi,rsi
 jb          LOOP_TOP

LOOP_END:
 sub		 eax,16
 vmovd		 xmm4,eax
 vpbroadcastd ymm4,xmm4
 vpaddd		 ymm4,ymm4,yword [PACKED_SEQ]

 vmovdqu     ymm8,yword [rsi-128]
 vpcmpgtq    ymm9,ymm8,ymm0
 vpblendvb   ymm0,ymm0,ymm8,ymm9
 vmovdqu     ymm8,yword [rsi-96]
 vpcmpgtq    ymm10,ymm8,ymm1
 vpblendvb   ymm1,ymm1,ymm8,ymm10
 vpackssdw   ymm9,ymm9,ymm10
 vpblendvb   ymm5,ymm5,ymm4,ymm9

 vmovdqu     ymm8,yword [rsi-64]
 vpcmpgtq    ymm9,ymm8,ymm2
 vpblendvb   ymm2,ymm2,ymm8,ymm9
 vmovdqu     ymm8,yword [rsi-32]
 vpcmpgtq    ymm10,ymm8,ymm3
 vpblendvb   ymm3,ymm3,ymm8,ymm10
 vpackssdw   ymm9,ymm9,ymm10
 vpblendvb   ymm6,ymm6,ymm4,ymm9

 vpcmpgtq    ymm8,ymm2,ymm0
 vpcmpgtq    ymm9,ymm3,ymm1
 vpblendvb   ymm0,ymm0,ymm2,ymm8
 vpblendvb   ymm1,ymm1,ymm3,ymm9
 vpackssdw   ymm2,ymm8,ymm9

 vpsrad      ymm4,ymm7,1

 vpsubd      ymm6,ymm6,ymm4
 vpblendvb   ymm2,ymm5,ymm6,ymm2

 vpunpckhdq  ymm3,ymm2,ymm2
 vpunpckldq  ymm2,ymm2,ymm2

 vpcmpgtq    ymm4,ymm1,ymm0
 vpblendvb   ymm0,ymm0,ymm1,ymm4
 vpblendvb   ymm2,ymm2,ymm3,ymm4

 vextractf128 xmm1,ymm0,1
 vextracti128 xmm3,ymm2,1

 vpcmpgtq    xmm4,xmm1,xmm0
 vpblendvb   xmm0,xmm0,xmm1,xmm4
 vpblendvb   xmm2,xmm2,xmm3,xmm4

 vpunpckhqdq xmm1,xmm0,xmm0
 vpunpckhqdq xmm3,xmm2,xmm2

 vpcmpgtq    xmm4,xmm1,xmm0
 vpblendvb   xmm0,xmm2,xmm3,xmm4
 vmovd       eax,xmm0

 ret
