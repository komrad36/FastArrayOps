; /*******************************************************************
; *
; *    Author: Kareem Omar
; *    kareem.h.omar@gmail.com
; *    https://github.com/komrad36
; *
; *    Last updated Mar 12, 2021
; *******************************************************************/

_TEXT$FastFindDouble SEGMENT ALIGN(64)

FastFindDouble PROC
 vbroadcastsd ymm0,xmm2
 cmp         rdx,32
 jae         CASE_LARGE
 lea         r9,JUMP_TABLE
 movzx       eax,byte ptr [r9+rdx]
 add         r9,rax
 xor         eax,eax
 lea         r10,[rax-1]
 jmp         r9
db 3 DUP (0CCh)
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
 vcmpeqpd    ymm1,ymm0,ymmword ptr [rcx]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 add         eax,4
CASE_24:
 vcmpeqpd    ymm1,ymm0,ymmword ptr [rcx+8*rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 add         eax,4
CASE_20:
 vcmpeqpd    ymm1,ymm0,ymmword ptr [rcx+8*rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 add         eax,4
CASE_16:
 vcmpeqpd    ymm1,ymm0,ymmword ptr [rcx+8*rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 add         eax,4
CASE_12:
 vcmpeqpd    ymm1,ymm0,ymmword ptr [rcx+8*rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 add         eax,4
CASE_8:
 vcmpeqpd    ymm1,ymm0,ymmword ptr [rcx+8*rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 add         eax,4
CASE_4:
 vcmpeqpd    ymm1,ymm0,ymmword ptr [rcx+8*rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 lea         eax,[rdx-4]
 vcmpeqpd    ymm1,ymm0,ymmword ptr [rcx+8*rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 mov         rax,r10
 ret
CASE_3:
 vucomisd    xmm0,qword ptr [rcx]
 je          FOUND_SMALL_SCALAR
 inc         eax
CASE_2:
 vucomisd    xmm0,qword ptr [rcx+8*rax]
 je          FOUND_SMALL_SCALAR
 inc         eax
CASE_1:
 vucomisd    xmm0,qword ptr [rcx+8*rax]
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
 vcmpeqpd    ymm1,ymm0,ymmword ptr [rcx-256]
 vcmpeqpd    ymm2,ymm0,ymmword ptr [rcx-224]
 vpor        ymm1,ymm1,ymm2
 vcmpeqpd    ymm3,ymm0,ymmword ptr [rcx-192]
 vcmpeqpd    ymm4,ymm0,ymmword ptr [rcx-160]
 vpor        ymm3,ymm3,ymm4
 vpor        ymm1,ymm1,ymm3
 vcmpeqpd    ymm2,ymm0,ymmword ptr [rcx-128]
 vcmpeqpd    ymm3,ymm0,ymmword ptr [rcx-96]
 vpor        ymm2,ymm2,ymm3
 vcmpeqpd    ymm4,ymm0,ymmword ptr [rcx-64]
 vcmpeqpd    ymm5,ymm0,ymmword ptr [rcx-32]
 vpor        ymm4,ymm4,ymm5
 vpor        ymm2,ymm2,ymm4
 vpor        ymm1,ymm1,ymm2
 vptest      ymm1,ymm1
 jnz         FOUND
 add         rcx,256
 cmp         rcx,rdx
 jb          LOOP_TOP

 mov         rcx,rdx

 vcmpeqpd    ymm1,ymm0,ymmword ptr [rcx-256]
 vcmpeqpd    ymm2,ymm0,ymmword ptr [rcx-224]
 vpor        ymm1,ymm1,ymm2
 vcmpeqpd    ymm3,ymm0,ymmword ptr [rcx-192]
 vcmpeqpd    ymm4,ymm0,ymmword ptr [rcx-160]
 vpor        ymm3,ymm3,ymm4
 vpor        ymm1,ymm1,ymm3
 vcmpeqpd    ymm2,ymm0,ymmword ptr [rcx-128]
 vcmpeqpd    ymm3,ymm0,ymmword ptr [rcx-96]
 vpor        ymm2,ymm2,ymm3
 vcmpeqpd    ymm4,ymm0,ymmword ptr [rcx-64]
 vcmpeqpd    ymm5,ymm0,ymmword ptr [rcx-32]
 vpor        ymm4,ymm4,ymm5
 vpor        ymm2,ymm2,ymm4
 vpor        ymm1,ymm1,ymm2
 vptest      ymm1,ymm1
 jnz         FOUND

 mov         rax,-1
 ret

FOUND:
 vcmpeqpd    ymm1,ymm0,ymmword ptr [rcx-256]
 vmovmskpd   eax,ymm1
 vcmpeqpd    ymm1,ymm0,ymmword ptr [rcx-224]
 vmovmskpd   edx,ymm1
 shl         edx,4
 or          eax,edx
 vcmpeqpd    ymm1,ymm0,ymmword ptr [rcx-192]
 vmovmskpd   edx,ymm1
 vcmpeqpd    ymm1,ymm0,ymmword ptr [rcx-160]
 vmovmskpd   r8d,ymm1
 shl         r8d,4
 or          edx,r8d
 shl         edx,8
 or          eax,edx
 vcmpeqpd    ymm1,ymm0,ymmword ptr [rcx-128]
 vmovmskpd   edx,ymm1
 vcmpeqpd    ymm1,ymm0,ymmword ptr [rcx-96]
 vmovmskpd   r8d,ymm1
 shl         r8d,4
 or          edx,r8d
 vcmpeqpd    ymm1,ymm0,ymmword ptr [rcx-64]
 vmovmskpd   r8d,ymm1
 vcmpeqpd    ymm1,ymm0,ymmword ptr [rcx-32]
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
FastFindDouble ENDP

_TEXT$FastFindDouble ENDS

END
