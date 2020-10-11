_TEXT$AsmFastMinI16 SEGMENT ALIGN(64)

AsmFastMinI16 PROC
 mov         eax,edx
 cmp         edx,64
 jae         CASE_LARGE
 vpcmpeqd    ymm0,ymm0,ymm0
 vpsrlw      ymm0,ymm0,1
 lea         r8,JUMP_TABLE
 movzx       edx,byte ptr [r8+rax]
 add         r8,rdx
 lea         rdx,[rcx+2*rax]
 and         eax,-16
 lea         rcx,[rcx+2*rax]
 mov         ax,07FFFh
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
db 1 DUP (0CCh)
CASE_48:
 vmovdqu     ymm0,ymmword ptr [rcx-96]
CASE_32:
 vpminsw     ymm0,ymm0,ymmword ptr [rcx-64]
CASE_16:
 vpminsw     ymm0,ymm0,ymmword ptr [rcx-32]
 vpminsw     ymm0,ymm0,ymmword ptr [rdx-32]
 vextracti128 xmm1,ymm0,1
 vpminsw     xmm0,xmm0,xmm1
 vpunpckhqdq xmm1,xmm0,xmm0
 vpminsw     xmm0,xmm0,xmm1
 vmovshdup   xmm1,xmm0
 vpminsw     xmm0,xmm0,xmm1
 vpshuflw    xmm1,xmm0,225
 vpminsw     xmm0,xmm0,xmm1
 vmovd       eax,xmm0
 ret
db 16 DUP (0CCh)
CASE_8:
 vmovdqu     xmm0,xmmword ptr [rcx]
 vpminsw     xmm0,xmm0,xmmword ptr [rdx-16]
 vpunpckhqdq xmm1,xmm0,xmm0
 vpminsw     xmm0,xmm0,xmm1
 vmovshdup   xmm1,xmm0
 vpminsw     xmm0,xmm0,xmm1
 vpshuflw    xmm1,xmm0,225
 vpminsw     xmm0,xmm0,xmm1
 vmovd       eax,xmm0
 ret
CASE_4:
 vmovq       xmm0,qword ptr [rcx]
 vmovq       xmm1,qword ptr [rdx-8]
 vpminsw     xmm0,xmm0,xmm1
 vmovshdup   xmm1,xmm0
 vpminsw     xmm0,xmm0,xmm1
 vpshuflw    xmm1,xmm0,225
 vpminsw     xmm0,xmm0,xmm1
 vmovd       eax,xmm0
 ret
db 1 DUP (0CCh)
CASE_3:
 mov         ax,word ptr [rdx-6]
CASE_2:
 cmp         ax,word ptr [rdx-4]
 cmovg       ax,word ptr [rdx-4]
CASE_1:
 cmp         ax,word ptr [rdx-2]
 cmovg       ax,word ptr [rdx-2]
CASE_0:
 ret

db 3 DUP (0CCh)

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
 vpminsw     ymm0,ymm0,ymmword ptr [rcx-128]
 vpminsw     ymm1,ymm1,ymmword ptr [rcx-96]
 vpminsw     ymm2,ymm2,ymmword ptr [rcx-64]
 vpminsw     ymm3,ymm3,ymmword ptr [rcx-32]
 sub         rcx,-128
 cmp         rcx,rdx
 jb          LOOP_TOP

LOOP_END:
 vpminsw     ymm0,ymm0,ymmword ptr [rdx-128]
 vpminsw     ymm1,ymm1,ymmword ptr [rdx-96]
 vpminsw     ymm2,ymm2,ymmword ptr [rdx-64]
 vpminsw     ymm3,ymm3,ymmword ptr [rdx-32]

 vpminsw     ymm0,ymm0,ymm2
 vpminsw     ymm1,ymm1,ymm3

 vpminsw     ymm0,ymm0,ymm1

 vextracti128 xmm1,ymm0,1
 vpminsw     xmm0,xmm0,xmm1
 vpunpckhqdq xmm1,xmm0,xmm0
 vpminsw     xmm0,xmm0,xmm1
 vmovshdup   xmm1,xmm0
 vpminsw     xmm0,xmm0,xmm1
 vpshuflw    xmm1,xmm0,225
 vpminsw     xmm0,xmm0,xmm1
 vmovd       eax,xmm0
 ret
AsmFastMinI16 ENDP

_TEXT$AsmFastMinI16 ENDS

END
