#############################################################################
####
##
#W  anupqi.gd           ANUPQ Share Package                       Greg Gamble
##
##  This file declares interactive functions that execute individual pq  menu
##  options.
##
#H  @(#)$Id$
##
#Y  Copyright (C) 2001  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
##
Revision.anupqi_gd :=
    "@(#)$Id$";

#############################################################################
##
#F  PQ_AUT_INPUT( <datarec>, <G> : <options> ) . . . . . . automorphism input
##
DeclareGlobalFunction( "PQ_AUT_INPUT" );

#############################################################################
##
#F  PQ_PC_PRESENTATION( <datarec>, <menu> ) . . . . . .  p-Q/SP menu option 1
##
DeclareGlobalFunction( "PQ_PC_PRESENTATION" );

#############################################################################
##
#F  PqPcPresentation( <i> : <options> ) . . user version of p-Q menu option 1
#F  PqPcPresentation( : <options> )
##
DeclareGlobalFunction( "PqPcPresentation" );

#############################################################################
##
#F PQ_SAVE_PC_PRESENTATION( <datarec> ) . . . . . . . . . . p-Q menu option 2
##
DeclareGlobalFunction( "PQ_SAVE_PC_PRESENTATION" );

#############################################################################
##
#F PqSavePcPresentation( <i> ) . . . . . .  user version of p-Q menu option 2
#F PqSavePcPresentation()
##
DeclareGlobalFunction( "PqSavePcPresentation" );

#############################################################################
##
#F PQ_RESTORE_PC_PRESENTATION( <datarec> ) . . . . . . . .  p-Q menu option 3
##
DeclareGlobalFunction( "PQ_RESTORE_PC_PRESENTATION" );

#############################################################################
##
#F PqRestorePcPresentation( <i> ) . . . . . user version of p-Q menu option 3
#F PqRestorePcPresentation()
##
DeclareGlobalFunction( "PqRestorePcPresentation" );

#############################################################################
##
#F PQ_DISPLAY_PC_PRESENTATION( <datarec> ) . . . . . . . .  p-Q menu option 4
##
DeclareGlobalFunction( "PQ_DISPLAY_PC_PRESENTATION" );

#############################################################################
##
#F PqDisplayPcPresentation( <i> ) . . . . . user version of p-Q menu option 4
#F PqDisplayPcPresentation()
##
DeclareGlobalFunction( "PqDisplayPcPresentation" );

#############################################################################
##
#F PQ_SET_PRINT_LEVEL( <datarec>, <menu> ) . . . . p-Q/SP/I p-Q menu option 5
##
DeclareGlobalFunction( "PQ_SET_PRINT_LEVEL" );

#############################################################################
##
#F PqSetPrintLevel( <i> ) . . . . . . . . . user version of p-Q menu option 5
#F PqSetPrintLevel()
##
DeclareGlobalFunction( "PqSetPrintLevel" );

#############################################################################
##
#F  PQ_P_COVER( <datarec> ) . . . . . . . . . . . . . . . . p-Q menu option 7
##
DeclareGlobalFunction( "PQ_P_COVER" );

#############################################################################
##
#F  PqPCover( <i> ) . . . . . . . . . . . . user version of p-Q menu option 7
#F  PqPCover()
##
DeclareGlobalFunction( "PqPCover" );

#############################################################################
##
#F  PQ_COLLECT( <datarec>, <word> ) . . . . . . . . . . . I p-Q menu option 1
##
DeclareGlobalFunction( "PQ_COLLECT" );

#############################################################################
##
#F PQ_SOLVE_EQUATION( <datarec> ) . . . . . . . . . . . . I p-Q menu option 2
##
DeclareGlobalFunction( "PQ_SOLVE_EQUATION" );

#############################################################################
##
#F PqSolveEquation( <i> ) . . . . . . . . user version of I p-Q menu option 2
#F PqSolveEquation()
##
DeclareGlobalFunction( "PqSolveEquation" );

#############################################################################
##
#F PQ_COMMUTATOR( <datarec> ) . . . . . . . . . . . . . . I p-Q menu option 3
##
DeclareGlobalFunction( "PQ_COMMUTATOR" );

