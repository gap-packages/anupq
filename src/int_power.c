/* return the power, x^n  */

int int_power (x, n)
int x;
int n;
{
   register int result = 1;

   while (n != 0) {
      if (n % 2 == 1) result *= x;  
      if (n > 1) x *= x;
      n = n >> 1;
   }

   return result;
}
