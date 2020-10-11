bits 64
section .text
align 64
global AsmFastMinIdxI16

AsmFastMinIdxI16:
 vmovdqu     ymm4,yword [SEQ]
 mov         eax,esi
 cmp         esi,127
 ja          CASE_LARGE
 vpcmpeqd    ymm0,ymm0,ymm0
 lea         r8,[JUMP_TABLE]
 vpsllw      ymm2,ymm0,4
 vpsrlw      ymm0,ymm0,1
 vmovdqa     ymm1,ymm0
 vmovdqa     ymm3,ymm4
 movzx       r9d,word [r8+2*rax]
 add         r8,r9
 lea         r9,[rdi+2*rax]
 mov         r10w,07FFFh
 and         eax,-16
 lea         rdi,[rdi+2*rax]
 jmp         r8
SEQ:
dw 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
JUMP_TABLE:
times  1 dw (  CASE_0 - JUMP_TABLE)
times  1 dw (  CASE_1 - JUMP_TABLE)
times  1 dw (  CASE_2 - JUMP_TABLE)
times  1 dw (  CASE_3 - JUMP_TABLE)
times  1 dw (  CASE_4 - JUMP_TABLE)
times  1 dw (  CASE_5 - JUMP_TABLE)
times  1 dw (  CASE_6 - JUMP_TABLE)
times  1 dw (  CASE_7 - JUMP_TABLE)
times  8 dw (  CASE_8 - JUMP_TABLE)
times 16 dw ( CASE_16 - JUMP_TABLE)
times 16 dw ( CASE_32 - JUMP_TABLE)
times 16 dw ( CASE_48 - JUMP_TABLE)
times 16 dw ( CASE_64 - JUMP_TABLE)
times 16 dw ( CASE_80 - JUMP_TABLE)
times 16 dw ( CASE_96 - JUMP_TABLE)
times 16 dw (CASE_112 - JUMP_TABLE)
CASE_112:
 vmovdqu     ymm1,yword [rdi-224]
 vpsubw      ymm4,ymm4,ymm2
CASE_96:
 vpminsw     ymm0,ymm1,yword [rdi-192]
 vpcmpeqw    ymm1,ymm0,ymm1
 vpblendvb   ymm3,ymm4,ymm3,ymm1
 vpsubw      ymm4,ymm4,ymm2
CASE_80:
 vpminsw     ymm1,ymm0,yword [rdi-160]
 vpcmpeqw    ymm0,ymm0,ymm1
 vpblendvb   ymm3,ymm4,ymm3,ymm0
 vpsubw      ymm4,ymm4,ymm2
CASE_64:
 vpminsw     ymm0,ymm1,yword [rdi-128]
 vpcmpeqw    ymm1,ymm0,ymm1
 vpblendvb   ymm3,ymm4,ymm3,ymm1
 vpsubw      ymm4,ymm4,ymm2
CASE_48:
 vpminsw     ymm1,ymm0,yword [rdi-96]
 vpcmpeqw    ymm0,ymm0,ymm1
 vpblendvb   ymm3,ymm4,ymm3,ymm0
 vpsubw      ymm4,ymm4,ymm2
CASE_32:
 vpminsw     ymm0,ymm1,yword [rdi-64]
 vpcmpeqw    ymm1,ymm0,ymm1
 vpblendvb   ymm3,ymm4,ymm3,ymm1
 vpsubw      ymm4,ymm4,ymm2
CASE_16:
 vpminsw     ymm1,ymm0,yword [rdi-32]
 vpcmpeqw    ymm0,ymm0,ymm1
 vpblendvb   ymm3,ymm4,ymm3,ymm0
 lea         edi,[rsi-16]
 vmovd       xmm4,edi
 vpbroadcastw ymm4,xmm4
 vpaddw      ymm4,ymm4,yword [SEQ]
 vpminsw     ymm0,ymm1,yword [r9-32]
 vpcmpeqw    ymm1,ymm0,ymm1
 vpblendvb   ymm2,ymm4,ymm3,ymm1
 vextracti128 xmm1,ymm0,1
 vextracti128 xmm3,ymm2,1
 vpminsw     xmm0,xmm0,xmm1
 vpcmpeqw    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm2,xmm3,xmm1
 vpunpckhqdq xmm1,xmm0,xmm0
 vpunpckhqdq xmm3,xmm2,xmm2
 vpminsw     xmm0,xmm0,xmm1
 vpcmpeqw    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm2,xmm3,xmm1
 vmovshdup   xmm1,xmm0
 vmovshdup   xmm3,xmm2
 vpminsw     xmm0,xmm0,xmm1
 vpcmpeqw    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm2,xmm3,xmm1
 vpshuflw    xmm1,xmm0,225
 vpshuflw    xmm3,xmm2,225
 vpcmpgtw    xmm0,xmm0,xmm1
 vpblendvb   xmm0,xmm2,xmm3,xmm0
 vmovd       eax,xmm0
 cwde
 ret
