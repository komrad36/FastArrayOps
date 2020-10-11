_TEXT$AsmFastMaxIdxI8 SEGMENT ALIGN(64)

AsmFastMaxIdxI8 PROC
 sub		 rsp,200
 vmovdqu     ymm4,ymmword ptr [SEQ]
 mov         eax,edx
 cmp         edx,256
 jae         CASE_LARGE
 vpcmpeqd    ymm0,ymm0,ymm0
 lea		 r8,JUMP_TABLE
 vpsllw      ymm2,ymm0,5
 vpacksswb   ymm2,ymm2,ymm2
 vpxor       xmm1,xmm1,xmm1
 vpavgb      ymm0,ymm0,ymm1
 vmovdqa     ymm1,ymm0
 vmovdqa	 ymm3,ymm4
 movzx		 r9d,word ptr [r8+2*rax]
 add		 r8,r9
 lea         r9,[rcx+rax]
 mov		 r10b,080h
 and		 eax,-32
 add         rcx,rax
 jmp         r8
SEQ:
db  0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15
db 16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
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
dw 32 DUP ( CASE_32 - JUMP_TABLE)
dw 32 DUP ( CASE_64 - JUMP_TABLE)
dw 32 DUP ( CASE_96 - JUMP_TABLE)
dw 32 DUP (CASE_128 - JUMP_TABLE)
dw 32 DUP (CASE_160 - JUMP_TABLE)
dw 32 DUP (CASE_192 - JUMP_TABLE)
dw 32 DUP (CASE_224 - JUMP_TABLE)
CASE_224:
 vmovdqu     ymm1,ymmword ptr [rcx-224]
 vpsubb		 ymm4,ymm4,ymm2
CASE_192:
 vpmaxsb     ymm0,ymm1,ymmword ptr [rcx-192]
 vpcmpeqb    ymm1,ymm0,ymm1
 vpblendvb   ymm3,ymm4,ymm3,ymm1
 vpsubb		 ymm4,ymm4,ymm2
CASE_160:
 vpmaxsb     ymm1,ymm0,ymmword ptr [rcx-160]
 vpcmpeqb    ymm0,ymm0,ymm1
 vpblendvb   ymm3,ymm4,ymm3,ymm0
 vpsubb		 ymm4,ymm4,ymm2
CASE_128:
 vpmaxsb     ymm0,ymm1,ymmword ptr [rcx-128]
 vpcmpeqb    ymm1,ymm0,ymm1
 vpblendvb   ymm3,ymm4,ymm3,ymm1
 vpsubb		 ymm4,ymm4,ymm2
CASE_96:
 vpmaxsb     ymm1,ymm0,ymmword ptr [rcx-96]
 vpcmpeqb    ymm0,ymm0,ymm1
 vpblendvb   ymm3,ymm4,ymm3,ymm0
 vpsubb		 ymm4,ymm4,ymm2
CASE_64:
 vpmaxsb     ymm0,ymm1,ymmword ptr [rcx-64]
 vpcmpeqb    ymm1,ymm0,ymm1
 vpblendvb   ymm3,ymm4,ymm3,ymm1
 vpsubb		 ymm4,ymm4,ymm2
CASE_32:
 vpmaxsb     ymm1,ymm0,ymmword ptr [rcx-32]
 vpcmpeqb    ymm0,ymm0,ymm1
 vpblendvb   ymm3,ymm4,ymm3,ymm0
 lea		 ecx,[rdx-32]
 vmovd		 xmm4,ecx
 vpbroadcastb ymm4,xmm4
 vpaddb		 ymm4,ymm4,ymmword ptr [SEQ]
 vpmaxsb     ymm0,ymm1,ymmword ptr [r9-32]
 vpcmpeqb    ymm1,ymm0,ymm1
 vpblendvb   ymm2,ymm4,ymm3,ymm1
 vextracti128 xmm1,ymm0,1
 vextracti128 xmm3,ymm2,1
 vpmaxsb	 xmm0,xmm0,xmm1
 vpcmpeqb    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm2,xmm3,xmm1
 vpunpckhqdq xmm1,xmm0,xmm0
 vpunpckhqdq xmm3,xmm2,xmm2
 vpmaxsb	 xmm0,xmm0,xmm1
 vpcmpeqb    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm2,xmm3,xmm1
 vmovshdup   xmm1,xmm0
 vmovshdup   xmm3,xmm2
 vpmaxsb	 xmm0,xmm0,xmm1
 vpcmpeqb    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm2,xmm3,xmm1
 vpshuflw    xmm1,xmm0,225
 vpshuflw    xmm3,xmm2,225
 vpmaxsb	 xmm0,xmm0,xmm1
 vpcmpeqb    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm2,xmm3,xmm1
 vpsrldq     xmm1,xmm0,1
 vpsrldq     xmm3,xmm2,1
 vpcmpgtb    xmm0,xmm1,xmm0
 vpblendvb   xmm0,xmm2,xmm3,xmm0
 vmovd       eax,xmm0
 movzx       eax,al
 add         rsp,200
 ret