#############################################################################
##
#F PqCommutator( <i> ) . . . . . . . . .  user version of I p-Q menu option 3
#F PqCommutator()
##
DeclareGlobalFunction( "PqCommutator" );

#############################################################################
##
#F PQ_DISPLAY_PRESENTATION( <datarec> ) . . . . . . . . . I p-Q menu option 4
##
DeclareGlobalFunction( "PQ_DISPLAY_PRESENTATION" );

#############################################################################
##
#F PqDisplayPresentation( <i> ) . . . . . user version of I p-Q menu option 4
#F PqDisplayPresentation()
##
DeclareGlobalFunction( "PqDisplayPresentation" );

#############################################################################
##
#F PQ_SETUP_TABLES_FOR_NEXT_CLASS( <datarec> ) . . . . .  I p-Q menu option 6
##
DeclareGlobalFunction( "PQ_SETUP_TABLES_FOR_NEXT_CLASS" );

#############################################################################
##
#F PqSetupTablesForNextClass( <i> ) . . . user version of I p-Q menu option 6
#F PqSetupTablesForNextClass()
##
DeclareGlobalFunction( "PqSetupTablesForNextClass" );

#############################################################################
##
#F PQ_INSERT_TAILS( <datarec> ) . . . . . . . . . . . . . I p-Q menu option 7
##
DeclareGlobalFunction( "PQ_INSERT_TAILS" );

#############################################################################
##
#F PqInsertTails( <i> ) . . . . . . . . . user version of I p-Q menu option 7
#F PqInsertTails()
##
DeclareGlobalFunction( "PqInsertTails" );

#############################################################################
##
#F PQ_DO_CONSISTENCY_CHECKS( <datarec> ) . . . . . . . .  I p-Q menu option 8
##
DeclareGlobalFunction( "PQ_DO_CONSISTENCY_CHECKS" );

#############################################################################
##
#F PqDoConsistencyChecks( <i> ) . . . . . user version of I p-Q menu option 8
#F PqDoConsistencyChecks()
##
DeclareGlobalFunction( "PqDoConsistencyChecks" );

#############################################################################
##
#F PQ_COLLECT_DEFINING_RELATIONS( <datarec> ) . . . . . . I p-Q menu option 9
##
DeclareGlobalFunction( "PQ_COLLECT_DEFINING_RELATIONS" );

#############################################################################
##
#F PqCollectDefiningRelations( <i> ) . .  user version of I p-Q menu option 9
#F PqCollectDefiningRelations()
##
DeclareGlobalFunction( "PqCollectDefiningRelations" );

#############################################################################
##
#F PQ_DO_EXPONENT_CHECKS( <datarec> ) . . . . . . . . .  I p-Q menu option 10
##
DeclareGlobalFunction( "PQ_DO_EXPONENT_CHECKS" );

#############################################################################
##
#F PqDoExponentChecks( <i> ) . . . . . . user version of I p-Q menu option 10
#F PqDoExponentChecks()
##
DeclareGlobalFunction( "PqDoExponentChecks" );

#############################################################################
##
#F PQ_ELIMINATE_REDUNDANT_GENERATORS( <datarec> ) . . .  I p-Q menu option 11
##
DeclareGlobalFunction( "PQ_ELIMINATE_REDUNDANT_GENERATORS" );

#############################################################################
##
#F PqEliminateRedundantGenerators( <i> ) user version of I p-Q menu option 11
#F PqEliminateRedundantGenerators()
##
DeclareGlobalFunction( "PqEliminateRedundantGenerators" );

#############################################################################
##
#F PQ_REVERT_TO_PREVIOUS_CLASS( <datarec> ) . . . . . .  I p-Q menu option 12
##
DeclareGlobalFunction( "PQ_REVERT_TO_PREVIOUS_CLASS" );

#############################################################################
##
#F PqRevertToPreviousClass( <i> ) . . .  user version of I p-Q menu option 12
#F PqRevertToPreviousClass()
##
DeclareGlobalFunction( "PqRevertToPreviousClass" );

#############################################################################
##
#F PQ_SET_MAXIMAL_OCCURRENCES( <datarec> ) . . . . . . . I p-Q menu option 13
##
DeclareGlobalFunction( "PQ_SET_MAXIMAL_OCCURRENCES" );

