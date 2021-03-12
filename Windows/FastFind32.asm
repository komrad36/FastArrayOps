; /*******************************************************************
; *
; *    Author: Kareem Omar
; *    kareem.h.omar@gmail.com
; *    https://github.com/komrad36
; *
; *    Last updated Mar 12, 2021
; *******************************************************************/

_TEXT$FastFind32 SEGMENT ALIGN(64)

FastFind32 PROC
 vmovd       xmm0,r8d
 vpbroadcastd ymm0,xmm0
 cmp         rdx,64
 jae         CASE_LARGE
 lea         r9,JUMP_TABLE
 movzx       eax,byte ptr [r9+rdx]
 add         r9,rax
 xor         eax,eax
 lea         r10,[rax-1]
 jmp         r9
db 4 DUP (0CCh)
JUMP_TABLE:
db 1 DUP ( CASE_0 - JUMP_TABLE)
db 1 DUP ( CASE_1 - JUMP_TABLE)
db 1 DUP ( CASE_2 - JUMP_TABLE)
db 1 DUP ( CASE_3 - JUMP_TABLE)
db 4 DUP ( CASE_4 - JUMP_TABLE)
db 8 DUP ( CASE_8 - JUMP_TABLE)
db 8 DUP (CASE_16 - JUMP_TABLE)
db 8 DUP (CASE_24 - JUMP_TABLE)
db 8 DUP (CASE_32 - JUMP_TABLE)
db 8 DUP (CASE_40 - JUMP_TABLE)
db 8 DUP (CASE_48 - JUMP_TABLE)
db 8 DUP (CASE_56 - JUMP_TABLE)
CASE_56:
 vpcmpeqd    ymm1,ymm0,ymmword ptr [rcx]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 add         eax,8
