## do not edit this definitions #############################################
SHELL=/bin/sh

GNUINC=/usr/local/include
GNULIB=/usr/local/lib

EFILE=pq
EXT=.ext
PQFLAGS=-DGAP_LINK_VIA_FILE -DGAP -I../include -DSTANDARD_PCP -DGROUP
GAP=gap

## ANUPQ is the anupq directory relative to the location of the Makefile
ANUPQ=..
GAP_PATH=$(ANUPQ)/..
PKG_PATH=${GAP_PATH}/pkg

## location of Makefile relative to the src directory
MAKEFILE=../gap/Makefile
SRC=$(ANUPQ)/src

SRCDISTFILE=anupq

## show makefile options ####################################################
unknown:
	@echo "usage: 'make <target> EXT=<ext>'  where <target> is one of"
	@echo "'dec-mips-ultrix-gcc2-gmp' for DECstations under Ultrix with GNU cc 2 and GNU mp"
	@echo "'dec-mips-ultrix-cc-gmp'   for DECstations under Ultrix with cc and GNU mp"
	@echo "'dec-mips-ultrix-gcc2'     for DECstations under Ultrix with GNU cc 2"
	@echo "'dec-mips-ultrix-cc'       for DECstations under Ultrix with cc"
	@echo "'hp-hppa1.1-hpux-cc-gmp'   for HP 9000/700 under HP-UX with cc and GNU mp"
	@echo "'hp-hppa1.1-hpux-cc'       for HP 9000/700 under HP-UX with cc"
	@echo "'hp-hppa1.1-hpux-gcc'      for HP 9000/700 under HP-UX with gcc"
	@echo "'hp-hppa1.0-hpux-cc-gmp'   for HP 9000/800 under HP-UX with cc and GNU mp"
	@echo "'hp-hppa1.0-hpux-cc'       for HP 9000/800 under HP-UX with cc"
	@echo "'hp-hppa1.0-hpux-gcc'      for HP 9000/800 under HP-UX with gcc"
	@echo "'ibm-i386-386bsd-gcc2-gmp' for IBM PCs under 386BSD with GNU cc 2 and mp"
	@echo "'ibm-i386-386bsd-cc-gmp'   for IBM PCs under 386BSD with cc and GNU mp"
	@echo "'ibm-i386-386bsd-gcc2'     for IBM PCs under 386BSD with GNU cc 2"
	@echo "'ibm-i386-386bsd-cc'       for IBM PCs under 386BSD with cc (GNU)"
	@echo "'mips-mips-bsd-cc-gmp'     for MIPS under RISC/os Berkeley with cc and GNU mp"
	@echo "'mips-mips-bsd-cc'         for MIPS under RISC/os Berkeley with cc"
	@echo "'next-m68k-mach-gcc2-gmp'  for NeXT under Mach with GNU cc 2 and GNU mp"
	@echo "'next-m68k-mach-cc-gmp'    for NeXT under Mach with cc and GNU mp"
	@echo "'next-m68k-mach-gcc2'      for NeXT under Mach with GNU cc 2"
	@echo "'next-m68k-mach-cc'        for NeXT under Mach with cc (GNU)"
	@echo "'sun-sparc-sunos-gcc2-gmp' for SUN 4 under SunOs with GNU cc 2 and gmp"
	@echo "'sun-sparc-sunos-cc-gmp'   for SUN 4 under SunOs with cc and GNU mp"
	@echo "'sun-sparc-sunos-gcc2'     for SUN 4 under SunOs with GNU cc 2"
	@echo "'sun-sparc-sunos-cc'       for SUN 4 under SunOs with cc"
	@echo "'unix-gmp'                 for a generic unix system with cc and GNU mp"
	@echo "'unix'                     for a generic unix system with cc"
	@echo "'clean'                    remove all created files"
	@echo ""
	@echo "   where <ext> should be a sensible extension, i.e.,"
	@echo "   'EXT=-sun-sparc-sunos' for SUN 4 or 'EXT=' if the PQ only"
	@echo "   runs on a single architecture"
	@echo ""
	@echo "   targets are listed according to preference,"
	@echo "   i.e., 'sun-sparc-sunos-gcc2' is better than 'sun-sparc-sunos-cc'."
	@echo "   additional C compiler and linker flags can be passed with"
	@echo "   'make <target> COPTS=<compiler-opts> LOPTS=<linker-opts>',"
	@echo "   i.e., 'make sun-sparc-sunos-cc COPTS=-g LOPTS=-g'."
	@echo ""
	@echo "   set GAP if gap 3.4 is not started with the command 'gap',"
	@echo "   i.e., 'make sun-sparc-sunos-cc GAP=/home/gap/bin/gap-3.4'."
	@echo ""
	@echo "   in order to use the GNU multiple precision (gmp) set"
	@echo "   'GNUINC' (default '/usr/local/include') and "
	@echo "   'GNULIB' (default '/usr/local/lib')"

unix-gmp:
	@( cd $(SRC) ; $(MAKE) -f $(MAKEFILE) $(EFILE) CC=cc \
	CFLAGS="$(COPTS) -DLARGE_INT -DGNUINC -I$(GNUINC) $(PQFLAGS) \
		-DNO_GETRUSAGE -DUNIX" \
	GAP=$(GAP) \
	EXT=$(EXT) \
	LDLIBS="-lm -L$(GNULIB) -lgmp" )

unix:
	@( cd $(SRC) ; $(MAKE) -f $(MAKEFILE) $(EFILE) CC=cc \
	CFLAGS="$(COPTS) $(PQFLAGS) -DUNIX -DNO_GETRUSAGE" \
	GAP=$(GAP) \
	EXT=$(EXT) \
	LDLIBS="-lm" )

