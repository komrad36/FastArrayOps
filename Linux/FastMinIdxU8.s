bits 64
section .text
align 64
global AsmFastMinIdxU8

AsmFastMinIdxU8:
 sub         rsp,136
 vmovdqu     ymm4,yword [SEQ]
 mov         eax,esi
 cmp         esi,256
 jae         CASE_LARGE
 vpcmpeqd    ymm0,ymm0,ymm0
 lea         r8,[JUMP_TABLE]
 vpsllw      ymm2,ymm0,5
 vpacksswb   ymm2,ymm2,ymm2
 vmovdqa     ymm1,ymm0
 vmovdqa     ymm3,ymm4
 movzx       r9d,word [r8+2*rax]
 add         r8,r9
 lea         r9,[rdi+rax]
 mov         r10b,-1
 and         eax,-32
 add         rdi,rax
 jmp         r8
SEQ:
db  0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15
db 16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
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
times 32 dw ( CASE_32 - JUMP_TABLE)
times 32 dw ( CASE_64 - JUMP_TABLE)
times 32 dw ( CASE_96 - JUMP_TABLE)
times 32 dw (CASE_128 - JUMP_TABLE)
times 32 dw (CASE_160 - JUMP_TABLE)
times 32 dw (CASE_192 - JUMP_TABLE)
times 32 dw (CASE_224 - JUMP_TABLE)
CASE_224:
 vmovdqu     ymm1,yword [rdi-224]
 vpsubb      ymm4,ymm4,ymm2
CASE_192:
 vpminub     ymm0,ymm1,yword [rdi-192]
 vpcmpeqb    ymm1,ymm0,ymm1
 vpblendvb   ymm3,ymm4,ymm3,ymm1
 vpsubb      ymm4,ymm4,ymm2
CASE_160:
 vpminub     ymm1,ymm0,yword [rdi-160]
 vpcmpeqb    ymm0,ymm0,ymm1
 vpblendvb   ymm3,ymm4,ymm3,ymm0
 vpsubb      ymm4,ymm4,ymm2
CASE_128:
 vpminub     ymm0,ymm1,yword [rdi-128]
 vpcmpeqb    ymm1,ymm0,ymm1
 vpblendvb   ymm3,ymm4,ymm3,ymm1
 vpsubb      ymm4,ymm4,ymm2
CASE_96:
 vpminub     ymm1,ymm0,yword [rdi-96]
 vpcmpeqb    ymm0,ymm0,ymm1
 vpblendvb   ymm3,ymm4,ymm3,ymm0
 vpsubb      ymm4,ymm4,ymm2
CASE_64:
 vpminub     ymm0,ymm1,yword [rdi-64]
 vpcmpeqb    ymm1,ymm0,ymm1
 vpblendvb   ymm3,ymm4,ymm3,ymm1
 vpsubb      ymm4,ymm4,ymm2
CASE_32:
 vpminub     ymm1,ymm0,yword [rdi-32]
 vpcmpeqb    ymm0,ymm0,ymm1
 vpblendvb   ymm3,ymm4,ymm3,ymm0
 lea         edi,[rsi-32]
 vmovd       xmm4,edi
 vpbroadcastb ymm4,xmm4
 vpaddb      ymm4,ymm4,yword [SEQ]
 vpminub     ymm0,ymm1,yword [r9-32]
 vpcmpeqb    ymm1,ymm0,ymm1
 vpblendvb   ymm2,ymm4,ymm3,ymm1
 vextracti128 xmm1,ymm0,1
 vextracti128 xmm3,ymm2,1
 vpminub     xmm0,xmm0,xmm1
 vpcmpeqb    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm2,xmm3,xmm1
 vpunpckhqdq xmm1,xmm0,xmm0
 vpunpckhqdq xmm3,xmm2,xmm2
 vpminub     xmm0,xmm0,xmm1
 vpcmpeqb    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm2,xmm3,xmm1
 vmovshdup   xmm1,xmm0
 vmovshdup   xmm3,xmm2
 vpminub     xmm0,xmm0,xmm1
 vpcmpeqb    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm2,xmm3,xmm1
 vpshuflw    xmm1,xmm0,225
 vpshuflw    xmm3,xmm2,225
 vpminub     xmm0,xmm0,xmm1
 vpcmpeqb    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm2,xmm3,xmm1
 vpsrldq     xmm1,xmm0,1
 vpsrldq     xmm3,xmm2,1
 vpminub     xmm0,xmm0,xmm1
 vpcmpeqb    xmm1,xmm0,xmm1
 vpblendvb   xmm0,xmm2,xmm3,xmm1
 vmovd       eax,xmm0
 movzx       eax,al
 add         rsp,136
 ret