CASE_16:
 vmovdqu	 xmm1,xmmword ptr [rcx]
 lea		 ecx,[rdx-16]
 vmovd		 xmm4,ecx
 vpbroadcastb xmm4,xmm4
 vpaddb		 xmm4,xmm4,xmmword ptr [SEQ]
 vpmaxsb     xmm0,xmm1,xmmword ptr [r9-16]
 vpcmpeqb    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm4,xmm3,xmm1
 vpunpckhqdq xmm1,xmm0,xmm0
 vpunpckhqdq xmm3,xmm2,xmm2
 vpmaxsb	 xmm0,xmm0,xmm1
 vpcmpeqb    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm2,xmm3,xmm1
 vmovshdup   xmm1,xmm0
 vmovshdup   xmm3,xmm2
 vpmaxsb	 xmm0,xmm0,xmm1
 vpcmpeqb    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm2,xmm3,xmm1
 vpshuflw    xmm1,xmm0,225
 vpshuflw    xmm3,xmm2,225
 vpmaxsb	 xmm0,xmm0,xmm1
 vpcmpeqb    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm2,xmm3,xmm1
 vpsrldq     xmm1,xmm0,1
 vpsrldq     xmm3,xmm2,1
 vpcmpgtb    xmm0,xmm1,xmm0
 vpblendvb   xmm0,xmm2,xmm3,xmm0
 vmovd       eax,xmm0
 movzx       eax,al
 add         rsp,200
 ret
CASE_8:
 vmovq		 xmm1,qword ptr [rcx]
 vmovq		 xmm0,qword ptr [r9-8]
 lea		 ecx,[rdx-8]
 vmovd		 xmm4,ecx
 vpbroadcastb xmm4,xmm4
 vpaddb		 xmm4,xmm4,xmmword ptr [SEQ]
 vpmaxsb     xmm0,xmm0,xmm1
 vpcmpeqb    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm4,xmm3,xmm1
 vmovshdup   xmm1,xmm0
 vmovshdup   xmm3,xmm2
 vpmaxsb	 xmm0,xmm0,xmm1
 vpcmpeqb    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm2,xmm3,xmm1
 vpshuflw    xmm1,xmm0,225
 vpshuflw    xmm3,xmm2,225
 vpmaxsb	 xmm0,xmm0,xmm1
 vpcmpeqb    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm2,xmm3,xmm1
 vpsrldq     xmm1,xmm0,1
 vpsrldq     xmm3,xmm2,1
 vpcmpgtb    xmm0,xmm1,xmm0
 vpblendvb   xmm0,xmm2,xmm3,xmm0
 vmovd       eax,xmm0
 movzx       eax,al
 add         rsp,200
 ret
CASE_7:
 mov		 r10b,byte ptr [r9-7]
CASE_6:
 mov		 cl,byte ptr [r9-6]
 cmp		 r10b,cl
 cmovl		 r10d,ecx
 lea		 ecx,[rdx-6]
 cmovl		 eax,ecx
CASE_5:
 mov		 cl,byte ptr [r9-5]
 cmp		 r10b,cl
 cmovl		 r10d,ecx
 lea		 ecx,[rdx-5]
 cmovl		 eax,ecx
