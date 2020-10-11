bits 64
section .text
align 64
global AsmFastMinIdxDouble

AsmFastMinIdxDouble:
 mov         eax,esi
 cmp         esi,32
 jae         CASE_LARGE
 vpcmpeqd    ymm0,ymm0,ymm0
 vpsllq      ymm5,ymm0,2
 vmovdqu     ymm4,yword [SEQ]
 vpcmpeqd    ymm1,ymm1,ymm1
 vmovdqa     ymm2,ymm4
 vmovdqa     ymm3,ymm4
 lea         r8,[JUMP_TABLE]
 movzx       esi,word [r8+2*rax]
 add         r8,rsi
 lea         rsi,[rdi+8*rax]
 mov         r9d,eax
 and         eax,-4
 lea         rdi,[rdi+8*rax]
 jmp         r8
SEQ:
dq 0,1,2,3
JUMP_TABLE:
times 1 dw ( CASE_0 - JUMP_TABLE)
times 1 dw ( CASE_1 - JUMP_TABLE)
times 1 dw ( CASE_2 - JUMP_TABLE)
times 1 dw ( CASE_3 - JUMP_TABLE)
times 4 dw ( CASE_4 - JUMP_TABLE)
times 4 dw ( CASE_8 - JUMP_TABLE)
times 4 dw (CASE_12 - JUMP_TABLE)
times 4 dw (CASE_16 - JUMP_TABLE)
times 4 dw (CASE_20 - JUMP_TABLE)
times 4 dw (CASE_24 - JUMP_TABLE)
times 4 dw (CASE_28 - JUMP_TABLE)
CASE_28:
 vmovupd     ymm1,yword [rdi-224]
 vpsubq      ymm3,ymm3,ymm5
CASE_24:
 vminpd      ymm0,ymm1,yword [rdi-192]
 vpcmpeqq    ymm1,ymm0,ymm1
 vpblendvb   ymm2,ymm3,ymm2,ymm1
 vpsubq      ymm3,ymm3,ymm5
CASE_20:
 vminpd      ymm1,ymm0,yword [rdi-160]
 vpcmpeqq    ymm0,ymm0,ymm1
 vpblendvb   ymm2,ymm3,ymm2,ymm0
 vpsubq      ymm3,ymm3,ymm5
CASE_16:
 vminpd      ymm0,ymm1,yword [rdi-128]
 vpcmpeqq    ymm1,ymm0,ymm1
 vpblendvb   ymm2,ymm3,ymm2,ymm1
 vpsubq      ymm3,ymm3,ymm5
CASE_12:
 vminpd      ymm1,ymm0,yword [rdi-96]
 vpcmpeqq    ymm0,ymm0,ymm1
 vpblendvb   ymm2,ymm3,ymm2,ymm0
 vpsubq      ymm3,ymm3,ymm5
CASE_8:
 vminpd      ymm0,ymm1,yword [rdi-64]
 vpcmpeqq    ymm1,ymm0,ymm1
 vpblendvb   ymm2,ymm3,ymm2,ymm1
 vpsubq      ymm3,ymm3,ymm5
CASE_4:
 vminpd      ymm1,ymm0,yword [rdi-32]
 vpcmpeqq    ymm0,ymm0,ymm1
 vpblendvb   ymm2,ymm3,ymm2,ymm0
 lea         edi,[r9-4]
 vmovd       xmm3,edi
 vpbroadcastq ymm3,xmm3
 vpaddq      ymm3,ymm3,ymm4
 vminpd      ymm0,ymm1,yword [rsi-32]
 vpcmpeqq    ymm1,ymm0,ymm1
 vpblendvb   ymm2,ymm3,ymm2,ymm1
 vextractf128 xmm1,ymm0,1
 vextracti128 xmm3,ymm2,1
 vminpd      xmm0,xmm0,xmm1
 vpcmpeqq    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm2,xmm3,xmm1
 vmovhlps    xmm1,xmm0,xmm0
 vpunpckhqdq xmm3,xmm2,xmm2
 vcmpgt_oqsd xmm0,xmm0,xmm1
 vpblendvb   xmm0,xmm2,xmm3,xmm0
 vmovd       eax,xmm0
 ret
CASE_3:
 vmovsd      xmm0,qword [rsi-24]
CASE_2:
 vucomisd    xmm0,qword [rsi-16]
 lea         ecx,[r9-2]
 cmova       eax,ecx
 vminsd      xmm0,xmm0,qword [rsi-16]
CASE_1:
 vucomisd    xmm0,qword [rsi-8]
 lea         ecx,[r9-1]
 cmova       eax,ecx
CASE_0:
 ret

PACKED_SEQ:
dd 0, 1, 4, 5, 2, 3, 6, 7