CASE_8:
 vpminsw     xmm1,xmm0,oword [rdi]
 vpcmpeqw    xmm0,xmm0,xmm1
 vpblendvb   xmm3,xmm4,xmm3,xmm0
 lea         edi,[rsi-8]
 vmovd       xmm4,edi
 vpbroadcastw xmm4,xmm4
 vpaddw      xmm4,xmm4,oword [SEQ]
 vpminsw     xmm0,xmm1,oword [r9-16]
 vpcmpeqw    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm4,xmm3,xmm1
 vpunpckhqdq xmm1,xmm0,xmm0
 vpunpckhqdq xmm3,xmm2,xmm2
 vpminsw     xmm0,xmm0,xmm1
 vpcmpeqw    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm2,xmm3,xmm1
 vmovshdup   xmm1,xmm0
 vmovshdup   xmm3,xmm2
 vpminsw     xmm0,xmm0,xmm1
 vpcmpeqw    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm2,xmm3,xmm1
 vpshuflw    xmm1,xmm0,225
 vpshuflw    xmm3,xmm2,225
 vpcmpgtw    xmm0,xmm0,xmm1
 vpblendvb   xmm0,xmm2,xmm3,xmm0
 vmovd       eax,xmm0
 cwde
 ret
CASE_7:
 mov         r10w,word [r9-14]
CASE_6:
 lea         ecx,[rsi-6]
 cmp         r10w,word [r9-12]
 cmovg       r10w,word [r9-12]
 cmovg       eax,ecx
CASE_5:
 lea         ecx,[rsi-5]
 cmp         r10w,word [r9-10]
 cmovg       r10w,word [r9-10]
 cmovg       eax,ecx
CASE_4:
 lea         ecx,[rsi-4]
 cmp         r10w,word [r9-8]
 cmovg       r10w,word [r9-8]
 cmovg       eax,ecx
CASE_3:
 lea         ecx,[rsi-3]
 cmp         r10w,word [r9-6]
 cmovg       r10w,word [r9-6]
 cmovg       eax,ecx
CASE_2:
 lea         ecx,[rsi-2]
 cmp         r10w,word [r9-4]
 cmovg       r10w,word [r9-4]
 cmovg       eax,ecx
CASE_1:
 lea         ecx,[rsi-1]
 cmp         r10w,word [r9-2]
 cmovg       eax,ecx
CASE_0:
 ret

CASE_LARGE:
 cmp         eax,0FFFFh
 ja          CASE_VERY_LARGE

 ; best indices
 vmovdqa     ymm5,ymm4
 vmovdqa     ymm6,ymm4
 vmovdqa     ymm7,ymm4
 vmovdqa     ymm8,ymm4

 ; increment
 vpcmpeqd    ymm9,ymm9,ymm9
 vpsllw      ymm9,ymm9,6

 ; best values
 vmovdqu     ymm10,yword [rdi]
 vmovdqu     ymm11,yword [rdi+32]
 vmovaps     oword [rsp-24],xmm12
 vmovdqu     ymm12,yword [rdi+64]
 vmovaps     oword [rsp-40],xmm13
 vmovdqu     ymm13,yword [rdi+96]

 vpsubw      ymm4,ymm4,ymm9

 vpminsw     ymm0,ymm10,yword [rdi+128]
 vpminsw     ymm1,ymm11,yword [rdi+160]
 vpminsw     ymm2,ymm12,yword [rdi+192]
 vpminsw     ymm3,ymm13,yword [rdi+224]
 vpcmpeqw    ymm10,ymm0,ymm10
 vpblendvb   ymm5,ymm4,ymm5,ymm10
 vpcmpeqw    ymm11,ymm1,ymm11
 vpblendvb   ymm6,ymm4,ymm6,ymm11
 vpcmpeqw    ymm12,ymm2,ymm12
 vpblendvb   ymm7,ymm4,ymm7,ymm12
 vpcmpeqw    ymm13,ymm3,ymm13
 vpblendvb   ymm8,ymm4,ymm8,ymm13

 vpsubw      ymm4,ymm4,ymm9

 lea         rsi,[rdi+2*rax]
 add         rdi,512
 cmp         rdi,rsi
 jae         LOOP_END