CASE_4:
 mov		 cl,byte ptr [r9-4]
 cmp		 r10b,cl
 cmovl		 r10d,ecx
 lea		 ecx,[rdx-4]
 cmovl		 eax,ecx
CASE_3:
 mov		 cl,byte ptr [r9-3]
 cmp		 r10b,cl
 cmovl		 r10d,ecx
 lea		 ecx,[rdx-3]
 cmovl		 eax,ecx
CASE_2:
 mov		 cl,byte ptr [r9-2]
 cmp		 r10b,cl
 cmovl		 r10d,ecx
 lea		 ecx,[rdx-2]
 cmovl		 eax,ecx
CASE_1:
 lea		 ecx,[rdx-1]
 cmp		 r10b,byte ptr [r9-1]
 cmovl		 eax,ecx
CASE_0:
 add         rsp,200
 ret

CASE_LARGE:
 cmp		 eax,0FFFFh
 ja			 CASE_VERY_LARGE

 vmovaps     xmmword ptr [rsp],xmm6
 vmovaps     xmmword ptr [rsp+16],xmm7
 vmovaps     xmmword ptr [rsp+32],xmm8

 ; -1
 vmovaps     xmmword ptr [rsp+48],xmm9
 vpcmpeqd    ymm9,ymm9,ymm9

 ; outer i
 vmovaps     xmmword ptr [rsp+64],xmm10
 vpxor		 xmm10,xmm10,xmm10

  ; 8-bit index sequence
 vmovaps     xmmword ptr [rsp+80],xmm11
 vmovdqu	 ymm11,ymmword ptr [SEQ]

 ; outer best indices
 vmovaps     xmmword ptr [rsp+96],xmm12
 vpxor		 xmm12,xmm12,xmm12

 ; 128
 vmovaps     xmmword ptr [rsp+112],xmm13
 vpavgb		 ymm13,ymm9,ymm10

 ; 64
 vmovaps     xmmword ptr [rsp+128],xmm14
 vpavgb		 ymm14,ymm13,ymm10

 ; 32
 vmovaps     xmmword ptr [rsp+144],xmm15
 vpavgb		 ymm15,ymm14,ymm10

 ; outer best value (0x80)
 vpavgb		 ymm8,ymm9,ymm10

 lea         rdx,[rcx+rax]
 add         rcx,256
 cmp         rcx,rdx
 jae         LOOP_END

LOOP_TOP:
 vmovdqu     ymm4,ymmword ptr [rcx-256]
 vmovdqu     ymm5,ymmword ptr [rcx-224]
 vmovdqu     ymm6,ymmword ptr [rcx-192]
 vmovdqu     ymm7,ymmword ptr [rcx-160]
 vpmaxsb     ymm0,ymm4,ymmword ptr [rcx-128]
 vpmaxsb     ymm1,ymm5,ymmword ptr [rcx-96]
 vpmaxsb     ymm2,ymm6,ymmword ptr [rcx-64]
 vpmaxsb     ymm3,ymm7,ymmword ptr [rcx-32]
 vpcmpeqb    ymm4,ymm0,ymm4
 vpcmpeqb    ymm5,ymm1,ymm5
 vpcmpeqb    ymm6,ymm2,ymm6
 vpcmpeqb    ymm7,ymm3,ymm7
 vpandn      ymm4,ymm4,ymm13
 vpandn      ymm5,ymm5,ymm13
 vpandn      ymm6,ymm6,ymm13
 vpandn      ymm7,ymm7,ymm13
 vpor		 ymm6,ymm6,ymm14
 vpor		 ymm7,ymm7,ymm14
 vpmaxsb     ymm0,ymm0,ymm2
 vpmaxsb     ymm1,ymm1,ymm3
 vpcmpeqb    ymm2,ymm0,ymm2
 vpcmpeqb    ymm3,ymm1,ymm3
 vpblendvb	 ymm4,ymm4,ymm6,ymm2
 vpblendvb	 ymm5,ymm5,ymm7,ymm3
 vpor		 ymm5,ymm5,ymm15
 vpmaxsb     ymm0,ymm0,ymm1
 vpcmpeqb    ymm1,ymm0,ymm1
 vpblendvb	 ymm4,ymm4,ymm5,ymm1
 vpor		 ymm2,ymm4,ymm11
 vpunpckhqdq ymm1,ymm0,ymm0
 vpunpckhqdq ymm3,ymm2,ymm2
 vpmaxsb	 ymm0,ymm0,ymm1
 vpcmpeqb    ymm1,ymm0,ymm1
 vpblendvb   ymm2,ymm2,ymm3,ymm1
 vpunpcklbw  ymm2,ymm2,ymm10
 vpmaxsb	 ymm8,ymm8,ymm0
 vpcmpeqb    ymm0,ymm0,ymm8
 vpunpcklbw  ymm0,ymm0,ymm0
 vpblendvb	 ymm12,ymm12,ymm2,ymm0

 vpsubb		 ymm10,ymm10,ymm9
 add         rcx,256
 cmp         rcx,rdx
 jb          LOOP_TOP