CASE_LARGE:
 vmovdqu     ymm4,yword [PACKED_SEQ]

 ; best indices
 vmovdqa     ymm5,ymm4
 vmovdqa     ymm6,ymm4

 ; increment
 vpcmpeqd    ymm7,ymm7,ymm7
 vpslld      ymm7,ymm7,4

 ; best values
 vmovupd     ymm8,yword [rdi]
 vmovupd     ymm9,yword [rdi+32]
 vmovupd     ymm10,yword [rdi+64]
 vmovupd     ymm11,yword [rdi+96]

 vpsubd      ymm4,ymm4,ymm7

 vminpd      ymm0,ymm8,yword [rdi+128]
 vminpd      ymm1,ymm9,yword [rdi+160]
 vminpd      ymm2,ymm10,yword [rdi+192]
 vminpd      ymm3,ymm11,yword [rdi+224]

 vpcmpeqq    ymm8,ymm0,ymm8
 vpcmpeqq    ymm9,ymm1,ymm9
 vpackssdw   ymm8,ymm8,ymm9
 vpblendvb   ymm5,ymm4,ymm5,ymm8

 vpcmpeqq    ymm10,ymm2,ymm10
 vpcmpeqq    ymm11,ymm3,ymm11
 vpackssdw   ymm10,ymm10,ymm11
 vpblendvb   ymm6,ymm4,ymm6,ymm10

 vpsubd      ymm4,ymm4,ymm7

 lea         rsi,[rdi+8*rax]
 add         rdi,512
 cmp         rdi,rsi
 jae         LOOP_END

LOOP_TOP:
 vminpd      ymm8,ymm0,yword [rdi-256]
 vminpd      ymm9,ymm1,yword [rdi-224]
 vminpd      ymm10,ymm2,yword [rdi-192]
 vminpd      ymm11,ymm3,yword [rdi-160]
 vpcmpeqq    ymm0,ymm0,ymm8
 vpcmpeqq    ymm1,ymm1,ymm9
 vpackssdw   ymm1,ymm0,ymm1
 vpblendvb   ymm5,ymm4,ymm5,ymm1
 vminpd      ymm0,ymm8,yword [rdi-128]
 vminpd      ymm1,ymm9,yword [rdi-96]
 vpcmpeqq    ymm2,ymm2,ymm10
 vpcmpeqq    ymm3,ymm3,ymm11
 vpackssdw   ymm3,ymm2,ymm3
 vpblendvb   ymm6,ymm4,ymm6,ymm3
 vminpd      ymm2,ymm10,yword [rdi-64]
 vminpd      ymm3,ymm11,yword [rdi-32]
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

 add         rdi,256
 cmp         rdi,rsi
 jb          LOOP_TOP

LOOP_END:
 sub         eax,32
 vmovd       xmm4,eax
 vpbroadcastd ymm4,xmm4
 vpaddd      ymm4,ymm4,yword [PACKED_SEQ]

 vminpd      ymm8,ymm0,yword [rsi-256]
 vminpd      ymm9,ymm1,yword [rsi-224]
 vminpd      ymm10,ymm2,yword [rsi-192]
 vminpd      ymm11,ymm3,yword [rsi-160]
 vpcmpeqq    ymm0,ymm0,ymm8
 vpcmpeqq    ymm1,ymm1,ymm9
 vpackssdw   ymm1,ymm0,ymm1
 vpblendvb   ymm5,ymm4,ymm5,ymm1
 vminpd      ymm0,ymm8,yword [rsi-128]
 vminpd      ymm1,ymm9,yword [rsi-96]
 vpcmpeqq    ymm2,ymm2,ymm10
 vpcmpeqq    ymm3,ymm3,ymm11
 vpackssdw   ymm3,ymm2,ymm3
 vpblendvb   ymm6,ymm4,ymm6,ymm3
 vminpd      ymm2,ymm10,yword [rsi-64]
 vminpd      ymm3,ymm11,yword [rsi-32]
 vpsubd      ymm4,ymm4,ymm7
 vpcmpeqq    ymm10,ymm2,ymm10
 vpcmpeqq    ymm11,ymm3,ymm11
 vpackssdw   ymm10,ymm10,ymm11
 vpblendvb   ymm6,ymm4,ymm6,ymm10
 vpcmpeqq    ymm8,ymm0,ymm8
 vpcmpeqq    ymm9,ymm1,ymm9
 vpackssdw   ymm8,ymm8,ymm9
 vpblendvb   ymm5,ymm4,ymm5,ymm8

 vpsrad      ymm4,ymm7,1

 vminpd      ymm0,ymm0,ymm2
 vminpd      ymm1,ymm1,ymm3
 vpcmpeqq    ymm2,ymm0,ymm2
 vpcmpeqq    ymm3,ymm1,ymm3
 vpackssdw   ymm2,ymm2,ymm3
 vpsubd      ymm6,ymm6,ymm4
 vpblendvb   ymm2,ymm5,ymm6,ymm2

 vminpd      ymm0,ymm0,ymm1
 vpunpckhdq  ymm3,ymm2,ymm2
 vpunpckldq  ymm2,ymm2,ymm2
 vpcmpeqq    ymm1,ymm0,ymm1
 vpblendvb   ymm2,ymm2,ymm3,ymm1

 vextractf128 xmm1,ymm0,1
 vextracti128 xmm3,ymm2,1

 vminpd      xmm0,xmm0,xmm1
 vpcmpeqq    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm2,xmm3,xmm1

 vmovhlps    xmm1,xmm0,xmm0
 vpunpckhqdq xmm3,xmm2,xmm2

 vcmpgt_oqsd xmm0,xmm0,xmm1
 vpblendvb   xmm0,xmm2,xmm3,xmm0
 vmovd       eax,xmm0

 ret
