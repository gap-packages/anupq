/****************************************************************************
**
*A  pq_functions.h              ANUPQ source                   Eamonn O'Brien
**
*Y  Copyright 1995-2001,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
*Y  Copyright 1995-2001,  School of Mathematical Sciences, ANU,     Australia
**
*/

/* prototypes for functions used in the p-Quotient Program */

#ifndef ANUPQ_FUNCTIONS_H
#define ANUPQ_FUNCTIONS_H

#include "pq_defs.h"
#include "pcp_vars.h"
#include "pga_vars.h"
#include "exp_vars.h"

void autgp_order ();
void collect_defining_generator (int ptr, int cp, struct pcp_vars *pcp);
void factor_subgroup (struct pcp_vars *pcp);
void handle_error (Logical group_present);
void is_timelimit_exceeded ();
void CreateGAPLibraryFile (void);
void compute_padic (int *powers, int x, int k, int p, int *expand);
void print_pcp_relations (struct pcp_vars *pcp);
int **find_allowable_subgroup ();
int*** determine_action (int format, int *nmr_of_auts, struct pcp_vars *pcp);
void check_input (int output, int *max_class, struct pcp_vars *pcp);
FILE *OpenTemporaryFile ();
void close_queue (Logical report, int list_length, int limit, int *head, int *list, int *queue, int queue_length, struct pcp_vars *pcp);
void enforce_exponent (Logical report, struct exp_vars *exp_flag, int **head, int **list, struct pcp_vars *pcp);
void bubble_sort (int *x, int len, struct pcp_vars *pcp);
void complete_echelon (Logical trivial, int redgen, struct pcp_vars *pcp);
void traverse_list (int exponent, int head, int *list, int cp, struct pcp_vars *pcp);
void extend ();
void extend_power (int cp1, int cp2, int u, int **auts, struct pcp_vars *pcp);
void extend_commutator (int cp1, int cp2, int u, int v, int **auts, struct pcp_vars *pcp);
void collect_image_of_generator (int cp, int *auts, struct pcp_vars *pcp);
void collect_image_of_string (int string, int cp, int **auts, struct pcp_vars *pcp);
int ***reallocate_array (int ***a, int orig_n, int orig_m, int orig_r, int n, int m, int r, Logical zero);
int *reallocate_vector (int *a, int original, int new, int start, Logical zero);
void next_class (Logical report, int **head, int **list, struct pcp_vars *pcp);
FILE *OpenSystemFile (const char *file_name, const char *mode);
void create_tail (int address, int f, int s, struct pcp_vars *pcp);
void extend_tail (int address, int f, int s, struct pcp_vars *pcp);
void enforce_laws (struct pga_vars *flag, struct pga_vars *pga, struct pcp_vars *pcp);
void orbit_option (int option, int **perms, int **a, int **b, char **c, int **orbit_length, struct pga_vars *pga);
void stabiliser_option (int option, int ***auts, int **perms, int *a, int *b, char *c, int *orbit_length, struct pga_vars *pga, struct pcp_vars *pcp);
void calculate_tails (int final_class, int start_weight, int end_weight, struct pcp_vars *pcp);
void calculate_power (int exp, int ptr, int cp, struct pcp_vars *pcp);
void write_GAP_matrix ();
int *bitstring_to_subset (int K, struct pga_vars *pga);
int ***allocate_array (int n, int m, int r, Logical zero);
int *allocate_vector (int n, int start, Logical zero);
char *allocate_char_vector (int n, int start, Logical zero);
int **allocate_matrix (int n, int m, int start, Logical zero);
char **allocate_char_matrix (int n, int m, int start, Logical zero);
int **commutator_matrix (struct pga_vars *pga, struct pcp_vars *pcp);
int ***restore_group (Logical rewind_flag, FILE *input_file, int group_number, struct pga_vars *pga, struct pcp_vars *pcp);
void invalid_group (struct pcp_vars *pcp);
void report (int nmr_of_capables, int nmr_of_descendants, int nmr_of_covers, struct pga_vars *pga, struct pcp_vars *pcp);
void print_group_details (struct pga_vars *pga, struct pcp_vars *pcp);
int*** restore_pga (FILE *ifp, struct pga_vars *pga, struct pcp_vars *pcp);
FILE *OpenFile (const char *file_name, const char *mode);
FILE *OpenFileOutput (const char *file_name);
void set_defaults (struct pga_vars *flag);
void read_subgroup_rank (int *k);
void read_step_size (struct pga_vars *pga, struct pcp_vars *pcp);
void query_metabelian_law (struct pga_vars *pga);
void query_degree_aut_information (struct pga_vars *pga);
void query_exponent_law (struct pga_vars *pga);
void query_perm_information (struct pga_vars *pga);
void query_space_efficiency (struct pga_vars *pga);
void query_group_information (int p, struct pga_vars *pga);
void query_aut_group_information (struct pga_vars *pga);
void query_orbit_information (struct pga_vars *pga);
void query_solubility (struct pga_vars *pga);
void query_terminal (struct pga_vars *pga);
void Extend_Aut (int start, int max_length, int *list_length, int *head, int **list, int offset, int *index, struct pcp_vars *pcp);
void Extend_Comm (int cp1, int cp2, int u, int v, int offset, int *head, int *list, struct pcp_vars *pcp);
void Extend_Pow (int cp1, int cp2, int u, int offset, int *head, int *list, struct pcp_vars *pcp);
void Collect_Image_Of_Str (int string, int cp, int offset, int *head, int *list, struct pcp_vars *pcp);
void Collect_Image_Of_Gen (int cp, int head, int *list, struct pcp_vars *pcp);
int** label_to_subgroup (int *Index, int **subset, int label, struct pga_vars *pga);
int** transpose (int **a, int n, int m);
int** multiply_matrix (int **a, int n, int m, int **b, int q, int p);
void add_to_list (int *subset, struct pga_vars *pga);
void visit (int k, int d, struct pga_vars *pga);
void get_definition_sets (struct pga_vars *pga);
int*** central_automorphisms (struct pga_vars *pga, struct pcp_vars *pcp);
void list_interactive_pga_menu (void);
void list_interactive_pq_menu (void);
void start_group (FILE **StartFile, int ***auts, struct pga_vars *pga, struct pcp_vars *pcp);
int* find_orbit_reps (int *a, int *b, struct pga_vars *pga);
int** permute_subgroups (FILE *LINK_input, int **a, int **b, char **c, int ***auts, struct pga_vars *pga, struct pcp_vars *pcp);
void list_pga_menu (void);
void image_to_word (int string, int *image, struct pcp_vars *pcp);
void Copy_Matrix (int **A, int **B, int nmr_of_rows, int nmr_of_bytes);
void CreateName (char *name, int call_depth, struct pcp_vars *pcp);
void find_padic (int x, int k, int p, int *expand, struct pga_vars *pga);
void trace_action (int *permutation, int j, int *a, int *b, char *c);
void update_image (int **A, int column, int **Image, int row, struct pga_vars *pga);
void compute_permutation (int *permutation, int **A, struct pga_vars *pga);
void find_available_positions (int K, int **A, int **Image, int **row, int **column, int depth, struct pga_vars *pga);
void compute_images (int **A, int K, int depth, int *permutation, struct pga_vars *pga);
void start_group (FILE **StartFile, int ***auts, struct pga_vars *pga, struct pcp_vars *pcp);
FILE *OpenFileInput (const char *file_name);
FILE *TemporaryFile (void);
int*** read_auts (int option, int *nmr_of_auts, int *nmr_of_exponents, struct pcp_vars *pcp);
int ***invert_automorphisms (int ***auts, struct pga_vars *pga, struct pcp_vars *pcp);
char* find_permutation (int *b, char *c, struct pga_vars *pga);
int*** immediate_descendant (FILE *descendant_file, struct pga_vars *pga, struct pcp_vars *pcp);
void process_rep (int **perms, int *a, int *b, char *c, char *d, int ***auts, int rep, int orbit_length, FILE *tmp_file, FILE *descendant_file, FILE *covers_file, struct pga_vars *pga, struct pcp_vars *pcp);
void evaluate_image (int *head, int *list, int offset, int ptr, int cp, struct pcp_vars *pcp);
void stabiliser_generators (int **perms, int rep, int *a, int *b, char *c, char *d, int ***auts, struct pga_vars *pga, struct pcp_vars *pcp);
void image_of_generator (int generator, int pointer, int ***auts, struct pga_vars *pga, struct pcp_vars *pcp);
void intermediate_stage (FILE *descendant_file, FILE *input_file, int nmr_of_covers, struct pga_vars *pga, struct pcp_vars *pcp);
void list_pqa_menu (void);
void space_for_orbits (int **a, int **b, char **c, struct pga_vars *pga);
void orbits (int *permutation, int *a, int *b, char *c, struct pga_vars *pga);
Logical is_space_exhausted (int required, struct pcp_vars *pcp);
Logical is_genlim_exceeded (struct pcp_vars *pcp);
void trace_relation (int *sequence, int *index, int ptr, int generator, struct pcp_vars *pcp);
void output_information(int *sequence, int nmr_of_exponents, struct pcp_vars *pcp);
int *compact_description (Logical write_to_file, struct pcp_vars *pcp);
void CloseFile (FILE* file);
void power (int exp, int cp, struct pcp_vars *pcp);
void vector_to_string (int cp, int str, struct pcp_vars *pcp);
int vector_to_word (int cp, int ptr, struct pcp_vars *pcp);
void string_to_vector (int str, int cp, struct pcp_vars *pcp);