#############################################################################
##
#F PqSetMaximalOccurrences( <i> ) . . .  user version of I p-Q menu option 13
#F PqSetMaximalOccurrences()
##
DeclareGlobalFunction( "PqSetMaximalOccurrences" );

#############################################################################
##
#F PQ_SET_METABELIAN( <datarec> ) . . . . . . . . . . .  I p-Q menu option 14
##
DeclareGlobalFunction( "PQ_SET_METABELIAN" );

#############################################################################
##
#F PqSetMetabelian( <i> ) . . . . . . .  user version of I p-Q menu option 14
#F PqSetMetabelian()
##
DeclareGlobalFunction( "PqSetMetabelian" );

#############################################################################
##
#F PQ_DO_CONSISTENCY_CHECK( <datarec> ) . . . . . . . .  I p-Q menu option 15
##
DeclareGlobalFunction( "PQ_DO_CONSISTENCY_CHECK" );

#############################################################################
##
#F PqDoConsistencyCheck( <i> ) . . . . . user version of I p-Q menu option 15
#F PqDoConsistencyCheck()
##
DeclareGlobalFunction( "PqDoConsistencyCheck" );

#############################################################################
##
#F PQ_COMPACT( <datarec> ) . . . . . . . . . . . . . . . I p-Q menu option 16
##
DeclareGlobalFunction( "PQ_COMPACT" );

#############################################################################
##
#F PqCompact( <i> ) . . . . . . . . . .  user version of I p-Q menu option 16
#F PqCompact()
##
DeclareGlobalFunction( "PqCompact" );

#############################################################################
##
#F PQ_ECHELONISE( <datarec> ) . . . . . . . . . . . . .  I p-Q menu option 17
##
DeclareGlobalFunction( "PQ_ECHELONISE" );

#############################################################################
##
#F PqEchelonise( <i> ) . . . . . . . . . user version of I p-Q menu option 17
#F PqEchelonise()
##
DeclareGlobalFunction( "PqEchelonise" );

#############################################################################
##
#F PQ_SUPPLY_AND_EXTEND_AUTOMORPHISMS( <datarec> ) . . . I p-Q menu option 18
##
DeclareGlobalFunction( "PQ_SUPPLY_AND_EXTEND_AUTOMORPHISMS" );

#############################################################################
##
#F PqSupplyAndExtendAutomorphisms( <i> ) user version of I p-Q menu option 18
#F PqSupplyAndExtendAutomorphisms()
##
DeclareGlobalFunction( "PqSupplyAndExtendAutomorphisms" );

#############################################################################
##
#F PQ_CLOSE_RELATIONS( <datarec> ) . . . . . . . . . . . I p-Q menu option 19
##
DeclareGlobalFunction( "PQ_CLOSE_RELATIONS" );

#############################################################################
##
#F PqCloseRelations( <i> ) . . . . . . . user version of I p-Q menu option 19
#F PqCloseRelations()
##
DeclareGlobalFunction( "PqCloseRelations" );

#############################################################################
##
#F PQ_PRINT_STRUCTURE( <datarec> ) . . . . . . . . . . . I p-Q menu option 20
##
DeclareGlobalFunction( "PQ_PRINT_STRUCTURE" );

#############################################################################
##
#F PqPrintStructure( <i> ) . . . . . . . user version of I p-Q menu option 20
#F PqPrintStructure()
##
DeclareGlobalFunction( "PqPrintStructure" );

#############################################################################
##
#F PQ_DISPLAY_AUTOMORPHISMS( <datarec> ) . . . . . . . . I p-Q menu option 21
##
DeclareGlobalFunction( "PQ_DISPLAY_AUTOMORPHISMS" );

#############################################################################
##
#F PqDisplayAutomorphisms( <i> ) . . . . user version of I p-Q menu option 21
#F PqDisplayAutomorphisms()
##
DeclareGlobalFunction( "PqDisplayAutomorphisms" );

#############################################################################
##
#F PQ_COLLECT_DEFINING_GENERATORS( <datarec> ) . . . . . I p-Q menu option 23
##
DeclareGlobalFunction( "PQ_COLLECT_DEFINING_GENERATORS" );

