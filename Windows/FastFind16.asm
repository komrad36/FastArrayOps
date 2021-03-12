; /*******************************************************************
; *
; *    Author: Kareem Omar
; *    kareem.h.omar@gmail.com
; *    https://github.com/komrad36
; *
; *    Last updated Mar 12, 2021
; *******************************************************************/

_TEXT$FastFind16 SEGMENT ALIGN(64)

FastFind16 PROC
 vmovd       xmm0,r8d
 vpbroadcastw ymm0,xmm0
 cmp         rdx,127
 ja          CASE_LARGE
 lea         r9,JUMP_TABLE
 movzx       eax,word ptr [r9+2*rdx]
 add         r9,rax
 xor         eax,eax
 lea         r10,[rax-1]
 jmp         r9
db 8 DUP (0CCh)
JUMP_TABLE:
dw  1 DUP (  CASE_0 - JUMP_TABLE)
dw  1 DUP (  CASE_1 - JUMP_TABLE)
dw  1 DUP (  CASE_2 - JUMP_TABLE)
dw  1 DUP (  CASE_3 - JUMP_TABLE)
dw  4 DUP (  CASE_4 - JUMP_TABLE)
dw  8 DUP (  CASE_8 - JUMP_TABLE)
dw 16 DUP ( CASE_16 - JUMP_TABLE)
dw 16 DUP ( CASE_32 - JUMP_TABLE)
dw 16 DUP ( CASE_48 - JUMP_TABLE)
dw 16 DUP ( CASE_64 - JUMP_TABLE)
dw 16 DUP ( CASE_80 - JUMP_TABLE)
dw 16 DUP ( CASE_96 - JUMP_TABLE)
dw 16 DUP (CASE_112 - JUMP_TABLE)
CASE_112:
 vpcmpeqw    ymm1,ymm0,ymmword ptr [rcx]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 add         eax,16