LOOP_END:

 ; remainder

 sub		 eax,256
 vmovd		 xmm10,eax
 vpbroadcastw ymm10,xmm10

 vmovdqu     ymm4,ymmword ptr [rdx-256]
 vmovdqu     ymm5,ymmword ptr [rdx-224]
 vmovdqu     ymm6,ymmword ptr [rdx-192]
 vmovdqu     ymm7,ymmword ptr [rdx-160]
 vpmaxsb     ymm0,ymm4,ymmword ptr [rdx-128]
 vpmaxsb     ymm1,ymm5,ymmword ptr [rdx-96]
 vpmaxsb     ymm2,ymm6,ymmword ptr [rdx-64]
 vpmaxsb     ymm3,ymm7,ymmword ptr [rdx-32]
 vpcmpeqb    ymm4,ymm0,ymm4
 vpcmpeqb    ymm5,ymm1,ymm5
 vpcmpeqb    ymm6,ymm2,ymm6
 vpcmpeqb    ymm7,ymm3,ymm7
 vpandn      ymm4,ymm4,ymm13
 vpandn      ymm5,ymm5,ymm13
 vpandn      ymm6,ymm6,ymm13
 vpandn      ymm7,ymm7,ymm13
 vpor		 ymm6,ymm6,ymm14
 vpor		 ymm7,ymm7,ymm14
 vpmaxsb     ymm0,ymm0,ymm2
 vpmaxsb     ymm1,ymm1,ymm3
 vpcmpeqb    ymm2,ymm0,ymm2
 vpcmpeqb    ymm3,ymm1,ymm3
 vpblendvb	 ymm4,ymm4,ymm6,ymm2
 vpblendvb	 ymm5,ymm5,ymm7,ymm3
 vpor		 ymm5,ymm5,ymm15
 vmovaps     xmm15,xmmword ptr [rsp+144]
 vpmaxsb     ymm0,ymm0,ymm1
 vmovaps     xmm14,xmmword ptr [rsp+128]
 vpcmpeqb    ymm1,ymm0,ymm1
 vmovaps     xmm13,xmmword ptr [rsp+112]
 vpblendvb	 ymm4,ymm4,ymm5,ymm1
 vpor		 ymm2,ymm4,ymm11
 vpunpckhqdq ymm1,ymm0,ymm0
 vpunpckhqdq ymm3,ymm2,ymm2
 vpmaxsb	 ymm0,ymm0,ymm1
 vpcmpeqb    ymm1,ymm0,ymm1
 vpblendvb   ymm2,ymm2,ymm3,ymm1
 vpxor		 xmm3,xmm3,xmm3
 vpunpcklbw  ymm2,ymm2,ymm3
 vpaddw		 ymm2,ymm2,ymm10
 vpmaxsb	 ymm0,ymm8,ymm0
 vpcmpeqb    ymm8,ymm0,ymm8
 vpunpcklbw  ymm8,ymm8,ymm8
 vpblendvb	 ymm2,ymm2,ymm12,ymm8
 vmovaps     xmm12,xmmword ptr [rsp+96]

 ; reduce

 vextracti128 xmm1,ymm0,1
 vmovaps     xmm11,xmmword ptr [rsp+80]
 vextracti128 xmm3,ymm2,1
 vmovaps     xmm10,xmmword ptr [rsp+64]
 vpmovsxbw   xmm0,xmm0
 vmovaps     xmm9,xmmword ptr [rsp+48]
 vpmovsxbw   xmm1,xmm1
 vmovaps     xmm8,xmmword ptr [rsp+32]
 vpmaxsw	 xmm0,xmm0,xmm1
 vmovaps     xmm7,xmmword ptr [rsp+16]
 vpcmpeqw    xmm1,xmm0,xmm1
 vmovaps     xmm6,xmmword ptr [rsp]
 vpblendvb   xmm2,xmm2,xmm3,xmm1
 vpunpckhqdq xmm1,xmm0,xmm0
 vpunpckhqdq xmm3,xmm2,xmm2
 vpmaxsw	 xmm0,xmm0,xmm1
 vpcmpeqw    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm2,xmm3,xmm1
 vmovshdup   xmm1,xmm0
 vmovshdup   xmm3,xmm2
 vpmaxsw	 xmm0,xmm0,xmm1
 vpcmpeqw    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm2,xmm3,xmm1
 vpshuflw    xmm1,xmm0,225
 vpshuflw    xmm3,xmm2,225
 vpcmpgtw    xmm0,xmm1,xmm0
 vpblendvb   xmm0,xmm2,xmm3,xmm0
 vmovd       eax,xmm0
 movzx       eax,ax

 add         rsp,200
 ret

