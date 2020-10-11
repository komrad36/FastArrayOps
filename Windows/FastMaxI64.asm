_TEXT$AsmFastMaxI64 SEGMENT ALIGN(64)

AsmFastMaxI64 PROC
 sub         rsp,40
 mov         eax,edx
 cmp         edx,32
 jae         CASE_LARGE
 vpcmpeqq    ymm0,ymm0,ymm0
 vpsllq      ymm0,ymm0,63
 lea         r8,JUMP_TABLE
 movzx       edx,byte ptr [r8+rax]
 add         r8,rdx
 vmovdqa     ymm1,ymm0
 lea         rdx,[rcx+8*rax]
 and         eax,-4
 lea         rcx,[rcx+8*rax]
 mov         rax,08000000000000000h
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
db 4 DUP (CASE_12 - JUMP_TABLE)
db 4 DUP (CASE_16 - JUMP_TABLE)
db 4 DUP (CASE_20 - JUMP_TABLE)
db 4 DUP (CASE_24 - JUMP_TABLE)
db 4 DUP (CASE_28 - JUMP_TABLE)
db 4 DUP (0CCh)
CASE_28:
 vmovdqu     ymm0,ymmword ptr [rcx-224]
CASE_24:
 vmovdqu     ymm1,ymmword ptr [rcx-192]
CASE_20:
 vmovdqu     ymm2,ymmword ptr [rcx-160]
 vpcmpgtq    ymm4,ymm2,ymm0
 vpblendvb   ymm0,ymm0,ymm2,ymm4
CASE_16:
 vmovdqu     ymm2,ymmword ptr [rcx-128]
 vpcmpgtq    ymm4,ymm2,ymm1
 vpblendvb   ymm1,ymm1,ymm2,ymm4
CASE_12:
 vmovdqu     ymm2,ymmword ptr [rcx-96]
 vpcmpgtq    ymm4,ymm2,ymm0
 vpblendvb   ymm0,ymm0,ymm2,ymm4
 vmovdqu     ymm2,ymmword ptr [rcx-64]
 vpcmpgtq    ymm4,ymm2,ymm1
 vpblendvb   ymm1,ymm1,ymm2,ymm4
 vmovdqu     ymm2,ymmword ptr [rcx-32]
 vpcmpgtq    ymm4,ymm2,ymm0
 vpblendvb   ymm0,ymm0,ymm2,ymm4
 vmovdqu     ymm2,ymmword ptr [rdx-32]
 vpcmpgtq    ymm4,ymm2,ymm1
 vpblendvb   ymm1,ymm1,ymm2,ymm4
 jmp GATHER_1
CASE_11:
 mov         rax,qword ptr [rdx-88]
CASE_10:
 cmp         rax,qword ptr [rdx-80]
 cmovl       rax,qword ptr [rdx-80]
CASE_9:
 cmp         rax,qword ptr [rdx-72]
 cmovl       rax,qword ptr [rdx-72]
CASE_8:
 cmp         rax,qword ptr [rdx-64]
 cmovl       rax,qword ptr [rdx-64]
CASE_7:
 cmp         rax,qword ptr [rdx-56]
 cmovl       rax,qword ptr [rdx-56]
CASE_6:
 cmp         rax,qword ptr [rdx-48]
 cmovl       rax,qword ptr [rdx-48]
CASE_5:
 cmp         rax,qword ptr [rdx-40]
 cmovl       rax,qword ptr [rdx-40]
CASE_4:
 cmp         rax,qword ptr [rdx-32]
 cmovl       rax,qword ptr [rdx-32]
CASE_3:
 cmp         rax,qword ptr [rdx-24]
 cmovl       rax,qword ptr [rdx-24]
CASE_2:
 cmp         rax,qword ptr [rdx-16]
 cmovl       rax,qword ptr [rdx-16]
CASE_1:
 cmp         rax,qword ptr [rdx-8]
 cmovl       rax,qword ptr [rdx-8]
CASE_0:
 add         rsp,40
 ret

