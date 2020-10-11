_TEXT$AsmFastMaxIdxI64 SEGMENT ALIGN(64)

AsmFastMaxIdxI64 PROC
 sub		 rsp,56
 mov         eax,edx
 cmp         edx,16
 jae         CASE_LARGE
 lea		 r8,JUMP_TABLE
 movzx		 r9d,byte ptr [r8+rax]
 add		 r8,r9
 lea         r9,[rcx+8*rax]
 mov		 r10,08000000000000000h
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
 cmovl		 r10,qword ptr [r9-112]
 cmovl		 eax,ecx
CASE_13:
 lea		 ecx,[rdx-13]
 cmp		 r10,qword ptr [r9-104]
 cmovl		 r10,qword ptr [r9-104]
 cmovl		 eax,ecx
CASE_12:
 lea		 ecx,[rdx-12]
 cmp		 r10,qword ptr [r9-96]
 cmovl		 r10,qword ptr [r9-96]
 cmovl		 eax,ecx
CASE_11:
 lea		 ecx,[rdx-11]
 cmp		 r10,qword ptr [r9-88]
 cmovl		 r10,qword ptr [r9-88]
 cmovl		 eax,ecx
CASE_10:
 lea		 ecx,[rdx-10]
 cmp		 r10,qword ptr [r9-80]
 cmovl		 r10,qword ptr [r9-80]
 cmovl		 eax,ecx
CASE_9:
 lea		 ecx,[rdx-9]
 cmp		 r10,qword ptr [r9-72]
 cmovl		 r10,qword ptr [r9-72]
 cmovl		 eax,ecx
CASE_8:
 lea		 ecx,[rdx-8]
 cmp		 r10,qword ptr [r9-64]
 cmovl		 r10,qword ptr [r9-64]
 cmovl		 eax,ecx
CASE_7:
 lea		 ecx,[rdx-7]
 cmp		 r10,qword ptr [r9-56]
 cmovl		 r10,qword ptr [r9-56]
 cmovl		 eax,ecx
CASE_6:
 lea		 ecx,[rdx-6]
 cmp		 r10,qword ptr [r9-48]
 cmovl		 r10,qword ptr [r9-48]
 cmovl		 eax,ecx
CASE_5:
 lea		 ecx,[rdx-5]
 cmp		 r10,qword ptr [r9-40]
 cmovl		 r10,qword ptr [r9-40]
 cmovl		 eax,ecx
CASE_4:
 lea		 ecx,[rdx-4]
 cmp		 r10,qword ptr [r9-32]
 cmovl		 r10,qword ptr [r9-32]
 cmovl		 eax,ecx
CASE_3:
 lea		 ecx,[rdx-3]
 cmp		 r10,qword ptr [r9-24]
 cmovl		 r10,qword ptr [r9-24]
 cmovl		 eax,ecx
CASE_2:
 lea		 ecx,[rdx-2]
 cmp		 r10,qword ptr [r9-16]
 cmovl		 r10,qword ptr [r9-16]
 cmovl		 eax,ecx
CASE_1:
 lea		 ecx,[rdx-1]
 cmp		 r10,qword ptr [r9-8]
 cmovl		 eax,ecx
CASE_0:
 add         rsp,56
 ret

PACKED_SEQ:
dd 0, 1, 4, 5, 2, 3, 6, 7

CASE_LARGE:
 vmovdqu     ymm4,ymmword ptr [PACKED_SEQ]

 ; best values
 vmovdqu     ymm0,ymmword ptr [rcx]
 vmovdqu     ymm1,ymmword ptr [rcx+32]
 vmovdqu     ymm2,ymmword ptr [rcx+64]
 vmovdqu     ymm3,ymmword ptr [rcx+96]

 ; best indices
 vmovdqa     ymm5,ymm4
 vmovaps     xmmword ptr [rsp],xmm6
 vmovdqa     ymm6,ymm4

 ; increment
 vmovaps     xmmword ptr [rsp+16],xmm7
 vpcmpeqd    ymm7,ymm7,ymm7
 vpslld      ymm7,ymm7,4

 vmovaps     xmmword ptr [rsp+32],xmm8
 vmovaps     xmmword ptr [rsp+64],xmm9
 vmovaps     xmmword ptr [rsp+80],xmm10

 vpsubd      ymm4,ymm4,ymm7

 lea         rdx,[rcx+8*rax]
 add         rcx,256
 cmp         rcx,rdx
 jae         LOOP_END