CASE_VERY_LARGE:

 vmovaps     xmmword ptr [rsp],xmm6
 vmovaps     xmmword ptr [rsp+16],xmm7
 vmovaps     xmmword ptr [rsp+32],xmm8

 ; -1
 vmovaps     xmmword ptr [rsp+48],xmm9
 vpcmpeqd    ymm9,ymm9,ymm9

 ; 16-bit outer i
 vmovaps     xmmword ptr [rsp+64],xmm10
 vpxor		 xmm10,xmm10,xmm10

 ; 8-bit index sequence
 vmovaps     xmmword ptr [rsp+80],xmm11
 vmovdqu	 ymm11,ymmword ptr [SEQ]
 vmovaps     xmmword ptr [rsp+96],xmm12

 ; 128
 vmovaps     xmmword ptr [rsp+112],xmm13
 vpavgb		 ymm13,ymm9,ymm10

 ; 64
 vmovaps     xmmword ptr [rsp+128],xmm14
 vpavgb		 ymm14,ymm13,ymm10

 ; 32
 vmovaps     xmmword ptr [rsp+144],xmm15
 vpavgb		 ymm15,ymm14,ymm10

 ; 32-bit outer i
 xor		 r9d,r9d

 ; 8-bit outer best value (0x80)
 vmovdqu	 ymmword ptr [rsp+160],ymm13

 ; 32-bit outer best indices
 vmovdqu	 ymmword ptr [rsp+208],ymm10

 lea         rdx,[rcx+rax]
 add		 rcx,256

OUTER_LOOP_TOP:

 ; 16-bit outer best indices
 vpxor		 xmm12,xmm12,xmm12

 ; 8-bit outer best value (0x80)
 vmovdqa	 ymm8,ymm13

 lea         r8,[rcx+010000h]
 cmp		 r8,rdx
 cmova       r8,rdx

 cmp         rcx,r8
 jae         INNER_LOOP_END

