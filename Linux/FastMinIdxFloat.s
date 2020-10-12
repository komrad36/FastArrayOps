; /*******************************************************************
; *
; *    Author: Kareem Omar
; *    kareem.h.omar@gmail.com
; *    https://github.com/komrad36
; *
; *    Last updated Oct 11, 2020
; *******************************************************************/

bits 64
section .text
align 64
global FastMinIdxFloat

FastMinIdxFloat:
 vmovdqu     ymm4,yword [SEQ]
 mov         eax,esi
 cmp         esi,64
 jae         CASE_LARGE
 vpcmpeqd    ymm0,ymm0,ymm0
 vpslld      ymm2,ymm0,3
 vmovdqa     ymm3,ymm4
 vpcmpeqd    ymm1,ymm1,ymm1
 lea         r8,[JUMP_TABLE]
 movzx       esi,word [r8+2*rax]
 add         r8,rsi
 lea         rsi,[rdi+4*rax]
 mov         r9d,eax
 and         eax,-8
 lea         rdi,[rdi+4*rax]
 jmp         r8
SEQ:
dd 0,1,2,3,4,5,6,7
JUMP_TABLE:
times 1 dw ( CASE_0 - JUMP_TABLE)
times 1 dw ( CASE_1 - JUMP_TABLE)
times 1 dw ( CASE_2 - JUMP_TABLE)
times 1 dw ( CASE_3 - JUMP_TABLE)
times 1 dw ( CASE_4 - JUMP_TABLE)
times 1 dw ( CASE_5 - JUMP_TABLE)
times 1 dw ( CASE_6 - JUMP_TABLE)
times 1 dw ( CASE_7 - JUMP_TABLE)
times 8 dw ( CASE_8 - JUMP_TABLE)
times 8 dw (CASE_16 - JUMP_TABLE)
times 8 dw (CASE_24 - JUMP_TABLE)
times 8 dw (CASE_32 - JUMP_TABLE)
times 8 dw (CASE_40 - JUMP_TABLE)
times 8 dw (CASE_48 - JUMP_TABLE)
times 8 dw (CASE_56 - JUMP_TABLE)
CASE_56:
 vmovups     ymm1,yword [rdi-224]
 vpsubd      ymm4,ymm4,ymm2
CASE_48:
 vminps      ymm0,ymm1,yword [rdi-192]
 vpcmpeqd    ymm1,ymm0,ymm1
 vpblendvb   ymm3,ymm4,ymm3,ymm1
 vpsubd      ymm4,ymm4,ymm2
CASE_40:
 vminps      ymm1,ymm0,yword [rdi-160]
 vpcmpeqd    ymm0,ymm0,ymm1
 vpblendvb   ymm3,ymm4,ymm3,ymm0
 vpsubd      ymm4,ymm4,ymm2
CASE_32:
 vminps      ymm0,ymm1,yword [rdi-128]
 vpcmpeqd    ymm1,ymm0,ymm1
 vpblendvb   ymm3,ymm4,ymm3,ymm1
 vpsubd      ymm4,ymm4,ymm2
CASE_24:
 vminps      ymm1,ymm0,yword [rdi-96]
 vpcmpeqd    ymm0,ymm0,ymm1
 vpblendvb   ymm3,ymm4,ymm3,ymm0
 vpsubd      ymm4,ymm4,ymm2
CASE_16:
 vminps      ymm0,ymm1,yword [rdi-64]
 vpcmpeqd    ymm1,ymm0,ymm1
 vpblendvb   ymm3,ymm4,ymm3,ymm1
 vpsubd      ymm4,ymm4,ymm2
