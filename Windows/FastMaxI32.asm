_TEXT$AsmFastMaxI32 SEGMENT ALIGN(64)

AsmFastMaxI32 PROC
 mov         eax,edx
 cmp         edx,32
 jae         CASE_LARGE
 vpcmpeqd	 ymm0,ymm0,ymm0
 vpslld		 ymm0,ymm0,31
 lea		 r8,JUMP_TABLE
 movzx		 edx,byte ptr [r8+rax]
 add		 r8,rdx
 lea         rdx,[rcx+4*rax]
 and		 eax,-8
 lea         rcx,[rcx+4*rax]
 mov		 eax,080000000h
 jmp         r8
JUMP_TABLE:
db 1 DUP ( CASE_0 - JUMP_TABLE)
db 1 DUP ( CASE_1 - JUMP_TABLE)
db 1 DUP ( CASE_2 - JUMP_TABLE)
db 1 DUP ( CASE_3 - JUMP_TABLE)
db 4 DUP ( CASE_4 - JUMP_TABLE)
db 8 DUP ( CASE_8 - JUMP_TABLE)
db 8 DUP (CASE_16 - JUMP_TABLE)
db 8 DUP (CASE_24 - JUMP_TABLE)
db 45 DUP (0CCh)
CASE_24:
 vmovdqu	 ymm0,ymmword ptr [rcx-96]
CASE_16:
 vpmaxsd     ymm0,ymm0,ymmword ptr [rcx-64]
CASE_8:
 vpmaxsd     ymm0,ymm0,ymmword ptr [rcx-32]
 vpmaxsd     ymm0,ymm0,ymmword ptr [rdx-32]
 vextracti128 xmm1,ymm0,1
 vpmaxsd     xmm0,xmm0,xmm1
 vpunpckhqdq xmm1,xmm0,xmm0
 vpmaxsd     xmm0,xmm0,xmm1
 vmovshdup   xmm1,xmm0
 vpmaxsd     xmm0,xmm0,xmm1
 vmovd       eax,xmm0
 ret
db 4 DUP (0CCh)
CASE_4:
 vmovdqu     xmm0,xmmword ptr [rcx]
 vpmaxsd     xmm0,xmm0,xmmword ptr [rdx-16]
 vpunpckhqdq xmm1,xmm0,xmm0
 vpmaxsd     xmm0,xmm0,xmm1
 vmovshdup   xmm1,xmm0
 vpmaxsd     xmm0,xmm0,xmm1
 vmovd       eax,xmm0
 ret
CASE_3:
 mov		 eax,dword ptr [rdx-12]
CASE_2:
 cmp		 eax,dword ptr [rdx-8]
 cmovl		 eax,dword ptr [rdx-8]
CASE_1:
 cmp		 eax,dword ptr [rdx-4]
 cmovl		 eax,dword ptr [rdx-4]
CASE_0:
 ret

db 50 DUP (0CCh)

CASE_LARGE:
 vmovdqu     ymm0,ymmword ptr [rcx]
 vmovdqu     ymm1,ymmword ptr [rcx+32]
 vmovdqu     ymm2,ymmword ptr [rcx+64]
 vmovdqu     ymm3,ymmword ptr [rcx+96]

 lea         rdx,[rcx+4*rax]
 add         rcx,256
 cmp         rcx,rdx
 jae         LOOP_END

LOOP_TOP:
 vpmaxsd     ymm0,ymm0,ymmword ptr [rcx-128]
 vpmaxsd     ymm1,ymm1,ymmword ptr [rcx-96]
 vpmaxsd     ymm2,ymm2,ymmword ptr [rcx-64]
 vpmaxsd     ymm3,ymm3,ymmword ptr [rcx-32]
 sub         rcx,-128
 cmp         rcx,rdx
 jb          LOOP_TOP

LOOP_END:
 vpmaxsd     ymm0,ymm0,ymmword ptr [rdx-128]
 vpmaxsd     ymm1,ymm1,ymmword ptr [rdx-96]
 vpmaxsd     ymm2,ymm2,ymmword ptr [rdx-64]
 vpmaxsd     ymm3,ymm3,ymmword ptr [rdx-32]

 vpmaxsd     ymm0,ymm0,ymm2
 vpmaxsd     ymm1,ymm1,ymm3

 vpmaxsd     ymm0,ymm0,ymm1

 vextracti128 xmm1,ymm0,1
 vpmaxsd     xmm0,xmm0,xmm1
 vpunpckhqdq xmm1,xmm0,xmm0
 vpmaxsd     xmm0,xmm0,xmm1
 vmovshdup   xmm1,xmm0
 vpmaxsd     xmm0,xmm0,xmm1
 vmovd       eax,xmm0
 ret
AsmFastMaxI32 ENDP

_TEXT$AsmFastMaxI32 ENDS

END