LOOP_TOP:
 vpminsw     ymm10,ymm0,yword [rdi-256]
 vpminsw     ymm11,ymm1,yword [rdi-224]
 vpminsw     ymm12,ymm2,yword [rdi-192]
 vpminsw     ymm13,ymm3,yword [rdi-160]
 vpcmpeqw    ymm0,ymm0,ymm10
 vpblendvb   ymm5,ymm4,ymm5,ymm0
 vpminsw     ymm0,ymm10,yword [rdi-128]
 vpcmpeqw    ymm1,ymm1,ymm11
 vpblendvb   ymm6,ymm4,ymm6,ymm1
 vpminsw     ymm1,ymm11,yword [rdi-96]
 vpcmpeqw    ymm2,ymm2,ymm12
 vpblendvb   ymm7,ymm4,ymm7,ymm2
 vpminsw     ymm2,ymm12,yword [rdi-64]
 vpcmpeqw    ymm3,ymm3,ymm13
 vpblendvb   ymm8,ymm4,ymm8,ymm3
 vpminsw     ymm3,ymm13,yword [rdi-32]
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
 add         rdi,256
 cmp         rdi,rsi
 jb          LOOP_TOP

LOOP_END:
 add         eax,-128
 vmovd       xmm4,eax
 vpbroadcastw ymm4,xmm4
 vpaddw      ymm4,ymm4,yword [SEQ]

 vpminsw     ymm10,ymm0,yword [rsi-256]
 vpminsw     ymm11,ymm1,yword [rsi-224]
 vpminsw     ymm12,ymm2,yword [rsi-192]
 vpminsw     ymm13,ymm3,yword [rsi-160]
 vpcmpeqw    ymm0,ymm0,ymm10
 vpblendvb   ymm5,ymm4,ymm5,ymm0
 vpminsw     ymm0,ymm10,yword [rsi-128]
 vpcmpeqw    ymm1,ymm1,ymm11
 vpblendvb   ymm6,ymm4,ymm6,ymm1
 vpminsw     ymm1,ymm11,yword [rsi-96]
 vpcmpeqw    ymm2,ymm2,ymm12
 vpblendvb   ymm7,ymm4,ymm7,ymm2
 vpminsw     ymm2,ymm12,yword [rsi-64]
 vpcmpeqw    ymm3,ymm3,ymm13
 vpblendvb   ymm8,ymm4,ymm8,ymm3
 vpminsw     ymm3,ymm13,yword [rsi-32]
 vpsubw      ymm4,ymm4,ymm9
 vpcmpeqw    ymm13,ymm3,ymm13
 vpblendvb   ymm8,ymm4,ymm8,ymm13
 vmovaps     xmm13,oword [rsp-40]
 vpcmpeqw    ymm12,ymm2,ymm12
 vpblendvb   ymm7,ymm4,ymm7,ymm12
 vmovaps     xmm12,oword [rsp-24]
 vpcmpeqw    ymm11,ymm1,ymm11
 vpblendvb   ymm6,ymm4,ymm6,ymm11
 vpcmpeqw    ymm10,ymm0,ymm10
 vpblendvb   ymm5,ymm4,ymm5,ymm10

 vpsraw      ymm4,ymm9,1

 vpminsw     ymm1,ymm1,ymm3
 vpcmpeqw    ymm3,ymm1,ymm3
 vpsubw      ymm8,ymm8,ymm4
 vpblendvb   ymm6,ymm6,ymm8,ymm3

 vpminsw     ymm0,ymm0,ymm2
 vpcmpeqw    ymm2,ymm0,ymm2
 vpsubw      ymm7,ymm7,ymm4
 vpblendvb   ymm5,ymm5,ymm7,ymm2

 vpsraw      ymm4,ymm4,1

 vpminsw     ymm0,ymm0,ymm1
 vpcmpeqw    ymm1,ymm0,ymm1
 vpsubw      ymm6,ymm6,ymm4
 vpblendvb   ymm2,ymm5,ymm6,ymm1

 vextracti128 xmm1,ymm0,1
 vextracti128 xmm3,ymm2,1

 vpminsw     xmm0,xmm0,xmm1
 vpcmpeqw    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm2,xmm3,xmm1

 vpunpckhqdq xmm1,xmm0,xmm0
 vpunpckhqdq xmm3,xmm2,xmm2

 vpminsw     xmm0,xmm0,xmm1
 vpcmpeqw    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm2,xmm3,xmm1

 vmovshdup   xmm1,xmm0
 vmovshdup   xmm3,xmm2

 vpminsw     xmm0,xmm0,xmm1
 vpcmpeqw    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm2,xmm3,xmm1

 vpshuflw    xmm1,xmm0,225
 vpshuflw    xmm3,xmm2,225

 vpcmpgtw    xmm0,xmm0,xmm1
 vpblendvb   xmm0,xmm2,xmm3,xmm0
 vmovd       eax,xmm0
 movzx       eax,ax

 ret