CASE_8:
 vminps      ymm1,ymm0,yword [rdi-32]
 vpcmpeqd    ymm0,ymm0,ymm1
 vpblendvb   ymm3,ymm4,ymm3,ymm0
 lea         edi,[r9-8]
 vmovd       xmm4,edi
 vpbroadcastd ymm4,xmm4
 vpaddd      ymm4,ymm4,yword [SEQ]
 vminps      ymm0,ymm1,yword [rsi-32]
 vpcmpeqd    ymm1,ymm0,ymm1
 vpblendvb   ymm2,ymm4,ymm3,ymm1
 vextractf128 xmm1,ymm0,1
 vextracti128 xmm3,ymm2,1
 vminps      xmm0,xmm0,xmm1
 vpcmpeqd    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm2,xmm3,xmm1
 vmovhlps    xmm1,xmm0,xmm0
 vpunpckhqdq xmm3,xmm2,xmm2
 vminps      xmm0,xmm0,xmm1
 vpcmpeqd    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm2,xmm3,xmm1
 vmovshdup   xmm1,xmm0
 vmovshdup   xmm3,xmm2
 vcmpgt_oqss xmm0,xmm0,xmm1
 vpblendvb   xmm0,xmm2,xmm3,xmm0
 vmovd       eax,xmm0
 ret
CASE_7:
 vmovss      xmm0,dword [rsi-28]
CASE_6:
 vucomiss    xmm0,dword [rsi-24]
 lea         ecx,[r9-6]
 cmova       eax,ecx
 vminss      xmm0,xmm0,dword [rsi-24]
CASE_5:
 vucomiss    xmm0,dword [rsi-20]
 lea         ecx,[r9-5]
 cmova       eax,ecx
 vminss      xmm0,xmm0,dword [rsi-20]
CASE_4:
 vucomiss    xmm0,dword [rsi-16]
 lea         ecx,[r9-4]
 cmova       eax,ecx
 vminss      xmm0,xmm0,dword [rsi-16]
CASE_3:
 vucomiss    xmm0,dword [rsi-12]
 lea         ecx,[r9-3]
 cmova       eax,ecx
 vminss      xmm0,xmm0,dword [rsi-12]
CASE_2:
 vucomiss    xmm0,dword [rsi-8]
 lea         ecx,[r9-2]
 cmova       eax,ecx
 vminss      xmm0,xmm0,dword [rsi-8]
CASE_1:
 vucomiss    xmm0,dword [rsi-4]
 lea         ecx,[r9-1]
 cmova       eax,ecx
CASE_0:
 ret

CASE_LARGE:
 ; best indices
 vmovdqa     ymm5,ymm4
 vmovdqa     ymm6,ymm4
 vmovdqa     ymm7,ymm4
 vmovdqa     ymm8,ymm4

 ; increment
 vpcmpeqd    ymm9,ymm9,ymm9
 vpslld      ymm9,ymm9,5

 ; best values
 vmovups     ymm10,yword [rdi]
 vmovups     ymm11,yword [rdi+32]
 vmovaps     oword [rsp-24],xmm12
 vmovups     ymm12,yword [rdi+64]
 vmovaps     oword [rsp-40],xmm13
 vmovups     ymm13,yword [rdi+96]

 vpsubd      ymm4,ymm4,ymm9

 vminps      ymm0,ymm10,yword [rdi+128]
 vminps      ymm1,ymm11,yword [rdi+160]
 vminps      ymm2,ymm12,yword [rdi+192]
 vminps      ymm3,ymm13,yword [rdi+224]
 vpcmpeqd    ymm10,ymm0,ymm10
 vpblendvb   ymm5,ymm4,ymm5,ymm10
 vpcmpeqd    ymm11,ymm1,ymm11
 vpblendvb   ymm6,ymm4,ymm6,ymm11
 vpcmpeqd    ymm12,ymm2,ymm12
 vpblendvb   ymm7,ymm4,ymm7,ymm12
 vpcmpeqd    ymm13,ymm3,ymm13
 vpblendvb   ymm8,ymm4,ymm8,ymm13

 vpsubd      ymm4,ymm4,ymm9

 lea         rsi,[rdi+4*rax]
 add         rdi,512
 cmp         rdi,rsi
 jae         LOOP_END