#############################################################################
##
#F PqCollectDefiningGenerators( <i> ) .  user version of I p-Q menu option 23
#F PqCollectDefiningGenerators()
##
DeclareGlobalFunction( "PqCollectDefiningGenerators" );

#############################################################################
##
#F PQ_COMMUTATOR_DEFINING_GENERATORS( <datarec> ) . . .  I p-Q menu option 24
##
DeclareGlobalFunction( "PQ_COMMUTATOR_DEFINING_GENERATORS" );

#############################################################################
##
#F PqCommutatorDefiningGenerators( <i> ) user version of I p-Q menu option 24
#F PqCommutatorDefiningGenerators()
##
DeclareGlobalFunction( "PqCommutatorDefiningGenerators" );

#############################################################################
##
#F  PQ_WRITE_PC_PRESENTATION( <datarec> : <options> ) .  I p-Q menu option 25
##
DeclareGlobalFunction( "PQ_WRITE_PC_PRESENTATION" );

#############################################################################
##
#F  PqWritePcPresentation( <i> : <options> ) . user ver. of I p-Q menu op. 25
#F  PqWritePcPresentation( )
##
DeclareGlobalFunction( "PqWritePcPresentation" );

#############################################################################
##
#F PQ_EVALUATE_CERTAIN_FORMULAE( <datarec> ) . . . . . . I p-Q menu option 27
##
DeclareGlobalFunction( "PQ_EVALUATE_CERTAIN_FORMULAE" );

#############################################################################
##
#F PqEvaluateCertainFormulae( <i> ) . .  user version of I p-Q menu option 27
#F PqEvaluateCertainFormulae()
##
DeclareGlobalFunction( "PqEvaluateCertainFormulae" );

#############################################################################
##
#F PQ_EVALUATE_ACTION( <datarec> ) . . . . . . . . . . . I p-Q menu option 28
##
DeclareGlobalFunction( "PQ_EVALUATE_ACTION" );

#############################################################################
##
#F PqEvaluateAction( <i> ) . . . . . . . user version of I p-Q menu option 28
#F PqEvaluateAction()
##
DeclareGlobalFunction( "PqEvaluateAction" );

#############################################################################
##
#F PQ_EVALUATE_ENGEL_IDENTITY( <datarec> ) . . . . . . . I p-Q menu option 29
##
DeclareGlobalFunction( "PQ_EVALUATE_ENGEL_IDENTITY" );

#############################################################################
##
#F PqEvaluateEngelIdentity( <i> ) . . .  user version of I p-Q menu option 29
#F PqEvaluateEngelIdentity()
##
DeclareGlobalFunction( "PqEvaluateEngelIdentity" );

#############################################################################
##
#F PQ_PROCESS_RELATIONS_FILE( <datarec> ) . . . . . . .  I p-Q menu option 30
##
DeclareGlobalFunction( "PQ_PROCESS_RELATIONS_FILE" );

#############################################################################
##
#F PqProcessRelationsFile( <i> ) . . . . user version of I p-Q menu option 30
#F PqProcessRelationsFile()
##
DeclareGlobalFunction( "PqProcessRelationsFile" );

#############################################################################
##
#F  PqSPPcPresentation( <i> : <options> ) . .  user version of SP menu opt. 1
#F  PqSPPcPresentation( : <options> )
##
DeclareGlobalFunction( "PqSPPcPresentation" );

#############################################################################
##
#F  PQ_SP_STANDARD_PRESENTATION( <datarec> : <options> ) . . SP menu option 2
##
DeclareGlobalFunction( "PQ_SP_STANDARD_PRESENTATION" );

#############################################################################
##
#F  PqSPStandardPresentation( <i> : <options> ) . user ver. of SP menu opt. 2
#F  PqSPStandardPresentation( : <options> )
##
DeclareGlobalFunction( "PqSPStandardPresentation" );

#############################################################################
##
#F PQ_SP_SAVE_PRESENTATION( <datarec> ) . . . . . . . . . .  SP menu option 3
##
DeclareGlobalFunction( "PQ_SP_SAVE_PRESENTATION" );

