_TEXT$AsmFastMinI8 SEGMENT ALIGN(64)

AsmFastMinI8 PROC
 mov         eax,edx
 cmp         edx,127
 ja          CASE_LARGE
 lea         r8,JUMP_TARGETS
 movzx       edx,byte ptr [r8+rax-(JUMP_TARGETS-JUMP_TABLE)]
db 03Eh
 add         r8,rdx
 lea         rdx,[rcx+rax]
 and         eax,-32
 add         rcx,rax
 vpcmpeqd    ymm0,ymm0,ymm0
 vpsrlw      ymm0,ymm0,1
 vpacksswb   ymm0,ymm0,ymm0
 mov         al,07Fh
 jmp         r8
db 10 DUP (0CCh)
JUMP_TABLE:
db  1 DUP ( CASE_0 - JUMP_TARGETS)
db  1 DUP ( CASE_1 - JUMP_TARGETS)
db  1 DUP ( CASE_2 - JUMP_TARGETS)
db  1 DUP ( CASE_3 - JUMP_TARGETS)
db  4 DUP ( CASE_4 - JUMP_TARGETS)
db  8 DUP ( CASE_8 - JUMP_TARGETS)
db 16 DUP (CASE_16 - JUMP_TARGETS)
db 32 DUP (CASE_32 - JUMP_TARGETS)
db 32 DUP (CASE_64 - JUMP_TARGETS)
db 32 DUP (CASE_96 - JUMP_TARGETS)
JUMP_TARGETS:
CASE_96:
 vmovdqu     ymm0,ymmword ptr [rcx-96]
CASE_64:
 vpminsb     ymm0,ymm0,ymmword ptr [rcx-64]
CASE_32:
 vpminsb     ymm0,ymm0,ymmword ptr [rcx-32]
 vpminsb     ymm0,ymm0,ymmword ptr [rdx-32]
 vextracti128 xmm1,ymm0,1
 vpminsb     xmm0,xmm0,xmm1
 vpunpckhqdq xmm1,xmm0,xmm0
 vpminsb     xmm0,xmm0,xmm1
 vmovshdup   xmm1,xmm0
 vpminsb     xmm0,xmm0,xmm1
 vpshuflw    xmm1,xmm0,225
 vpminsb     xmm0,xmm0,xmm1
 vpsrldq     xmm1,xmm0,1
 vpminsb     xmm0,xmm0,xmm1
 vmovd       eax,xmm0
 ret
db 1 DUP (0CCh)
CASE_16:
 vmovdqu     xmm0,xmmword ptr [rcx]
 vpminsb     xmm0,xmm0,xmmword ptr [rdx-16]
 vpunpckhqdq xmm1,xmm0,xmm0
 vpminsb     xmm0,xmm0,xmm1
 vmovshdup   xmm1,xmm0
 vpminsb     xmm0,xmm0,xmm1
 vpshuflw    xmm1,xmm0,225
 vpminsb     xmm0,xmm0,xmm1
 vpsrldq     xmm1,xmm0,1
 vpminsb     xmm0,xmm0,xmm1
 vmovd       eax,xmm0
 ret
db 2 DUP (0CCh)
CASE_8:
 vmovq       xmm0,qword ptr [rcx]
 vmovq       xmm1,qword ptr [rdx-8]
 vpminsb     xmm0,xmm0,xmm1
 vmovshdup   xmm1,xmm0
 vpminsb     xmm0,xmm0,xmm1
 vpshuflw    xmm1,xmm0,225
 vpminsb     xmm0,xmm0,xmm1
 vpsrldq     xmm1,xmm0,1
 vpminsb     xmm0,xmm0,xmm1
 vmovd       eax,xmm0
 ret
db 10 DUP (0CCh)
CASE_4:
 vmovd       xmm0,dword ptr [rcx]
 vmovd       xmm1,dword ptr [rdx-4]
 vpminsb     xmm0,xmm0,xmm1
 vpshuflw    xmm1,xmm0,225
 vpminsb     xmm0,xmm0,xmm1
 vpsrldq     xmm1,xmm0,1
 vpminsb     xmm0,xmm0,xmm1
 vmovd       eax,xmm0
 ret
CASE_3:
 mov         al,byte ptr [rdx-3]
CASE_2:
 mov         cl,byte ptr [rdx-2]
 cmp         al,cl
 cmovg       eax,ecx
CASE_1:
 mov         cl,byte ptr [rdx-1]
 cmp         al,cl
 cmovg       eax,ecx
CASE_0:
 ret

db 39 DUP (0CCh)

CASE_LARGE:
 vmovdqu     ymm0,ymmword ptr [rcx]
 vmovdqu     ymm1,ymmword ptr [rcx+32]
 vmovdqu     ymm2,ymmword ptr [rcx+64]
 vmovdqu     ymm3,ymmword ptr [rcx+96]

 lea         rdx,[rcx+rax]
 add         rcx,256
 cmp         rcx,rdx
 jae         LOOP_END

LOOP_TOP:
 vpminsb     ymm0,ymm0,ymmword ptr [rcx-128]
 vpminsb     ymm1,ymm1,ymmword ptr [rcx-96]
 vpminsb     ymm2,ymm2,ymmword ptr [rcx-64]
 vpminsb     ymm3,ymm3,ymmword ptr [rcx-32]
 sub         rcx,-128
 cmp         rcx,rdx
 jb          LOOP_TOP

LOOP_END:
 vpminsb     ymm0,ymm0,ymmword ptr [rdx-128]
 vpminsb     ymm1,ymm1,ymmword ptr [rdx-96]
 vpminsb     ymm2,ymm2,ymmword ptr [rdx-64]
 vpminsb     ymm3,ymm3,ymmword ptr [rdx-32]

 vpminsb     ymm0,ymm0,ymm2
 vpminsb     ymm1,ymm1,ymm3

 vpminsb     ymm0,ymm0,ymm1

 vextracti128 xmm1,ymm0,1
 vpminsb     xmm0,xmm0,xmm1
 vpunpckhqdq xmm1,xmm0,xmm0
 vpminsb     xmm0,xmm0,xmm1
 vmovshdup   xmm1,xmm0
 vpminsb     xmm0,xmm0,xmm1
 vpshuflw    xmm1,xmm0,225
 vpminsb     xmm0,xmm0,xmm1
 vpsrldq     xmm1,xmm0,1
 vpminsb     xmm0,xmm0,xmm1
 vmovd       eax,xmm0
 ret

AsmFastMinI8 ENDP

_TEXT$AsmFastMinI8 ENDS

END