LOOP_TOP:
 vminps      ymm10,ymm0,yword [rdi-256]
 vminps      ymm11,ymm1,yword [rdi-224]
 vminps      ymm12,ymm2,yword [rdi-192]
 vminps      ymm13,ymm3,yword [rdi-160]
 vpcmpeqd    ymm0,ymm0,ymm10
 vpblendvb   ymm5,ymm4,ymm5,ymm0
 vminps      ymm0,ymm10,yword [rdi-128]
 vpcmpeqd    ymm1,ymm1,ymm11
 vpblendvb   ymm6,ymm4,ymm6,ymm1
 vminps      ymm1,ymm11,yword [rdi-96]
 vpcmpeqd    ymm2,ymm2,ymm12
 vpblendvb   ymm7,ymm4,ymm7,ymm2
 vminps      ymm2,ymm12,yword [rdi-64]
 vpcmpeqd    ymm3,ymm3,ymm13
 vpblendvb   ymm8,ymm4,ymm8,ymm3
 vminps      ymm3,ymm13,yword [rdi-32]
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
 add         rdi,256
 cmp         rdi,rsi
 jb          LOOP_TOP

LOOP_END:
 sub         eax,64
 vmovd       xmm4,eax
 vpbroadcastd ymm4,xmm4
 vpaddd      ymm4,ymm4,yword [SEQ]

 vminps      ymm10,ymm0,yword [rsi-256]
 vminps      ymm11,ymm1,yword [rsi-224]
 vminps      ymm12,ymm2,yword [rsi-192]
 vminps      ymm13,ymm3,yword [rsi-160]
 vpcmpeqd    ymm0,ymm0,ymm10
 vpblendvb   ymm5,ymm4,ymm5,ymm0
 vminps      ymm0,ymm10,yword [rsi-128]
 vpcmpeqd    ymm1,ymm1,ymm11
 vpblendvb   ymm6,ymm4,ymm6,ymm1
 vminps      ymm1,ymm11,yword [rsi-96]
 vpcmpeqd    ymm2,ymm2,ymm12
 vpblendvb   ymm7,ymm4,ymm7,ymm2
 vminps      ymm2,ymm12,yword [rsi-64]
 vpcmpeqd    ymm3,ymm3,ymm13
 vpblendvb   ymm8,ymm4,ymm8,ymm3
 vminps      ymm3,ymm13,yword [rsi-32]
 vpsubd      ymm4,ymm4,ymm9
 vpcmpeqd    ymm13,ymm3,ymm13
 vpblendvb   ymm8,ymm4,ymm8,ymm13
 vmovaps     xmm13,oword [rsp-40]
 vpcmpeqd    ymm12,ymm2,ymm12
 vpblendvb   ymm7,ymm4,ymm7,ymm12
 vmovaps     xmm12,oword [rsp-24]
 vpcmpeqd    ymm11,ymm1,ymm11
 vpblendvb   ymm6,ymm4,ymm6,ymm11
 vpcmpeqd    ymm10,ymm0,ymm10
 vpblendvb   ymm5,ymm4,ymm5,ymm10

 vpsrad      ymm4,ymm9,1

 vminps      ymm1,ymm1,ymm3
 vpcmpeqd    ymm3,ymm1,ymm3
 vpsubd      ymm8,ymm8,ymm4
 vpblendvb   ymm6,ymm6,ymm8,ymm3

 vminps      ymm0,ymm0,ymm2
 vpcmpeqd    ymm2,ymm0,ymm2
 vpsubd      ymm7,ymm7,ymm4
 vpblendvb   ymm5,ymm5,ymm7,ymm2

 vpsrad      ymm4,ymm4,1

 vminps      ymm0,ymm0,ymm1
 vpcmpeqd    ymm1,ymm0,ymm1
 vpsubd      ymm6,ymm6,ymm4
 vpblendvb   ymm2,ymm5,ymm6,ymm1

 vextractf128 xmm1,ymm0,1
 vextracti128 xmm3,ymm2,1

 vminps      xmm0,xmm0,xmm1
 vpcmpeqd    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm2,xmm3,xmm1

 vmovhlps    xmm1,xmm0,xmm0
 vpunpckhqdq xmm3,xmm2,xmm2

 vminps      xmm0,xmm0,xmm1
 vpcmpeqd    xmm1,xmm0,xmm1
 vpblendvb   xmm2,xmm2,xmm3,xmm1

 vmovshdup   xmm1,xmm0
 vmovshdup   xmm3,xmm2

 vcmpgt_oqss xmm0,xmm0,xmm1
 vpblendvb   xmm0,xmm2,xmm3,xmm0
 vmovd       eax,xmm0

 ret
