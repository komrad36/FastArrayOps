; /*******************************************************************
; *
; *    Author: Kareem Omar
; *    kareem.h.omar@gmail.com
; *    https://github.com/komrad36
; *
; *    Last updated Oct 11, 2020
; *******************************************************************/

_TEXT$FastMaxIdxI16 SEGMENT ALIGN(64)

FastMaxIdxI16 PROC
 sub         rsp,136
 vmovdqu     ymm4,ymmword ptr [SEQ]
 mov         eax,edx
 cmp         edx,127
 ja          CASE_LARGE
 vpcmpeqd    ymm0,ymm0,ymm0
 lea         r8,JUMP_TABLE
 vpsllw      ymm2,ymm0,4
 vpsllw      ymm0,ymm0,15
 vmovdqa     ymm1,ymm0
 vmovdqa     ymm3,ymm4
 movzx       r9d,word ptr [r8+2*rax]
 add         r8,r9
 lea         r9,[rcx+2*rax]
 mov         r10w,08000h
 and         eax,-16
 lea         rcx,[rcx+2*rax]
 jmp         r8
SEQ:
dw 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
JUMP_TABLE:
dw  1 DUP (  CASE_0 - JUMP_TABLE)
dw  1 DUP (  CASE_1 - JUMP_TABLE)
dw  1 DUP (  CASE_2 - JUMP_TABLE)
dw  1 DUP (  CASE_3 - JUMP_TABLE)
dw  1 DUP (  CASE_4 - JUMP_TABLE)
dw  1 DUP (  CASE_5 - JUMP_TABLE)
dw  1 DUP (  CASE_6 - JUMP_TABLE)
dw  1 DUP (  CASE_7 - JUMP_TABLE)
dw  8 DUP (  CASE_8 - JUMP_TABLE)
dw 16 DUP ( CASE_16 - JUMP_TABLE)
dw 16 DUP ( CASE_32 - JUMP_TABLE)
dw 16 DUP ( CASE_48 - JUMP_TABLE)
dw 16 DUP ( CASE_64 - JUMP_TABLE)
dw 16 DUP ( CASE_80 - JUMP_TABLE)
dw 16 DUP ( CASE_96 - JUMP_TABLE)
dw 16 DUP (CASE_112 - JUMP_TABLE)
CASE_112:
 vmovdqu     ymm1,ymmword ptr [rcx-224]
 vpsubw      ymm4,ymm4,ymm2
CASE_96:
 vpmaxsw     ymm0,ymm1,ymmword ptr [rcx-192]
 vpcmpeqw    ymm1,ymm0,ymm1
 vpblendvb   ymm3,ymm4,ymm3,ymm1
 vpsubw      ymm4,ymm4,ymm2
CASE_80:
 vpmaxsw     ymm1,ymm0,ymmword ptr [rcx-160]
 vpcmpeqw    ymm0,ymm0,ymm1
 vpblendvb   ymm3,ymm4,ymm3,ymm0
 vpsubw      ymm4,ymm4,ymm2
CASE_64:
 vpmaxsw     ymm0,ymm1,ymmword ptr [rcx-128]
 vpcmpeqw    ymm1,ymm0,ymm1
 vpblendvb   ymm3,ymm4,ymm3,ymm1
 vpsubw      ymm4,ymm4,ymm2
CASE_48:
 vpmaxsw     ymm1,ymm0,ymmword ptr [rcx-96]
 vpcmpeqw    ymm0,ymm0,ymm1
 vpblendvb   ymm3,ymm4,ymm3,ymm0
 vpsubw      ymm4,ymm4,ymm2
CASE_32:
 vpmaxsw     ymm0,ymm1,ymmword ptr [rcx-64]
 vpcmpeqw    ymm1,ymm0,ymm1
 vpblendvb   ymm3,ymm4,ymm3,ymm1
 vpsubw      ymm4,ymm4,ymm2
