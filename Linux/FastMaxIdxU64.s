bits 64
section .text
align 64
global AsmFastMaxIdxU64

AsmFastMaxIdxU64:
 mov         eax,esi
 cmp         esi,16
 jae         CASE_LARGE
 lea		 r8,[JUMP_TABLE]
 movzx		 r9d,byte [r8+rax]
 add		 r8,r9
 lea         r9,[rdi+8*rsi]
 xor		 r10d,r10d
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
 cmovb		 r10,qword [r9-112]
 cmovb		 eax,ecx
CASE_13:
 lea		 ecx,[rsi-13]
 cmp		 r10,qword [r9-104]
 cmovb		 r10,qword [r9-104]
 cmovb		 eax,ecx
CASE_12:
 lea		 ecx,[rsi-12]
 cmp		 r10,qword [r9-96]
 cmovb		 r10,qword [r9-96]
 cmovb		 eax,ecx
CASE_11:
 lea		 ecx,[rsi-11]
 cmp		 r10,qword [r9-88]
 cmovb		 r10,qword [r9-88]
 cmovb		 eax,ecx
CASE_10:
 lea		 ecx,[rsi-10]
 cmp		 r10,qword [r9-80]
 cmovb		 r10,qword [r9-80]
 cmovb		 eax,ecx
CASE_9:
 lea		 ecx,[rsi-9]
 cmp		 r10,qword [r9-72]
 cmovb		 r10,qword [r9-72]
 cmovb		 eax,ecx
CASE_8:
 lea		 ecx,[rsi-8]
 cmp		 r10,qword [r9-64]
 cmovb		 r10,qword [r9-64]
 cmovb		 eax,ecx
CASE_7:
 lea		 ecx,[rsi-7]
 cmp		 r10,qword [r9-56]
 cmovb		 r10,qword [r9-56]
 cmovb		 eax,ecx
CASE_6:
 lea		 ecx,[rsi-6]
 cmp		 r10,qword [r9-48]
 cmovb		 r10,qword [r9-48]
 cmovb		 eax,ecx
CASE_5:
 lea		 ecx,[rsi-5]
 cmp		 r10,qword [r9-40]
 cmovb		 r10,qword [r9-40]
 cmovb		 eax,ecx
CASE_4:
 lea		 ecx,[rsi-4]
 cmp		 r10,qword [r9-32]
 cmovb		 r10,qword [r9-32]
 cmovb		 eax,ecx
CASE_3:
 lea		 ecx,[rsi-3]
 cmp		 r10,qword [r9-24]
 cmovb		 r10,qword [r9-24]
 cmovb		 eax,ecx
CASE_2:
 lea		 ecx,[rsi-2]
 cmp		 r10,qword [r9-16]
 cmovb		 r10,qword [r9-16]
 cmovb		 eax,ecx
CASE_1:
 lea		 ecx,[rsi-1]
 cmp		 r10,qword [r9-8]
 cmovb		 eax,ecx
CASE_0:
 ret

PACKED_SEQ:
dd 0, 1, 4, 5, 2, 3, 6, 7

CASE_LARGE:
 vmovdqu     ymm5,yword [PACKED_SEQ]

 ; best indices
 vmovdqa     ymm6,ymm5
 vmovdqa     ymm7,ymm5

 vpcmpeqd    ymm0,ymm0,ymm0
 ; increment
 vpslld      ymm8,ymm0,4
 ; sign bit
 vpsllq		 ymm0,ymm0,63

 ; best values
 vpxor       ymm1,ymm0,yword [rdi]
 vpxor       ymm2,ymm0,yword [rdi+32]
 vpxor       ymm3,ymm0,yword [rdi+64]
 vpxor       ymm4,ymm0,yword [rdi+96]

 vpsubd      ymm5,ymm5,ymm8

 lea         rsi,[rdi+8*rax]
 add         rdi,256
 cmp         rdi,rsi
 jae         LOOP_END