CASE_16:
 vmovdqu     xmm1,oword [rdi]
 lea         edi,[rsi-16]
 vmovd       xmm4,edi
 vpbroadcastb xmm4,xmm4
 vpaddb      xmm4,xmm4,oword [SEQ]
 vpminub     xmm0,xmm1,oword [r9-16]
 vpcmpeqb    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm4,xmm3,xmm1
 vpunpckhqdq xmm1,xmm0,xmm0
 vpunpckhqdq xmm3,xmm2,xmm2
 vpminub     xmm0,xmm0,xmm1
 vpcmpeqb    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm2,xmm3,xmm1
 vmovshdup   xmm1,xmm0
 vmovshdup   xmm3,xmm2
 vpminub     xmm0,xmm0,xmm1
 vpcmpeqb    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm2,xmm3,xmm1
 vpshuflw    xmm1,xmm0,225
 vpshuflw    xmm3,xmm2,225
 vpminub     xmm0,xmm0,xmm1
 vpcmpeqb    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm2,xmm3,xmm1
 vpsrldq     xmm1,xmm0,1
 vpsrldq     xmm3,xmm2,1
 vpminub     xmm0,xmm0,xmm1
 vpcmpeqb    xmm1,xmm0,xmm1
 vpblendvb   xmm0,xmm2,xmm3,xmm1
 vmovd       eax,xmm0
 movzx       eax,al
 add         rsp,136
 ret
CASE_8:
 vmovq       xmm1,qword [rdi]
 vmovq       xmm0,qword [r9-8]
 lea         edi,[rsi-8]
 vmovd       xmm4,edi
 vpbroadcastb xmm4,xmm4
 vpaddb      xmm4,xmm4,oword [SEQ]
 vpminub     xmm0,xmm0,xmm1
 vpcmpeqb    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm4,xmm3,xmm1
 vmovshdup   xmm1,xmm0
 vmovshdup   xmm3,xmm2
 vpminub     xmm0,xmm0,xmm1
 vpcmpeqb    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm2,xmm3,xmm1
 vpshuflw    xmm1,xmm0,225
 vpshuflw    xmm3,xmm2,225
 vpminub     xmm0,xmm0,xmm1
 vpcmpeqb    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm2,xmm3,xmm1
 vpsrldq     xmm1,xmm0,1
 vpsrldq     xmm3,xmm2,1
 vpminub     xmm0,xmm0,xmm1
 vpcmpeqb    xmm1,xmm0,xmm1
 vpblendvb   xmm0,xmm2,xmm3,xmm1
 vmovd       eax,xmm0
 movzx       eax,al
 add         rsp,136
 ret
CASE_7:
 mov         r10b,byte [r9-7]
CASE_6:
 mov         cl,byte [r9-6]
 cmp         r10b,cl
 cmova       r10d,ecx
 lea         ecx,[rsi-6]
 cmova       eax,ecx
CASE_5:
 mov         cl,byte [r9-5]
 cmp         r10b,cl
 cmova       r10d,ecx
 lea         ecx,[rsi-5]
 cmova       eax,ecx
CASE_4:
 mov         cl,byte [r9-4]
 cmp         r10b,cl
 cmova       r10d,ecx
 lea         ecx,[rsi-4]
 cmova       eax,ecx