ibm-i386-386bsd-gcc2-gmp:
	@( cd $(SRC) ; $(MAKE) -f $(MAKEFILE) $(EFILE) CC=gcc \
	CFLAGS="$(COPTS) -DLARGE_INT -DGNUINC -I$(GNUINC) -O2 $(PQFLAGS) \
                -DUNIX -DUSE_BIT_OPS" \
	GAP=$(GAP) \
	EXT=$(EXT) \
	LDLIBS="-lm -L$(GNULIB) -lgmp" )

ibm-i386-386bsd-gcc2:
	@( cd $(SRC) ; $(MAKE) -f $(MAKEFILE) $(EFILE) CC=gcc \
	CFLAGS="$(COPTS) -O2 $(PQFLAGS) -DUNIX -DUSE_BIT_OPS" \
	GAP=$(GAP) \
	EXT=$(EXT) \
	LDLIBS="-lm" )

ibm-i386-386bsd-cc-gmp:
	@( cd $(SRC) ; $(MAKE) -f $(MAKEFILE) $(EFILE) CC=cc \
	CFLAGS="$(COPTS) -DLARGE_INT -DGNUINC -I$(GNUINC) -O $(PQFLAGS) \
                -DUNIX -DUSE_BIT_OPS" \
	GAP=$(GAP) \
	EXT=$(EXT) \
	LDLIBS="-lm -L$(GNULIB) -lgmp" )

ibm-i386-386bsd-cc:
	@( cd $(SRC) ; $(MAKE) -f $(MAKEFILE) $(EFILE) CC=cc \
	CFLAGS="$(COPTS) -O $(PQFLAGS) -DUNIX -DUSE_BIT_OPS" \
	GAP=$(GAP) \
	EXT=$(EXT) \
	LDLIBS="-lm" )

sun-sparc-sunos-gcc2-gmp:
	@( cd $(SRC) ; $(MAKE) -f $(MAKEFILE) $(EFILE) CC=gcc \
	CFLAGS="$(COPTS) -DLARGE_INT -DGNUINC -I$(GNUINC) -O2 $(PQFLAGS) \
                -DUNIX" \
	GAP=$(GAP) \
	EXT=$(EXT) \
	LDLIBS="-lm -L$(GNULIB) -lgmp" )

sun-sparc-sunos-gcc2:
	@( cd $(SRC) ; $(MAKE) -f $(MAKEFILE) $(EFILE) CC=gcc \
	CFLAGS="$(COPTS) -O2 $(PQFLAGS) -DUNIX" \
	GAP=$(GAP) \
	EXT=$(EXT) \
	LDLIBS="-lm" )

sun-sparc-sunos-cc-gmp:
	@( cd $(SRC) ; $(MAKE) -f $(MAKEFILE) $(EFILE) CC=cc \
	CFLAGS="$(COPTS) -DLARGE_INT -DGNUINC -I$(GNUINC) -O $(PQFLAGS) \
                -DUNIX" \
	GAP=$(GAP) \
	EXT=$(EXT) \
	LDLIBS="-lm -L$(GNULIB) -lgmp -lgnu" )

sun-sparc-sunos-cc:
	@( cd $(SRC) ; $(MAKE) -f $(MAKEFILE) $(EFILE) CC=cc \
	CFLAGS="$(COPTS) -O $(PQFLAGS) -DUNIX" \
	GAP=$(GAP) \
	EXT=$(EXT) \
	LDLIBS="-lm" )

mips-mips-bsd-cc-gmp:
	@( cd $(SRC) ; $(MAKE) -f $(MAKEFILE) $(EFILE) CC=cc \
	CFLAGS="$(COPTS) -DLARGE_INT -DGNUINC -I$(GNUINC) -DNEEDS_TYPES_H \
		-DHAS_NO_STRFTIME -systype bsd43 -O2 $(PQFLAGS) -DUNIX" \
	GAP=$(GAP) \
	EXT=$(EXT) \
	LDLIBS="-systype bsd43 -lm -L$(GNULIB) -lgmp" )

mips-mips-bsd-cc:
	@( cd $(SRC) ; $(MAKE) -f $(MAKEFILE) $(EFILE) CC=cc \
	CFLAGS="$(COPTS) -DNEEDS_TYPES_H -DHAS_NO_STRFTIME -systype bsd43 \
		-O2 $(PQFLAGS) -DUNIX" \
	GAP=$(GAP) \
	EXT=$(EXT) \
	LDLIBS="-systype bsd43 -lm" )

dec-mips-ultrix-gcc2-gmp:
	@( cd $(SRC) ; $(MAKE) -f $(MAKEFILE) $(EFILE) CC=gcc \
	CFLAGS="$(COPTS) -DLARGE_INT -DGNUINC -I$(GNUINC) -O2 $(PQFLAGS) \
                -DUNIX" \
	GAP=$(GAP) \
	EXT=$(EXT) \
	LDLIBS="-lm -L$(GNULIB) -lgmp" )

dec-mips-ultrix-gcc2:
	@( cd $(SRC) ; $(MAKE) -f $(MAKEFILE) $(EFILE) CC=gcc \
	CFLAGS="$(COPTS) -O2 $(PQFLAGS) -DUNIX" \
	GAP=$(GAP) \
	EXT=$(EXT) \
	LDLIBS="-lm" )

