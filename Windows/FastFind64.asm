; /*******************************************************************
; *
; *    Author: Kareem Omar
; *    kareem.h.omar@gmail.com
; *    https://github.com/komrad36
; *
; *    Last updated Mar 12, 2021
; *******************************************************************/

_TEXT$FastFind64 SEGMENT ALIGN(64)

FastFind64 PROC
 vmovq       xmm0,r8
 vpbroadcastq ymm0,xmm0
 cmp         rdx,32
 jae         CASE_LARGE
 lea         r9,JUMP_TABLE
 movzx       eax,byte ptr [r9+rdx]
 add         r9,rax
 xor         eax,eax
 lea         r10,[rax-1]
 jmp         r9
db 1 DUP (0CCh)
JUMP_TABLE:
db 1 DUP ( CASE_0 - JUMP_TABLE)
db 1 DUP ( CASE_1 - JUMP_TABLE)
db 1 DUP ( CASE_2 - JUMP_TABLE)
db 1 DUP ( CASE_3 - JUMP_TABLE)
db 4 DUP ( CASE_4 - JUMP_TABLE)
db 4 DUP ( CASE_8 - JUMP_TABLE)
db 4 DUP (CASE_12 - JUMP_TABLE)
db 4 DUP (CASE_16 - JUMP_TABLE)
db 4 DUP (CASE_20 - JUMP_TABLE)
db 4 DUP (CASE_24 - JUMP_TABLE)
db 4 DUP (CASE_28 - JUMP_TABLE)
CASE_28:
 vpcmpeqq    ymm1,ymm0,ymmword ptr [rcx]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 add         eax,4
CASE_24:
 vpcmpeqq    ymm1,ymm0,ymmword ptr [rcx+8*rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 add         eax,4
CASE_20:
 vpcmpeqq    ymm1,ymm0,ymmword ptr [rcx+8*rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 add         eax,4
CASE_16:
 vpcmpeqq    ymm1,ymm0,ymmword ptr [rcx+8*rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 add         eax,4
CASE_12:
 vpcmpeqq    ymm1,ymm0,ymmword ptr [rcx+8*rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 add         eax,4
CASE_8:
 vpcmpeqq    ymm1,ymm0,ymmword ptr [rcx+8*rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 add         eax,4
CASE_4:
 vpcmpeqq    ymm1,ymm0,ymmword ptr [rcx+8*rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 lea         eax,[rdx-4]
 vpcmpeqq    ymm1,ymm0,ymmword ptr [rcx+8*rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 mov         rax,r10
 ret
CASE_3:
 cmp         r8d,dword ptr [rcx]
 je          FOUND_SMALL_SCALAR
 inc         eax
CASE_2:
 cmp         r8d,dword ptr [rcx+8*rax]
 je          FOUND_SMALL_SCALAR
 inc         eax
CASE_1:
 cmp         r8d,dword ptr [rcx+8*rax]
 je          FOUND_SMALL_SCALAR
CASE_0:
 mov         rax,r10
FOUND_SMALL_SCALAR:
 ret

FOUND_SMALL:
 vmovmskpd   ecx,ymm1
 tzcnt       ecx,ecx
 add         eax,ecx
 ret

CASE_LARGE:
 lea         rdx,[rcx+8*rdx]
 add         rcx,256
 mov         r10,rcx

LOOP_TOP:
 vpcmpeqq    ymm1,ymm0,ymmword ptr [rcx-256]
 vpcmpeqq    ymm2,ymm0,ymmword ptr [rcx-224]
 vpor        ymm1,ymm1,ymm2
 vpcmpeqq    ymm3,ymm0,ymmword ptr [rcx-192]
 vpcmpeqq    ymm4,ymm0,ymmword ptr [rcx-160]
 vpor        ymm3,ymm3,ymm4
 vpor        ymm1,ymm1,ymm3
 vpcmpeqq    ymm2,ymm0,ymmword ptr [rcx-128]
 vpcmpeqq    ymm3,ymm0,ymmword ptr [rcx-96]
 vpor        ymm2,ymm2,ymm3
 vpcmpeqq    ymm4,ymm0,ymmword ptr [rcx-64]
 vpcmpeqq    ymm5,ymm0,ymmword ptr [rcx-32]
 vpor        ymm4,ymm4,ymm5
 vpor        ymm2,ymm2,ymm4
 vpor        ymm1,ymm1,ymm2
 vptest      ymm1,ymm1
 jnz         FOUND
 add         rcx,256
 cmp         rcx,rdx
 jb          LOOP_TOP

 mov         rcx,rdx

 vpcmpeqq    ymm1,ymm0,ymmword ptr [rcx-256]
 vpcmpeqq    ymm2,ymm0,ymmword ptr [rcx-224]
 vpor        ymm1,ymm1,ymm2
 vpcmpeqq    ymm3,ymm0,ymmword ptr [rcx-192]
 vpcmpeqq    ymm4,ymm0,ymmword ptr [rcx-160]
 vpor        ymm3,ymm3,ymm4
 vpor        ymm1,ymm1,ymm3
 vpcmpeqq    ymm2,ymm0,ymmword ptr [rcx-128]
 vpcmpeqq    ymm3,ymm0,ymmword ptr [rcx-96]
 vpor        ymm2,ymm2,ymm3
 vpcmpeqq    ymm4,ymm0,ymmword ptr [rcx-64]
 vpcmpeqq    ymm5,ymm0,ymmword ptr [rcx-32]
 vpor        ymm4,ymm4,ymm5
 vpor        ymm2,ymm2,ymm4
 vpor        ymm1,ymm1,ymm2
 vptest      ymm1,ymm1
 jnz         FOUND

 mov         rax,-1
 ret

FOUND:
 vpcmpeqq    ymm1,ymm0,ymmword ptr [rcx-256]
 vmovmskpd   eax,ymm1
 vpcmpeqq    ymm1,ymm0,ymmword ptr [rcx-224]
 vmovmskpd   edx,ymm1
 shl         edx,4
 or          eax,edx
 vpcmpeqq    ymm1,ymm0,ymmword ptr [rcx-192]
 vmovmskpd   edx,ymm1
 vpcmpeqq    ymm1,ymm0,ymmword ptr [rcx-160]
 vmovmskpd   r8d,ymm1
 shl         r8d,4
 or          edx,r8d
 shl         edx,8
 or          eax,edx
 vpcmpeqq    ymm1,ymm0,ymmword ptr [rcx-128]
 vmovmskpd   edx,ymm1
 vpcmpeqq    ymm1,ymm0,ymmword ptr [rcx-96]
 vmovmskpd   r8d,ymm1
 shl         r8d,4
 or          edx,r8d
 vpcmpeqq    ymm1,ymm0,ymmword ptr [rcx-64]
 vmovmskpd   r8d,ymm1
 vpcmpeqq    ymm1,ymm0,ymmword ptr [rcx-32]
 vmovmskpd   r9d,ymm1
 shl         r9d,4
 or          r8d,r9d
 shl         r8d,8
 or          edx,r8d
 shl         edx,16
 or          eax,edx
 tzcnt       eax,eax
 sub         rcx,r10
 shr         rcx,3
 add         rax,rcx
 ret
FastFind64 ENDP

_TEXT$FastFind64 ENDS

END