#############################################################################
##
#F PqSPSavePresentation( <i> ) . . . . . . . user version of SP menu option 3
#F PqSPSavePresentation()
##
DeclareGlobalFunction( "PqSPSavePresentation" );

#############################################################################
##
#F PQ_SP_DISPLAY_PRESENTATION( <datarec> ) . . . . . . . . . SP menu option 4
##
DeclareGlobalFunction( "PQ_SP_DISPLAY_PRESENTATION" );

#############################################################################
##
#F PqSPDisplayPresentation( <i> ) . . . . .  user version of SP menu option 4
#F PqSPDisplayPresentation()
##
DeclareGlobalFunction( "PqSPDisplayPresentation" );

#############################################################################
##
#F PQ_SP_COMPARE_TWO_FILE_PRESENTATIONS( <datarec> ) . . . . SP menu option 6
##
DeclareGlobalFunction( "PQ_SP_COMPARE_TWO_FILE_PRESENTATIONS" );

#############################################################################
##
#F PqSPCompareTwoFilePresentations( <i> ) .  user version of SP menu option 6
#F PqSPCompareTwoFilePresentations()
##
DeclareGlobalFunction( "PqSPCompareTwoFilePresentations" );

#############################################################################
##
#F  PQ_SP_ISOMORPHISM( <datarec> ) . . . . . . . . . . . . . SP menu option 8
##
DeclareGlobalFunction( "PQ_SP_ISOMORPHISM" );

#############################################################################
##
#F  PqSPIsomorphism( <i> ) . . . . . . . . . user version of SP menu option 8
#F  PqSPIsomorphism()
##
DeclareGlobalFunction( "PqSPIsomorphism" );

#############################################################################
##
#F  PQ_PG_SUPPLY_AUTS( <datarec> ) . . . . . . . . . . . . . pG menu option 1
##
DeclareGlobalFunction( "PQ_PG_SUPPLY_AUTS" );

#############################################################################
##
#F  PqPGSupplyAutomorphisms( <i> ) . . . . . user version of pG menu option 1
#F  PqPGSupplyAutomorphisms()
##
DeclareGlobalFunction( "PqPGSupplyAutomorphisms" );

#############################################################################
##
#F PQ_PG_EXTEND_AUTOMORPHISMS( <datarec> ) . . . . . . . .  p-G menu option 2
##
DeclareGlobalFunction( "PQ_PG_EXTEND_AUTOMORPHISMS" );

#############################################################################
##
#F PqPGExtendAutomorphisms( <i> ) . . . . . user version of p-G menu option 2
#F PqPGExtendAutomorphisms()
##
DeclareGlobalFunction( "PqPGExtendAutomorphisms" );

#############################################################################
##
#F PQ_PG_RESTORE_GROUP_FROM_FILE( <datarec> ) . . . . . . . p-G menu option 3
##
DeclareGlobalFunction( "PQ_PG_RESTORE_GROUP_FROM_FILE" );

#############################################################################
##
#F PqPGRestoreGroupFromFile( <i> ) . . . .  user version of p-G menu option 3
#F PqPGRestoreGroupFromFile()
##
DeclareGlobalFunction( "PqPGRestoreGroupFromFile" );

#############################################################################
##
#F PQ_PG_DISPLAY_GROUP_PRESENTATION( <datarec> ) . . . . .  p-G menu option 4
##
DeclareGlobalFunction( "PQ_PG_DISPLAY_GROUP_PRESENTATION" );

#############################################################################
##
#F PqPGDisplayGroupPresentation( <i> ) . .  user version of p-G menu option 4
#F PqPGDisplayGroupPresentation()
##
DeclareGlobalFunction( "PqPGDisplayGroupPresentation" );

#############################################################################
##
#F  PQ_PG_CONSTRUCT_DESCENDANTS( <datarec> : <options> ) . . pG menu option 5
##
DeclareGlobalFunction( "PQ_PG_CONSTRUCT_DESCENDANTS" );

#############################################################################
##
#F PQ_IPG_SUPPLY_AUTOMORPHISMS( <datarec> ) . . . . . . . I p-G menu option 1
##
DeclareGlobalFunction( "PQ_IPG_SUPPLY_AUTOMORPHISMS" );