dec-mips-ultrix-cc-gmp:
	@( cd $(SRC) ; $(MAKE) -f $(MAKEFILE) $(EFILE) CC=cc \
	CFLAGS="$(COPTS) -DLARGE_INT -DGNUINC -I$(GNUINC) -O $(PQFLAGS) \
                -DUNIX -DUSE_BIT_OPS" \
	GAP=$(GAP) \
	EXT=$(EXT) \
	LDLIBS="-lm -L$(GNULIB) -lgmp" )

dec-mips-ultrix-cc:
	@( cd $(SRC) ; $(MAKE) -f $(MAKEFILE) $(EFILE) CC=cc \
	CFLAGS="$(COPTS) -O $(PQFLAGS) -DUNIX -DUSE_BIT_OPS" \
	GAP=$(GAP) \
	EXT=$(EXT) \
	LDLIBS="-lm" )

hp-hppa1.1-hpux-cc-gmp:
	@( cd $(SRC) ; $(MAKE) -f $(MAKEFILE) $(EFILE) CC=cc \
	CFLAGS="$(COPTS) -DLARGE_INT -DGNUINC -I$(GNUINC) -O $(PQFLAGS) \
                -DUNIX -DNO_GETRUSAGE" \
	GAP=$(GAP) \
	EXT=$(EXT) \
	LDLIBS="-lm -L$(GNULIB) -lgmp" )

hp-hppa1.1-hpux-cc:
	@( cd $(SRC) ; $(MAKE) -f $(MAKEFILE) $(EFILE) CC=cc \
	CFLAGS="$(COPTS) -O $(PQFLAGS) -DUNIX -DNO_GETRUSAGE" \
	GAP=$(GAP) \
	EXT=$(EXT) \
	LDLIBS="-lm" )

hp-hppa1.1-hpux-gcc:
	@( cd $(SRC) ; $(MAKE) -f $(MAKEFILE) $(EFILE) CC=gcc \
	CFLAGS="$(COPTS) -O $(PQFLAGS) -DUNIX -DNO_GETRUSAGE" \
	GAP=$(GAP) \
	EXT=$(EXT) \
	LDLIBS="-lm" )

hp-hppa1.0-hpux-cc-gmp:
	@( cd $(SRC) ; $(MAKE) -f $(MAKEFILE) $(EFILE) CC=cc \
	CFLAGS="$(COPTS) -DLARGE_INT -DGNUINC -I$(GNUINC) $(PQFLAGS) \
		-DNO_GETRUSAGE -DUNIX" \
	GAP=$(GAP) \
	EXT=$(EXT) \
	LDLIBS="-lm -L$(GNULIB) -lgmp" )

hp-hppa1.0-hpux-cc:
	@( cd $(SRC) ; $(MAKE) -f $(MAKEFILE) $(EFILE) CC=cc \
	CFLAGS="$(COPTS) $(PQFLAGS) -DUNIX -DNO_GETRUSAGE" \
	GAP=$(GAP) \
	EXT=$(EXT) \
	LDLIBS="-lm" )

hp-hppa1.0-hpux-gcc:
	@( cd $(SRC) ; $(MAKE) -f $(MAKEFILE) $(EFILE) CC=gcc \
	CFLAGS="$(COPTS) $(PQFLAGS) -DUNIX -DNO_GETRUSAGE" \
	GAP=$(GAP) \
	EXT=$(EXT) \
	LDLIBS="-lm" )

next-m68k-mach-gcc2-gmp:
	@( cd $(SRC) ; $(MAKE) -f $(MAKEFILE) $(EFILE) CC=gcc \
        CFLAGS="$(COPTS) -DLARGE_INT -DGNUINC -I$(GNUINC) -O2 $(PQFLAGS) \
                -DUNIX -DNEXT -DHAS_NO_TEMPNAM" \
	GAP=$(GAP) \
	EXT=$(EXT) \
	LDLIBS="-lgmp" )

next-m68k-mach-gcc2:
	@( cd $(SRC) ; $(MAKE) -f $(MAKEFILE) $(EFILE) CC=gcc \
        CFLAGS="$(COPTS)-O2 $(PQFLAGS) -DUNIX -DNEXT -DHAS_NO_TEMPNAM" \
	GAP=$(GAP) \
	EXT=$(EXT) \
	LDLIBS="" )

next-m68k-mach-cc-gmp:
	@( cd $(SRC) ; $(MAKE) -f $(MAKEFILE) $(EFILE) CC=cc \
        CFLAGS="$(COPTS) -DLARGE_INT -DGNUINC -I$(GNUINC) -O2 $(PQFLAGS) \
                -DUNIX -DNEXT -DHAS_NO_TEMPNAM" \
	GAP=$(GAP) \
	EXT=$(EXT) \
	LDLIBS="-lgmp" )

next-m68k-mach-cc:
	@( cd $(SRC) ; $(MAKE) -f $(MAKEFILE) $(EFILE) CC=cc \
        CFLAGS="$(COPTS) -O2 $(PQFLAGS) -DUNIX -DNEXT -DHAS_NO_TEMPNAM" \
	GAP=$(GAP) \
	EXT=$(EXT) \
	LDLIBS="" )

## special rules,  we need to set ANUPQ_GAP_EXEC ############################
GAP.o: GAP.c
	$(CC) $(CFLAGS) -DANUPQ_GAP_EXEC='"$(GAP)"' -c GAP.c

GAP_link_via_file.o: GAP_link_via_file.c
	$(CC) $(CFLAGS) -DANUPQ_GAP_EXEC='"$(GAP)"' -c GAP_link_via_file.c

## NEVER DELETE/ALTER THESE LINES BELOW - see "objectlist" and "depend" #####

