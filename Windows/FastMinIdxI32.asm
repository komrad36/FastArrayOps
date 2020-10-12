; /*******************************************************************
; *
; *    Author: Kareem Omar
; *    kareem.h.omar@gmail.com
; *    https://github.com/komrad36
; *
; *    Last updated Oct 11, 2020
; *******************************************************************/

_TEXT$FastMinIdxI32 SEGMENT ALIGN(64)

FastMinIdxI32 PROC
 sub         rsp,104
 vmovdqu     ymm4,ymmword ptr [SEQ]
 mov         eax,edx
 cmp         edx,64
 jae         CASE_LARGE
 vpcmpeqd    ymm0,ymm0,ymm0
 vpslld      ymm2,ymm0,3
 vpsrld      ymm0,ymm0,1
 vmovdqa     ymm1,ymm0
 vmovdqa     ymm3,ymm4
 lea         r8,JUMP_TABLE
 movzx       r9d,word ptr [r8+2*rax]
 add         r8,r9
 lea         r9,[rcx+4*rax]
 mov         r10d,07FFFFFFFh
 and         eax,-8
 lea         rcx,[rcx+4*rax]
 jmp         r8
SEQ:
dd 0,1,2,3,4,5,6,7
JUMP_TABLE:
dw 1 DUP ( CASE_0 - JUMP_TABLE)
dw 1 DUP ( CASE_1 - JUMP_TABLE)
dw 1 DUP ( CASE_2 - JUMP_TABLE)
dw 1 DUP ( CASE_3 - JUMP_TABLE)
dw 1 DUP ( CASE_4 - JUMP_TABLE)
dw 1 DUP ( CASE_5 - JUMP_TABLE)
dw 1 DUP ( CASE_6 - JUMP_TABLE)
dw 1 DUP ( CASE_7 - JUMP_TABLE)
dw 8 DUP ( CASE_8 - JUMP_TABLE)
dw 8 DUP (CASE_16 - JUMP_TABLE)
dw 8 DUP (CASE_24 - JUMP_TABLE)
dw 8 DUP (CASE_32 - JUMP_TABLE)
dw 8 DUP (CASE_40 - JUMP_TABLE)
dw 8 DUP (CASE_48 - JUMP_TABLE)
dw 8 DUP (CASE_56 - JUMP_TABLE)
CASE_56:
 vmovdqu     ymm1,ymmword ptr [rcx-224]
 vpsubd      ymm4,ymm4,ymm2
CASE_48:
 vpminsd     ymm0,ymm1,ymmword ptr [rcx-192]
 vpcmpeqd    ymm1,ymm0,ymm1
 vpblendvb   ymm3,ymm4,ymm3,ymm1
 vpsubd      ymm4,ymm4,ymm2
CASE_40:
 vpminsd     ymm1,ymm0,ymmword ptr [rcx-160]
 vpcmpeqd    ymm0,ymm0,ymm1
 vpblendvb   ymm3,ymm4,ymm3,ymm0
 vpsubd      ymm4,ymm4,ymm2
CASE_32:
 vpminsd     ymm0,ymm1,ymmword ptr [rcx-128]
 vpcmpeqd    ymm1,ymm0,ymm1
 vpblendvb   ymm3,ymm4,ymm3,ymm1
 vpsubd      ymm4,ymm4,ymm2
CASE_24:
 vpminsd     ymm1,ymm0,ymmword ptr [rcx-96]
 vpcmpeqd    ymm0,ymm0,ymm1
 vpblendvb   ymm3,ymm4,ymm3,ymm0
 vpsubd      ymm4,ymm4,ymm2
CASE_16:
 vpminsd     ymm0,ymm1,ymmword ptr [rcx-64]
 vpcmpeqd    ymm1,ymm0,ymm1
 vpblendvb   ymm3,ymm4,ymm3,ymm1
 vpsubd      ymm4,ymm4,ymm2
CASE_8:
 vpminsd     ymm1,ymm0,ymmword ptr [rcx-32]
 vpcmpeqd    ymm0,ymm0,ymm1
 vpblendvb   ymm3,ymm4,ymm3,ymm0
 lea         ecx,[rdx-8]
 vmovd       xmm4,ecx
 vpbroadcastd ymm4,xmm4
 vpaddd      ymm4,ymm4,ymmword ptr [SEQ]
 vpminsd     ymm0,ymm1,ymmword ptr [r9-32]
 vpcmpeqd    ymm1,ymm0,ymm1
 vpblendvb   ymm2,ymm4,ymm3,ymm1
 vextracti128 xmm1,ymm0,1
 vextracti128 xmm3,ymm2,1
 vpminsd     xmm0,xmm0,xmm1
 vpcmpeqd    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm2,xmm3,xmm1
 vpunpckhqdq xmm1,xmm0,xmm0
 vpunpckhqdq xmm3,xmm2,xmm2
 vpminsd     xmm0,xmm0,xmm1
 vpcmpeqd    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm2,xmm3,xmm1
 vmovshdup   xmm1,xmm0
 vmovshdup   xmm3,xmm2
 vpcmpgtd    xmm0,xmm0,xmm1
 vpblendvb   xmm0,xmm2,xmm3,xmm0
 vmovd       eax,xmm0
 add         rsp,104
 ret