#if defined (GROUP)
void collect (int pointer, int collected_part, struct pcp_vars *pcp);
#endif


/* collect_relations.c */
void collect_relations (struct pcp_vars *pcp);

/* degree.c */
void compute_degree (struct pga_vars *pga);

/* echelon.c */
int echelon (struct pcp_vars *pcp);

/* eliminate.c */
void eliminate (Logical middle_of_tails, struct pcp_vars *pcp);

/* exponent_info.c */
void initialise_exponent (struct exp_vars *exp_flag, struct pcp_vars *pcp);

/* extend_automorphisms.c */
void extend_automorphisms (int ***auts, int nmr_of_auts, struct pcp_vars *pcp);

/* extra_relations.c */
#if defined (GROUP)
void extra_relations (struct exp_vars *exp_flag, struct pcp_vars *pcp);
#endif

/* FreeSpace.c */
void free_vector (int *a, int start);
void free_matrix (int **a, int n, int start);
void free_array (int ***a, int n, int m, int start);
void free_char_vector (char *a, int start);
void free_char_matrix (char **a, int n);
void free_space (Logical soluble_computation, int **perms, int *orbit_length, int *a, int *b, char *c, struct pga_vars *pga);

/* GAP_link_via_file.c */
void start_GAP_file ( FILE **GAP_input, int ***auts, struct pga_vars *pga, struct pcp_vars *pcp );

