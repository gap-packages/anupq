#if defined (RUN_TIME) 
   /* variables which determine access functions for words stored in y */
   unsigned long SC1, SC2, SC3, MASK1, MASK2;
   SC1 = GSC1;  SC2 = GSC2;  SC3 = SC1 + SC2;
   MASK1 = (1L << SC1) - 1; MASK2 = (1L << SC2) - 1;
#endif