CASE_7:
 mov         r10d,dword ptr [r9-28]
CASE_6:
 lea         ecx,[rdx-6]
 cmp         r10d,dword ptr [r9-24]
 cmovg       r10d,dword ptr [r9-24]
 cmovg       eax,ecx
CASE_5:
 lea         ecx,[rdx-5]
 cmp         r10d,dword ptr [r9-20]
 cmovg       r10d,dword ptr [r9-20]
 cmovg       eax,ecx
CASE_4:
 lea         ecx,[rdx-4]
 cmp         r10d,dword ptr [r9-16]
 cmovg       r10d,dword ptr [r9-16]
 cmovg       eax,ecx
CASE_3:
 lea         ecx,[rdx-3]
 cmp         r10d,dword ptr [r9-12]
 cmovg       r10d,dword ptr [r9-12]
 cmovg       eax,ecx
CASE_2:
 lea         ecx,[rdx-2]
 cmp         r10d,dword ptr [r9-8]
 cmovg       r10d,dword ptr [r9-8]
 cmovg       eax,ecx
CASE_1:
 lea         ecx,[rdx-1]
 cmp         r10d,dword ptr [r9-4]
 cmovg       eax,ecx
CASE_0:
 add         rsp,104
 ret

CASE_LARGE:
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
 vpslld      ymm9,ymm9,5

 ; best values
 vmovaps     xmmword ptr [rsp+64],xmm10
 vmovdqu     ymm10,ymmword ptr [rcx]
 vmovaps     xmmword ptr [rsp+80],xmm11
 vmovdqu     ymm11,ymmword ptr [rcx+32]
 vmovaps     xmmword ptr [rsp+112],xmm12
 vmovdqu     ymm12,ymmword ptr [rcx+64]
 vmovaps     xmmword ptr [rsp+128],xmm13
 vmovdqu     ymm13,ymmword ptr [rcx+96]

 vpsubd      ymm4,ymm4,ymm9

 vpminsd     ymm0,ymm10,ymmword ptr [rcx+128]
 vpminsd     ymm1,ymm11,ymmword ptr [rcx+160]
 vpminsd     ymm2,ymm12,ymmword ptr [rcx+192]
 vpminsd     ymm3,ymm13,ymmword ptr [rcx+224]
 vpcmpeqd    ymm10,ymm0,ymm10
 vpblendvb   ymm5,ymm4,ymm5,ymm10
 vpcmpeqd    ymm11,ymm1,ymm11
 vpblendvb   ymm6,ymm4,ymm6,ymm11
 vpcmpeqd    ymm12,ymm2,ymm12
 vpblendvb   ymm7,ymm4,ymm7,ymm12
 vpcmpeqd    ymm13,ymm3,ymm13
 vpblendvb   ymm8,ymm4,ymm8,ymm13

 vpsubd      ymm4,ymm4,ymm9

 lea         rdx,[rcx+4*rax]
 add         rcx,512
 cmp         rcx,rdx
 jae         LOOP_END

LOOP_TOP:
 vpminsd     ymm10,ymm0,ymmword ptr [rcx-256]
 vpminsd     ymm11,ymm1,ymmword ptr [rcx-224]
 vpminsd     ymm12,ymm2,ymmword ptr [rcx-192]
 vpminsd     ymm13,ymm3,ymmword ptr [rcx-160]
 vpcmpeqd    ymm0,ymm0,ymm10
 vpblendvb   ymm5,ymm4,ymm5,ymm0
 vpminsd     ymm0,ymm10,ymmword ptr [rcx-128]
 vpcmpeqd    ymm1,ymm1,ymm11
 vpblendvb   ymm6,ymm4,ymm6,ymm1
 vpminsd     ymm1,ymm11,ymmword ptr [rcx-96]
 vpcmpeqd    ymm2,ymm2,ymm12
 vpblendvb   ymm7,ymm4,ymm7,ymm2
 vpminsd     ymm2,ymm12,ymmword ptr [rcx-64]
 vpcmpeqd    ymm3,ymm3,ymm13
 vpblendvb   ymm8,ymm4,ymm8,ymm3
 vpminsd     ymm3,ymm13,ymmword ptr [rcx-32]
 vpsubd      ymm4,ymm4,ymm9
 vpcmpeqd    ymm10,ymm0,ymm10
 vpblendvb   ymm5,ymm4,ymm5,ymm10
 vpcmpeqd    ymm11,ymm1,ymm11
 vpblendvb   ymm6,ymm4,ymm6,ymm11
 vpcmpeqd    ymm12,ymm2,ymm12
 vpblendvb   ymm7,ymm4,ymm7,ymm12
 vpcmpeqd    ymm13,ymm3,ymm13
 vpblendvb   ymm8,ymm4,ymm8,ymm13

 vpsubd      ymm4,ymm4,ymm9
 add         rcx,256
 cmp         rcx,rdx
 jb          LOOP_TOP