CASE_16:
 vpmaxsw     ymm1,ymm0,ymmword ptr [rcx-32]
 vpcmpeqw    ymm0,ymm0,ymm1
 vpblendvb   ymm3,ymm4,ymm3,ymm0
 lea         ecx,[rdx-16]
 vmovd       xmm4,ecx
 vpbroadcastw ymm4,xmm4
 vpaddw      ymm4,ymm4,ymmword ptr [SEQ]
 vpmaxsw     ymm0,ymm1,ymmword ptr [r9-32]
 vpcmpeqw    ymm1,ymm0,ymm1
 vpblendvb   ymm2,ymm4,ymm3,ymm1
 vextracti128 xmm1,ymm0,1
 vextracti128 xmm3,ymm2,1
 vpmaxsw     xmm0,xmm0,xmm1
 vpcmpeqw    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm2,xmm3,xmm1
 vpunpckhqdq xmm1,xmm0,xmm0
 vpunpckhqdq xmm3,xmm2,xmm2
 vpmaxsw     xmm0,xmm0,xmm1
 vpcmpeqw    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm2,xmm3,xmm1
 vmovshdup   xmm1,xmm0
 vmovshdup   xmm3,xmm2
 vpmaxsw     xmm0,xmm0,xmm1
 vpcmpeqw    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm2,xmm3,xmm1
 vpshuflw    xmm1,xmm0,225
 vpshuflw    xmm3,xmm2,225
 vpcmpgtw    xmm0,xmm1,xmm0
 vpblendvb   xmm0,xmm2,xmm3,xmm0
 vmovd       eax,xmm0
 cwde
 add         rsp,136
 ret
CASE_8:
 vpmaxsw     xmm1,xmm0,xmmword ptr [rcx]
 vpcmpeqw    xmm0,xmm0,xmm1
 vpblendvb   xmm3,xmm4,xmm3,xmm0
 lea         ecx,[rdx-8]
 vmovd       xmm4,ecx
 vpbroadcastw xmm4,xmm4
 vpaddw      xmm4,xmm4,xmmword ptr [SEQ]
 vpmaxsw     xmm0,xmm1,xmmword ptr [r9-16]
 vpcmpeqw    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm4,xmm3,xmm1
 vpunpckhqdq xmm1,xmm0,xmm0
 vpunpckhqdq xmm3,xmm2,xmm2
 vpmaxsw     xmm0,xmm0,xmm1
 vpcmpeqw    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm2,xmm3,xmm1
 vmovshdup   xmm1,xmm0
 vmovshdup   xmm3,xmm2
 vpmaxsw     xmm0,xmm0,xmm1
 vpcmpeqw    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm2,xmm3,xmm1
 vpshuflw    xmm1,xmm0,225
 vpshuflw    xmm3,xmm2,225
 vpcmpgtw    xmm0,xmm1,xmm0
 vpblendvb   xmm0,xmm2,xmm3,xmm0
 vmovd       eax,xmm0
 cwde
 add         rsp,136
 ret
CASE_7:
 mov         r10w,word ptr [r9-14]
CASE_6:
 lea         ecx,[rdx-6]
 cmp         r10w,word ptr [r9-12]
 cmovl       r10w,word ptr [r9-12]
 cmovl       eax,ecx
CASE_5:
 lea         ecx,[rdx-5]
 cmp         r10w,word ptr [r9-10]
 cmovl       r10w,word ptr [r9-10]
 cmovl       eax,ecx
CASE_4:
 lea         ecx,[rdx-4]
 cmp         r10w,word ptr [r9-8]
 cmovl       r10w,word ptr [r9-8]
 cmovl       eax,ecx
CASE_3:
 lea         ecx,[rdx-3]
 cmp         r10w,word ptr [r9-6]
 cmovl       r10w,word ptr [r9-6]
 cmovl       eax,ecx
CASE_2:
 lea         ecx,[rdx-2]
 cmp         r10w,word ptr [r9-4]
 cmovl       r10w,word ptr [r9-4]
 cmovl       eax,ecx