CASE_96:
 vpcmpeqw    ymm1,ymm0,ymmword ptr [rcx+2*rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 add         eax,16
CASE_80:
 vpcmpeqw    ymm1,ymm0,ymmword ptr [rcx+2*rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 add         eax,16
CASE_64:
 vpcmpeqw    ymm1,ymm0,ymmword ptr [rcx+2*rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 add         eax,16
CASE_48:
 vpcmpeqw    ymm1,ymm0,ymmword ptr [rcx+2*rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 add         eax,16
CASE_32:
 vpcmpeqw    ymm1,ymm0,ymmword ptr [rcx+2*rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 add         eax,16
CASE_16:
 vpcmpeqw    ymm1,ymm0,ymmword ptr [rcx+2*rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 lea         eax,[rdx-16]
 vpcmpeqw    ymm1,ymm0,ymmword ptr [rcx+2*rax]
 vptest      ymm1,ymm1
 jnz         FOUND_SMALL
 mov         rax,r10
 ret
CASE_8:
 vpcmpeqw    xmm1,xmm0,xmmword ptr [rcx]
 vptest      xmm1,xmm1
 jnz         FOUND_SMALL
 lea         eax,[rdx-8]
 vpcmpeqw    xmm1,xmm0,xmmword ptr [rcx+2*rax]
 vptest      xmm1,xmm1
 jnz         FOUND_SMALL
 mov         rax,r10
 ret
CASE_4:
 vpbroadcastq xmm1,qword ptr [rcx]
 vpcmpeqw    xmm1,xmm0,xmm1
 vptest      xmm1,xmm1
 jnz         FOUND_SMALL
 lea         eax,[rdx-4]
 vpbroadcastq xmm1,qword ptr [rcx+2*rax]
 vpcmpeqw    xmm1,xmm0,xmm1
 vptest      xmm1,xmm1
 jnz         FOUND_SMALL
 mov         rax,r10
 ret
CASE_3:
 cmp         r8w,word ptr [rcx]
 je          FOUND_SMALL_SCALAR
 inc         eax
CASE_2:
 cmp         r8w,word ptr [rcx+2*rax]
 je          FOUND_SMALL_SCALAR
 inc         eax
CASE_1:
 cmp         r8w,word ptr [rcx+2*rax]
 je          FOUND_SMALL_SCALAR
CASE_0:
 mov         rax,r10
FOUND_SMALL_SCALAR:
 ret

FOUND_SMALL:
 vpmovmskb   ecx,ymm1
 tzcnt       ecx,ecx
 shr         ecx,1
 add         eax,ecx
 ret

CASE_LARGE:
 lea         rdx,[rcx+2*rdx]
 add         rcx,256
 mov         r11,rcx

LOOP_TOP:
 vpcmpeqw    ymm1,ymm0,ymmword ptr [rcx-256]
 vpcmpeqw    ymm2,ymm0,ymmword ptr [rcx-224]
 vpor        ymm1,ymm1,ymm2
 vpcmpeqw    ymm3,ymm0,ymmword ptr [rcx-192]
 vpcmpeqw    ymm4,ymm0,ymmword ptr [rcx-160]
 vpor        ymm3,ymm3,ymm4
 vpor        ymm1,ymm1,ymm3
 vpcmpeqw    ymm2,ymm0,ymmword ptr [rcx-128]
 vpcmpeqw    ymm3,ymm0,ymmword ptr [rcx-96]
 vpor        ymm2,ymm2,ymm3
 vpcmpeqw    ymm4,ymm0,ymmword ptr [rcx-64]
 vpcmpeqw    ymm5,ymm0,ymmword ptr [rcx-32]
 vpor        ymm4,ymm4,ymm5
 vpor        ymm2,ymm2,ymm4
 vpor        ymm1,ymm1,ymm2
 vptest      ymm1,ymm1
 jnz         FOUND
 add         rcx,256
 cmp         rcx,rdx
 jb          LOOP_TOP

 mov         rcx,rdx

 vpcmpeqw    ymm1,ymm0,ymmword ptr [rcx-256]
 vpcmpeqw    ymm2,ymm0,ymmword ptr [rcx-224]
 vpor        ymm1,ymm1,ymm2
 vpcmpeqw    ymm3,ymm0,ymmword ptr [rcx-192]
 vpcmpeqw    ymm4,ymm0,ymmword ptr [rcx-160]
 vpor        ymm3,ymm3,ymm4
 vpor        ymm1,ymm1,ymm3
 vpcmpeqw    ymm2,ymm0,ymmword ptr [rcx-128]
 vpcmpeqw    ymm3,ymm0,ymmword ptr [rcx-96]
 vpor        ymm2,ymm2,ymm3
 vpcmpeqw    ymm4,ymm0,ymmword ptr [rcx-64]
 vpcmpeqw    ymm5,ymm0,ymmword ptr [rcx-32]
 vpor        ymm4,ymm4,ymm5
 vpor        ymm2,ymm2,ymm4
 vpor        ymm1,ymm1,ymm2
 vptest      ymm1,ymm1
 jnz         FOUND

 mov         rax,-1
 ret

FOUND:
 vpcmpeqw    ymm1,ymm0,ymmword ptr [rcx-256]
 vpmovmskb   eax,ymm1
 vpcmpeqw    ymm1,ymm0,ymmword ptr [rcx-224]
 vpmovmskb   edx,ymm1
 shl         rdx,32
 or          rax,rdx
 vpcmpeqw    ymm1,ymm0,ymmword ptr [rcx-192]
 vpmovmskb   edx,ymm1
 vpcmpeqw    ymm1,ymm0,ymmword ptr [rcx-160]
 vpmovmskb   r8d,ymm1
 shl         r8,32
 or          rdx,r8
 vpcmpeqw    ymm1,ymm0,ymmword ptr [rcx-128]
 vpmovmskb   r8d,ymm1
 vpcmpeqw    ymm1,ymm0,ymmword ptr [rcx-96]
 vpmovmskb   r9d,ymm1
 shl         r9,32
 or          r8,r9
 vpcmpeqw    ymm1,ymm0,ymmword ptr [rcx-64]
 vpmovmskb   r9d,ymm1
 vpcmpeqw    ymm1,ymm0,ymmword ptr [rcx-32]
 vpmovmskb   r10d,ymm1
 shl         r10,32
 or          r9,r10
 tzcnt       r9,r9
 add         r9b,192
 tzcnt       r8,r8
 lea         r8d,[r8+128]
 cmovnc      r9d,r8d
 tzcnt       rdx,rdx
 lea         edx,[rdx+64]
 cmovnc      r9d,edx
 tzcnt       rax,rax
 cmovc       eax,r9d
 sub         rcx,r11
 add         rax,rcx
 shr         rax,1
 ret
FastFind16 ENDP

_TEXT$FastFind16 ENDS

END