#@OBJ@#
OBJECTS=\
	AllocateSpace.o                	CAYLEY.o                      \
	CAYLEY_present.o               	CloseFile.o                   \
	Extend_Auts.o                  	FreeSpace.o                   \
	GAP.o                          	GAP_link_via_file.o           \
	GAP_present.o                  	Magma.o                       \
	Magma_present.o                	OpenFile.o                    \
	TemporaryFile.o                	action.o                      \
	assemble_matrix.o              	autgp_order.o                 \
	bit_print.o                    	calculate_jacobi.o            \
	central_auts.o                 	check_exponent.o              \
	class1_eliminate.o             	close_relations.o             \
	close_subgroup.o               	collect.o                     \
	collect_comm.o                 	collect_gen_word.o            \
	collect_relations.o            	collect_word.o                \
	collectp2.o                    	combined.o                    \
	commutator.o                   	commute_dgen.o                \
	compact.o                      	compact_description.o         \
	consistency.o                  	consistency_info.o            \
	construct.o                    	convert.o                     \
	defaults_pga.o                 	degree.o                      \
	delete_tables.o                	down_class.o                  \
	echelon.o                      	echelonise_matrix.o           \
	eliminate.o                    	expand_commutator.o           \
	exponent_auts.o                	exponent_info.o               \
	extend_automorphisms.o         	extend_matrix.o               \
	extend_representation.o        	extra_relations.o             \
	find_allowable_subgroup.o      	find_image.o                  \
	find_permutation.o             	formula.o                     \
	generator_definition.o         	get_definition_sets.o         \
	identity.o                     	immediate_descendant.o        \
	initialise_pcp.o               	initialise_pga.o              \
	insoluble_orbits.o             	int_power.o                   \
	interactive_pga.o              	interactive_pq.o              \
	invert.o                       	invert_auts.o                 \
	invert_modp.o                  	is_genlim_exceeded.o          \
	is_space_exhausted.o           	isom_options.o                \
	iteration.o                    	jacobi.o                      \
	label_to_subgroup.o            	last_class.o                  \
	list_commutators.o             	main.o                        \
	map_relations.o                	matrix.o                      \
	maxoccur.o                     	meataxe.o                     \
	multiply_word.o                	next_class.o                  \
	options.o                      	orbit_summary.o               \
	permute_elements.o             	permute_subgroups.o           \
	pgroup.o                       	\
	power.o                        	pquotient.o                   \
	pretty_filter.o                	pretty_filterfns.o            \
	print_arrays.o                 	print_auts.o                  \
	print_level.o                  	print_presentation.o          \
	print_structure.o              	print_word.o                  \
	quotpic.o                      	read.o                        \
	read_auts.o                    	read_parameters.o             \
	read_relations.o               	read_relator_file.o           \
	read_value.o                   	read_word.o                   \
	reduce_matrix.o                	reduced_covers.o              \
	report_error.o                 	restore_group.o               \
	setup.o                        	setup_reps.o                  \
	soluble_orbits.o               	solve_equation.o              \
	stabiliser.o                   	stages.o                      \
	standard.o                     	start_group.o                 \
	start_iteration.o              	step_range.o                  \
	store_definition_sets.o        	strip_identities.o            \
	subgroup_to_label.o            	system.o                      \
	tail_info.o                     tails.o                       \
	tails_filter.o                  text.o                        \
	update.o                       	update_generators.o           \
	update_name.o                  	vsystem.o                     \
	write.o                       

#@ENDOBJ@#

## clean me up ##############################################################
clean:
	(cd $(SRC) ; rm -f $(OBJECTS) core* $(EFILE) ../bin/$(EFILE)$(EXT))

## link together the executable #############################################
$(EFILE):  $(OBJECTS)
	$(CC) -o $(EFILE) $(OBJECTS) $(LOPTS) $(LDLIBS)
	@ GAParch=`sed "s/GAParch=//" ../../../sysinfo.gap`; mkdir -p ../bin/$$GAParch; \
	     echo ""; echo "moving pq to ../bin/$$GAParch"; echo ""; \
	     mv $(EFILE) ../bin/$$GAParch/$(EFILE);

## create object list for the Makefile ######################################
objectlist:
	@( cd $(SRC) ; ls -1 *.c ) | \
	sed s/\\.c$$/\\.o/ | \
	( echo "OBJECTS=\\"; \
	  awk '{printf( "\t%-30s%s", $$0, (i++ % 2)?"\\\n":" ")}'; \
	  echo ""; echo "" ) > /tmp/object.tmp
	@gap/replace OBJ gap/Makefile /tmp/object.tmp > /tmp/Makefile
	@mv gap/Makefile gap/Makefile.bak
	@mv /tmp/Makefile gap
	@rm /tmp/object.tmp
	@echo "check 'gap/Makefile',  backup is in 'gap/Makefile.bak'"

## create dependency list for the Makefile ##################################
depend:
	@(cd $(SRC) ; gcc -MM -I$(GNUINC) $(PQFLAGS) -DNO_GETRUSAGE -DUNIX *.c \
	    > /tmp/depend.tmp )
	@gap/replace DEP gap/Makefile /tmp/depend.tmp > /tmp/Makefile
	@mv gap/Makefile gap/Makefile.bak
	@mv /tmp/Makefile gap
	@rm /tmp/depend.tmp
	@echo "check 'gap/Makefile',  backup is in 'gap/Makefile.bak'"