CASE_1:
 lea         ecx,[rdx-1]
 cmp         r10w,word ptr [r9-2]
 cmovl       eax,ecx
CASE_0:
 add         rsp,136
 ret

CASE_LARGE:
 cmp         eax,0FFFFh
 ja          CASE_VERY_LARGE

 ; best indices
 vmovdqa     ymm5,ymm4
 vmovaps     xmmword ptr [rsp],xmm6
 vmovdqa     ymm6,ymm4
 vmovaps     xmmword ptr [rsp+16],xmm7
 vmovdqa     ymm7,ymm4
 vmovaps     xmmword ptr [rsp+32],xmm8
 vmovdqa     ymm8,ymm4

 ; increment
 vmovaps     xmmword ptr [rsp+48],xmm9
 vpcmpeqd    ymm9,ymm9,ymm9
 vpsllw      ymm9,ymm9,6

 ; best values
 vmovaps     xmmword ptr [rsp+64],xmm10
 vmovdqu     ymm10,ymmword ptr [rcx]
 vmovaps     xmmword ptr [rsp+80],xmm11
 vmovdqu     ymm11,ymmword ptr [rcx+32]
 vmovaps     xmmword ptr [rsp+96],xmm12
 vmovdqu     ymm12,ymmword ptr [rcx+64]
 vmovaps     xmmword ptr [rsp+112],xmm13
 vmovdqu     ymm13,ymmword ptr [rcx+96]

 vpsubw      ymm4,ymm4,ymm9

 vpmaxsw     ymm0,ymm10,ymmword ptr [rcx+128]
 vpmaxsw     ymm1,ymm11,ymmword ptr [rcx+160]
 vpmaxsw     ymm2,ymm12,ymmword ptr [rcx+192]
 vpmaxsw     ymm3,ymm13,ymmword ptr [rcx+224]
 vpcmpeqw    ymm10,ymm0,ymm10
 vpblendvb   ymm5,ymm4,ymm5,ymm10
 vpcmpeqw    ymm11,ymm1,ymm11
 vpblendvb   ymm6,ymm4,ymm6,ymm11
 vpcmpeqw    ymm12,ymm2,ymm12
 vpblendvb   ymm7,ymm4,ymm7,ymm12
 vpcmpeqw    ymm13,ymm3,ymm13
 vpblendvb   ymm8,ymm4,ymm8,ymm13

 vpsubw      ymm4,ymm4,ymm9

 lea         rdx,[rcx+2*rax]
 add         rcx,512
 cmp         rcx,rdx
 jae         LOOP_END

LOOP_TOP:
 vpmaxsw     ymm10,ymm0,ymmword ptr [rcx-256]
 vpmaxsw     ymm11,ymm1,ymmword ptr [rcx-224]
 vpmaxsw     ymm12,ymm2,ymmword ptr [rcx-192]
 vpmaxsw     ymm13,ymm3,ymmword ptr [rcx-160]
 vpcmpeqw    ymm0,ymm0,ymm10
 vpblendvb   ymm5,ymm4,ymm5,ymm0
 vpmaxsw     ymm0,ymm10,ymmword ptr [rcx-128]
 vpcmpeqw    ymm1,ymm1,ymm11
 vpblendvb   ymm6,ymm4,ymm6,ymm1
 vpmaxsw     ymm1,ymm11,ymmword ptr [rcx-96]
 vpcmpeqw    ymm2,ymm2,ymm12
 vpblendvb   ymm7,ymm4,ymm7,ymm2
 vpmaxsw     ymm2,ymm12,ymmword ptr [rcx-64]
 vpcmpeqw    ymm3,ymm3,ymm13
 vpblendvb   ymm8,ymm4,ymm8,ymm3
 vpmaxsw     ymm3,ymm13,ymmword ptr [rcx-32]
 vpsubw      ymm4,ymm4,ymm9
 vpcmpeqw    ymm10,ymm0,ymm10
 vpblendvb   ymm5,ymm4,ymm5,ymm10
 vpcmpeqw    ymm11,ymm1,ymm11
 vpblendvb   ymm6,ymm4,ymm6,ymm11
 vpcmpeqw    ymm12,ymm2,ymm12
 vpblendvb   ymm7,ymm4,ymm7,ymm12
 vpcmpeqw    ymm13,ymm3,ymm13
 vpblendvb   ymm8,ymm4,ymm8,ymm13

 vpsubw      ymm4,ymm4,ymm9
 add         rcx,256
 cmp         rcx,rdx
 jb          LOOP_TOP

