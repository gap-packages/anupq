/* definition of the y array;
   place this as the first line of the routine, before other declarations */

#ifdef Magma
register int *y = mem_access(pcp->y_handle);
#else
register int *y = y_address;
#endif