## create distribution package ##############################################
src_dist:
	@(cmp ${PKG_PATH}/anupq/gap/anupq.tex ${GAP_PATH}/doc/anupq.tex \
	 || echo \
	 "*** WARNING: current 'anupq.tex' and 'doc/anupq.tex' differ ***")
	@zoo ah ${SRCDISTFILE}.zoo \
		${PKG_PATH}/anupq/README \
		`find ${PKG_PATH}/anupq/TEST -print` \
		`find ${PKG_PATH}/anupq/MakeLibrary -print ` \
		${PKG_PATH}/anupq/bin/pq \
		${PKG_PATH}/anupq/bin/pq.sh \
		`find ${PKG_PATH}/anupq/cayley -print` \
		`find ${PKG_PATH}/anupq/doc -print` \
		`find ${PKG_PATH}/anupq/examples -print` \
		`find ${PKG_PATH}/anupq/gap -print` \
		`find ${PKG_PATH}/anupq/include -print` \
		`find ${PKG_PATH}/anupq/isom -print`\
		`find ${PKG_PATH}/anupq/magma -print`\
		`find ${PKG_PATH}/anupq/init.g -print` \
		${PKG_PATH}/anupq/src/Makefile \
		`find ${PKG_PATH}/anupq/src -name "*.c" -print` \
		${PKG_PATH}/anupq/Makefile
	@zoo PE ${SRCDISTFILE}.zoo

bin_dist:
	@( test \! -r ${PKG_PATH}/anupq/bin.orig || ( echo \
	 "*** WARNING: 'anupq/bin.orig' exists ***";  exit 1 ) )
	( cd ${PKG_PATH}/anupq ; mv bin bin.orig ; mkdir bin ; \
	  cp bin.orig/pq.sh bin/pq.sh ; cp bin.orig/pq-${EXT} bin/pq )
	@zoo ah ${SRCDISTFILE}-${EXT}.zoo \
		${PKG_PATH}/anupq/bin/pq \
		${PKG_PATH}/anupq/bin/pq.sh 
	@zoo PE ${SRCDISTFILE}-${EXT}.zoo
	( cd ${PKG_PATH}/anupq ; rm -rf bin.old ; mv bin bin.old ; \
	  mv bin.orig bin )

#@DEP@#
AllocateSpace.o : AllocateSpace.c ../include/pq_defs.h ../include/pcp_vars.h \
  ../include/constants.h 
CAYLEY.o : CAYLEY.c ../include/pq_defs.h ../include/pga_vars.h ../include/pcp_vars.h \
  ../include/pq_functions.h ../include/constants.h 
CAYLEY_present.o : CAYLEY_present.c ../include/pq_defs.h ../include/pcp_vars.h \
  ../include/define_y.h 
CloseFile.o : CloseFile.c ../include/pq_defs.h ../include/constants.h 
Extend_Auts.o : Extend_Auts.c ../include/pq_defs.h ../include/pcp_vars.h ../include/pq_functions.h \
  ../include/define_y.h 
FreeSpace.o : FreeSpace.c ../include/pq_defs.h ../include/pga_vars.h ../include/pcp_vars.h 
GAP.o : GAP.c ../include/pq_defs.h ../include/pga_vars.h ../include/pcp_vars.h \
  ../include/pq_functions.h ../include/constants.h 
GAP_link_via_file.o : GAP_link_via_file.c 
GAP_present.o : GAP_present.c ../include/pq_defs.h ../include/pcp_vars.h ../include/pga_vars.h \
  ../include/constants.h ../include/pq_functions.h ../include/menus.h ../include/define_y.h 
Magma.o : Magma.c 
Magma_present.o : Magma_present.c ../include/pq_defs.h ../include/pcp_vars.h \
  ../include/define_y.h 
OpenFile.o : OpenFile.c ../include/pq_defs.h ../include/constants.h 
TemporaryFile.o : TemporaryFile.c ../include/pq_defs.h ../include/pq_functions.h \
  ../include/constants.h 
action.o : action.c ../include/pq_defs.h ../include/constants.h ../include/pcp_vars.h \
  ../include/pq_functions.h ../include/standard.h ../include/word_types.h ../include/define_y.h 
assemble_matrix.o : assemble_matrix.c ../include/pq_defs.h ../include/pcp_vars.h \
  ../include/define_y.h 
autgp_order.o : autgp_order.c 
bit_print.o : bit_print.c 
calculate_jacobi.o : calculate_jacobi.c ../include/pq_defs.h ../include/pcp_vars.h \
  ../include/constants.h ../include/define_y.h 
central_auts.o : central_auts.c ../include/pq_defs.h ../include/pcp_vars.h ../include/pga_vars.h \
  ../include/pq_functions.h ../include/define_y.h 
check_exponent.o : check_exponent.c ../include/pq_defs.h ../include/pcp_vars.h \
  ../include/constants.h ../include/pq_functions.h ../include/exp_vars.h 
class1_eliminate.o : class1_eliminate.c ../include/pq_defs.h ../include/pcp_vars.h \
  ../include/pq_functions.h ../include/define_y.h 
close_relations.o : close_relations.c ../include/pq_defs.h ../include/pcp_vars.h \
  ../include/pga_vars.h ../include/pq_functions.h ../include/define_y.h 
close_subgroup.o : close_subgroup.c ../include/pq_defs.h ../include/pcp_vars.h \
  ../include/pga_vars.h ../include/define_y.h 
collect.o : collect.c ../include/pq_defs.h ../include/pcp_vars.h ../include/constants.h \
  ../include/define_y.h 
collect_comm.o : collect_comm.c ../include/pq_defs.h ../include/pcp_vars.h ../include/constants.h \
  ../include/pq_functions.h ../include/pretty_filterfns.h ../include/word_types.h \
  ../include/define_y.h 
collect_gen_word.o : collect_gen_word.c ../include/pq_defs.h ../include/pcp_vars.h \
  ../include/define_y.h 
