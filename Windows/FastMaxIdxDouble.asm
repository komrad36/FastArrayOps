; /*******************************************************************
; *
; *    Author: Kareem Omar
; *    kareem.h.omar@gmail.com
; *    https://github.com/komrad36
; *
; *    Last updated Oct 11, 2020
; *******************************************************************/

_TEXT$FastMaxIdxDouble SEGMENT ALIGN(64)

FastMaxIdxDouble PROC
 sub         rsp,72
 mov         eax,edx
 cmp         edx,32
 jae         CASE_LARGE
 vpcmpeqd    ymm0,ymm0,ymm0
 vpsllq      ymm5,ymm0,2
 vmovdqu     ymm4,ymmword ptr [SEQ]
 vpcmpeqd    ymm1,ymm1,ymm1
 vmovdqa     ymm2,ymm4
 vmovdqa     ymm3,ymm4
 lea         r8,JUMP_TABLE
 movzx       edx,word ptr [r8+2*rax]
 add         r8,rdx
 lea         rdx,[rcx+8*rax]
 mov         r9d,eax
 and         eax,-4
 lea         rcx,[rcx+8*rax]
 jmp         r8
SEQ:
dq 0,1,2,3
JUMP_TABLE:
dw 1 DUP ( CASE_0 - JUMP_TABLE)
dw 1 DUP ( CASE_1 - JUMP_TABLE)
dw 1 DUP ( CASE_2 - JUMP_TABLE)
dw 1 DUP ( CASE_3 - JUMP_TABLE)
dw 4 DUP ( CASE_4 - JUMP_TABLE)
dw 4 DUP ( CASE_8 - JUMP_TABLE)
dw 4 DUP (CASE_12 - JUMP_TABLE)
dw 4 DUP (CASE_16 - JUMP_TABLE)
dw 4 DUP (CASE_20 - JUMP_TABLE)
dw 4 DUP (CASE_24 - JUMP_TABLE)
dw 4 DUP (CASE_28 - JUMP_TABLE)
CASE_28:
 vmovupd     ymm1,ymmword ptr [rcx-224]
 vpsubq      ymm3,ymm3,ymm5
CASE_24:
 vmaxpd      ymm0,ymm1,ymmword ptr [rcx-192]
 vpcmpeqq    ymm1,ymm0,ymm1
 vpblendvb   ymm2,ymm3,ymm2,ymm1
 vpsubq      ymm3,ymm3,ymm5
CASE_20:
 vmaxpd      ymm1,ymm0,ymmword ptr [rcx-160]
 vpcmpeqq    ymm0,ymm0,ymm1
 vpblendvb   ymm2,ymm3,ymm2,ymm0
 vpsubq      ymm3,ymm3,ymm5
CASE_16:
 vmaxpd      ymm0,ymm1,ymmword ptr [rcx-128]
 vpcmpeqq    ymm1,ymm0,ymm1
 vpblendvb   ymm2,ymm3,ymm2,ymm1
 vpsubq      ymm3,ymm3,ymm5
CASE_12:
 vmaxpd      ymm1,ymm0,ymmword ptr [rcx-96]
 vpcmpeqq    ymm0,ymm0,ymm1
 vpblendvb   ymm2,ymm3,ymm2,ymm0
 vpsubq      ymm3,ymm3,ymm5
CASE_8:
 vmaxpd      ymm0,ymm1,ymmword ptr [rcx-64]
 vpcmpeqq    ymm1,ymm0,ymm1
 vpblendvb   ymm2,ymm3,ymm2,ymm1
 vpsubq      ymm3,ymm3,ymm5
CASE_4:
 vmaxpd      ymm1,ymm0,ymmword ptr [rcx-32]
 vpcmpeqq    ymm0,ymm0,ymm1
 vpblendvb   ymm2,ymm3,ymm2,ymm0
 lea         ecx,[r9-4]
 vmovd       xmm3,ecx
 vpbroadcastq ymm3,xmm3
 vpaddq      ymm3,ymm3,ymm4
 vmaxpd      ymm0,ymm1,ymmword ptr [rdx-32]
 vpcmpeqq    ymm1,ymm0,ymm1
 vpblendvb   ymm2,ymm3,ymm2,ymm1
 vextractf128 xmm1,ymm0,1
 vextracti128 xmm3,ymm2,1
 vmaxpd      xmm0,xmm0,xmm1
 vpcmpeqq    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm2,xmm3,xmm1
 vmovhlps    xmm1,xmm0,xmm0
 vpunpckhqdq xmm3,xmm2,xmm2
 vcmplt_oqsd xmm0,xmm0,xmm1
 vpblendvb   xmm0,xmm2,xmm3,xmm0
 vmovd       eax,xmm0
 add         rsp,72
 ret
