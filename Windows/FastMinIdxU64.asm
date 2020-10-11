_TEXT$AsmFastMinIdxU64 SEGMENT ALIGN(64)

AsmFastMinIdxU64 PROC
 sub		 rsp,72
 mov         eax,edx
 cmp         edx,16
 jae         CASE_LARGE
 lea		 r8,JUMP_TABLE
 movzx		 r9d,byte ptr [r8+rax]
 add		 r8,r9
 lea         r9,[rcx+8*rdx]
 mov		 r10,-1
 xor		 eax,eax
 jmp         r8
JUMP_TABLE:
db 1 DUP ( CASE_0 - JUMP_TABLE)
db 1 DUP ( CASE_1 - JUMP_TABLE)
db 1 DUP ( CASE_2 - JUMP_TABLE)
db 1 DUP ( CASE_3 - JUMP_TABLE)
db 1 DUP ( CASE_4 - JUMP_TABLE)
db 1 DUP ( CASE_5 - JUMP_TABLE)
db 1 DUP ( CASE_6 - JUMP_TABLE)
db 1 DUP ( CASE_7 - JUMP_TABLE)
db 1 DUP ( CASE_8 - JUMP_TABLE)
db 1 DUP ( CASE_9 - JUMP_TABLE)
db 1 DUP (CASE_10 - JUMP_TABLE)
db 1 DUP (CASE_11 - JUMP_TABLE)
db 1 DUP (CASE_12 - JUMP_TABLE)
db 1 DUP (CASE_13 - JUMP_TABLE)
db 1 DUP (CASE_14 - JUMP_TABLE)
db 1 DUP (CASE_15 - JUMP_TABLE)
CASE_15:
 mov		 r10,qword ptr [r9-120]
CASE_14:
 lea		 ecx,[rdx-14]
 cmp		 r10,qword ptr [r9-112]
 cmova		 r10,qword ptr [r9-112]
 cmova		 eax,ecx
CASE_13:
 lea		 ecx,[rdx-13]
 cmp		 r10,qword ptr [r9-104]
 cmova		 r10,qword ptr [r9-104]
 cmova		 eax,ecx
CASE_12:
 lea		 ecx,[rdx-12]
 cmp		 r10,qword ptr [r9-96]
 cmova		 r10,qword ptr [r9-96]
 cmova		 eax,ecx
CASE_11:
 lea		 ecx,[rdx-11]
 cmp		 r10,qword ptr [r9-88]
 cmova		 r10,qword ptr [r9-88]
 cmova		 eax,ecx
CASE_10:
 lea		 ecx,[rdx-10]
 cmp		 r10,qword ptr [r9-80]
 cmova		 r10,qword ptr [r9-80]
 cmova		 eax,ecx
CASE_9:
 lea		 ecx,[rdx-9]
 cmp		 r10,qword ptr [r9-72]
 cmova		 r10,qword ptr [r9-72]
 cmova		 eax,ecx
CASE_8:
 lea		 ecx,[rdx-8]
 cmp		 r10,qword ptr [r9-64]
 cmova		 r10,qword ptr [r9-64]
 cmova		 eax,ecx
CASE_7:
 lea		 ecx,[rdx-7]
 cmp		 r10,qword ptr [r9-56]
 cmova		 r10,qword ptr [r9-56]
 cmova		 eax,ecx
CASE_6:
 lea		 ecx,[rdx-6]
 cmp		 r10,qword ptr [r9-48]
 cmova		 r10,qword ptr [r9-48]
 cmova		 eax,ecx
CASE_5:
 lea		 ecx,[rdx-5]
 cmp		 r10,qword ptr [r9-40]
 cmova		 r10,qword ptr [r9-40]
 cmova		 eax,ecx
CASE_4:
 lea		 ecx,[rdx-4]
 cmp		 r10,qword ptr [r9-32]
 cmova		 r10,qword ptr [r9-32]
 cmova		 eax,ecx
CASE_3:
 lea		 ecx,[rdx-3]
 cmp		 r10,qword ptr [r9-24]
 cmova		 r10,qword ptr [r9-24]
 cmova		 eax,ecx
CASE_2:
 lea		 ecx,[rdx-2]
 cmp		 r10,qword ptr [r9-16]
 cmova		 r10,qword ptr [r9-16]
 cmova		 eax,ecx
CASE_1:
 lea		 ecx,[rdx-1]
 cmp		 r10,qword ptr [r9-8]
 cmova		 eax,ecx
CASE_0:
 add         rsp,72
 ret

PACKED_SEQ:
dd 0, 1, 4, 5, 2, 3, 6, 7