CASE_3:
 mov         cl,byte [r9-3]
 cmp         r10b,cl
 cmova       r10d,ecx
 lea         ecx,[rsi-3]
 cmova       eax,ecx
CASE_2:
 mov         cl,byte [r9-2]
 cmp         r10b,cl
 cmova       r10d,ecx
 lea         ecx,[rsi-2]
 cmova       eax,ecx
CASE_1:
 lea         ecx,[rsi-1]
 cmp         r10b,byte [r9-1]
 cmova       eax,ecx
CASE_0:
 add         rsp,136
 ret

CASE_LARGE:
 cmp         eax,0FFFFh
 ja          CASE_VERY_LARGE

 ; -1
 vpcmpeqd    ymm9,ymm9,ymm9

 ; outer i
 vpxor       xmm10,xmm10,xmm10

  ; 8-bit index sequence
 vmovdqu     ymm11,yword [SEQ]

 ; outer best indices
 vmovaps     oword [rsp],xmm12
 vpxor       xmm12,xmm12,xmm12

 ; 128
 vmovaps     oword [rsp+16],xmm13
 vpavgb      ymm13,ymm9,ymm10

 ; 64
 vmovaps     oword [rsp+32],xmm14
 vpavgb      ymm14,ymm13,ymm10

 ; 32
 vmovaps     oword [rsp+48],xmm15
 vpavgb      ymm15,ymm14,ymm10

 ; outer best value (0xFF)
 vpcmpeqd    ymm8,ymm8,ymm8

 lea         rsi,[rdi+rax]
 add         rdi,256
 cmp         rdi,rsi
 jae         LOOP_END

LOOP_TOP:
 vmovdqu     ymm4,yword [rdi-256]
 vmovdqu     ymm5,yword [rdi-224]
 vmovdqu     ymm6,yword [rdi-192]
 vmovdqu     ymm7,yword [rdi-160]
 vpminub     ymm0,ymm4,yword [rdi-128]
 vpminub     ymm1,ymm5,yword [rdi-96]
 vpminub     ymm2,ymm6,yword [rdi-64]
 vpminub     ymm3,ymm7,yword [rdi-32]
 vpcmpeqb    ymm4,ymm0,ymm4
 vpcmpeqb    ymm5,ymm1,ymm5
 vpcmpeqb    ymm6,ymm2,ymm6
 vpcmpeqb    ymm7,ymm3,ymm7
 vpandn      ymm4,ymm4,ymm13
 vpandn      ymm5,ymm5,ymm13
 vpandn      ymm6,ymm6,ymm13
 vpandn      ymm7,ymm7,ymm13
 vpor        ymm6,ymm6,ymm14
 vpor        ymm7,ymm7,ymm14
 vpminub     ymm0,ymm0,ymm2
 vpminub     ymm1,ymm1,ymm3
 vpcmpeqb    ymm2,ymm0,ymm2
 vpcmpeqb    ymm3,ymm1,ymm3
 vpblendvb   ymm4,ymm4,ymm6,ymm2
 vpblendvb   ymm5,ymm5,ymm7,ymm3
 vpor        ymm5,ymm5,ymm15
 vpminub     ymm0,ymm0,ymm1
 vpcmpeqb    ymm1,ymm0,ymm1
 vpblendvb   ymm4,ymm4,ymm5,ymm1
 vpor        ymm2,ymm4,ymm11
 vpunpckhqdq ymm1,ymm0,ymm0
 vpunpckhqdq ymm3,ymm2,ymm2
 vpminub     ymm0,ymm0,ymm1
 vpcmpeqb    ymm1,ymm0,ymm1
 vpblendvb   ymm2,ymm2,ymm3,ymm1
 vpunpcklbw  ymm2,ymm2,ymm10
 vpminub     ymm8,ymm8,ymm0
 vpcmpeqb    ymm0,ymm0,ymm8
 vpunpcklbw  ymm0,ymm0,ymm0
 vpblendvb   ymm12,ymm12,ymm2,ymm0

 vpsubb      ymm10,ymm10,ymm9
 add         rdi,256
 cmp         rdi,rsi
 jb          LOOP_TOP