LOOP_END:
 add         eax,-128
 vmovd       xmm4,eax
 vpbroadcastw ymm4,xmm4
 vpaddw      ymm4,ymm4,ymmword ptr [SEQ]

 vpmaxsw     ymm10,ymm0,ymmword ptr [rdx-256]
 vpmaxsw     ymm11,ymm1,ymmword ptr [rdx-224]
 vpmaxsw     ymm12,ymm2,ymmword ptr [rdx-192]
 vpmaxsw     ymm13,ymm3,ymmword ptr [rdx-160]
 vpcmpeqw    ymm0,ymm0,ymm10
 vpblendvb   ymm5,ymm4,ymm5,ymm0
 vpmaxsw     ymm0,ymm10,ymmword ptr [rdx-128]
 vpcmpeqw    ymm1,ymm1,ymm11
 vpblendvb   ymm6,ymm4,ymm6,ymm1
 vpmaxsw     ymm1,ymm11,ymmword ptr [rdx-96]
 vpcmpeqw    ymm2,ymm2,ymm12
 vpblendvb   ymm7,ymm4,ymm7,ymm2
 vpmaxsw     ymm2,ymm12,ymmword ptr [rdx-64]
 vpcmpeqw    ymm3,ymm3,ymm13
 vpblendvb   ymm8,ymm4,ymm8,ymm3
 vpmaxsw     ymm3,ymm13,ymmword ptr [rdx-32]
 vpsubw      ymm4,ymm4,ymm9
 vpcmpeqw    ymm13,ymm3,ymm13
 vpblendvb   ymm8,ymm4,ymm8,ymm13
 vmovaps     xmm13,xmmword ptr [rsp+112]
 vpcmpeqw    ymm12,ymm2,ymm12
 vpblendvb   ymm7,ymm4,ymm7,ymm12
 vmovaps     xmm12,xmmword ptr [rsp+96]
 vpcmpeqw    ymm11,ymm1,ymm11
 vpblendvb   ymm6,ymm4,ymm6,ymm11
 vmovaps     xmm11,xmmword ptr [rsp+80]
 vpcmpeqw    ymm10,ymm0,ymm10
 vpblendvb   ymm5,ymm4,ymm5,ymm10
 vmovaps     xmm10,xmmword ptr [rsp+64]

 vpsraw      ymm4,ymm9,1
 vmovaps     xmm9,xmmword ptr [rsp+48]

 vpmaxsw     ymm1,ymm1,ymm3
 vpcmpeqw    ymm3,ymm1,ymm3
 vpsubw      ymm8,ymm8,ymm4
 vpblendvb   ymm6,ymm6,ymm8,ymm3
 vmovaps     xmm8,xmmword ptr [rsp+32]

 vpmaxsw     ymm0,ymm0,ymm2
 vpcmpeqw    ymm2,ymm0,ymm2
 vpsubw      ymm7,ymm7,ymm4
 vpblendvb   ymm5,ymm5,ymm7,ymm2
 vmovaps     xmm7,xmmword ptr [rsp+16]

 vpsraw      ymm4,ymm4,1

 vpmaxsw     ymm0,ymm0,ymm1
 vpcmpeqw    ymm1,ymm0,ymm1
 vpsubw      ymm6,ymm6,ymm4
 vpblendvb   ymm2,ymm5,ymm6,ymm1
 vmovaps     xmm6,xmmword ptr [rsp]

 vextracti128 xmm1,ymm0,1
 vextracti128 xmm3,ymm2,1

 vpmaxsw     xmm0,xmm0,xmm1
 vpcmpeqw    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm2,xmm3,xmm1

 vpunpckhqdq xmm1,xmm0,xmm0
 vpunpckhqdq xmm3,xmm2,xmm2

 vpmaxsw     xmm0,xmm0,xmm1
 vpcmpeqw    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm2,xmm3,xmm1

 vmovshdup   xmm1,xmm0
 vmovshdup   xmm3,xmm2

 vpmaxsw     xmm0,xmm0,xmm1
 vpcmpeqw    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm2,xmm3,xmm1

 vpshuflw    xmm1,xmm0,225
 vpshuflw    xmm3,xmm2,225

 vpcmpgtw    xmm0,xmm1,xmm0
 vpblendvb   xmm0,xmm2,xmm3,xmm0
 vmovd       eax,xmm0
 movzx       eax,ax

 add         rsp,136
 ret