LOOP_TOP:
 vpxor       ymm11,ymm0,yword [rdi-128]
 vpcmpgtq    ymm9,ymm11,ymm1
 vpblendvb   ymm1,ymm1,ymm11,ymm9
 vpxor       ymm11,ymm0,yword [rdi-96]
 vpcmpgtq    ymm10,ymm11,ymm2
 vpblendvb   ymm2,ymm2,ymm11,ymm10
 vpackssdw   ymm9,ymm9,ymm10
 vpblendvb   ymm6,ymm6,ymm5,ymm9

 vpxor       ymm11,ymm0,yword [rdi-64]
 vpcmpgtq    ymm9,ymm11,ymm3
 vpblendvb   ymm3,ymm3,ymm11,ymm9
 vpxor       ymm11,ymm0,yword [rdi-32]
 vpcmpgtq    ymm10,ymm11,ymm4
 vpblendvb   ymm4,ymm4,ymm11,ymm10
 vpackssdw   ymm9,ymm9,ymm10
 vpblendvb   ymm7,ymm7,ymm5,ymm9

 vpsubd      ymm5,ymm5,ymm8

 sub         rdi,-128
 cmp         rdi,rsi
 jb          LOOP_TOP

LOOP_END:
 sub		 eax,16
 vmovd		 xmm5,eax
 vpbroadcastd ymm5,xmm5
 vpaddd		 ymm5,ymm5,yword [PACKED_SEQ]

 vpxor       ymm11,ymm0,yword [rsi-128]
 vpcmpgtq    ymm9,ymm11,ymm1
 vpblendvb   ymm1,ymm1,ymm11,ymm9
 vpxor       ymm11,ymm0,yword [rsi-96]
 vpcmpgtq    ymm10,ymm11,ymm2
 vpblendvb   ymm2,ymm2,ymm11,ymm10
 vpackssdw   ymm9,ymm9,ymm10
 vpblendvb   ymm6,ymm6,ymm5,ymm9

 vpxor       ymm11,ymm0,yword [rsi-64]
 vpcmpgtq    ymm9,ymm11,ymm3
 vpblendvb   ymm3,ymm3,ymm11,ymm9
 vpxor       ymm11,ymm0,yword [rsi-32]
 vpcmpgtq    ymm10,ymm11,ymm4
 vpblendvb   ymm4,ymm4,ymm11,ymm10
 vpackssdw   ymm9,ymm9,ymm10
 vpblendvb   ymm7,ymm7,ymm5,ymm9

 vpcmpgtq    ymm9,ymm3,ymm1
 vpcmpgtq    ymm10,ymm4,ymm2
 vpblendvb   ymm1,ymm1,ymm3,ymm9
 vpblendvb   ymm2,ymm2,ymm4,ymm10
 vpackssdw   ymm3,ymm9,ymm10

 vpsrad      ymm5,ymm8,1

 vpsubd      ymm7,ymm7,ymm5
 vpblendvb   ymm3,ymm6,ymm7,ymm3

 vpunpckhdq  ymm4,ymm3,ymm3
 vpunpckldq  ymm3,ymm3,ymm3

 vpcmpgtq    ymm5,ymm2,ymm1
 vpblendvb   ymm1,ymm1,ymm2,ymm5
 vpblendvb   ymm3,ymm3,ymm4,ymm5

 vextractf128 xmm2,ymm1,1
 vextracti128 xmm4,ymm3,1

 vpcmpgtq    xmm5,xmm2,xmm1
 vpblendvb   xmm1,xmm1,xmm2,xmm5
 vpblendvb   xmm3,xmm3,xmm4,xmm5

 vpunpckhqdq xmm2,xmm1,xmm1
 vpunpckhqdq xmm4,xmm3,xmm3

 vpcmpgtq    xmm5,xmm2,xmm1
 vpblendvb   xmm0,xmm3,xmm4,xmm5
 vmovd       eax,xmm0

 ret
