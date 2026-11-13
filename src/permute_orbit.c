/****************************************************************************
**
*A  permute_orbit.c             ANUPQ source
**
*/

#include "pq_defs.h"
#include "pcp_vars.h"
#include "pga_vars.h"
#include "pq_functions.h"
#include "constants.h"

/* A standard presentation needs only the orbit of the non-standard
   allowable subgroup: its least label is the representative, and the word
   mapping the subgroup to the representative and the stabiliser of the
   representative depend only on the action on this orbit.  The orbit
   algorithms treat each orbit by itself and compare labels only by size,
   so acting on the orbit, numbered 1, ..., L in increasing order of
   labels, gives the same representative, word and stabiliser as acting
   on all pga->Degree allowable subgroups.

   Restrict to the orbit only if there are at least ORBIT_MIN_DEGREE
   allowable subgroups and the orbit has at most 1 / ORBIT_FRACTION of
   them: an image computed by itself costs more than one computed by
   compute_images, which runs through all allowable subgroups, so the
   orbit pays up to about a quarter of them, and a search given up at an
   eighth costs at most about half of permuting them all. */

#ifndef ORBIT_MIN_DEGREE
#define ORBIT_MIN_DEGREE 100000
#endif
#ifndef ORBIT_FRACTION
#define ORBIT_FRACTION 8
#endif

static int *orbit_labels = 0; /* label of each point, or 0 if unrestricted */

/* the label of the allowable subgroup at this point of the permutations */

int point_label(int point)
{
   return orbit_labels == 0 ? point : orbit_labels[point];
}

void free_orbit_labels(void)
{
   if (orbit_labels == 0)
      return;
   free_vector(orbit_labels, 1);
   orbit_labels = 0;
}

/* a set of labels: open addressing, 0 marks an empty slot */

struct label_set {
   int *slot;
   int size; /* number of slots, a power of 2 */
   int count;
};

static int first_slot(int label, int size)
{
   unsigned long long hash = (unsigned long long)label * 0x9E3779B97F4A7C15ULL;

   return (int)((hash >> 32) & (unsigned long long)(size - 1));
}

static void add_to_slots(int *slot, int size, int label)
{
   int i;

   for (i = first_slot(label, size); slot[i] != 0; i = (i + 1) & (size - 1))
      ;
   slot[i] = label;
}

/* add label to set; return FALSE if it was there already */

static Logical add_label(struct label_set *set, int label)
{
   int *old;
   int i;

   for (i = first_slot(label, set->size); set->slot[i] != 0;
        i = (i + 1) & (set->size - 1))
      if (set->slot[i] == label)
         return FALSE;

   /* keep at most half of the slots used */
   if (2 * (set->count + 1) > set->size) {
      old = set->slot;
      set->slot = allocate_vector(2 * set->size, 0, TRUE);
      for (i = 0; i < set->size; ++i)
         if (old[i] != 0)
            add_to_slots(set->slot, 2 * set->size, old[i]);
      free_vector(old, 0);
      set->size *= 2;
   }

   add_to_slots(set->slot, set->size, label);
   ++set->count;
   return TRUE;
}

static int compare_labels(const void *a, const void *b)
{
   int x = *(const int *)a, y = *(const int *)b;

   return (x > y) - (x < y);
}

/* space to compute images of allowable subgroups as find_image does, but
   without allocating for each image */

struct image_space {
   int **S;       /* standard matrix of the allowable subgroup */
   int **image;   /* its image under an automorphism matrix */
   int *subset;   /* definition set of the image */
   int **def_set; /* def_set[i]: pga->list[i] as a subset */
};

static void setup_image_space(struct image_space *space, struct pga_vars *pga)
{
   int i;

   space->S = allocate_matrix(pga->s, pga->q, 0, FALSE);
   space->image = allocate_matrix(pga->s, pga->q, 0, FALSE);
   space->subset = allocate_vector(pga->s, 0, FALSE);
   space->def_set = (int **)malloc(pga->nmr_def_sets * sizeof(int *));
   if (space->def_set == 0) {
      perror("Call to setup_image_space");
      exit(FAILURE);
   }
   for (i = 0; i < pga->nmr_def_sets; ++i)
      space->def_set[i] = bitstring_to_subset(pga->list[i], pga);
}

static void free_image_space(struct image_space *space, struct pga_vars *pga)
{
   int i;

   free_matrix(space->S, pga->s, 0);
   free_matrix(space->image, pga->s, 0);
   free_vector(space->subset, 0);
   for (i = 0; i < pga->nmr_def_sets; ++i)
      free_vector(space->def_set[i], 0);
   free(space->def_set);
}

/* the label of the image of the allowable subgroup with this label under
   the automorphism matrix A; the standard matrix is set up as by
   label_to_subgroup, and the image as in find_image */

static int
orbit_image(int label, int **A, struct image_space *space, struct pga_vars *pga)
{
   register int s = pga->s, q = pga->q, p = pga->p;
   register int i, j, c, sum;
   int lo = 0, hi = pga->nmr_def_sets - 1, mid;
   int K, x, *set;
   int **S = space->S, **image = space->image;

   /* the definition set is the last one with offset below label */
   while (lo < hi) {
      mid = (lo + hi + 1) / 2;
      if (pga->offset[mid] < label)
         lo = mid;
      else
         hi = mid - 1;
   }
   K = pga->list[lo];
   set = space->def_set[lo];

   /* the p-adic digits of the remainder fill the available positions */
   x = label - pga->offset[lo] - 1;
   for (i = 0; i < s; ++i) {
      for (j = 0; j < q; ++j)
         S[i][j] = 0;
      S[i][set[i]] = 1;
      for (j = set[i] + 1; j < q; ++j) {
         if (1 << j & K)
            continue;
         S[i][j] = x % p;
         x /= p;
      }
   }

   for (i = 0; i < s; ++i)
      for (j = 0; j < q; ++j) {
         sum = 0;
         for (c = set[i]; c < q; ++c)
            sum += S[i][c] * A[j][c];
         image[i][j] = sum % p;
      }

   K = echelonise_matrix(image, s, q, p, space->subset, pga);
   return subgroup_to_label(image, K, space->subset, pga);
}