collect_relations.o : collect_relations.c ../include/pq_defs.h ../include/pcp_vars.h \
  ../include/pq_functions.h ../include/define_y.h 
collect_word.o : collect_word.c ../include/pq_defs.h ../include/pcp_vars.h ../include/pq_functions.h \
  ../include/constants.h ../include/word_types.h ../include/define_y.h 
collectp2.o : collectp2.c ../include/pq_defs.h ../include/pcp_vars.h ../include/constants.h \
  ../include/define_y.h 
combined.o : combined.c ../include/pq_defs.h ../include/pcp_vars.h ../include/pga_vars.h \
  ../include/constants.h ../include/pq_functions.h ../include/define_y.h 
commutator.o : commutator.c ../include/pq_defs.h ../include/pcp_vars.h ../include/pretty_filterfns.h \
  ../include/word_types.h ../include/constants.h ../include/define_y.h 
commute_dgen.o : commute_dgen.c ../include/pq_defs.h ../include/pcp_vars.h ../include/constants.h \
  ../include/pq_functions.h ../include/pretty_filterfns.h ../include/word_types.h \
  ../include/define_y.h 
compact.o : compact.c ../include/pq_defs.h ../include/pcp_vars.h ../include/define_y.h 
compact_description.o : compact_description.c ../include/pq_defs.h ../include/pcp_vars.h \
  ../include/pq_functions.h ../include/constants.h ../include/define_y.h 
consistency.o : consistency.c ../include/pq_defs.h ../include/pcp_vars.h ../include/define_y.h 
consistency_info.o : consistency_info.c ../include/pq_defs.h ../include/constants.h \
  ../include/pcp_vars.h ../include/exp_vars.h ../include/pq_functions.h 
construct.o : construct.c ../include/pq_defs.h ../include/pcp_vars.h ../include/pga_vars.h \
  ../include/exp_vars.h ../include/constants.h ../include/pq_functions.h ../include/define_y.h 
convert.o : convert.c ../include/pq_defs.h ../include/pcp_vars.h ../include/define_y.h 
defaults_pga.o : defaults_pga.c ../include/pq_defs.h ../include/pcp_vars.h ../include/pga_vars.h \
  ../include/constants.h ../include/pq_functions.h ../include/define_y.h 
degree.o : degree.c ../include/pq_defs.h ../include/pga_vars.h ../include/pq_functions.h \
  ../include/constants.h 
delete_tables.o : delete_tables.c ../include/pq_defs.h ../include/pcp_vars.h \
  ../include/define_y.h 
down_class.o : down_class.c ../include/pq_defs.h ../include/pcp_vars.h ../include/define_y.h 
echelon.o : echelon.c ../include/pq_defs.h ../include/pcp_vars.h ../include/pq_functions.h \
  ../include/define_y.h 
echelonise_matrix.o : echelonise_matrix.c ../include/pq_defs.h ../include/pga_vars.h 
eliminate.o : eliminate.c ../include/pq_defs.h ../include/pcp_vars.h ../include/pq_functions.h \
  ../include/define_y.h 
expand_commutator.o : expand_commutator.c ../include/constants.h 
exponent_auts.o : exponent_auts.c ../include/pq_defs.h ../include/pcp_vars.h \
  ../include/pq_functions.h 
exponent_info.o : exponent_info.c ../include/pq_defs.h ../include/constants.h \
  ../include/pcp_vars.h ../include/exp_vars.h ../include/pq_functions.h 
extend_automorphisms.o : extend_automorphisms.c ../include/pq_defs.h ../include/pcp_vars.h \
  ../include/pq_functions.h ../include/define_y.h 
extend_matrix.o : extend_matrix.c ../include/pq_defs.h ../include/pcp_vars.h \
  ../include/constants.h ../include/pq_functions.h ../include/define_y.h 
extend_representation.o : extend_representation.c ../include/pq_defs.h ../include/pcp_vars.h \
  ../include/constants.h ../include/pq_functions.h ../include/define_y.h 
extra_relations.o : extra_relations.c ../include/pq_defs.h ../include/pcp_vars.h \
  ../include/constants.h ../include/pq_functions.h ../include/exp_vars.h ../include/define_y.h 
find_allowable_subgroup.o : find_allowable_subgroup.c ../include/pq_defs.h ../include/pcp_vars.h \
  ../include/pga_vars.h ../include/constants.h ../include/pq_functions.h ../include/standard.h \
  ../include/define_y.h 
find_image.o : find_image.c ../include/pq_defs.h ../include/pcp_vars.h ../include/pga_vars.h \
  ../include/pq_functions.h 
find_permutation.o : find_permutation.c ../include/pq_defs.h ../include/pga_vars.h \
  ../include/pq_functions.h 
formula.o : formula.c ../include/pq_defs.h ../include/constants.h ../include/pcp_vars.h \
  ../include/pq_functions.h ../include/define_y.h 
generator_definition.o : generator_definition.c ../include/pq_defs.h ../include/pcp_vars.h \
  ../include/pq_functions.h ../include/define_y.h 
get_definition_sets.o : get_definition_sets.c ../include/pq_defs.h ../include/pga_vars.h \
  ../include/pq_functions.h 
identity.o : identity.c ../include/pq_defs.h ../include/pga_vars.h 
immediate_descendant.o : immediate_descendant.c ../include/pq_defs.h ../include/pcp_vars.h \
  ../include/pga_vars.h ../include/exp_vars.h ../include/constants.h ../include/pq_functions.h \
  ../include/define_y.h 
initialise_pcp.o : initialise_pcp.c ../include/pq_defs.h ../include/pcp_vars.h \
  ../include/constants.h 