LOOP_END:

 ; remainder

 sub         eax,256
 vmovd       xmm10,eax
 vpbroadcastw ymm10,xmm10

 vmovdqu     ymm4,yword [rsi-256]
 vmovdqu     ymm5,yword [rsi-224]
 vmovdqu     ymm6,yword [rsi-192]
 vmovdqu     ymm7,yword [rsi-160]
 vpminub     ymm0,ymm4,yword [rsi-128]
 vpminub     ymm1,ymm5,yword [rsi-96]
 vpminub     ymm2,ymm6,yword [rsi-64]
 vpminub     ymm3,ymm7,yword [rsi-32]
 vpcmpeqb    ymm4,ymm0,ymm4
 vpcmpeqb    ymm5,ymm1,ymm5
 vpcmpeqb    ymm6,ymm2,ymm6
 vpcmpeqb    ymm7,ymm3,ymm7
 vpandn      ymm4,ymm4,ymm13
 vpandn      ymm5,ymm5,ymm13
 vpandn      ymm6,ymm6,ymm13
 vpandn      ymm7,ymm7,ymm13
 vpor        ymm6,ymm6,ymm14
 vpor        ymm7,ymm7,ymm14
 vpminub     ymm0,ymm0,ymm2
 vpminub     ymm1,ymm1,ymm3
 vpcmpeqb    ymm2,ymm0,ymm2
 vpcmpeqb    ymm3,ymm1,ymm3
 vpblendvb   ymm4,ymm4,ymm6,ymm2
 vpblendvb   ymm5,ymm5,ymm7,ymm3
 vpor        ymm5,ymm5,ymm15
 vmovaps     xmm15,oword [rsp+48]
 vpminub     ymm0,ymm0,ymm1
 vmovaps     xmm14,oword [rsp+32]
 vpcmpeqb    ymm1,ymm0,ymm1
 vmovaps     xmm13,oword [rsp+16]
 vpblendvb   ymm4,ymm4,ymm5,ymm1
 vpor        ymm2,ymm4,ymm11
 vpunpckhqdq ymm1,ymm0,ymm0
 vpunpckhqdq ymm3,ymm2,ymm2
 vpminub     ymm0,ymm0,ymm1
 vpcmpeqb    ymm1,ymm0,ymm1
 vpblendvb   ymm2,ymm2,ymm3,ymm1
 vpxor       xmm3,xmm3,xmm3
 vpunpcklbw  ymm2,ymm2,ymm3
 vpaddw      ymm2,ymm2,ymm10
 vpminub     ymm0,ymm8,ymm0
 vpcmpeqb    ymm8,ymm0,ymm8
 vpunpcklbw  ymm8,ymm8,ymm8
 vpblendvb   ymm2,ymm2,ymm12,ymm8
 vmovaps     xmm12,oword [rsp]

 ; reduce

 vextracti128 xmm1,ymm0,1
 vextracti128 xmm3,ymm2,1
 vpmovzxbw   xmm0,xmm0
 vpmovzxbw   xmm1,xmm1
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

 add         rsp,136
 ret

CASE_VERY_LARGE:

 ; -1
 vpcmpeqd    ymm9,ymm9,ymm9

 ; 16-bit outer i
 vpxor       xmm10,xmm10,xmm10

 ; 8-bit index sequence
 vmovdqu     ymm11,yword [SEQ]
 vmovaps     oword [rsp],xmm12

 ; 128
 vmovaps     oword [rsp+16],xmm13
 vpavgb      ymm13,ymm9,ymm10

 ; 64
 vmovaps     oword [rsp+32],xmm14
 vpavgb      ymm14,ymm13,ymm10

 ; 32
 vmovaps     oword [rsp+48],xmm15
 vpavgb      ymm15,ymm14,ymm10

 ; 32-bit outer i
 xor         r9d,r9d

 ; 8-bit outer best value (0xFF)
 vmovdqu     yword [rsp+64],ymm9

 ; 32-bit outer best indices
 vmovdqu     yword [rsp+96],ymm10

 lea         rsi,[rdi+rax]
 add         rdi,256