CASE_VERY_LARGE:

 lea         rdx,[rcx+2*rax]
 add         rcx,256

 vmovaps     xmmword ptr [rsp],xmm6
 vmovaps     xmmword ptr [rsp+16],xmm7
 vmovaps     xmmword ptr [rsp+32],xmm8
 vmovaps     xmmword ptr [rsp+48],xmm9
 vmovaps     xmmword ptr [rsp+64],xmm10
 vmovaps     xmmword ptr [rsp+80],xmm11
 vmovaps     xmmword ptr [rsp+96],xmm12
 vmovaps     xmmword ptr [rsp+112],xmm13
 vmovaps     xmmword ptr [rsp+144],xmm14
 vmovaps     xmmword ptr [rsp+160],xmm15

 ; outer i
 xor         r9d,r9d

 ; outer best values
 vpcmpeqd    ymm14,ymm14,ymm14
 vpsllw      ymm14,ymm14,15

 ; outer best indices
 vpxor       xmm15,xmm15,xmm15

 ; increment
 vpcmpeqd    ymm9,ymm9,ymm9
 vpsllw      ymm9,ymm9,6

OUTER_LOOP_TOP:

 ; best indices
 vmovdqa     ymm5,ymm4
 vmovdqa     ymm6,ymm4
 vmovdqa     ymm7,ymm4
 vmovdqa     ymm8,ymm4

 ; best values
 vmovdqu     ymm10,ymmword ptr [rcx-256]
 vmovdqu     ymm11,ymmword ptr [rcx-224]
 vmovdqu     ymm12,ymmword ptr [rcx-192]
 vmovdqu     ymm13,ymmword ptr [rcx-160]

 vpsubw      ymm4,ymm4,ymm9

 vpmaxsw     ymm0,ymm10,ymmword ptr [rcx-128]
 vpmaxsw     ymm1,ymm11,ymmword ptr [rcx-96]
 vpmaxsw     ymm2,ymm12,ymmword ptr [rcx-64]
 vpmaxsw     ymm3,ymm13,ymmword ptr [rcx-32]
 vpcmpeqw    ymm10,ymm0,ymm10
 vpblendvb   ymm5,ymm4,ymm5,ymm10
 vpcmpeqw    ymm11,ymm1,ymm11
 vpblendvb   ymm6,ymm4,ymm6,ymm11
 vpcmpeqw    ymm12,ymm2,ymm12
 vpblendvb   ymm7,ymm4,ymm7,ymm12
 vpcmpeqw    ymm13,ymm3,ymm13
 vpblendvb   ymm8,ymm4,ymm8,ymm13

 vpsubw      ymm4,ymm4,ymm9

 lea         r8,[rcx+020000h]
 cmp         r8,rdx
 cmova       r8,rdx

 add         rcx,256

 cmp         rcx,r8
 jae         INNER_LOOP_END