INNER_LOOP_TOP:
 vmovdqu     ymm4,ymmword ptr [rcx-256]
 vmovdqu     ymm5,ymmword ptr [rcx-224]
 vmovdqu     ymm6,ymmword ptr [rcx-192]
 vmovdqu     ymm7,ymmword ptr [rcx-160]
 vpmaxsb     ymm0,ymm4,ymmword ptr [rcx-128]
 vpmaxsb     ymm1,ymm5,ymmword ptr [rcx-96]
 vpmaxsb     ymm2,ymm6,ymmword ptr [rcx-64]
 vpmaxsb     ymm3,ymm7,ymmword ptr [rcx-32]
 vpcmpeqb    ymm4,ymm0,ymm4
 vpcmpeqb    ymm5,ymm1,ymm5
 vpcmpeqb    ymm6,ymm2,ymm6
 vpcmpeqb    ymm7,ymm3,ymm7
 vpandn      ymm4,ymm4,ymm13
 vpandn      ymm5,ymm5,ymm13
 vpandn      ymm6,ymm6,ymm13
 vpandn      ymm7,ymm7,ymm13
 vpor		 ymm6,ymm6,ymm14
 vpor		 ymm7,ymm7,ymm14
 vpmaxsb     ymm0,ymm0,ymm2
 vpmaxsb     ymm1,ymm1,ymm3
 vpcmpeqb    ymm2,ymm0,ymm2
 vpcmpeqb    ymm3,ymm1,ymm3
 vpblendvb	 ymm4,ymm4,ymm6,ymm2
 vpblendvb	 ymm5,ymm5,ymm7,ymm3
 vpor		 ymm5,ymm5,ymm15
 vpmaxsb     ymm0,ymm0,ymm1
 vpcmpeqb    ymm1,ymm0,ymm1
 vpblendvb	 ymm4,ymm4,ymm5,ymm1
 vpor		 ymm2,ymm4,ymm11
 vpunpckhqdq ymm1,ymm0,ymm0
 vpunpckhqdq ymm3,ymm2,ymm2
 vpmaxsb	 ymm0,ymm0,ymm1
 vpcmpeqb    ymm1,ymm0,ymm1
 vpblendvb   ymm2,ymm2,ymm3,ymm1
 vpunpcklbw  ymm2,ymm2,ymm10
 vpmaxsb	 ymm8,ymm8,ymm0
 vpcmpeqb    ymm0,ymm0,ymm8
 vpunpcklbw  ymm0,ymm0,ymm0
 vpblendvb	 ymm12,ymm12,ymm2,ymm0

 vpsubb		 ymm10,ymm10,ymm9
 add         rcx,256
 cmp         rcx,r8
 jb          INNER_LOOP_TOP