initialise_pga.o : initialise_pga.c ../include/pq_defs.h ../include/pcp_vars.h \
  ../include/pga_vars.h ../include/define_y.h 
insoluble_orbits.o : insoluble_orbits.c ../include/pq_defs.h ../include/pcp_vars.h \
  ../include/pga_vars.h ../include/pq_functions.h ../include/standard.h 
int_power.o : int_power.c 
interactive_pga.o : interactive_pga.c ../include/pq_defs.h ../include/pcp_vars.h \
  ../include/pga_vars.h ../include/constants.h ../include/menus.h ../include/standard.h \
  ../include/pq_functions.h ../include/global.h 
interactive_pq.o : interactive_pq.c ../include/pq_defs.h ../include/pcp_vars.h \
  ../include/pga_vars.h ../include/exp_vars.h ../include/constants.h ../include/menus.h \
  ../include/pq_functions.h ../include/pretty_filterfns.h ../include/word_types.h \
  ../include/global.h ../include/define_y.h 
invert.o : invert.c ../include/pq_defs.h ../include/pcp_vars.h ../include/constants.h \
  ../include/word_types.h ../include/define_y.h 
invert_auts.o : invert_auts.c ../include/pq_defs.h ../include/pcp_vars.h ../include/pga_vars.h \
  ../include/pq_functions.h ../include/define_y.h 
invert_modp.o : invert_modp.c 
is_genlim_exceeded.o : is_genlim_exceeded.c ../include/pq_defs.h ../include/pcp_vars.h \
  ../include/define_y.h 
is_space_exhausted.o : is_space_exhausted.c ../include/pq_defs.h ../include/pcp_vars.h \
  ../include/define_y.h 
isom_options.o : isom_options.c ../include/constants.h ../include/pq_defs.h \
  ../include/pretty_filterfns.h ../include/standard.h ../include/menus.h ../include/pcp_vars.h \
  ../include/pga_vars.h ../include/pq_functions.h ../include/word_types.h ../include/define_y.h 
iteration.o : iteration.c ../include/pq_defs.h ../include/pcp_vars.h ../include/pga_vars.h \
  ../include/constants.h ../include/pq_functions.h 
jacobi.o : jacobi.c ../include/pq_defs.h ../include/pcp_vars.h ../include/pq_functions.h \
  ../include/define_y.h 
label_to_subgroup.o : label_to_subgroup.c ../include/pq_defs.h ../include/pga_vars.h \
  ../include/pcp_vars.h ../include/pq_functions.h ../include/define_y.h 
last_class.o : last_class.c ../include/pq_defs.h ../include/pcp_vars.h ../include/define_y.h 
list_commutators.o : list_commutators.c ../include/pq_defs.h ../include/constants.h \
  ../include/pcp_vars.h ../include/pq_functions.h ../include/define_y.h 
main.o : main.c ../include/pq_defs.h ../include/pcp_vars.h ../include/pq_functions.h \
  ../include/constants.h ../include/pq_author.h ../include/menus.h ../include/global.h \
  ../include/standard.h ../include/define_y.h 
map_relations.o : map_relations.c ../include/pq_defs.h ../include/pcp_vars.h \
  ../include/pga_vars.h ../include/menus.h ../include/constants.h ../include/pq_functions.h \
  ../include/define_y.h 
matrix.o : matrix.c ../include/pq_defs.h ../include/pq_functions.h 
maxoccur.o : maxoccur.c ../include/pq_defs.h ../include/pcp_vars.h ../include/constants.h \
  ../include/define_y.h 
meataxe.o : meataxe.c ../include/pq_defs.h ../include/constants.h ../include/pcp_vars.h \
  ../include/pq_functions.h ../include/define_y.h 
multiply_word.o : multiply_word.c ../include/pq_defs.h ../include/pcp_vars.h \
  ../include/define_y.h 
next_class.o : next_class.c ../include/pq_defs.h ../include/constants.h ../include/pcp_vars.h \
  ../include/pq_functions.h ../include/exp_vars.h ../include/define_y.h 
options.o : options.c ../include/pq_defs.h ../include/pcp_vars.h ../include/pga_vars.h \
  ../include/constants.h ../include/menus.h ../include/pq_functions.h 
orbit_summary.o : orbit_summary.c ../include/pq_defs.h ../include/pga_vars.h 
permute_elements.o : permute_elements.c ../include/pq_defs.h ../include/pga_vars.h \
  ../include/pq_functions.h 
permute_subgroups.o : permute_subgroups.c ../include/pq_defs.h ../include/pcp_vars.h \
  ../include/pga_vars.h ../include/pq_functions.h ../include/constants.h 
pgroup.o : pgroup.c ../include/pq_defs.h ../include/pcp_vars.h ../include/pga_vars.h \
  ../include/constants.h ../include/menus.h ../include/pq_functions.h ../include/standard.h \
  ../include/define_y.h 
power.o : power.c ../include/pq_defs.h ../include/pcp_vars.h ../include/define_y.h 
pquotient.o : pquotient.c ../include/pq_defs.h ../include/pcp_vars.h ../include/constants.h 
pretty_filter.o : pretty_filter.c ../include/pq_defs.h ../include/pq_functions.h \
  ../include/constants.h ../include/pcp_vars.h ../include/pretty_filterfns.h ../include/define_y.h 
pretty_filterfns.o : pretty_filterfns.c ../include/pq_defs.h ../include/pretty_filterfns.h \
  ../include/constants.h 
