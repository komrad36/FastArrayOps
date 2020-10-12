; /*******************************************************************
; *
; *    Author: Kareem Omar
; *    kareem.h.omar@gmail.com
; *    https://github.com/komrad36
; *
; *    Last updated Oct 11, 2020
; *******************************************************************/

_TEXT$FastMaxU64 SEGMENT ALIGN(64)

FastMaxU64 PROC
 sub         rsp,56
 vpcmpeqd    ymm1,ymm1,ymm1
 mov         eax,edx
 vpsllq      ymm0,ymm1,63
 cmp         edx,32
 jae         CASE_LARGE
 vmovdqa     ymm1,ymm0
 vmovdqa     ymm2,ymm0
 lea         r8,JUMP_TABLE
 movzx       edx,byte ptr [r8+rax]
 add         r8,rdx
 lea         rdx,[rcx+8*rax]
 and         eax,-4
 lea         rcx,[rcx+8*rax]
 xor         eax,eax
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
CASE_28:
 vpxor       ymm1,ymm0,ymmword ptr [rcx-224]
CASE_24:
 vpxor       ymm2,ymm0,ymmword ptr [rcx-192]
CASE_20:
 vpxor       ymm3,ymm0,ymmword ptr [rcx-160]
 vpcmpgtq    ymm4,ymm3,ymm1
 vpblendvb   ymm1,ymm1,ymm3,ymm4
CASE_16:
 vpxor       ymm3,ymm0,ymmword ptr [rcx-128]
 vpcmpgtq    ymm4,ymm3,ymm2
 vpblendvb   ymm2,ymm2,ymm3,ymm4
CASE_12:
 vpxor       ymm3,ymm0,ymmword ptr [rcx-96]
 vpcmpgtq    ymm4,ymm3,ymm1
 vpblendvb   ymm1,ymm1,ymm3,ymm4
 vpxor       ymm3,ymm0,ymmword ptr [rcx-64]
 vpcmpgtq    ymm4,ymm3,ymm2
 vpblendvb   ymm2,ymm2,ymm3,ymm4
 vpxor       ymm3,ymm0,ymmword ptr [rcx-32]
 vpcmpgtq    ymm4,ymm3,ymm1
 vpblendvb   ymm1,ymm1,ymm3,ymm4
 vpxor       ymm3,ymm0,ymmword ptr [rdx-32]
 vpcmpgtq    ymm4,ymm3,ymm2
 vpblendvb   ymm2,ymm2,ymm3,ymm4
 jmp         GATHER_1
CASE_11:
 mov         rax,qword ptr [rdx-88]
CASE_10:
 cmp         rax,qword ptr [rdx-80]
 cmovb       rax,qword ptr [rdx-80]
CASE_9:
 cmp         rax,qword ptr [rdx-72]
 cmovb       rax,qword ptr [rdx-72]
CASE_8:
 cmp         rax,qword ptr [rdx-64]
 cmovb       rax,qword ptr [rdx-64]
CASE_7:
 cmp         rax,qword ptr [rdx-56]
 cmovb       rax,qword ptr [rdx-56]
CASE_6:
 cmp         rax,qword ptr [rdx-48]
 cmovb       rax,qword ptr [rdx-48]
CASE_5:
 cmp         rax,qword ptr [rdx-40]
 cmovb       rax,qword ptr [rdx-40]
CASE_4:
 cmp         rax,qword ptr [rdx-32]
 cmovb       rax,qword ptr [rdx-32]
CASE_3:
 cmp         rax,qword ptr [rdx-24]
 cmovb       rax,qword ptr [rdx-24]
CASE_2:
 cmp         rax,qword ptr [rdx-16]
 cmovb       rax,qword ptr [rdx-16]
CASE_1:
 cmp         rax,qword ptr [rdx-8]
 cmovb       rax,qword ptr [rdx-8]
CASE_0:
 add         rsp,56
 ret

db 26 DUP (0CCh)

