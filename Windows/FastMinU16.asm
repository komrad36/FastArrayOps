; /*******************************************************************
; *
; *    Author: Kareem Omar
; *    kareem.h.omar@gmail.com
; *    https://github.com/komrad36
; *
; *    Last updated Oct 11, 2020
; *******************************************************************/

_TEXT$FastMinU16 SEGMENT ALIGN(64)

FastMinU16 PROC
 mov         eax,edx
 cmp         edx,64
 jae         CASE_LARGE
 vpcmpeqd    ymm0,ymm0,ymm0
 lea         r8,JUMP_TABLE
 movzx       edx,byte ptr [r8+rax]
db 03Eh, 03Eh
 add         r8,rdx
 lea         rdx,[rcx+2*rax]
 and         eax,-16
 lea         rcx,[rcx+2*rax]
 mov         ax,-1
 jmp         r8
JUMP_TABLE:
db  1 DUP ( CASE_0 - JUMP_TABLE)
db  1 DUP ( CASE_1 - JUMP_TABLE)
db  1 DUP ( CASE_2 - JUMP_TABLE)
db  1 DUP ( CASE_3 - JUMP_TABLE)
db  4 DUP ( CASE_4 - JUMP_TABLE)
db  8 DUP ( CASE_8 - JUMP_TABLE)
db 16 DUP (CASE_16 - JUMP_TABLE)
db 16 DUP (CASE_32 - JUMP_TABLE)
db 16 DUP (CASE_48 - JUMP_TABLE)
db 3 DUP (0CCh)
CASE_48:
 vmovdqu     ymm0,ymmword ptr [rcx-96]
CASE_32:
 vpminuw     ymm0,ymm0,ymmword ptr [rcx-64]
CASE_16:
 vpminuw     ymm0,ymm0,ymmword ptr [rcx-32]
 vpminuw     ymm0,ymm0,ymmword ptr [rdx-32]
 vextracti128 xmm1,ymm0,1
 vpminuw     xmm0,xmm0,xmm1
 vpunpckhqdq xmm1,xmm0,xmm0
 vpminuw     xmm0,xmm0,xmm1
 vmovshdup   xmm1,xmm0
 vpminuw     xmm0,xmm0,xmm1
 vpshuflw    xmm1,xmm0,225
 vpminuw     xmm0,xmm0,xmm1
 vmovd       eax,xmm0
 ret
db 12 DUP (0CCh)
CASE_8:
 vmovdqu     xmm0,xmmword ptr [rcx]
 vpminuw     xmm0,xmm0,xmmword ptr [rdx-16]
 vpunpckhqdq xmm1,xmm0,xmm0
 vpminuw     xmm0,xmm0,xmm1
 vmovshdup   xmm1,xmm0
 vpminuw     xmm0,xmm0,xmm1
 vpshuflw    xmm1,xmm0,225
 vpminuw     xmm0,xmm0,xmm1
 vmovd       eax,xmm0
 ret
db 1 DUP (0CCh)
CASE_4:
 vmovq       xmm0,qword ptr [rcx]
 vmovq       xmm1,qword ptr [rdx-8]
 vpminuw     xmm0,xmm0,xmm1
 vmovshdup   xmm1,xmm0
 vpminuw     xmm0,xmm0,xmm1
 vpshuflw    xmm1,xmm0,225
 vpminuw     xmm0,xmm0,xmm1
 vmovd       eax,xmm0
 ret
CASE_3:
 mov         ax,word ptr [rdx-6]
CASE_2:
 cmp         ax,word ptr [rdx-4]
 cmova       ax,word ptr [rdx-4]
CASE_1:
 cmp         ax,word ptr [rdx-2]
 cmova       ax,word ptr [rdx-2]
CASE_0:
 ret

CASE_LARGE:
 vmovdqu     ymm0,ymmword ptr [rcx]
 vmovdqu     ymm1,ymmword ptr [rcx+32]
 vmovdqu     ymm2,ymmword ptr [rcx+64]
 vmovdqu     ymm3,ymmword ptr [rcx+96]

 lea         rdx,[rcx+2*rax]
 add         rcx,256
 cmp         rcx,rdx
 jae         LOOP_END

LOOP_TOP:
 vpminuw     ymm0,ymm0,ymmword ptr [rcx-128]
 vpminuw     ymm1,ymm1,ymmword ptr [rcx-96]
 vpminuw     ymm2,ymm2,ymmword ptr [rcx-64]
 vpminuw     ymm3,ymm3,ymmword ptr [rcx-32]
 sub         rcx,-128
 cmp         rcx,rdx
 jb          LOOP_TOP

LOOP_END:
 vpminuw     ymm0,ymm0,ymmword ptr [rdx-128]
 vpminuw     ymm1,ymm1,ymmword ptr [rdx-96]
 vpminuw     ymm2,ymm2,ymmword ptr [rdx-64]
 vpminuw     ymm3,ymm3,ymmword ptr [rdx-32]

 vpminuw     ymm0,ymm0,ymm2
 vpminuw     ymm1,ymm1,ymm3

 vpminuw     ymm0,ymm0,ymm1

 vextracti128 xmm1,ymm0,1
 vpminuw     xmm0,xmm0,xmm1
 vpunpckhqdq xmm1,xmm0,xmm0
 vpminuw     xmm0,xmm0,xmm1
 vmovshdup   xmm1,xmm0
 vpminuw     xmm0,xmm0,xmm1
 vpshuflw    xmm1,xmm0,225
 vpminuw     xmm0,xmm0,xmm1
 vmovd       eax,xmm0
 ret
FastMinU16 ENDP

_TEXT$FastMinU16 ENDS

END