INNER_LOOP_END:

 vmovshdup   ymm0,ymm8
 vpunpckhqdq ymm2,ymm12,ymm12
 vpmaxsb	 ymm0,ymm0,ymm8
 vpcmpeqb    ymm1,ymm0,ymm8
 vpunpcklbw  ymm1,ymm1,ymm1
 vpblendvb   ymm2,ymm2,ymm12,ymm1

 vmovd		 xmm1,r9d
 vpbroadcastw ymm1,xmm1
 vpunpcklwd  ymm2,ymm2,ymm1

 vpmaxsb	 ymm1,ymm0,ymmword ptr [rsp+160]
 vpcmpeqb    ymm0,ymm0,ymm1
 vmovdqu	 ymmword ptr [rsp+160],ymm1
 vpunpcklbw  ymm0,ymm0,ymm0
 vpunpcklwd  ymm0,ymm0,ymm0
 vpsubd      ymm0,ymm9,ymm0

 vpblendvb	 ymm3,ymm2,ymmword ptr [rsp+208],ymm0
 vmovdqu	 ymmword ptr [rsp+208],ymm3

 inc		 r9d

 cmp         rcx,rdx
 jb          OUTER_LOOP_TOP

 ; remainder

 vmovdqu     ymm4,ymmword ptr [rdx-256]
 vmovdqu     ymm5,ymmword ptr [rdx-224]
 vmovdqu     ymm6,ymmword ptr [rdx-192]
 vmovdqu     ymm7,ymmword ptr [rdx-160]
 vpmaxsb     ymm0,ymm4,ymmword ptr [rdx-128]
 vpmaxsb     ymm1,ymm5,ymmword ptr [rdx-96]
 vpmaxsb     ymm2,ymm6,ymmword ptr [rdx-64]
 vpmaxsb     ymm3,ymm7,ymmword ptr [rdx-32]
 vpcmpeqb    ymm4,ymm0,ymm4
 vpcmpeqb    ymm5,ymm1,ymm5
 vpcmpeqb    ymm6,ymm2,ymm6
 vpcmpeqb    ymm7,ymm3,ymm7
 vpandn      ymm4,ymm4,ymm13
 vpandn      ymm5,ymm5,ymm13
 vpandn      ymm6,ymm6,ymm13
 vpandn      ymm7,ymm7,ymm13
 vpor		 ymm6,ymm6,ymm14
 vpor		 ymm7,ymm7,ymm14
 vpmaxsb     ymm0,ymm0,ymm2
 vpmaxsb     ymm1,ymm1,ymm3
 vpcmpeqb    ymm2,ymm0,ymm2
 vpcmpeqb    ymm3,ymm1,ymm3
 vpblendvb	 ymm4,ymm4,ymm6,ymm2
 vpblendvb	 ymm5,ymm5,ymm7,ymm3
 vpor		 ymm5,ymm5,ymm15
 vmovaps     xmm15,xmmword ptr [rsp+144]
 vpmaxsb     ymm0,ymm0,ymm1
 vmovaps     xmm14,xmmword ptr [rsp+128]
 vpcmpeqb    ymm1,ymm0,ymm1
 vmovaps     xmm13,xmmword ptr [rsp+112]
 vpblendvb	 ymm4,ymm4,ymm5,ymm1
 vmovaps     xmm12,xmmword ptr [rsp+96]
 vpor		 ymm2,ymm4,ymm11
 vmovaps     xmm11,xmmword ptr [rsp+80]
 vpunpckhqdq ymm1,ymm0,ymm0
 vmovaps     xmm10,xmmword ptr [rsp+64]
 vpunpckhqdq ymm3,ymm2,ymm2
 vpmaxsb	 ymm0,ymm0,ymm1
 vpcmpeqb    ymm1,ymm0,ymm1
 vpblendvb   ymm2,ymm2,ymm3,ymm1
 vmovshdup   ymm1,ymm0
 vmovshdup   ymm3,ymm2
 vpmaxsb	 ymm1,ymm0,ymm1
 vpcmpeqb    ymm0,ymm0,ymm1
 vpblendvb   ymm2,ymm3,ymm2,ymm0
 vpxor		 xmm4,xmm4,xmm4
 vpunpcklbw  ymm2,ymm2,ymm4
 vpunpcklwd  ymm2,ymm2,ymm4
 sub		 eax,256
 vmovd		 xmm0,eax
 vpbroadcastd ymm0,xmm0
 vpaddd		 ymm3,ymm2,ymm0

 vpmaxsb	 ymm0,ymm1,ymmword ptr [rsp+160]
 vpcmpeqb    ymm1,ymm0,ymm1
 vpunpcklbw  ymm1,ymm1,ymm1
 vpunpcklwd  ymm1,ymm1,ymm1
 vpsubd      ymm1,ymm9,ymm1
 vmovaps     xmm9,xmmword ptr [rsp+48]
 vpblendvb	 ymm2,ymm3,ymmword ptr [rsp+208],ymm1
 vmovaps     xmm8,xmmword ptr [rsp+32]

 ; reduce

 vextracti128 xmm1,ymm0,1
 vmovaps     xmm7,xmmword ptr [rsp+16]
 vextracti128 xmm3,ymm2,1
 vmovaps     xmm6,xmmword ptr [rsp]
 vpmovsxbd   xmm0,xmm0
 vpmovsxbd   xmm1,xmm1
 vpmaxsd	 xmm0,xmm0,xmm1
 vpcmpeqd    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm2,xmm3,xmm1
 vpunpckhqdq xmm1,xmm0,xmm0
 vpunpckhqdq xmm3,xmm2,xmm2
 vpmaxsd	 xmm0,xmm0,xmm1
 vpcmpeqd    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm2,xmm3,xmm1
 vmovshdup   xmm1,xmm0
 vmovshdup   xmm3,xmm2
 vpcmpgtd    xmm1,xmm1,xmm0
 vpblendvb   xmm0,xmm2,xmm3,xmm1
 vmovd       eax,xmm0

 add         rsp,200
 ret

AsmFastMaxIdxI8 ENDP

_TEXT$AsmFastMaxIdxI8 ENDS

END