CASE_LARGE:
 vpxor       ymm1,ymm0,ymmword ptr [rcx]
 vpxor       ymm2,ymm0,ymmword ptr [rcx+32]
 vpxor       ymm3,ymm0,ymmword ptr [rcx+64]
 vpxor       ymm4,ymm0,ymmword ptr [rcx+96]
 vpxor       ymm5,ymm0,ymmword ptr [rcx+128]
 vmovaps     xmmword ptr [rsp],xmm6
 vpxor       ymm6,ymm0,ymmword ptr [rcx+160]
 vmovaps     xmmword ptr [rsp+16],xmm7
 vpxor       ymm7,ymm0,ymmword ptr [rcx+192]
 vmovaps     xmmword ptr [rsp+32],xmm8
 vpxor       ymm8,ymm0,ymmword ptr [rcx+224]
 vmovaps     xmmword ptr [rsp+64],xmm9
 vmovaps     xmmword ptr [rsp+80],xmm10

 lea         rdx,[rcx+8*rax]
 add         rcx,512
 cmp         rcx,rdx
 jae         LOOP_END

 LOOP_TOP:
 vpxor       ymm9,ymm0,ymmword ptr [rcx-256]
 vpcmpgtq    ymm10,ymm9,ymm1
 vpblendvb   ymm1,ymm1,ymm9,ymm10
 vpxor       ymm9,ymm0,ymmword ptr [rcx-224]
 vpcmpgtq    ymm10,ymm9,ymm2
 vpblendvb   ymm2,ymm2,ymm9,ymm10
 vpxor       ymm9,ymm0,ymmword ptr [rcx-192]
 vpcmpgtq    ymm10,ymm9,ymm3
 vpblendvb   ymm3,ymm3,ymm9,ymm10
 vpxor       ymm9,ymm0,ymmword ptr [rcx-160]
 vpcmpgtq    ymm10,ymm9,ymm4
 vpblendvb   ymm4,ymm4,ymm9,ymm10
 vpxor       ymm9,ymm0,ymmword ptr [rcx-128]
 vpcmpgtq    ymm10,ymm9,ymm5
 vpblendvb   ymm5,ymm5,ymm9,ymm10
 vpxor       ymm9,ymm0,ymmword ptr [rcx-96]
 vpcmpgtq    ymm10,ymm9,ymm6
 vpblendvb   ymm6,ymm6,ymm9,ymm10
 vpxor       ymm9,ymm0,ymmword ptr [rcx-64]
 vpcmpgtq    ymm10,ymm9,ymm7
 vpblendvb   ymm7,ymm7,ymm9,ymm10
 vpxor       ymm9,ymm0,ymmword ptr [rcx-32]
 vpcmpgtq    ymm10,ymm9,ymm8
 vpblendvb   ymm8,ymm8,ymm9,ymm10
 add         rcx,256
 cmp         rcx,rdx
 jb          LOOP_TOP

 LOOP_END:
 vpxor       ymm9,ymm0,ymmword ptr [rdx-256]
 vpcmpgtq    ymm10,ymm9,ymm1
 vpblendvb   ymm1,ymm1,ymm9,ymm10
 vpxor       ymm9,ymm0,ymmword ptr [rdx-224]
 vpcmpgtq    ymm10,ymm9,ymm2
 vpblendvb   ymm2,ymm2,ymm9,ymm10
 vpxor       ymm9,ymm0,ymmword ptr [rdx-192]
 vpcmpgtq    ymm10,ymm9,ymm3
 vpblendvb   ymm3,ymm3,ymm9,ymm10
 vpxor       ymm9,ymm0,ymmword ptr [rdx-160]
 vpcmpgtq    ymm10,ymm9,ymm4
 vpblendvb   ymm4,ymm4,ymm9,ymm10
 vpxor       ymm9,ymm0,ymmword ptr [rdx-128]
 vpcmpgtq    ymm10,ymm9,ymm5
 vpblendvb   ymm5,ymm5,ymm9,ymm10
 vpxor       ymm9,ymm0,ymmword ptr [rdx-96]
 vpcmpgtq    ymm10,ymm9,ymm6
 vpblendvb   ymm6,ymm6,ymm9,ymm10
 vpxor       ymm9,ymm0,ymmword ptr [rdx-64]
 vpcmpgtq    ymm10,ymm9,ymm7
 vpblendvb   ymm7,ymm7,ymm9,ymm10
 vpxor       ymm9,ymm0,ymmword ptr [rdx-32]
 vpcmpgtq    ymm10,ymm9,ymm8
 vpblendvb   ymm8,ymm8,ymm9,ymm10
 vmovaps     xmm10,xmmword ptr [rsp+80]
 vmovaps     xmm9,xmmword ptr [rsp+64]

 vpcmpgtq    ymm0,ymm8,ymm4
 vpblendvb   ymm4,ymm4,ymm8,ymm0
 vmovaps     xmm8,xmmword ptr [rsp+32]
 vpcmpgtq    ymm0,ymm7,ymm3
 vpblendvb   ymm3,ymm3,ymm7,ymm0
 vmovaps     xmm7,xmmword ptr [rsp+16]
 vpcmpgtq    ymm0,ymm6,ymm2
 vpblendvb   ymm2,ymm2,ymm6,ymm0
 vmovaps     xmm6,xmmword ptr [rsp]
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
 btc         rax,63
 add         rsp,56
 ret
FastMaxU64 ENDP

_TEXT$FastMaxU64 ENDS

END
