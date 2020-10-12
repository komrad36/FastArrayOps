# FastExtrema

Find the value or index of the minimum or maximum element of a linear array up to 35x faster (even for arbitrarily large n) than the best compiler output for the typical loop or STL. Requires x86 and AVX2.

Assembly provided for both Windows (MASM) and Linux (NASM).

This means the crossover point at which accelerated structures such as hash tables or trees become preferable to linear arrays is much, MUCH larger than usually taught or seen in the wild, especially for small elements. A linear array traversed with FastExtrema and FastSearch (https://github.com/komrad36/FastSearch) is faster for find-element, find-min, find-max, decrease-value, increase-value operations than "better" data structures unless you have hundreds or *thousands* of elements.

Note that these are the operations provided by a priority queue, and indeed, similarly, an array-backed priority queue implemented with FastExtrema and FastSearch is faster than the traditional heap-backed priority queue unless you have many hundreds of elements.

The following are speedups for __large n__; proportional speedup is higher than this for smaller n as the functions incorporate bespoke behavior optimized over all n.

## Approx. speedup vs. best compiler output ##  

Data type      | Min/Max Element     | Min/Max Index       
---------------|---------------------|---------------------
I8/U8          | 2.3x                | 34.7x               
I16/U16        | 2.1x                | 18.6x               
I32/U32        | 1.1x                | 8.5x                
I64/U64        | 1.3x                | 3.1x                
Float          | 28.0x               | 8.9x                
Double         | 13.9x               | 5.0x                