/* last_class.c */
void last_class (struct pcp_vars *pcp);

/* map_relations.c */
void map_relations (int **map, struct pga_vars *pga, struct pcp_vars *pcp);

/* print_arrays.c */
void print_array (int *a, int first, int last);
void print_chars (char *a, int first, int last);

/* print_presentation.c */
void print_map (struct pcp_vars *pcp);
void print_presentation (Logical full, struct pcp_vars *pcp);

/* print_structure.c */
int find_definition (int generator, int pointer, int weight, struct pcp_vars *pcp);

/* read.c */
void verify_read (int nmr_items, int required);
void restore_pcp (FILE *ifp, struct pcp_vars *pcp);
int*** restore_pga (FILE *ifp, struct pga_vars *pga, struct pcp_vars *pcp);

/* read_value.c */
void read_line (void);
void read_value (Logical newline, char *string, int *value, int lower_bound);
int string_to_int (char *s, Logical *error);
char* GetString (char *string);

/* read_word.c */
void setup_symbols (struct pcp_vars *pcp);
void read_word (FILE *file, int disp, int type, struct pcp_vars *pcp);
void pretty_read_word (FILE *file, int disp, int type, struct pcp_vars *pcp);

/* report_error.c */
void report_error (int a, int b, int c);

/* setup_reps.c */
void setup_reps (int *reps, int nmr_of_reps, int *orbit_length,
                 int **perms, int *a, int *b, char *c, int ***auts, 
                 FILE *descendant_file, FILE *covers_file,
                 struct pga_vars *pga, struct pcp_vars *pcp);

/* soluble_orbits.c */
void process_identity_perm (int *a, int *b, char *c, struct pga_vars *pga);

/* stabiliser.c */
int*** stabiliser_of_rep (int **perms, int rep, int orbit_length,
                            int *a, int *b, char *c, char *d, int ***auts,
                            struct pga_vars *pga, struct pcp_vars *pcp);
void stabiliser_generators (int **perms, int rep, int *a, int *b, char *c, char *d,
                            int ***auts, struct pga_vars *pga, struct pcp_vars *pcp);
void image_of_generator (int generator, int pointer, int ***auts, struct pga_vars *pga, struct pcp_vars *pcp);
int preimage (int perm, struct pga_vars *pga);
int ***read_stabiliser_gens (int nmr_of_generators, int ***soluble_generators, struct pga_vars *pga, struct pcp_vars *pcp);

/* standard.c */
#if defined (GROUP) && defined (STANDARD_PCP)
void standard_presentation (Logical *identity_map, int standard_output, int ***auts, struct pga_vars *pga, struct pcp_vars *pcp);
void print_aut_description (int ***central, int ***stabiliser, struct pga_vars *pga, struct pcp_vars *pcp);
int ***read_auts_from_file (FILE *file, int *nmr_of_auts, struct pcp_vars *pcp);
#endif

/* step_range.c */
void step_range (int k, int *lower_step, int *upper_step, int ***auts, struct pga_vars *pga, struct pcp_vars *pcp);

/* store_definition_sets.c */
void store_definition_sets (int r, int lower_step, int upper_step, struct pga_vars *pga);
int choose (int r, int s);

/* strip_identities.c */
void strip_identities (int ***auts, struct pga_vars *pga, struct pcp_vars *pcp);

/* subgroup_to_label.c */
int subgroup_to_label (int **S, int K, int *subset, struct pga_vars *pga);

/* system.c */
void print_message (int work_space);

/* update_generators.c */
void update_generators (struct pcp_vars *pcp);

/* write.c */
void save_pcp (FILE *ofp, struct pcp_vars *pcp);


#endif