INNER_LOOP_TOP:
 vpmaxsw     ymm10,ymm0,ymmword ptr [rcx-256]
 vpmaxsw     ymm11,ymm1,ymmword ptr [rcx-224]
 vpmaxsw     ymm12,ymm2,ymmword ptr [rcx-192]
 vpmaxsw     ymm13,ymm3,ymmword ptr [rcx-160]
 vpcmpeqw    ymm0,ymm0,ymm10
 vpblendvb   ymm5,ymm4,ymm5,ymm0
 vpmaxsw     ymm0,ymm10,ymmword ptr [rcx-128]
 vpcmpeqw    ymm1,ymm1,ymm11
 vpblendvb   ymm6,ymm4,ymm6,ymm1
 vpmaxsw     ymm1,ymm11,ymmword ptr [rcx-96]
 vpcmpeqw    ymm2,ymm2,ymm12
 vpblendvb   ymm7,ymm4,ymm7,ymm2
 vpmaxsw     ymm2,ymm12,ymmword ptr [rcx-64]
 vpcmpeqw    ymm3,ymm3,ymm13
 vpblendvb   ymm8,ymm4,ymm8,ymm3
 vpmaxsw     ymm3,ymm13,ymmword ptr [rcx-32]
 vpsubw      ymm4,ymm4,ymm9
 vpcmpeqw    ymm10,ymm0,ymm10
 vpblendvb   ymm5,ymm4,ymm5,ymm10
 vpcmpeqw    ymm11,ymm1,ymm11
 vpblendvb   ymm6,ymm4,ymm6,ymm11
 vpcmpeqw    ymm12,ymm2,ymm12
 vpblendvb   ymm7,ymm4,ymm7,ymm12
 vpcmpeqw    ymm13,ymm3,ymm13
 vpblendvb   ymm8,ymm4,ymm8,ymm13

 vpsubw      ymm4,ymm4,ymm9
 add         rcx,256
 cmp         rcx,r8
 jb          INNER_LOOP_TOP