OUTER_LOOP_TOP:

 ; 16-bit outer best indices
 vpxor       xmm12,xmm12,xmm12

 ; 8-bit outer best value (127)
 vpaddb      ymm8,ymm13,ymm9

 lea         r8,[rdi+010000h]
 cmp         r8,rsi
 cmova       r8,rsi

 cmp         rdi,r8
 jae         INNER_LOOP_END

INNER_LOOP_TOP:
 vmovdqu     ymm4,yword [rdi-256]
 vmovdqu     ymm5,yword [rdi-224]
 vmovdqu     ymm6,yword [rdi-192]
 vmovdqu     ymm7,yword [rdi-160]
 vpminub     ymm0,ymm4,yword [rdi-128]
 vpminub     ymm1,ymm5,yword [rdi-96]
 vpminub     ymm2,ymm6,yword [rdi-64]
 vpminub     ymm3,ymm7,yword [rdi-32]
 vpcmpeqb    ymm4,ymm0,ymm4
 vpcmpeqb    ymm5,ymm1,ymm5
 vpcmpeqb    ymm6,ymm2,ymm6
 vpcmpeqb    ymm7,ymm3,ymm7
 vpandn      ymm4,ymm4,ymm13
 vpandn      ymm5,ymm5,ymm13
 vpandn      ymm6,ymm6,ymm13
 vpandn      ymm7,ymm7,ymm13
 vpor        ymm6,ymm6,ymm14
 vpor        ymm7,ymm7,ymm14
 vpminub     ymm0,ymm0,ymm2
 vpminub     ymm1,ymm1,ymm3
 vpcmpeqb    ymm2,ymm0,ymm2
 vpcmpeqb    ymm3,ymm1,ymm3
 vpblendvb   ymm4,ymm4,ymm6,ymm2
 vpblendvb   ymm5,ymm5,ymm7,ymm3
 vpor        ymm5,ymm5,ymm15
 vpminub     ymm0,ymm0,ymm1
 vpcmpeqb    ymm1,ymm0,ymm1
 vpblendvb   ymm4,ymm4,ymm5,ymm1
 vpor        ymm2,ymm4,ymm11
 vpunpckhqdq ymm1,ymm0,ymm0
 vpunpckhqdq ymm3,ymm2,ymm2
 vpminub     ymm0,ymm0,ymm1
 vpcmpeqb    ymm1,ymm0,ymm1
 vpblendvb   ymm2,ymm2,ymm3,ymm1
 vpunpcklbw  ymm2,ymm2,ymm10
 vpminub     ymm8,ymm8,ymm0
 vpcmpeqb    ymm0,ymm0,ymm8
 vpunpcklbw  ymm0,ymm0,ymm0
 vpblendvb   ymm12,ymm12,ymm2,ymm0

 vpsubb      ymm10,ymm10,ymm9
 add         rdi,256
 cmp         rdi,r8
 jb          INNER_LOOP_TOP