CASE_LARGE:
 vmovdqu     ymm0,ymmword ptr [rcx]
 vmovdqu     ymm1,ymmword ptr [rcx+32]
 vmovdqu     ymm2,ymmword ptr [rcx+64]
 vmovdqu     ymm3,ymmword ptr [rcx+96]
 vmovdqu     ymm4,ymmword ptr [rcx+128]
 vmovdqu     ymm5,ymmword ptr [rcx+160]
 vmovaps     xmmword ptr [rsp],xmm6
 vmovdqu     ymm6,ymmword ptr [rcx+192]
 vmovaps     xmmword ptr [rsp+16],xmm7
 vmovdqu     ymm7,ymmword ptr [rcx+224]

 vmovaps     xmmword ptr [rsp+48],xmm8
 vmovaps     xmmword ptr [rsp+64],xmm9

 lea         rdx,[rcx+8*rax]
 add         rcx,512
 cmp         rcx,rdx
 jae         LOOP_END

 LOOP_TOP:
 vmovdqu     ymm9,ymmword ptr [rcx-256]
 vpcmpgtq    ymm8,ymm9,ymm0
 vpblendvb   ymm0,ymm0,ymm9,ymm8
 vmovdqu     ymm9,ymmword ptr [rcx-224]
 vpcmpgtq    ymm8,ymm9,ymm1
 vpblendvb   ymm1,ymm1,ymm9,ymm8
 vmovdqu     ymm9,ymmword ptr [rcx-192]
 vpcmpgtq    ymm8,ymm9,ymm2
 vpblendvb   ymm2,ymm2,ymm9,ymm8
 vmovdqu     ymm9,ymmword ptr [rcx-160]
 vpcmpgtq    ymm8,ymm9,ymm3
 vpblendvb   ymm3,ymm3,ymm9,ymm8
 vmovdqu     ymm9,ymmword ptr [rcx-128]
 vpcmpgtq    ymm8,ymm9,ymm4
 vpblendvb   ymm4,ymm4,ymm9,ymm8
 vmovdqu     ymm9,ymmword ptr [rcx-96]
 vpcmpgtq    ymm8,ymm9,ymm5
 vpblendvb   ymm5,ymm5,ymm9,ymm8
 vmovdqu     ymm9,ymmword ptr [rcx-64]
 vpcmpgtq    ymm8,ymm9,ymm6
 vpblendvb   ymm6,ymm6,ymm9,ymm8
 vmovdqu     ymm9,ymmword ptr [rcx-32]
 vpcmpgtq    ymm8,ymm9,ymm7
 vpblendvb   ymm7,ymm7,ymm9,ymm8

 add         rcx,256
 cmp         rcx,rdx
 jb          LOOP_TOP

 LOOP_END:
 vmovdqu     ymm9,ymmword ptr [rdx-256]
 vpcmpgtq    ymm8,ymm9,ymm0
 vpblendvb   ymm0,ymm0,ymm9,ymm8
 vmovdqu     ymm9,ymmword ptr [rdx-224]
 vpcmpgtq    ymm8,ymm9,ymm1
 vpblendvb   ymm1,ymm1,ymm9,ymm8
 vmovdqu     ymm9,ymmword ptr [rdx-192]
 vpcmpgtq    ymm8,ymm9,ymm2
 vpblendvb   ymm2,ymm2,ymm9,ymm8
 vmovdqu     ymm9,ymmword ptr [rdx-160]
 vpcmpgtq    ymm8,ymm9,ymm3
 vpblendvb   ymm3,ymm3,ymm9,ymm8
 vmovdqu     ymm9,ymmword ptr [rdx-128]
 vpcmpgtq    ymm8,ymm9,ymm4
 vpblendvb   ymm4,ymm4,ymm9,ymm8
 vmovdqu     ymm9,ymmword ptr [rdx-96]
 vpcmpgtq    ymm8,ymm9,ymm5
 vpblendvb   ymm5,ymm5,ymm9,ymm8
 vmovdqu     ymm9,ymmword ptr [rdx-64]
 vpcmpgtq    ymm8,ymm9,ymm6
 vpblendvb   ymm6,ymm6,ymm9,ymm8
 vmovdqu     ymm9,ymmword ptr [rdx-32]
 vpcmpgtq    ymm8,ymm9,ymm7
 vpblendvb   ymm7,ymm7,ymm9,ymm8
 vmovaps     xmm9,xmmword ptr [rsp+64]

 vpcmpgtq    ymm8,ymm4,ymm0
 vpblendvb   ymm0,ymm0,ymm4,ymm8
 vpcmpgtq    ymm8,ymm5,ymm1
 vpblendvb   ymm1,ymm1,ymm5,ymm8
 vpcmpgtq    ymm8,ymm6,ymm2
 vpblendvb   ymm2,ymm2,ymm6,ymm8
 vpcmpgtq    ymm8,ymm7,ymm3
 vpblendvb   ymm3,ymm3,ymm7,ymm8
 vmovaps     xmm8,xmmword ptr [rsp+48]
 vmovaps     xmm7,xmmword ptr [rsp+16]
 vmovaps     xmm6,xmmword ptr [rsp]

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
 add         rsp,40
 ret
AsmFastMaxI64 ENDP

_TEXT$AsmFastMaxI64 ENDS

END