LOOP_END:
 sub         eax,64
 vmovd       xmm4,eax
 vpbroadcastd ymm4,xmm4
 vpaddd      ymm4,ymm4,ymmword ptr [SEQ]

 vpminsd     ymm10,ymm0,ymmword ptr [rdx-256]
 vpminsd     ymm11,ymm1,ymmword ptr [rdx-224]
 vpminsd     ymm12,ymm2,ymmword ptr [rdx-192]
 vpminsd     ymm13,ymm3,ymmword ptr [rdx-160]
 vpcmpeqd    ymm0,ymm0,ymm10
 vpblendvb   ymm5,ymm4,ymm5,ymm0
 vpminsd     ymm0,ymm10,ymmword ptr [rdx-128]
 vpcmpeqd    ymm1,ymm1,ymm11
 vpblendvb   ymm6,ymm4,ymm6,ymm1
 vpminsd     ymm1,ymm11,ymmword ptr [rdx-96]
 vpcmpeqd    ymm2,ymm2,ymm12
 vpblendvb   ymm7,ymm4,ymm7,ymm2
 vpminsd     ymm2,ymm12,ymmword ptr [rdx-64]
 vpcmpeqd    ymm3,ymm3,ymm13
 vpblendvb   ymm8,ymm4,ymm8,ymm3
 vpminsd     ymm3,ymm13,ymmword ptr [rdx-32]
 vpsubd      ymm4,ymm4,ymm9
 vpcmpeqd    ymm13,ymm3,ymm13
 vpblendvb   ymm8,ymm4,ymm8,ymm13
 vmovaps     xmm13,xmmword ptr [rsp+128]
 vpcmpeqd    ymm12,ymm2,ymm12
 vpblendvb   ymm7,ymm4,ymm7,ymm12
 vmovaps     xmm12,xmmword ptr [rsp+112]
 vpcmpeqd    ymm11,ymm1,ymm11
 vpblendvb   ymm6,ymm4,ymm6,ymm11
 vmovaps     xmm11,xmmword ptr [rsp+80]
 vpcmpeqd    ymm10,ymm0,ymm10
 vpblendvb   ymm5,ymm4,ymm5,ymm10
 vmovaps     xmm10,xmmword ptr [rsp+64]

 vpsrad      ymm4,ymm9,1
 vmovaps     xmm9,xmmword ptr [rsp+48]

 vpminsd     ymm1,ymm1,ymm3
 vpcmpeqd    ymm3,ymm1,ymm3
 vpsubd      ymm8,ymm8,ymm4
 vpblendvb   ymm6,ymm6,ymm8,ymm3
 vmovaps     xmm8,xmmword ptr [rsp+32]

 vpminsd     ymm0,ymm0,ymm2
 vpcmpeqd    ymm2,ymm0,ymm2
 vpsubd      ymm7,ymm7,ymm4
 vpblendvb   ymm5,ymm5,ymm7,ymm2
 vmovaps     xmm7,xmmword ptr [rsp+16]

 vpsrad      ymm4,ymm4,1

 vpminsd     ymm0,ymm0,ymm1
 vpcmpeqd    ymm1,ymm0,ymm1
 vpsubd      ymm6,ymm6,ymm4
 vpblendvb   ymm2,ymm5,ymm6,ymm1
 vmovaps     xmm6,xmmword ptr [rsp]

 vextracti128 xmm1,ymm0,1
 vextracti128 xmm3,ymm2,1

 vpminsd     xmm0,xmm0,xmm1
 vpcmpeqd    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm2,xmm3,xmm1

 vpunpckhqdq xmm1,xmm0,xmm0
 vpunpckhqdq xmm3,xmm2,xmm2

 vpminsd     xmm0,xmm0,xmm1
 vpcmpeqd    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm2,xmm3,xmm1

 vmovshdup   xmm1,xmm0
 vmovshdup   xmm3,xmm2

 vpcmpgtd    xmm0,xmm0,xmm1
 vpblendvb   xmm0,xmm2,xmm3,xmm0
 vmovd       eax,xmm0

 add         rsp,104
 ret
FastMinIdxI32 ENDP

_TEXT$FastMinIdxI32 ENDS

END