CASE_VERY_LARGE:

 lea         rsi,[rdi+2*rax]
 add         rdi,256

 vmovaps     oword [rsp-24],xmm12
 vmovaps     oword [rsp-40],xmm13
 vmovaps     oword [rsp-56],xmm14
 vmovaps     oword [rsp-72],xmm15

 ; outer i
 xor         r9d,r9d

 ; outer best values
 vpcmpeqd    ymm14,ymm14,ymm14
 vpsrlw      ymm14,ymm14,1

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
 vmovdqu     ymm10,yword [rdi-256]
 vmovdqu     ymm11,yword [rdi-224]
 vmovdqu     ymm12,yword [rdi-192]
 vmovdqu     ymm13,yword [rdi-160]

 vpsubw      ymm4,ymm4,ymm9

 vpminsw     ymm0,ymm10,yword [rdi-128]
 vpminsw     ymm1,ymm11,yword [rdi-96]
 vpminsw     ymm2,ymm12,yword [rdi-64]
 vpminsw     ymm3,ymm13,yword [rdi-32]
 vpcmpeqw    ymm10,ymm0,ymm10
 vpblendvb   ymm5,ymm4,ymm5,ymm10
 vpcmpeqw    ymm11,ymm1,ymm11
 vpblendvb   ymm6,ymm4,ymm6,ymm11
 vpcmpeqw    ymm12,ymm2,ymm12
 vpblendvb   ymm7,ymm4,ymm7,ymm12
 vpcmpeqw    ymm13,ymm3,ymm13
 vpblendvb   ymm8,ymm4,ymm8,ymm13

 vpsubw      ymm4,ymm4,ymm9

 lea         r8,[rdi+020000h]
 cmp         r8,rsi
 cmova       r8,rsi

 add         rdi,256

 cmp         rdi,r8
 jae         INNER_LOOP_END

INNER_LOOP_TOP:
 vpminsw     ymm10,ymm0,yword [rdi-256]
 vpminsw     ymm11,ymm1,yword [rdi-224]
 vpminsw     ymm12,ymm2,yword [rdi-192]
 vpminsw     ymm13,ymm3,yword [rdi-160]
 vpcmpeqw    ymm0,ymm0,ymm10
 vpblendvb   ymm5,ymm4,ymm5,ymm0
 vpminsw     ymm0,ymm10,yword [rdi-128]
 vpcmpeqw    ymm1,ymm1,ymm11
 vpblendvb   ymm6,ymm4,ymm6,ymm1
 vpminsw     ymm1,ymm11,yword [rdi-96]
 vpcmpeqw    ymm2,ymm2,ymm12
 vpblendvb   ymm7,ymm4,ymm7,ymm2
 vpminsw     ymm2,ymm12,yword [rdi-64]
 vpcmpeqw    ymm3,ymm3,ymm13
 vpblendvb   ymm8,ymm4,ymm8,ymm3
 vpminsw     ymm3,ymm13,yword [rdi-32]
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
 add         rdi,256
 cmp         rdi,r8
 jb          INNER_LOOP_TOP

