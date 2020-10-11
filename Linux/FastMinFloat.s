bits 64
section .text
align 64
global AsmFastMinFloat

AsmFastMinFloat:
 mov         eax,esi
 cmp         esi,64
 jae         CASE_LARGE
 vpcmpeqd    ymm0,ymm0,ymm0
db 03Eh
 vpcmpeqd    ymm1,ymm1,ymm1
 lea		 r8,[JUMP_TABLE]
 movzx		 esi,byte [r8+rax]
 add		 r8,rsi
 lea         rsi,[rdi+4*rax]
 and		 eax,-8
 lea         rdi,[rdi+4*rax]
 jmp         r8
JUMP_TABLE:
times 1 db ( CASE_0 - JUMP_TABLE)
times 1 db ( CASE_1 - JUMP_TABLE)
times 1 db ( CASE_2 - JUMP_TABLE)
times 1 db ( CASE_3 - JUMP_TABLE)
times 1 db ( CASE_4 - JUMP_TABLE)
times 1 db ( CASE_5 - JUMP_TABLE)
times 1 db ( CASE_6 - JUMP_TABLE)
times 1 db ( CASE_7 - JUMP_TABLE)
times 8 db ( CASE_8 - JUMP_TABLE)
times 8 db (CASE_16 - JUMP_TABLE)
times 8 db (CASE_24 - JUMP_TABLE)
times 8 db (CASE_32 - JUMP_TABLE)
times 8 db (CASE_40 - JUMP_TABLE)
times 8 db (CASE_48 - JUMP_TABLE)
times 8 db (CASE_56 - JUMP_TABLE)
times 18 db (0CCh)
CASE_56:
 vmovups     ymm0,yword [rdi-224]
CASE_48:
 vmovups     ymm1,yword [rdi-192]
CASE_40:
 vminps      ymm0,ymm0,yword [rdi-160]
CASE_32:
 vminps      ymm1,ymm1,yword [rdi-128]
CASE_24:
 vminps      ymm0,ymm0,yword [rdi-96]
CASE_16:
 vminps      ymm1,ymm1,yword [rdi-64]
CASE_8:
 vminps      ymm0,ymm0,yword [rdi-32]
 vminps      ymm1,ymm1,yword [rsi-32]
 vminps      ymm0,ymm0,ymm1
 vextractf128 xmm1,ymm0,1
 vminps      xmm0,xmm0,xmm1
 vmovhlps    xmm1,xmm0,xmm0
 vminps      xmm0,xmm0,xmm1
 vmovshdup   xmm1,xmm0
 vminss      xmm0,xmm0,xmm1
 ret
times 3 db (0CCh)
CASE_7:
 vmovss      xmm0,dword [rsi-28]
CASE_6:
 vminss      xmm0,xmm0,dword [rsi-24]
CASE_5:
 vminss      xmm0,xmm0,dword [rsi-20]
CASE_4:
 vminss      xmm0,xmm0,dword [rsi-16]
CASE_3:
 vminss      xmm0,xmm0,dword [rsi-12]
CASE_2:
 vminss      xmm0,xmm0,dword [rsi-8]
CASE_1:
 vminss      xmm0,xmm0,dword [rsi-4]
CASE_0:
 ret

CASE_LARGE:
 vmovups     ymm0,yword [rdi]
 vmovups     ymm1,yword [rdi+32]
 vmovups     ymm2,yword [rdi+64]
 vmovups     ymm3,yword [rdi+96]
 vmovups     ymm4,yword [rdi+128]
 vmovups     ymm5,yword [rdi+160]
 vmovups     ymm6,yword [rdi+192]
 vmovups     ymm7,yword [rdi+224]

 lea         rsi,[rdi+4*rax]
 add         rdi,512
 cmp         rdi,rsi
 jae         LOOP_END

LOOP_TOP:
 vminps      ymm0,ymm0,yword [rdi-256]
 vminps      ymm1,ymm1,yword [rdi-224]
 vminps      ymm2,ymm2,yword [rdi-192]
 vminps      ymm3,ymm3,yword [rdi-160]
 vminps      ymm4,ymm4,yword [rdi-128]
 vminps      ymm5,ymm5,yword [rdi-96]
 vminps      ymm6,ymm6,yword [rdi-64]
 vminps      ymm7,ymm7,yword [rdi-32]
 add         rdi,256
 cmp         rdi,rsi
 jb          LOOP_TOP

LOOP_END:
 vminps      ymm0,ymm0,yword [rsi-256]
 vminps      ymm1,ymm1,yword [rsi-224]
 vminps      ymm2,ymm2,yword [rsi-192]
 vminps      ymm3,ymm3,yword [rsi-160]
 vminps      ymm4,ymm4,yword [rsi-128]
 vminps      ymm5,ymm5,yword [rsi-96]
 vminps      ymm6,ymm6,yword [rsi-64]
 vminps      ymm7,ymm7,yword [rsi-32]

 vminps      ymm2,ymm2,ymm6
 vminps      ymm3,ymm3,ymm7
 vminps      ymm0,ymm0,ymm4
 vminps      ymm1,ymm1,ymm5

 vminps      ymm0,ymm0,ymm2
 vminps      ymm1,ymm1,ymm3

 vminps      ymm0,ymm0,ymm1

 vextractf128 xmm1,ymm0,1
 vminps      xmm0,xmm0,xmm1
 vmovhlps    xmm1,xmm0,xmm0
 vminps      xmm0,xmm0,xmm1
 vmovshdup   xmm1,xmm0
 vminss      xmm0,xmm0,xmm1
 ret