CASE_3:
 vmovsd      xmm0,qword ptr [rdx-24]
CASE_2:
 vucomisd    xmm0,qword ptr [rdx-16]
 lea         ecx,[r9-2]
 cmovb       eax,ecx
 vmaxsd      xmm0,xmm0,qword ptr [rdx-16]
CASE_1:
 vucomisd    xmm0,qword ptr [rdx-8]
 lea         ecx,[r9-1]
 cmovb       eax,ecx
CASE_0:
 add         rsp,72
 ret

PACKED_SEQ:
dd 0, 1, 4, 5, 2, 3, 6, 7

CASE_LARGE:
 vmovdqu     ymm4,ymmword ptr [PACKED_SEQ]

 ; best indices
 vmovdqa     ymm5,ymm4
 vmovaps     xmmword ptr [rsp],xmm6
 vmovdqa     ymm6,ymm4

 ; increment
 vmovaps     xmmword ptr [rsp+16],xmm7
 vpcmpeqd    ymm7,ymm7,ymm7
 vpslld      ymm7,ymm7,4

 ; best values
 vmovaps     xmmword ptr [rsp+32],xmm8
 vmovupd     ymm8,ymmword ptr [rcx]
 vmovaps     xmmword ptr [rsp+48],xmm9
 vmovupd     ymm9,ymmword ptr [rcx+32]
 vmovaps     xmmword ptr [rsp+80],xmm10
 vmovupd     ymm10,ymmword ptr [rcx+64]
 vmovaps     xmmword ptr [rsp+96],xmm11
 vmovupd     ymm11,ymmword ptr [rcx+96]

 vpsubd      ymm4,ymm4,ymm7

 vmaxpd      ymm0,ymm8,ymmword ptr [rcx+128]
 vmaxpd      ymm1,ymm9,ymmword ptr [rcx+160]
 vmaxpd      ymm2,ymm10,ymmword ptr [rcx+192]
 vmaxpd      ymm3,ymm11,ymmword ptr [rcx+224]

 vpcmpeqq    ymm8,ymm0,ymm8
 vpcmpeqq    ymm9,ymm1,ymm9
 vpackssdw   ymm8,ymm8,ymm9
 vpblendvb   ymm5,ymm4,ymm5,ymm8

 vpcmpeqq    ymm10,ymm2,ymm10
 vpcmpeqq    ymm11,ymm3,ymm11
 vpackssdw   ymm10,ymm10,ymm11
 vpblendvb   ymm6,ymm4,ymm6,ymm10

 vpsubd      ymm4,ymm4,ymm7

 lea         rdx,[rcx+8*rax]
 add         rcx,512
 cmp         rcx,rdx
 jae         LOOP_END

LOOP_TOP:
 vmaxpd      ymm8,ymm0,ymmword ptr [rcx-256]
 vmaxpd      ymm9,ymm1,ymmword ptr [rcx-224]
 vmaxpd      ymm10,ymm2,ymmword ptr [rcx-192]
 vmaxpd      ymm11,ymm3,ymmword ptr [rcx-160]
 vpcmpeqq    ymm0,ymm0,ymm8
 vpcmpeqq    ymm1,ymm1,ymm9
 vpackssdw   ymm1,ymm0,ymm1
 vpblendvb   ymm5,ymm4,ymm5,ymm1
 vmaxpd      ymm0,ymm8,ymmword ptr [rcx-128]
 vmaxpd      ymm1,ymm9,ymmword ptr [rcx-96]
 vpcmpeqq    ymm2,ymm2,ymm10
 vpcmpeqq    ymm3,ymm3,ymm11
 vpackssdw   ymm3,ymm2,ymm3
 vpblendvb   ymm6,ymm4,ymm6,ymm3
 vmaxpd      ymm2,ymm10,ymmword ptr [rcx-64]
 vmaxpd      ymm3,ymm11,ymmword ptr [rcx-32]
 vpsubd      ymm4,ymm4,ymm7
 vpcmpeqq    ymm8,ymm0,ymm8
 vpcmpeqq    ymm9,ymm1,ymm9
 vpackssdw   ymm8,ymm8,ymm9
 vpblendvb   ymm5,ymm4,ymm5,ymm8
 vpcmpeqq    ymm10,ymm2,ymm10
 vpcmpeqq    ymm11,ymm3,ymm11
 vpackssdw   ymm10,ymm10,ymm11
 vpblendvb   ymm6,ymm4,ymm6,ymm10
 vpsubd      ymm4,ymm4,ymm7

 add         rcx,256
 cmp         rcx,rdx
 jb          LOOP_TOP