#############################################################################
##
#F PqIPGSupplyAutomorphisms( <i> ) . . .  user version of I p-G menu option 1
#F PqIPGSupplyAutomorphisms()
##
DeclareGlobalFunction( "PqIPGSupplyAutomorphisms" );

#############################################################################
##
#F PQ_IPG_EXTEND_AUTOMORPHISMS( <datarec> ) . . . . . . . I p-G menu option 2
##
DeclareGlobalFunction( "PQ_IPG_EXTEND_AUTOMORPHISMS" );

#############################################################################
##
#F PqIPGExtendAutomorphisms( <i> ) . . .  user version of I p-G menu option 2
#F PqIPGExtendAutomorphisms()
##
DeclareGlobalFunction( "PqIPGExtendAutomorphisms" );

#############################################################################
##
#F PQ_IPG_RESTORE_GROUP_FROM_FILE( <datarec> ) . . . . .  I p-G menu option 3
##
DeclareGlobalFunction( "PQ_IPG_RESTORE_GROUP_FROM_FILE" );

#############################################################################
##
#F PqIPGRestoreGroupFromFile( <i> ) . . . user version of I p-G menu option 3
#F PqIPGRestoreGroupFromFile()
##
DeclareGlobalFunction( "PqIPGRestoreGroupFromFile" );

#############################################################################
##
#F PQ_IPG_DISPLAY_GROUP_PRESENTATION( <datarec> ) . . . . I p-G menu option 4
##
DeclareGlobalFunction( "PQ_IPG_DISPLAY_GROUP_PRESENTATION" );

#############################################################################
##
#F PqIPGDisplayGroupPresentation( <i> ) . user version of I p-G menu option 4
#F PqIPGDisplayGroupPresentation()
##
DeclareGlobalFunction( "PqIPGDisplayGroupPresentation" );

#############################################################################
##
#F PQ_IPG_SINGLE_STAGE( <datarec> ) . . . . . . . . . . . I p-G menu option 5
##
DeclareGlobalFunction( "PQ_IPG_SINGLE_STAGE" );

#############################################################################
##
#F PqIPGSingleStage( <i> ) . . . . . . .  user version of I p-G menu option 5
#F PqIPGSingleStage()
##
DeclareGlobalFunction( "PqIPGSingleStage" );

#############################################################################
##
#F PQ_IPG_DEGREE( <datarec> ) . . . . . . . . . . . . . . I p-G menu option 6
##
DeclareGlobalFunction( "PQ_IPG_DEGREE" );

#############################################################################
##
#F PqIPGDegree( <i> ) . . . . . . . . . . user version of I p-G menu option 6
#F PqIPGDegree()
##
DeclareGlobalFunction( "PqIPGDegree" );

#############################################################################
##
#F PQ_IPG_PERMUTATIONS( <datarec> ) . . . . . . . . . . . I p-G menu option 7
##
DeclareGlobalFunction( "PQ_IPG_PERMUTATIONS" );

#############################################################################
##
#F PqIPGPermutations( <i> ) . . . . . . . user version of I p-G menu option 7
#F PqIPGPermutations()
##
DeclareGlobalFunction( "PqIPGPermutations" );

#############################################################################
##
#F PQ_IPG_ORBITS( <datarec> ) . . . . . . . . . . . . . . I p-G menu option 8
##
DeclareGlobalFunction( "PQ_IPG_ORBITS" );

#############################################################################
##
#F PqIPGOrbits( <i> ) . . . . . . . . . . user version of I p-G menu option 8
#F PqIPGOrbits()
##
DeclareGlobalFunction( "PqIPGOrbits" );

#############################################################################
##
#F PQ_IPG_ORBIT_REPRESENTATIVES( <datarec> ) . . . . . .  I p-G menu option 9
##
DeclareGlobalFunction( "PQ_IPG_ORBIT_REPRESENTATIVES" );

#############################################################################
##
#F PqIPGOrbitRepresentatives( <i> ) . . . user version of I p-G menu option 9
#F PqIPGOrbitRepresentatives()
##
DeclareGlobalFunction( "PqIPGOrbitRepresentatives" );