INNER_LOOP_END:

 vpsraw      ymm10,ymm9,1
 vpsubw      ymm7,ymm7,ymm10
 vpsubw      ymm8,ymm8,ymm10

 vpminsw     ymm0,ymm0,ymm2
 vpcmpeqw    ymm2,ymm0,ymm2
 vpblendvb   ymm5,ymm5,ymm7,ymm2

 vpminsw     ymm1,ymm1,ymm3
 vpcmpeqw    ymm3,ymm1,ymm3
 vpblendvb   ymm6,ymm6,ymm8,ymm3

 vpsraw      ymm10,ymm10,1
 vpsubw      ymm6,ymm6,ymm10

 vpminsw     ymm0,ymm0,ymm1
 vpcmpeqw    ymm1,ymm0,ymm1
 vpblendvb   ymm5,ymm5,ymm6,ymm1

 vpunpckhqdq ymm1,ymm0,ymm0
 vpunpckhqdq ymm6,ymm5,ymm5

 vpminsw     ymm0,ymm0,ymm1
 vpcmpeqw    ymm1,ymm0,ymm1
 vpblendvb   ymm5,ymm5,ymm6,ymm1

 vmovd       xmm6,r9d
 vpbroadcastd ymm6,xmm6
 vpunpcklwd  ymm5,ymm5,ymm6

 vpminsw     ymm14,ymm0,ymm14
 vpcmpeqw    ymm1,ymm0,ymm14
 vpunpcklwd  ymm1,ymm1,ymm1
 vpblendvb   ymm15,ymm15,ymm5,ymm1

 inc         r9d

 cmp         rdi,rsi
 jb          OUTER_LOOP_TOP

 ; remainder

 vpabsw      ymm4,ymm9

 vmovdqu     ymm5,yword [rsi-256]
 vmovdqu     ymm6,yword [rsi-224]
 vmovdqu     ymm7,yword [rsi-192]
 vmovdqu     ymm8,yword [rsi-160]

 vpminsw     ymm0,ymm5,yword [rsi-128]
 vpminsw     ymm1,ymm6,yword [rsi-96]
 vpminsw     ymm2,ymm7,yword [rsi-64]
 vpminsw     ymm3,ymm8,yword [rsi-32]

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

 vpminsw     ymm0,ymm0,ymm2
 vpminsw     ymm1,ymm1,ymm3

 vpcmpeqw    ymm2,ymm0,ymm2
 vpcmpeqw    ymm3,ymm1,ymm3

 vpblendvb   ymm5,ymm5,ymm7,ymm2
 vpblendvb   ymm6,ymm6,ymm8,ymm3

 vpsrlw      ymm4,ymm4,1
 vpor        ymm6,ymm6,ymm4

 vpminsw     ymm0,ymm0,ymm1

 vpcmpeqw    ymm1,ymm0,ymm1

 vpblendvb   ymm5,ymm5,ymm6,ymm1
 vpor        ymm5,ymm5,yword [SEQ]

 vpunpckhqdq ymm1,ymm0,ymm0
 vpunpckhqdq ymm4,ymm5,ymm5

 vpminsw     ymm0,ymm0,ymm1
 vpcmpeqw    ymm1,ymm0,ymm1
 vpblendvb   ymm5,ymm5,ymm4,ymm1
 vmovaps     xmm12,oword [rsp-24]

 vpxor       xmm2,xmm2,xmm2
 vmovaps     xmm13,oword [rsp-40]
 vpunpcklwd  ymm5,ymm5,ymm2
 add         eax,-128
 vmovd       xmm4,eax
 vpbroadcastd ymm4,xmm4
 vpaddd      ymm5,ymm5,ymm4

 vpminsw     ymm0,ymm0,ymm14
 vpcmpeqw    ymm1,ymm0,ymm14
 vmovaps     xmm14,oword [rsp-56]
 vpunpcklwd  ymm1,ymm1,ymm1
 vpblendvb   ymm2,ymm5,ymm15,ymm1
 vmovaps     xmm15,oword [rsp-72]

 ; reduce

 vextracti128 xmm1,ymm0,1
 vextracti128 xmm3,ymm2,1

 vpmovsxwd   xmm0,xmm0
 vpmovsxwd   xmm1,xmm1

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

 ret
