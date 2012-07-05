/****************************************************************************
**
*A  pretty_filterfns.h          ANUPQ source                   Eamonn O'Brien
**
*A  @(#)$Id$
**
*Y  Copyright 1995-2001,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
*Y  Copyright 1995-2001,  School of Mathematical Sciences, ANU,     Australia
**
*/

/* header file supplied by Sarah Rees */

#ifndef __PRETTY_FILTER__
#define __PRETTY_FILTER__

#include <stdlib.h>

typedef int gen_type; /*name for generator*/

#define anu_valloc(A,N) (A *)malloc((unsigned)(sizeof(A)*(N)))
#define vzalloc(A,N) (A *)calloc((unsigned)N,(unsigned)sizeof(A))
#define inv(g)          inv_of[(g)]

typedef struct {
   gen_type *g;
   int first;	       /* the position of the first entry in the word */
   int last;	       /* position of last entry; if word is empty, 
                          define this to be position BEFORE first entry */
   int space;	       /* this should be a power of 2 */
   char type; /* initialised to 0, 'c' for commutator, or 's' for string */
   int n; /* used if the word is a power of that pointed to by the "g" field.
            0 means the same as 1, i.e. the word is not a proper power */
} word;

typedef struct word_link {
   word * wp;
   struct word_link * next;
} word_link;

typedef struct word_traverser {
   word * wp;
   int posn;
} word_traverser;

extern char word_delget_first(word *wp, gen_type *gp); 
extern char word_del_last(word *wp); 
extern char word_next(word_traverser *wtp, gen_type *gp);
extern char read_next_gen(word *wp, FILE *file);
extern char read_next_word(word *wp, FILE *file);
extern char word_get_last(word *wp, gen_type *gp);
extern char find_keyword(char *label, FILE *rfile);
extern char read_next_string(char *cp, int n, FILE *rfile);
extern char read_next_int(int *kp, FILE *rfile);
extern char word_eq(word *w1p, word *w2p);

word_link * word_link_create(void);
void word_link_init (word_link * wlp);
void word_link_clear (word_link * wlp);

void word_expand (word *wp);
void word2prog_word (word *user_wordp, word *prog_wordp);

void default_inverse_array (void);
int read_char (FILE *rfile);
void find_char (char c, FILE *rfile);

#define word_length(wp)         (((wp)->last) + 1 - ((wp)->first))

extern int num_gens;
extern int paired_gens;
extern gen_type * inv_of;
extern int * pairnumber;
extern word * user_gen_name;
extern int gen_array_size;


#endif 