INNER_LOOP_END:

 vpsraw      ymm10,ymm9,1
 vpsubw      ymm7,ymm7,ymm10
 vpsubw      ymm8,ymm8,ymm10

 vpmaxsw     ymm0,ymm0,ymm2
 vpcmpeqw    ymm2,ymm0,ymm2
 vpblendvb   ymm5,ymm5,ymm7,ymm2

 vpmaxsw     ymm1,ymm1,ymm3
 vpcmpeqw    ymm3,ymm1,ymm3
 vpblendvb   ymm6,ymm6,ymm8,ymm3

 vpsraw      ymm10,ymm10,1
 vpsubw      ymm6,ymm6,ymm10

 vpmaxsw     ymm0,ymm0,ymm1
 vpcmpeqw    ymm1,ymm0,ymm1
 vpblendvb   ymm5,ymm5,ymm6,ymm1

 vpunpckhqdq ymm1,ymm0,ymm0
 vpunpckhqdq ymm6,ymm5,ymm5

 vpmaxsw     ymm0,ymm0,ymm1
 vpcmpeqw    ymm1,ymm0,ymm1
 vpblendvb   ymm5,ymm5,ymm6,ymm1

 vmovd       xmm6,r9d
 vpbroadcastd ymm6,xmm6
 vpunpcklwd  ymm5,ymm5,ymm6

 vpmaxsw     ymm14,ymm0,ymm14
 vpcmpeqw    ymm1,ymm0,ymm14
 vpunpcklwd  ymm1,ymm1,ymm1
 vpblendvb   ymm15,ymm15,ymm5,ymm1

 inc         r9d

 cmp         rcx,rdx
 jb          OUTER_LOOP_TOP

 ; remainder

 vpabsw      ymm4,ymm9

 vmovdqu     ymm5,ymmword ptr [rdx-256]
 vmovdqu     ymm6,ymmword ptr [rdx-224]
 vmovdqu     ymm7,ymmword ptr [rdx-192]
 vmovdqu     ymm8,ymmword ptr [rdx-160]

 vpmaxsw     ymm0,ymm5,ymmword ptr [rdx-128]
 vpmaxsw     ymm1,ymm6,ymmword ptr [rdx-96]
 vpmaxsw     ymm2,ymm7,ymmword ptr [rdx-64]
 vpmaxsw     ymm3,ymm8,ymmword ptr [rdx-32]

 vpcmpeqw    ymm5,ymm0,ymm5
 vpcmpeqw    ymm6,ymm1,ymm6
 vpcmpeqw    ymm7,ymm2,ymm7
 vpcmpeqw    ymm8,ymm3,ymm8

 vpandn      ymm5,ymm5,ymm4
 vpandn      ymm6,ymm6,ymm4
 vpandn      ymm7,ymm7,ymm4
 vpandn      ymm8,ymm8,ymm4

 vpsrlw      ymm4,ymm4,1
 vpor        ymm7,ymm7,ymm4
 vpor        ymm8,ymm8,ymm4

 vpmaxsw     ymm0,ymm0,ymm2
 vpmaxsw     ymm1,ymm1,ymm3

 vpcmpeqw    ymm2,ymm0,ymm2
 vpcmpeqw    ymm3,ymm1,ymm3

 vpblendvb   ymm5,ymm5,ymm7,ymm2
 vpblendvb   ymm6,ymm6,ymm8,ymm3

 vpsrlw      ymm4,ymm4,1
 vpor        ymm6,ymm6,ymm4

 vpmaxsw     ymm0,ymm0,ymm1

 vpcmpeqw    ymm1,ymm0,ymm1

 vpblendvb   ymm5,ymm5,ymm6,ymm1
 vmovaps     xmm6,xmmword ptr [rsp]
 vpor        ymm5,ymm5,ymmword ptr [SEQ]
 vmovaps     xmm7,xmmword ptr [rsp+16]

 vpunpckhqdq ymm1,ymm0,ymm0
 vmovaps     xmm8,xmmword ptr [rsp+32]
 vpunpckhqdq ymm4,ymm5,ymm5
 vmovaps     xmm9,xmmword ptr [rsp+48]

 vpmaxsw     ymm0,ymm0,ymm1
 vmovaps     xmm10,xmmword ptr [rsp+64]
 vpcmpeqw    ymm1,ymm0,ymm1
 vmovaps     xmm11,xmmword ptr [rsp+80]
 vpblendvb   ymm5,ymm5,ymm4,ymm1
 vmovaps     xmm12,xmmword ptr [rsp+96]

 vpxor       xmm2,xmm2,xmm2
 vmovaps     xmm13,xmmword ptr [rsp+112]
 vpunpcklwd  ymm5,ymm5,ymm2
 add         eax,-128
 vmovd       xmm4,eax
 vpbroadcastd ymm4,xmm4
 vpaddd      ymm5,ymm5,ymm4

 vpmaxsw     ymm0,ymm0,ymm14
 vpcmpeqw    ymm1,ymm0,ymm14
 vmovaps     xmm14,xmmword ptr [rsp+144]
 vpunpcklwd  ymm1,ymm1,ymm1
 vpblendvb   ymm2,ymm5,ymm15,ymm1
 vmovaps     xmm15,xmmword ptr [rsp+160]

 ; reduce

 vextracti128 xmm1,ymm0,1
 vextracti128 xmm3,ymm2,1

 vpmovsxwd   xmm0,xmm0
 vpmovsxwd   xmm1,xmm1

 vpmaxsd     xmm0,xmm0,xmm1
 vpcmpeqd    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm2,xmm3,xmm1

 vpunpckhqdq xmm1,xmm0,xmm0
 vpunpckhqdq xmm3,xmm2,xmm2

 vpmaxsd     xmm0,xmm0,xmm1
 vpcmpeqd    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm2,xmm3,xmm1

 vmovshdup   xmm1,xmm0
 vmovshdup   xmm3,xmm2

 vpcmpgtd    xmm0,xmm1,xmm0
 vpblendvb   xmm0,xmm2,xmm3,xmm0
 vmovd       eax,xmm0

 add         rsp,136
 ret

FastMaxIdxI16 ENDP

_TEXT$FastMaxIdxI16 ENDS

END