INNER_LOOP_END:

 vmovshdup   ymm0,ymm8
 vpunpckhqdq ymm2,ymm12,ymm12
 vpminub     ymm0,ymm0,ymm8
 vpcmpeqb    ymm1,ymm0,ymm8
 vpunpcklbw  ymm1,ymm1,ymm1
 vpblendvb   ymm2,ymm2,ymm12,ymm1

 vmovd       xmm1,r9d
 vpbroadcastw ymm1,xmm1
 vpunpcklwd  ymm2,ymm2,ymm1

 vpminub     ymm1,ymm0,yword [rsp+64]
 vpcmpeqb    ymm0,ymm0,ymm1
 vmovdqu     yword [rsp+64],ymm1
 vpunpcklbw  ymm0,ymm0,ymm0
 vpunpcklwd  ymm0,ymm0,ymm0
 vpsubd      ymm0,ymm9,ymm0

 vpblendvb   ymm3,ymm2,yword [rsp+96],ymm0
 vmovdqu     yword [rsp+96],ymm3

 inc         r9d

 cmp         rdi,rsi
 jb          OUTER_LOOP_TOP

 ; remainder

 vmovdqu     ymm4,yword [rsi-256]
 vmovdqu     ymm5,yword [rsi-224]
 vmovdqu     ymm6,yword [rsi-192]
 vmovdqu     ymm7,yword [rsi-160]
 vpminub     ymm0,ymm4,yword [rsi-128]
 vpminub     ymm1,ymm5,yword [rsi-96]
 vpminub     ymm2,ymm6,yword [rsi-64]
 vpminub     ymm3,ymm7,yword [rsi-32]
 vpcmpeqb    ymm4,ymm0,ymm4
 vpcmpeqb    ymm5,ymm1,ymm5
 vpcmpeqb    ymm6,ymm2,ymm6
 vpcmpeqb    ymm7,ymm3,ymm7
 vpandn      ymm4,ymm4,ymm13
 vpandn      ymm5,ymm5,ymm13
 vpandn      ymm6,ymm6,ymm13
 vpandn      ymm7,ymm7,ymm13
 vpor        ymm6,ymm6,ymm14
 vpor        ymm7,ymm7,ymm14
 vpminub     ymm0,ymm0,ymm2
 vpminub     ymm1,ymm1,ymm3
 vpcmpeqb    ymm2,ymm0,ymm2
 vpcmpeqb    ymm3,ymm1,ymm3
 vpblendvb   ymm4,ymm4,ymm6,ymm2
 vpblendvb   ymm5,ymm5,ymm7,ymm3
 vpor        ymm5,ymm5,ymm15
 vmovaps     xmm15,oword [rsp+48]
 vpminub     ymm0,ymm0,ymm1
 vmovaps     xmm14,oword [rsp+32]
 vpcmpeqb    ymm1,ymm0,ymm1
 vmovaps     xmm13,oword [rsp+16]
 vpblendvb   ymm4,ymm4,ymm5,ymm1
 vmovaps     xmm12,oword [rsp]
 vpor        ymm2,ymm4,ymm11
 vpunpckhqdq ymm1,ymm0,ymm0
 vpunpckhqdq ymm3,ymm2,ymm2
 vpminub     ymm0,ymm0,ymm1
 vpcmpeqb    ymm1,ymm0,ymm1
 vpblendvb   ymm2,ymm2,ymm3,ymm1
 vmovshdup   ymm1,ymm0
 vmovshdup   ymm3,ymm2
 vpminub     ymm1,ymm0,ymm1
 vpcmpeqb    ymm0,ymm0,ymm1
 vpblendvb   ymm2,ymm3,ymm2,ymm0
 vpxor       xmm4,xmm4,xmm4
 vpunpcklbw  ymm2,ymm2,ymm4
 vpunpcklwd  ymm2,ymm2,ymm4
 sub         eax,256
 vmovd       xmm0,eax
 vpbroadcastd ymm0,xmm0
 vpaddd      ymm3,ymm2,ymm0

 vpminub     ymm0,ymm1,yword [rsp+64]
 vpcmpeqb    ymm1,ymm0,ymm1
 vpunpcklbw  ymm1,ymm1,ymm1
 vpunpcklwd  ymm1,ymm1,ymm1
 vpsubd      ymm1,ymm9,ymm1
 vpblendvb   ymm2,ymm3,yword [rsp+96],ymm1

 ; reduce

 vextracti128 xmm1,ymm0,1
 vextracti128 xmm3,ymm2,1
 vpmovzxbd   xmm0,xmm0
 vpmovzxbd   xmm1,xmm1
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
 vpcmpgtd    xmm1,xmm0,xmm1
 vpblendvb   xmm0,xmm2,xmm3,xmm1
 vmovd       eax,xmm0

 add         rsp,136
 ret