CASE_48:
 vpcmpeqd    ymm1,ymm0,ymmword ptr [rcx+4*rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 add         eax,8
CASE_40:
 vpcmpeqd    ymm1,ymm0,ymmword ptr [rcx+4*rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 add         eax,8
CASE_32:
 vpcmpeqd    ymm1,ymm0,ymmword ptr [rcx+4*rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 add         eax,8
CASE_24:
 vpcmpeqd    ymm1,ymm0,ymmword ptr [rcx+4*rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 add         eax,8
CASE_16:
 vpcmpeqd    ymm1,ymm0,ymmword ptr [rcx+4*rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 add         eax,8
CASE_8:
 vpcmpeqd    ymm1,ymm0,ymmword ptr [rcx+4*rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 lea         eax,[rdx-8]
 vpcmpeqd    ymm1,ymm0,ymmword ptr [rcx+4*rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 mov         rax,r10
 ret
CASE_4:
 vpcmpeqd    xmm1,xmm0,xmmword ptr [rcx]
 vptest      xmm1,xmm1
 jnz         FOUND_SMALL
 lea         eax,[rdx-4]
 vpcmpeqd    xmm1,xmm0,xmmword ptr [rcx+4*rax]
 vptest      xmm1,xmm1
 jnz         FOUND_SMALL
 mov         rax,r10
 ret
CASE_3:
 cmp         r8d,dword ptr [rcx]
 je          FOUND_SMALL_SCALAR
 inc         eax
CASE_2:
 cmp         r8d,dword ptr [rcx+4*rax]
 je          FOUND_SMALL_SCALAR
 inc         eax
CASE_1:
 cmp         r8d,dword ptr [rcx+4*rax]
 je          FOUND_SMALL_SCALAR
CASE_0:
 mov         rax,r10
FOUND_SMALL_SCALAR:
 ret

FOUND_SMALL:
 vmovmskps   ecx,ymm1
 tzcnt       ecx,ecx
 add         eax,ecx
 ret

CASE_LARGE:
 lea         rdx,[rcx+4*rdx]
 add         rcx,256
 mov         r10,rcx

LOOP_TOP:
 vpcmpeqd    ymm1,ymm0,ymmword ptr [rcx-256]
 vpcmpeqd    ymm2,ymm0,ymmword ptr [rcx-224]
 vpor        ymm1,ymm1,ymm2
 vpcmpeqd    ymm3,ymm0,ymmword ptr [rcx-192]
 vpcmpeqd    ymm4,ymm0,ymmword ptr [rcx-160]
 vpor        ymm3,ymm3,ymm4
 vpor        ymm1,ymm1,ymm3
 vpcmpeqd    ymm2,ymm0,ymmword ptr [rcx-128]
 vpcmpeqd    ymm3,ymm0,ymmword ptr [rcx-96]
 vpor        ymm2,ymm2,ymm3
 vpcmpeqd    ymm4,ymm0,ymmword ptr [rcx-64]
 vpcmpeqd    ymm5,ymm0,ymmword ptr [rcx-32]
 vpor        ymm4,ymm4,ymm5
 vpor        ymm2,ymm2,ymm4
 vpor        ymm1,ymm1,ymm2
 vptest      ymm1,ymm1
 jnz         FOUND
 add         rcx,256
 cmp         rcx,rdx
 jb          LOOP_TOP

 mov         rcx,rdx

 vpcmpeqd    ymm1,ymm0,ymmword ptr [rcx-256]
 vpcmpeqd    ymm2,ymm0,ymmword ptr [rcx-224]
 vpor        ymm1,ymm1,ymm2
 vpcmpeqd    ymm3,ymm0,ymmword ptr [rcx-192]
 vpcmpeqd    ymm4,ymm0,ymmword ptr [rcx-160]
 vpor        ymm3,ymm3,ymm4
 vpor        ymm1,ymm1,ymm3
 vpcmpeqd    ymm2,ymm0,ymmword ptr [rcx-128]
 vpcmpeqd    ymm3,ymm0,ymmword ptr [rcx-96]
 vpor        ymm2,ymm2,ymm3
 vpcmpeqd    ymm4,ymm0,ymmword ptr [rcx-64]
 vpcmpeqd    ymm5,ymm0,ymmword ptr [rcx-32]
 vpor        ymm4,ymm4,ymm5
 vpor        ymm2,ymm2,ymm4
 vpor        ymm1,ymm1,ymm2
 vptest      ymm1,ymm1
 jnz         FOUND

 mov         rax,-1
 ret

FOUND:
 vpcmpeqd    ymm1,ymm0,ymmword ptr [rcx-256]
 vmovmskps   eax,ymm1
 vpcmpeqd    ymm1,ymm0,ymmword ptr [rcx-224]
 vmovmskps   edx,ymm1
 shl         edx,8
 or          eax,edx
 vpcmpeqd    ymm1,ymm0,ymmword ptr [rcx-192]
 vmovmskps   edx,ymm1
 vpcmpeqd    ymm1,ymm0,ymmword ptr [rcx-160]
 vmovmskps   r8d,ymm1
 shl         r8d,8
 or          edx,r8d
 shl         edx,16
 or          eax,edx
 vpcmpeqd    ymm1,ymm0,ymmword ptr [rcx-128]
 vmovmskps   edx,ymm1
 vpcmpeqd    ymm1,ymm0,ymmword ptr [rcx-96]
 vmovmskps   r8d,ymm1
 shl         r8d,8
 or          edx,r8d
 vpcmpeqd    ymm1,ymm0,ymmword ptr [rcx-64]
 vmovmskps   r8d,ymm1
 vpcmpeqd    ymm1,ymm0,ymmword ptr [rcx-32]
 vmovmskps   r9d,ymm1
 shl         r9d,8
 or          r8d,r9d
 shl         r8d,16
 or          edx,r8d
 shl         rdx,32
 or          rax,rdx
 tzcnt       rax,rax
 sub         rcx,r10
 shr         rcx,2
 add         rax,rcx
 ret
FastFind32 ENDP

_TEXT$FastFind32 ENDS

END
