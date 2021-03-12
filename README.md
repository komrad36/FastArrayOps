# FastArrayOps

Extremely fast (up to 35x faster than compiler or STL, for arbitrarily large or small n) x86 / AVX2 implementations of common array ops for arrays of all basic data types:

- Check if array contains element (set membership query)
- Find index of element in array (find-element)
- Find min element in array (find-min, min-element)
- Find max element in array (find-max, max-element)
- Find index of min element in array (idx-min, argmin, minidx)
- Find index of max element in array (idx-max, argmax, maxidx)

This means the crossover point at which accelerated structures such as hash tables or trees become preferable to linear arrays is much, MUCH larger than usually taught or seen in the wild, especially for small elements. A linear array traversed with this library is faster for find-element, find-min, find-max, decrease-value, increase-value operations than "better" data structures unless you have *thousands* of elements.

Note that these are the operations provided by a priority queue, and indeed, similarly, an array-backed priority queue implemented with this library is faster than the traditional heap-backed priority queue unless you have many hundreds or thousands of elements.

The following are speedups for __large n__; proportional speedup is even higher than this for smaller n as the functions incorporate bespoke behavior optimized over all n.

## Approx. speedup vs. best compiler output ##  

Data type      | Contains/Find       | Min/Max Element     | Min/Max Index         
---------------|---------------------|---------------------|-------------------
I8/U8          | 22x                 | 2.3x                | 35x               
I16/U16        | 18x                 | 2.1x                | 19x               
I32/U32        | 12x                 | 1.1x                | 8.5x                
I64/U64        | 7.0x                | 1.3x                | 3.1x                
Float          | 13.0x               | 28x                 | 8.9x                
Double         | 7.0x                | 14x                 | 5.0x    

Min/max index does not guarantee _which_ index is returned if multiple elements are all the minimum.

In contrast, find-element _does_ guarantee to always return the first (lowest-index) element that matches.

0-element arrays are handled gracefully. Min/max index returns ~0U. Min/max returns the min/max representable value for the datatype.

If find-element does not find the element, it returns ~0ULL.