print_arrays.o : print_arrays.c 
print_auts.o : print_auts.c ../include/pq_defs.h ../include/pcp_vars.h ../include/pga_vars.h 
print_level.o : print_level.c ../include/pq_defs.h ../include/pcp_vars.h ../include/constants.h 
print_presentation.o : print_presentation.c ../include/pq_defs.h ../include/pcp_vars.h \
  ../include/define_y.h 
print_structure.o : print_structure.c ../include/pq_defs.h ../include/pcp_vars.h \
  ../include/constants.h ../include/define_y.h 
print_word.o : print_word.c ../include/pq_defs.h ../include/pcp_vars.h ../include/define_y.h 
quotpic.o : quotpic.c 
read.o : read.c ../include/pq_defs.h ../include/pcp_vars.h ../include/pga_vars.h \
  ../include/pq_functions.h ../include/constants.h ../include/define_y.h 
read_auts.o : read_auts.c ../include/pq_defs.h ../include/constants.h ../include/pcp_vars.h \
  ../include/pq_functions.h ../include/standard.h ../include/define_y.h 
read_parameters.o : read_parameters.c ../include/pq_defs.h ../include/pcp_vars.h \
  ../include/constants.h ../include/pq_functions.h 
read_relations.o : read_relations.c ../include/pq_defs.h ../include/pcp_vars.h \
  ../include/define_y.h 
read_relator_file.o : read_relator_file.c ../include/pq_defs.h ../include/constants.h \
  ../include/pcp_vars.h ../include/pq_functions.h ../include/word_types.h ../include/define_y.h 
read_value.o : read_value.c ../include/pq_defs.h ../include/constants.h ../include/pcp_vars.h 
read_word.o : read_word.c ../include/pq_defs.h ../include/pcp_vars.h ../include/constants.h \
  ../include/pq_functions.h ../include/pretty_filterfns.h ../include/word_types.h \
  ../include/define_y.h 
reduce_matrix.o : reduce_matrix.c ../include/pq_defs.h ../include/pga_vars.h 
reduced_covers.o : reduced_covers.c ../include/pq_defs.h ../include/pcp_vars.h \
  ../include/pga_vars.h ../include/constants.h ../include/pq_functions.h 
report_error.o : report_error.c ../include/constants.h 
restore_group.o : restore_group.c ../include/pq_defs.h ../include/pcp_vars.h \
  ../include/pga_vars.h ../include/constants.h ../include/pq_functions.h 
setup.o : setup.c ../include/pq_defs.h ../include/pcp_vars.h ../include/constants.h \
  ../include/pq_functions.h ../include/setup.h ../include/define_y.h 
setup_reps.o : setup_reps.c ../include/pq_defs.h ../include/pcp_vars.h ../include/pga_vars.h \
  ../include/constants.h ../include/pq_functions.h ../include/global.h ../include/standard.h 
soluble_orbits.o : soluble_orbits.c ../include/pq_defs.h ../include/pcp_vars.h \
  ../include/pga_vars.h ../include/constants.h ../include/pq_functions.h 
solve_equation.o : solve_equation.c ../include/pq_defs.h ../include/pcp_vars.h \
  ../include/word_types.h ../include/define_y.h 
stabiliser.o : stabiliser.c ../include/pq_defs.h ../include/pcp_vars.h ../include/pga_vars.h \
  ../include/pq_functions.h ../include/constants.h ../include/define_y.h 
stages.o : stages.c ../include/pq_defs.h ../include/pcp_vars.h ../include/pga_vars.h \
  ../include/constants.h ../include/pq_functions.h 
standard.o : standard.c ../include/pq_defs.h ../include/constants.h ../include/pcp_vars.h \
  ../include/pga_vars.h ../include/exp_vars.h ../include/pq_functions.h ../include/menus.h \
  ../include/standard.h ../include/define_y.h 
start_group.o : start_group.c ../include/pq_defs.h ../include/pcp_vars.h ../include/pga_vars.h \
  ../include/constants.h ../include/define_y.h 
start_iteration.o : start_iteration.c ../include/pq_defs.h ../include/pcp_vars.h \
  ../include/pga_vars.h ../include/constants.h ../include/pq_functions.h 
step_range.o : step_range.c ../include/pq_defs.h ../include/pcp_vars.h ../include/pga_vars.h 
store_definition_sets.o : store_definition_sets.c ../include/pq_defs.h ../include/pga_vars.h \
  ../include/pq_functions.h 
strip_identities.o : strip_identities.c ../include/pq_defs.h ../include/pcp_vars.h \
  ../include/pga_vars.h ../include/pq_functions.h 
subgroup_to_label.o : subgroup_to_label.c ../include/pq_defs.h ../include/pga_vars.h 
system.o : system.c ../include/pq_defs.h 
tail_info.o : tail_info.c ../include/pq_defs.h ../include/constants.h 
tails.o : tails.c ../include/pq_defs.h ../include/pcp_vars.h ../include/pq_functions.h \
  ../include/define_y.h 
tails_filter.o : tails_filter.c ../include/pq_defs.h ../include/pcp_vars.h ../include/pq_functions.h \
  ../include/define_y.h 
text.o : text.c ../include/pq_defs.h 
update.o : update.c ../include/pq_defs.h ../include/pcp_vars.h ../include/pq_functions.h \
  ../include/define_y.h 
update_generators.o : update_generators.c ../include/pq_defs.h ../include/pcp_vars.h \
  ../include/pq_functions.h ../include/define_y.h 
update_name.o : update_name.c ../include/pq_defs.h ../include/pcp_vars.h 
vsystem.o : vsystem.c 
write.o : write.c ../include/pq_defs.h ../include/pcp_vars.h ../include/pga_vars.h \
  ../include/constants.h ../include/define_y.h 
#@ENDDEP@#