LOOP_END:
 sub         eax,32
 vmovd       xmm4,eax
 vpbroadcastd ymm4,xmm4
 vpaddd      ymm4,ymm4,ymmword ptr [PACKED_SEQ]

 vmaxpd      ymm8,ymm0,ymmword ptr [rdx-256]
 vmaxpd      ymm9,ymm1,ymmword ptr [rdx-224]
 vmaxpd      ymm10,ymm2,ymmword ptr [rdx-192]
 vmaxpd      ymm11,ymm3,ymmword ptr [rdx-160]
 vpcmpeqq    ymm0,ymm0,ymm8
 vpcmpeqq    ymm1,ymm1,ymm9
 vpackssdw   ymm1,ymm0,ymm1
 vpblendvb   ymm5,ymm4,ymm5,ymm1
 vmaxpd      ymm0,ymm8,ymmword ptr [rdx-128]
 vmaxpd      ymm1,ymm9,ymmword ptr [rdx-96]
 vpcmpeqq    ymm2,ymm2,ymm10
 vpcmpeqq    ymm3,ymm3,ymm11
 vpackssdw   ymm3,ymm2,ymm3
 vpblendvb   ymm6,ymm4,ymm6,ymm3
 vmaxpd      ymm2,ymm10,ymmword ptr [rdx-64]
 vmaxpd      ymm3,ymm11,ymmword ptr [rdx-32]
 vpsubd      ymm4,ymm4,ymm7
 vpcmpeqq    ymm10,ymm2,ymm10
 vpcmpeqq    ymm11,ymm3,ymm11
 vpackssdw   ymm10,ymm10,ymm11
 vmovaps     xmm11,xmmword ptr [rsp+96]
 vpblendvb   ymm6,ymm4,ymm6,ymm10
 vmovaps     xmm10,xmmword ptr [rsp+80]
 vpcmpeqq    ymm8,ymm0,ymm8
 vpcmpeqq    ymm9,ymm1,ymm9
 vpackssdw   ymm8,ymm8,ymm9
 vmovaps     xmm9,xmmword ptr [rsp+48]
 vpblendvb   ymm5,ymm4,ymm5,ymm8
 vmovaps     xmm8,xmmword ptr [rsp+32]

 vpsrad      ymm4,ymm7,1
 vmovaps     xmm7,xmmword ptr [rsp+16]

 vmaxpd      ymm0,ymm0,ymm2
 vmaxpd      ymm1,ymm1,ymm3
 vpcmpeqq    ymm2,ymm0,ymm2
 vpcmpeqq    ymm3,ymm1,ymm3
 vpackssdw   ymm2,ymm2,ymm3
 vpsubd      ymm6,ymm6,ymm4
 vpblendvb   ymm2,ymm5,ymm6,ymm2
 vmovaps     xmm6,xmmword ptr [rsp]

 vmaxpd      ymm0,ymm0,ymm1
 vpunpckhdq  ymm3,ymm2,ymm2
 vpunpckldq  ymm2,ymm2,ymm2
 vpcmpeqq    ymm1,ymm0,ymm1
 vpblendvb   ymm2,ymm2,ymm3,ymm1

 vextractf128 xmm1,ymm0,1
 vextracti128 xmm3,ymm2,1

 vmaxpd      xmm0,xmm0,xmm1
 vpcmpeqq    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm2,xmm3,xmm1

 vmovhlps    xmm1,xmm0,xmm0
 vpunpckhqdq xmm3,xmm2,xmm2

 vcmplt_oqsd xmm0,xmm0,xmm1
 vpblendvb   xmm0,xmm2,xmm3,xmm0
 vmovd       eax,xmm0

 add         rsp,72
 ret
FastMaxIdxDouble ENDP

_TEXT$FastMaxIdxDouble ENDS

END