LOOP_TOP:
 vmovdqu     ymm8,ymmword ptr [rcx-128]
 vpcmpgtq    ymm9,ymm8,ymm0
 vpblendvb   ymm0,ymm0,ymm8,ymm9
 vmovdqu     ymm8,ymmword ptr [rcx-96]
 vpcmpgtq    ymm10,ymm8,ymm1
 vpblendvb   ymm1,ymm1,ymm8,ymm10
 vpackssdw   ymm9,ymm9,ymm10
 vpblendvb   ymm5,ymm5,ymm4,ymm9

 vmovdqu     ymm8,ymmword ptr [rcx-64]
 vpcmpgtq    ymm9,ymm8,ymm2
 vpblendvb   ymm2,ymm2,ymm8,ymm9
 vmovdqu     ymm8,ymmword ptr [rcx-32]
 vpcmpgtq    ymm10,ymm8,ymm3
 vpblendvb   ymm3,ymm3,ymm8,ymm10
 vpackssdw   ymm9,ymm9,ymm10
 vpblendvb   ymm6,ymm6,ymm4,ymm9

 vpsubd      ymm4,ymm4,ymm7

 sub         rcx,-128
 cmp         rcx,rdx
 jb          LOOP_TOP

LOOP_END:
 sub		 eax,16
 vmovd		 xmm4,eax
 vpbroadcastd ymm4,xmm4
 vpaddd		 ymm4,ymm4,ymmword ptr [PACKED_SEQ]

 vmovdqu     ymm8,ymmword ptr [rdx-128]
 vpcmpgtq    ymm9,ymm8,ymm0
 vpblendvb   ymm0,ymm0,ymm8,ymm9
 vmovdqu     ymm8,ymmword ptr [rdx-96]
 vpcmpgtq    ymm10,ymm8,ymm1
 vpblendvb   ymm1,ymm1,ymm8,ymm10
 vpackssdw   ymm9,ymm9,ymm10
 vpblendvb   ymm5,ymm5,ymm4,ymm9

 vmovdqu     ymm8,ymmword ptr [rdx-64]
 vpcmpgtq    ymm9,ymm8,ymm2
 vpblendvb   ymm2,ymm2,ymm8,ymm9
 vmovdqu     ymm8,ymmword ptr [rdx-32]
 vpcmpgtq    ymm10,ymm8,ymm3
 vpblendvb   ymm3,ymm3,ymm8,ymm10
 vpackssdw   ymm9,ymm9,ymm10
 vmovaps     xmm10,xmmword ptr [rsp+80]
 vpblendvb   ymm6,ymm6,ymm4,ymm9

 vpcmpgtq    ymm8,ymm2,ymm0
 vpcmpgtq    ymm9,ymm3,ymm1
 vpblendvb   ymm0,ymm0,ymm2,ymm8
 vpblendvb   ymm1,ymm1,ymm3,ymm9
 vpackssdw   ymm2,ymm8,ymm9

 vmovaps     xmm9,xmmword ptr [rsp+64]
 vmovaps     xmm8,xmmword ptr [rsp+32]

 vpsrad      ymm4,ymm7,1
 vmovaps     xmm7,xmmword ptr [rsp+16]

 vpsubd      ymm6,ymm6,ymm4
 vpblendvb   ymm2,ymm5,ymm6,ymm2
 vmovaps     xmm6,xmmword ptr [rsp]

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

 add         rsp,56
 ret
AsmFastMaxIdxI64 ENDP

_TEXT$AsmFastMaxIdxI64 ENDS

END