CASE_LARGE:
 vmovdqu     ymm5,ymmword ptr [PACKED_SEQ]

 ; best indices
 vmovaps     xmmword ptr [rsp],xmm6
 vmovdqa     ymm6,ymm5
 vmovaps     xmmword ptr [rsp+16],xmm7
 vmovdqa     ymm7,ymm5

 vpcmpeqd    ymm0,ymm0,ymm0
 vmovaps     xmmword ptr [rsp+32],xmm8
 ; increment
 vpslld      ymm8,ymm0,4
 ; sign bit
 vpsllq		 ymm0,ymm0,63

 ; best values
 vpxor       ymm1,ymm0,ymmword ptr [rcx]
 vpxor       ymm2,ymm0,ymmword ptr [rcx+32]
 vpxor       ymm3,ymm0,ymmword ptr [rcx+64]
 vpxor       ymm4,ymm0,ymmword ptr [rcx+96]

 vmovaps     xmmword ptr [rsp+48],xmm9
 vmovaps     xmmword ptr [rsp+80],xmm10
 vmovaps     xmmword ptr [rsp+96],xmm11

 vpsubd      ymm5,ymm5,ymm8

 lea         rdx,[rcx+8*rax]
 add         rcx,256
 cmp         rcx,rdx
 jae         LOOP_END

LOOP_TOP:
 vpxor       ymm11,ymm0,ymmword ptr [rcx-128]
 vpcmpgtq    ymm9,ymm1,ymm11
 vpblendvb   ymm1,ymm1,ymm11,ymm9
 vpxor       ymm11,ymm0,ymmword ptr [rcx-96]
 vpcmpgtq    ymm10,ymm2,ymm11
 vpblendvb   ymm2,ymm2,ymm11,ymm10
 vpackssdw   ymm9,ymm9,ymm10
 vpblendvb   ymm6,ymm6,ymm5,ymm9

 vpxor       ymm11,ymm0,ymmword ptr [rcx-64]
 vpcmpgtq    ymm9,ymm3,ymm11
 vpblendvb   ymm3,ymm3,ymm11,ymm9
 vpxor       ymm11,ymm0,ymmword ptr [rcx-32]
 vpcmpgtq    ymm10,ymm4,ymm11
 vpblendvb   ymm4,ymm4,ymm11,ymm10
 vpackssdw   ymm9,ymm9,ymm10
 vpblendvb   ymm7,ymm7,ymm5,ymm9

 vpsubd      ymm5,ymm5,ymm8

 sub         rcx,-128
 cmp         rcx,rdx
 jb          LOOP_TOP

LOOP_END:
 sub		 eax,16
 vmovd		 xmm5,eax
 vpbroadcastd ymm5,xmm5
 vpaddd		 ymm5,ymm5,ymmword ptr [PACKED_SEQ]

 vpxor       ymm11,ymm0,ymmword ptr [rdx-128]
 vpcmpgtq    ymm9,ymm1,ymm11
 vpblendvb   ymm1,ymm1,ymm11,ymm9
 vpxor       ymm11,ymm0,ymmword ptr [rdx-96]
 vpcmpgtq    ymm10,ymm2,ymm11
 vpblendvb   ymm2,ymm2,ymm11,ymm10
 vpackssdw   ymm9,ymm9,ymm10
 vpblendvb   ymm6,ymm6,ymm5,ymm9

 vpxor       ymm11,ymm0,ymmword ptr [rdx-64]
 vpcmpgtq    ymm9,ymm3,ymm11
 vpblendvb   ymm3,ymm3,ymm11,ymm9
 vpxor       ymm11,ymm0,ymmword ptr [rdx-32]
 vpcmpgtq    ymm10,ymm4,ymm11
 vpblendvb   ymm4,ymm4,ymm11,ymm10
 vmovaps     xmm11,xmmword ptr [rsp+96]
 vpackssdw   ymm9,ymm9,ymm10
 vpblendvb   ymm7,ymm7,ymm5,ymm9

 vpcmpgtq    ymm9,ymm1,ymm3
 vpcmpgtq    ymm10,ymm2,ymm4
 vpblendvb   ymm1,ymm1,ymm3,ymm9
 vpblendvb   ymm2,ymm2,ymm4,ymm10
 vpackssdw   ymm3,ymm9,ymm10
 vmovaps     xmm10,xmmword ptr [rsp+80]
 vmovaps     xmm9,xmmword ptr [rsp+48]

 vpsrad      ymm5,ymm8,1
 vmovaps     xmm8,xmmword ptr [rsp+32]

 vpsubd      ymm7,ymm7,ymm5
 vpblendvb   ymm3,ymm6,ymm7,ymm3
 vmovaps     xmm7,xmmword ptr [rsp+16]
 vmovaps     xmm6,xmmword ptr [rsp]

 vpunpckhdq  ymm4,ymm3,ymm3
 vpunpckldq  ymm3,ymm3,ymm3

 vpcmpgtq    ymm5,ymm1,ymm2
 vpblendvb   ymm1,ymm1,ymm2,ymm5
 vpblendvb   ymm3,ymm3,ymm4,ymm5

 vextractf128 xmm2,ymm1,1
 vextracti128 xmm4,ymm3,1

 vpcmpgtq    xmm5,xmm1,xmm2
 vpblendvb   xmm1,xmm1,xmm2,xmm5
 vpblendvb   xmm3,xmm3,xmm4,xmm5

 vpunpckhqdq xmm2,xmm1,xmm1
 vpunpckhqdq xmm4,xmm3,xmm3

 vpcmpgtq    xmm5,xmm1,xmm2
 vpblendvb   xmm0,xmm3,xmm4,xmm5
 vmovd       eax,xmm0

 add         rsp,72
 ret
AsmFastMinIdxU64 ENDP

_TEXT$AsmFastMinIdxU64 ENDS

END