#############################################################################
##
#F PQ_IPG_ORBIT_REPRESENTATIVE( <datarec> ) . . . . . .  I p-G menu option 10
##
DeclareGlobalFunction( "PQ_IPG_ORBIT_REPRESENTATIVE" );

#############################################################################
##
#F PqIPGOrbitRepresentative( <i> ) . . . user version of I p-G menu option 10
#F PqIPGOrbitRepresentative()
##
DeclareGlobalFunction( "PqIPGOrbitRepresentative" );

#############################################################################
##
#F PQ_IPG_STANDARD_MATRIX_LABEL( <datarec> ) . . . . . . I p-G menu option 11
##
DeclareGlobalFunction( "PQ_IPG_STANDARD_MATRIX_LABEL" );

#############################################################################
##
#F PqIPGStandardMatrixLabel( <i> ) . . . user version of I p-G menu option 11
#F PqIPGStandardMatrixLabel()
##
DeclareGlobalFunction( "PqIPGStandardMatrixLabel" );

#############################################################################
##
#F PQ_IPG_MATRIX_OF_LABEL( <datarec> ) . . . . . . . . . I p-G menu option 12
##
DeclareGlobalFunction( "PQ_IPG_MATRIX_OF_LABEL" );

#############################################################################
##
#F PqIPGMatrixOfLabel( <i> ) . . . . . . user version of I p-G menu option 12
#F PqIPGMatrixOfLabel()
##
DeclareGlobalFunction( "PqIPGMatrixOfLabel" );

#############################################################################
##
#F PQ_IPG_IMAGE_OF_ALLOWABLE_SUBGROUP( <datarec> ) . . . I p-G menu option 13
##
DeclareGlobalFunction( "PQ_IPG_IMAGE_OF_ALLOWABLE_SUBGROUP" );

#############################################################################
##
#F PqIPGImageOfAllowableSubgroup( <i> )  user version of I p-G menu option 13
#F PqIPGImageOfAllowableSubgroup()
##
DeclareGlobalFunction( "PqIPGImageOfAllowableSubgroup" );

#############################################################################
##
#F PQ_IPG_RANK_CLOSURE_OF_INITIAL_SEGMENT( <datarec> ) . I p-G menu option 14
##
DeclareGlobalFunction( "PQ_IPG_RANK_CLOSURE_OF_INITIAL_SEGMENT" );

#############################################################################
##
#F PqIPGRankClosureOfInitialSegment( <i> )  user version of I p-G menu option 14
#F PqIPGRankClosureOfInitialSegment()
##
DeclareGlobalFunction( "PqIPGRankClosureOfInitialSegment" );

#############################################################################
##
#F PQ_IPG_ORBIT_REPRESENTATIVE_OF_LABEL( <datarec> ) . . I p-G menu option 15
##
DeclareGlobalFunction( "PQ_IPG_ORBIT_REPRESENTATIVE_OF_LABEL" );

#############################################################################
##
#F PqIPGOrbitRepresentativeOfLabel( <i> )  user version of I p-G menu option 15
#F PqIPGOrbitRepresentativeOfLabel()
##
DeclareGlobalFunction( "PqIPGOrbitRepresentativeOfLabel" );

#############################################################################
##
#F PQ_IPG_WRITE_COMPACT_DESCRIPTION( <datarec> ) . . . . I p-G menu option 16
##
DeclareGlobalFunction( "PQ_IPG_WRITE_COMPACT_DESCRIPTION" );

#############################################################################
##
#F PqIPGWriteCompactDescription( <i> ) . user version of I p-G menu option 16
#F PqIPGWriteCompactDescription()
##
DeclareGlobalFunction( "PqIPGWriteCompactDescription" );

#############################################################################
##
#F PQ_IPG_AUTOMORPHISM_CLASSES( <datarec> ) . . . . . .  I p-G menu option 17
##
DeclareGlobalFunction( "PQ_IPG_AUTOMORPHISM_CLASSES" );

#############################################################################
##
#F PqIPGAutomorphismClasses( <i> ) . . . user version of I p-G menu option 17
#F PqIPGAutomorphismClasses()
##
DeclareGlobalFunction( "PqIPGAutomorphismClasses" );

#E  anupqi.gd . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here 