/* the point of the orbit with this label */

static int label_point(int label, int length)
{
   int *found = (int *)bsearch(
       &label, orbit_labels + 1, length, sizeof(int), compare_labels);

   return (int)(found - orbit_labels);
}

/* as permute_subgroups, but act only on the orbit of the allowable
   subgroup with label *label, replace *label by its point and set
   pga->Degree to the length of the orbit; return 0, having changed
   nothing, if this does not pay or does not apply */

int **permute_orbit(FILE *LINK_input,
                    int *label,
                    int ***auts,
                    struct pga_vars *pga,
                    struct pcp_vars *pcp)
{
   register int q = pga->q;
   register int n = pga->nmr_of_perms;
   register int alpha, j, k;
   int **A;
   int ***mats;   /* matrix of the automorphism of each permutation */
   int *identity; /* whether it is the identity */
   int *orbit;    /* the orbit, in the order found */
   int **image;   /* image[k][j]: label of the image of orbit[j] */
   int length, size, limit, point;
   struct label_set found;
   struct image_space space;
   int **perms = 0;
   Logical soluble_group;

   if (pga->Degree < ORBIT_MIN_DEGREE || pga->space_efficient || n == 0)
      return 0;

   soluble_group = (pga->soluble || pga->Degree == 1 || pga->nmr_of_perms == 0);

   /* permute_subgroups reports an invalid matrix */
   A = allocate_matrix(q, q, 0, FALSE);
   mats = (int ***)calloc(n + 1, sizeof(int **));
   identity = allocate_vector(n, 1, FALSE);
   if (mats == 0) {
      perror("Call to permute_orbit");
      exit(FAILURE);
   }
   for (alpha = 1; alpha <= pga->m; ++alpha) {
      assemble_matrix(A, q, auts[alpha], pcp);
      if (!valid_matrix(A, q, pga->p, 0))
         goto cleanup;
      if ((k = pga->map[alpha]) == 0)
         continue;
      mats[k] = allocate_matrix(q, q, 0, FALSE);
      assemble_matrix(mats[k], q, auts[alpha], pcp);
      identity[k] = is_identity(mats[k], q, 0);
   }

   /* the orbit by breadth-first search, given up beyond limit */
   limit = pga->Degree / ORBIT_FRACTION;
   size = 1024;
   orbit = allocate_vector(size, 1, FALSE);
   image = allocate_matrix(n, size, 1, FALSE);
   found.size = 2 * size;
   found.count = 0;
   found.slot = allocate_vector(found.size, 0, TRUE);
   setup_image_space(&space, pga);
   length = 1;
   orbit[1] = *label;
   add_label(&found, *label);
   for (j = 1; j <= length; ++j) {
      for (k = 1; k <= n; ++k) {
         if (identity[k]) {
            image[k][j] = orbit[j];
            continue;
         }
         image[k][j] = orbit_image(orbit[j], mats[k], &space, pga);
         if (!add_label(&found, image[k][j]))
            continue;
         if (length >= limit)
            goto discard;
         if (length == size) {
            orbit = reallocate_vector(orbit, size, 2 * size, 1, FALSE);
            for (point = 1; point <= n; ++point)
               image[point] =
                   reallocate_vector(image[point], size, 2 * size, 1, FALSE);
            size *= 2;
         }
         orbit[++length] = image[k][j];
      }
   }

   /* with one point, pga->Degree == 1 would select the soluble algorithm */
   if (length == 1)
      goto discard;

   /* number the orbit in increasing order of labels */
   orbit_labels = allocate_vector(length, 1, FALSE);
   memcpy(orbit_labels + 1, orbit + 1, length * sizeof(int));
   qsort(orbit_labels + 1, length, sizeof(int), compare_labels);

   perms = allocate_matrix(n, length, 1, FALSE);
   for (j = 1; j <= length; ++j) {
      point = label_point(orbit[j], length);
      for (k = 1; k <= n; ++k)
         perms[k][point] = label_point(image[k][j], length);
   }
   *label = label_point(*label, length);
   pga->Degree = length;
   pga->nmr_subgroups = length;

   /* what else permute_subgroups does, in the same order */
   for (alpha = 1; alpha <= pga->m; ++alpha) {
      if (pga->trace)
         printf("Processing automorphism %d:\n", alpha);
      assemble_matrix(A, q, auts[alpha], pcp);
      if (pga->print_automorphism_matrix) {
         printf("Automorphism matrix %d is\n", alpha);
         print_matrix(A, q, q);
      }
      if (!soluble_group) {
#if defined(GAP_LINK) || defined(GAP_LINK_VIA_FILE)
         write_GAP_matrix(LINK_input, "ANUPQglb.genQ", A, q, 0, alpha);
#endif
      }
      if ((k = pga->map[alpha]) != 0 && pga->print_permutation) {
         printf("Permutation %d is\n", alpha);
         print_array(perms[k], 1, pga->Degree + 1);
      }
   }

discard:
   free_vector(orbit, 1);
   free_matrix(image, n, 1);
   free_vector(found.slot, 0);
   free_image_space(&space, pga);
cleanup:
   for (k = 1; k <= n; ++k)
      if (mats[k] != 0)
         free_matrix(mats[k], q, 0);
   free(mats);
   free_vector(identity, 1);
   free_matrix(A, q, 0);
   return perms;
}
