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
#F  PQ_MANUAL_AUT_INPUT(<datarec>,<mlist>) . automorphism input w/o an Aut gp
##
DeclareGlobalFunction( "PQ_MANUAL_AUT_INPUT" );

#############################################################################
##
#F  PQ_AUT_ARG_CHK(<datarec>, <mlist>) .  checks a matrix list look like auts
##
DeclareGlobalFunction( "PQ_AUT_ARG_CHK" );

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
#F  PQ_SAVE_PC_PRESENTATION( <datarec>, <filename> ) . . .  p-Q menu option 2
##
DeclareGlobalFunction( "PQ_SAVE_PC_PRESENTATION" );

#############################################################################
##
#F  PQ_PATH_CURRENT_DIRECTORY() . . . . . . . . . .  essentially the UNIX pwd
##
DeclareGlobalFunction( "PQ_PATH_CURRENT_DIRECTORY" );

#############################################################################
##
#F  PQ_CHK_PATH(<filename>, <rw>) . add curr dir path if nec. & check file ok
##
DeclareGlobalFunction( "PQ_CHK_PATH" );

#############################################################################
##
#F  PqSavePcPresentation( <i>, <filename> ) . .  user ver. of p-Q menu opt. 2
#F  PqSavePcPresentation( <filename> )
##
DeclareGlobalFunction( "PqSavePcPresentation" );

#############################################################################
##
#F  PQ_RESTORE_PC_PRESENTATION( <datarec>, <filename> ) . . p-Q menu option 3
##
DeclareGlobalFunction( "PQ_RESTORE_PC_PRESENTATION" );

#############################################################################
##
#F  PqRestorePcPresentation( <i>, <filename> ) . user ver. of p-Q menu opt. 3
#F  PqRestorePcPresentation( <filename> )
##
DeclareGlobalFunction( "PqRestorePcPresentation" );

#############################################################################
##
#F  PQ_PRE_DISPLAY( <datarec>, <menu> ) . . . .  execute pre-display commands
##
DeclareGlobalFunction( "PQ_PRE_DISPLAY" );

#############################################################################
##
#F  PQ_DISPLAY_PRESENTATION( <datarec>, <menu> ) . . . . .  any menu option 4
##
DeclareGlobalFunction( "PQ_DISPLAY_PRESENTATION" );

#############################################################################
##
#F  PQ_CURRENT_GROUP(<datarec>) .  uses p-Q menu opt 4 to set the current grp
##
DeclareGlobalFunction( "PQ_CURRENT_GROUP" );

#############################################################################
##
#F  PqCurrentGroup( <i> ) . . .  using p-Q menu opt 4 returns the current grp
#F  PqCurrentGroup()
##
DeclareGlobalFunction( "PqCurrentGroup" );

#############################################################################
##
#F  PqDisplayPcPresentation( <i> ) . . . .  user version of p-Q menu option 4
#F  PqDisplayPcPresentation()
##
DeclareGlobalFunction( "PqDisplayPcPresentation" );

#############################################################################
##
#F  PQ_SET_PRINT_LEVEL(<datarec>, <menu>, <lev>) . . p-Q/SP/A p-Q menu opt. 5
##
DeclareGlobalFunction( "PQ_SET_PRINT_LEVEL" );

#############################################################################
##
#F  PQ_CHK_PRINT_ARGS( <args> ) . . . . . . check args for print level cmd ok
##
DeclareGlobalFunction( "PQ_CHK_PRINT_ARGS" );

#############################################################################
##
#F  PqSetPrintLevel( <i>, <lev> ) . . . . . user version of p-Q menu option 5
#F  PqSetPrintLevel( <lev> )
##
DeclareGlobalFunction( "PqSetPrintLevel" );

#############################################################################
##
#F  PQ_NEXT_CLASS( <datarec> ) . . . . . . . . . . . . . .  p-Q menu option 6
##
DeclareGlobalFunction( "PQ_NEXT_CLASS" );

#############################################################################
##
#F  PqNextClass( <i> ) . . . . . . . . . .  user version of p-Q menu option 6
#F  PqNextClass()
##
DeclareGlobalFunction( "PqNextClass" );

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
#F  PQ_COLLECT( <datarec>, <word> ) . . . . . . . . . . . A p-Q menu option 1
##
DeclareGlobalFunction( "PQ_COLLECT" );

#############################################################################
##
#F  PQ_CHK_COLLECT_COMMAND_ARGS( <args> ) . . check args for a collect cmd ok
##
DeclareGlobalFunction( "PQ_CHK_COLLECT_COMMAND_ARGS" );

#############################################################################
##
#F  PqCollect( <i>, <word> ) . . . . . .  user version of A p-Q menu option 1
#F  PqCollect( <word> )
##
DeclareGlobalFunction( "PqCollect" );

#############################################################################
##
#F  PQ_SOLVE_EQUATION( <datarec>, <a>, <b> ) . . . . . .  A p-Q menu option 2
##
DeclareGlobalFunction( "PQ_SOLVE_EQUATION" );

#############################################################################
##
#F  PqSolveEquation( <i>, <a>, <b> ) . .  user version of A p-Q menu option 2
#F  PqSolveEquation( <a>, <b> )
##
DeclareGlobalFunction( "PqSolveEquation" );

#############################################################################
##
#F  PQ_COMMUTATOR( <datarec>, <words>, <pow>, <item> ) . A p-Q menu opts 3/24
##
DeclareGlobalFunction( "PQ_COMMUTATOR" );

#############################################################################
##
#F  PQ_COMMUTATOR_CHK_ARGS( <args> ) . . . . check args for commutator cmd ok
##
DeclareGlobalFunction( "PQ_COMMUTATOR_CHK_ARGS" );

#############################################################################
##
#F  PqCommutator( <i>, <words>, <pow> ) . user version of A p-Q menu option 3
#F  PqCommutator( <words>, <pow> )
##
DeclareGlobalFunction( "PqCommutator" );

#############################################################################
##
#F  PqAPQDisplayPresentation( <i> ) . . . user version of A p-Q menu option 4
#F  PqAPQDisplayPresentation()
##
DeclareGlobalFunction( "PqAPQDisplayPresentation" );

#############################################################################
##
#F  PqAPQSetPrintLevel( <i>, <lev> ) . . .  user version of p-Q menu option 5
#F  PqAPQSetPrintLevel( <lev> )
##
DeclareGlobalFunction( "PqAPQSetPrintLevel" );

#############################################################################
##
#F  PQ_SETUP_TABLES_FOR_NEXT_CLASS( <datarec> ) . . . . . A p-Q menu option 6
##
DeclareGlobalFunction( "PQ_SETUP_TABLES_FOR_NEXT_CLASS" );

#############################################################################
##
#F  PqSetupTablesForNextClass( <i> ) . .  user version of A p-Q menu option 6
#F  PqSetupTablesForNextClass()
##
DeclareGlobalFunction( "PqSetupTablesForNextClass" );

#############################################################################
##
#F  PQ_INSERT_TAILS( <datarec>, <weight>, <which> )  . .  A p-Q menu option 7
##
DeclareGlobalFunction( "PQ_INSERT_TAILS" );

#############################################################################
##
#F  PQ_CHK_TAILS_ARGS( <args> ) . . . . .  check args for insert tails cmd ok
##
DeclareGlobalFunction( "PQ_CHK_TAILS_ARGS" );

#############################################################################
##
#F  PqAddTails( <i>, <weight> ) . . . .  adds tails using A p-Q menu option 7
#F  PqAddTails( <weight> )
##
DeclareGlobalFunction( "PqAddTails" );

#############################################################################
##
#F  PqComputeTails( <i>, <weight> ) . . computes tails using A p-Q menu opt 7
#F  PqComputeTails( <weight> )
##
DeclareGlobalFunction( "PqComputeTails" );

#############################################################################
##
#F  PqTails( <i>, <weight> ) . computes and adds tails using A p-Q menu opt 7
#F  PqTails( <weight> )
##
DeclareGlobalFunction( "PqTails" );

#############################################################################
##
#F  PQ_DO_CONSISTENCY_CHECKS( <datarec>, <weight>, <type> ) . A p-Q menu opt 8
##
DeclareGlobalFunction( "PQ_DO_CONSISTENCY_CHECKS" );

#############################################################################
##
#F  PqDoConsistencyChecks(<i>,<weight>,<type>) . user ver of A p-Q menu opt 8
#F  PqDoConsistencyChecks( <weight>, <type> )
##
DeclareGlobalFunction( "PqDoConsistencyChecks" );

#############################################################################
##
#F  PQ_COLLECT_DEFINING_RELATIONS( <datarec> ) . . . . .  A p-Q menu option 9
##
DeclareGlobalFunction( "PQ_COLLECT_DEFINING_RELATIONS" );

#############################################################################
##
#F  PqCollectDefiningRelations( <i> ) . . user version of A p-Q menu option 9
#F  PqCollectDefiningRelations()
##
DeclareGlobalFunction( "PqCollectDefiningRelations" );

#############################################################################
##
#F  PQ_DO_EXPONENT_CHECKS( <datarec>, <w1>, <w2> ) . . . A p-Q menu option 10
##
DeclareGlobalFunction( "PQ_DO_EXPONENT_CHECKS" );

#############################################################################
##
#F  PqDoExponentChecks( <i>, <w1>, <w2> ) . .  user version A p-Q menu opt 10
#F  PqDoExponentChecks( <w1>, <w2> )
##
DeclareGlobalFunction( "PqDoExponentChecks" );

#############################################################################
##
#F  PQ_ELIMINATE_REDUNDANT_GENERATORS( <datarec> ) . . . A p-Q menu option 11
##
DeclareGlobalFunction( "PQ_ELIMINATE_REDUNDANT_GENERATORS" );

#############################################################################
##
#F  PqEliminateRedundantGenerators( <i> ) .  user ver of A p-Q menu option 11
#F  PqEliminateRedundantGenerators()
##
DeclareGlobalFunction( "PqEliminateRedundantGenerators" );

#############################################################################
##
#F  PQ_REVERT_TO_PREVIOUS_CLASS( <datarec> ) . . . . . . A p-Q menu option 12
##
DeclareGlobalFunction( "PQ_REVERT_TO_PREVIOUS_CLASS" );

#############################################################################
##
#F  PqRevertToPreviousClass( <i> ) . . . user version of A p-Q menu option 12
#F  PqRevertToPreviousClass()
##
DeclareGlobalFunction( "PqRevertToPreviousClass" );

#############################################################################
##
#F  PQ_SET_MAXIMAL_OCCURRENCES( <datarec>, <weights> ) . . A p-Q menu opt. 13
##
DeclareGlobalFunction( "PQ_SET_MAXIMAL_OCCURRENCES" );

#############################################################################
##
#F  PQ_PQUOTIENT_CHK( <datarec> ) . . . .  check p-quotient has been computed
##
DeclareGlobalFunction( "PQ_PQUOTIENT_CHK" );

#############################################################################
##
#F  PqSetMaximalOccurrences( <i>, <weights> ) . user ver of A p-Q menu opt 13
#F  PqSetMaximalOccurrences( <weights> )
##
DeclareGlobalFunction( "PqSetMaximalOccurrences" );

#############################################################################
##
#F  PQ_SET_METABELIAN( <datarec> ) . . . . . . . . . . . A p-Q menu option 14
##
DeclareGlobalFunction( "PQ_SET_METABELIAN" );

#############################################################################
##
#F  PqSetMetabelian( <i> ) . . . . . . . user version of A p-Q menu option 14
#F  PqSetMetabelian()
##
DeclareGlobalFunction( "PqSetMetabelian" );

#############################################################################
##
#F  PQ_DO_CONSISTENCY_CHECK( <datarec>, <c>, <b>, <a> ) . A p-Q menu option 15
##
DeclareGlobalFunction( "PQ_DO_CONSISTENCY_CHECK" );

#############################################################################
##
#F  PqDoConsistencyCheck(<i>, <c>, <b>, <a>) .  user ver of A p-Q menu opt 15
#F  PqDoConsistencyCheck( <c>, <b>, <a> )
##
DeclareGlobalFunction( "PqDoConsistencyCheck" );

#############################################################################
##
#F  PQ_COMPACT( <datarec> ) . . . . . . . . . . . . . .  A p-Q menu option 16
##
DeclareGlobalFunction( "PQ_COMPACT" );

#############################################################################
##
#F  PqCompact( <i> ) . . . . . . . . . . user version of A p-Q menu option 16
#F  PqCompact()
##
DeclareGlobalFunction( "PqCompact" );

#############################################################################
##
#F  PQ_ECHELONISE( <datarec> ) . . . . . . . . . . . . . A p-Q menu option 17
##
DeclareGlobalFunction( "PQ_ECHELONISE" );

#############################################################################
##
#F  PqEchelonise( <i> ) . . . . . . . .  user version of A p-Q menu option 17
#F  PqEchelonise()
##
DeclareGlobalFunction( "PqEchelonise" );

#############################################################################
##
#F  PQ_SUPPLY_OR_EXTEND_AUTOMORPHISMS(<datarec>[,<mlist>])  A p-Q menu opt 18
##
DeclareGlobalFunction( "PQ_SUPPLY_OR_EXTEND_AUTOMORPHISMS" );

#############################################################################
##
#F  PqSupplyAutomorphisms(<i>, <mlist>) . . supply auts via A p-Q menu opt 18
#F  PqSupplyAutomorphisms( <mlist> )
##
DeclareGlobalFunction( "PqSupplyAutomorphisms" );

#############################################################################
##
#F  PqExtendAutomorphisms( <i> ) . . . . .  extend auts via A p-Q menu opt 18
#F  PqExtendAutomorphisms()
##
DeclareGlobalFunction( "PqExtendAutomorphisms" );

#############################################################################
##
#F  PQ_CLOSE_RELATIONS( <datarec>, <qfac> ) . . . . . .  A p-Q menu option 19
##
DeclareGlobalFunction( "PQ_CLOSE_RELATIONS" );

#############################################################################
##
#F  PqApplyAutomorphisms( <i>, <qfac> ) . .  user ver of A p-Q menu option 19
#F  PqApplyAutomorphisms( <qfac> )
##
DeclareGlobalFunction( "PqApplyAutomorphisms" );

#############################################################################
##
#F  PQ_PRINT_STRUCTURE( <datarec>, <m>, <n> ) . . . . .  A p-Q menu option 20
##
DeclareGlobalFunction( "PQ_PRINT_STRUCTURE" );

#############################################################################
##
#F  PQ_CHK_DISPLAY_COMMAND_ARGS( <args> ) . . check args for a display cmd ok
##
DeclareGlobalFunction( "PQ_CHK_DISPLAY_COMMAND_ARGS" );

#############################################################################
##
#F  PqPrintStructure( <i>, <m>, <n> ) .  user version of A p-Q menu option 20
#F  PqPrintStructure( <m>, <n> )
##
DeclareGlobalFunction( "PqPrintStructure" );

#############################################################################
##
#F  PQ_DISPLAY_AUTOMORPHISMS( <datarec>, <m>, <n> ) . .  A p-Q menu option 21
##
DeclareGlobalFunction( "PQ_DISPLAY_AUTOMORPHISMS" );

#############################################################################
##
#F  PqDisplayAutomorphisms( <i>, <m>, <n> ) . . user ver of A p-Q menu opt 21
#F  PqDisplayAutomorphisms( <m>, <n> )
##
DeclareGlobalFunction( "PqDisplayAutomorphisms" );

#############################################################################
##
#F  PQ_COLLECT_DEFINING_GENERATORS( <datarec>, <word> ) . . A p-Q menu opt 23
##
DeclareGlobalFunction( "PQ_COLLECT_DEFINING_GENERATORS" );

#############################################################################
##
#F  PqCollectDefiningGenerators(<i>, <word>) .  user ver of A p-Q menu opt 23
#F  PqCollectDefiningGenerators( <word> )
##
DeclareGlobalFunction( "PqCollectDefiningGenerators" );

#############################################################################
##
#F  PqCommutatorDefiningGenerators(<i>,<words>,<pow>) . user ver A p-Q opt 24
#F  PqCommutatorDefiningGenerators( <words>, <pow> )
##
DeclareGlobalFunction( "PqCommutatorDefiningGenerators" );

#############################################################################
##
#F  PQ_WRITE_PC_PRESENTATION( <datarec>, <filename> ) .  A p-Q menu option 25
##
DeclareGlobalFunction( "PQ_WRITE_PC_PRESENTATION" );

#############################################################################
##
#F  PqWritePcPresentation( <i>, <filename> ) . user ver. of A p-Q menu opt 25
#F  PqWritePcPresentation( <filename> )
##
DeclareGlobalFunction( "PqWritePcPresentation" );

#############################################################################
##
#F  PQ_WRITE_COMPACT_DESCRIPTION( <datarec> ) . . . . .  A p-Q menu option 26
##
DeclareGlobalFunction( "PQ_WRITE_COMPACT_DESCRIPTION" );

#############################################################################
##
#F  PqWriteCompactDescription( <i> ) . . user version of A p-Q menu option 26
#F  PqWriteCompactDescription()
##
DeclareGlobalFunction( "PqWriteCompactDescription" );

#############################################################################
##
#F  PQ_EVALUATE_CERTAIN_FORMULAE( <datarec> ) . . . . .  A p-Q menu option 27
##
DeclareGlobalFunction( "PQ_EVALUATE_CERTAIN_FORMULAE" );

#############################################################################
##
#F  PqEvaluateCertainFormulae( <i> ) . . user version of A p-Q menu option 27
#F  PqEvaluateCertainFormulae()
##
DeclareGlobalFunction( "PqEvaluateCertainFormulae" );

#############################################################################
##
#F  PQ_EVALUATE_ACTION( <datarec> ) . . . . . . . . . .  A p-Q menu option 28
##
DeclareGlobalFunction( "PQ_EVALUATE_ACTION" );

#############################################################################
##
#F  PqEvaluateAction( <i> ) . . . . . .  user version of A p-Q menu option 28
#F  PqEvaluateAction()
##
DeclareGlobalFunction( "PqEvaluateAction" );

#############################################################################
##
#F PQ_EVALUATE_ENGEL_IDENTITY( <datarec> ) . . . . . . . A p-Q menu option 29
##
DeclareGlobalFunction( "PQ_EVALUATE_ENGEL_IDENTITY" );

#############################################################################
##
#F PqEvaluateEngelIdentity( <i> ) . . .  user version of A p-Q menu option 29
#F PqEvaluateEngelIdentity()
##
DeclareGlobalFunction( "PqEvaluateEngelIdentity" );

#############################################################################
##
#F PQ_PROCESS_RELATIONS_FILE( <datarec> ) . . . . . . .  A p-Q menu option 30
##
DeclareGlobalFunction( "PQ_PROCESS_RELATIONS_FILE" );

#############################################################################
##
#F PqProcessRelationsFile( <i> ) . . . . user version of A p-Q menu option 30
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
#F  PQ_SP_STANDARD_PRESENTATION(<datarec>[,<mlist>] :<options>) SP menu opt 2
##
DeclareGlobalFunction( "PQ_SP_STANDARD_PRESENTATION" );

#############################################################################
##
#F  PqSPStandardPresentation(<i>[,<mlist>]:<options>)  user ver SP menu opt 2
#F  PqSPStandardPresentation([<mlist>] : <options> )
##
DeclareGlobalFunction( "PqSPStandardPresentation" );

#############################################################################
##
#F  PQ_SP_SAVE_PRESENTATION( <datarec>, <filename> ) . . . . SP menu option 3
##
DeclareGlobalFunction( "PQ_SP_SAVE_PRESENTATION" );

#############################################################################
##
#F  PqSPSavePresentation( <i>, <filename> ) . .  user ver of SP menu option 3
#F  PqSPSavePresentation( <filename> )
##
DeclareGlobalFunction( "PqSPSavePresentation" );

#############################################################################
##
#F  PqSPDisplayPresentation( <i> ) . . . . . user version of SP menu option 4
#F  PqSPDisplayPresentation()
##
DeclareGlobalFunction( "PqSPDisplayPresentation" );

#############################################################################
##
#F  PqSPSetPrintLevel( <i>, <lev> ) . . . .  user version of SP menu option 5
#F  PqSPSetPrintLevel( <lev> )
##
DeclareGlobalFunction( "PqSPSetPrintLevel" );

#############################################################################
##
#F  PQ_SP_COMPARE_TWO_FILE_PRESENTATIONS(<datarec>,<f1>,<f2>) . SP menu opt 6
##
DeclareGlobalFunction( "PQ_SP_COMPARE_TWO_FILE_PRESENTATIONS" );

#############################################################################
##
#F  PqSPCompareTwoFilePresentations(<i>,<f1>,<f2>)  user ver of SP menu opt 6
#F  PqSPCompareTwoFilePresentations(<f1>,<f2>)
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
#F  PQ_PG_SUPPLY_AUTS( <datarec>, <menu> ) . . . . .  p-G/A p-G menu option 1
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
#F  PQ_PG_EXTEND_AUTOMORPHISMS( <datarec>, <menu> ) . p-G/A p-G menu option 2
##
DeclareGlobalFunction( "PQ_PG_EXTEND_AUTOMORPHISMS" );

#############################################################################
##
#F  PqPGExtendAutomorphisms( <i> ) . . . .  user version of p-G menu option 2
#F  PqPGExtendAutomorphisms()
##
DeclareGlobalFunction( "PqPGExtendAutomorphisms" );

#############################################################################
##
#F  PQ_PG_RESTORE_GROUP(<datarec>, <menu>, <cls>, <n>) . p-G/A p-G menu opt 3
##
DeclareGlobalFunction( "PQ_PG_RESTORE_GROUP" );

#############################################################################
##
#F  PQ_PG_RESTORE_GROUP_ARG_CHK( <arg> ) .  check args for restore grp cmd ok
##
DeclareGlobalFunction( "PQ_PG_RESTORE_GROUP_ARG_CHK" );

#############################################################################
##
#F  PqPGRestoreGroupFromFile( <i>, <cls>, <n> ) .  user ver of p-G menu opt 3
#F  PqPGRestoreGroupFromFile( <cls>, <n> )
##
DeclareGlobalFunction( "PqPGRestoreGroupFromFile" );

#############################################################################
##
#F  PqPGDisplayPresentation( <i> ) . . . .  user version of p-G menu option 4
#F  PqPGDisplayPresentation()
##
DeclareGlobalFunction( "PqPGDisplayPresentation" );

#############################################################################
##
#F  PQ_PG_CONSTRUCT_DESCENDANTS( <datarec> : <options> ) . . pG menu option 5
##
DeclareGlobalFunction( "PQ_PG_CONSTRUCT_DESCENDANTS" );

#############################################################################
##
#F  PqPGConstructDescendants( <i> : <options> ) . user ver. of p-G menu op. 5
#F  PqPGConstructDescendants( : <options> )
##
DeclareGlobalFunction( "PqPGConstructDescendants" );

#############################################################################
##
#F  PqAPGSupplyAutomorphisms( <i> ) . . . user version of A p-G menu option 1
#F  PqAPGSupplyAutomorphisms()
##
DeclareGlobalFunction( "PqAPGSupplyAutomorphisms" );

#############################################################################
##
#F  PqAPGExtendAutomorphisms( <i> ) . . . user version of A p-G menu option 2
#F  PqAPGExtendAutomorphisms()
##
DeclareGlobalFunction( "PqAPGExtendAutomorphisms" );

#############################################################################
##
#F  PqAPGRestoreGroupFromFile(<i>, <cls>, <n>) . user ver of A p-G menu opt 3
#F  PqAPGRestoreGroupFromFile( <cls>, <n> )
##
DeclareGlobalFunction( "PqAPGRestoreGroupFromFile" );

#############################################################################
##
#F  PqAPGDisplayPresentation( <i> ) . . . user version of A p-G menu option 4
#F  PqAPGDisplayPresentation()
##
DeclareGlobalFunction( "PqAPGDisplayPresentation" );

#############################################################################
##
#F PQ_APG_SINGLE_STAGE( <datarec> ) . . . . . . . . . . . A p-G menu option 5
##
DeclareGlobalFunction( "PQ_APG_SINGLE_STAGE" );

#############################################################################
##
#F PqAPGSingleStage( <i> ) . . . . . . .  user version of A p-G menu option 5
#F PqAPGSingleStage()
##
DeclareGlobalFunction( "PqAPGSingleStage" );

#############################################################################
##
#F PQ_APG_DEGREE( <datarec> ) . . . . . . . . . . . . . . A p-G menu option 6
##
DeclareGlobalFunction( "PQ_APG_DEGREE" );

#############################################################################
##
#F PqAPGDegree( <i> ) . . . . . . . . . . user version of A p-G menu option 6
#F PqAPGDegree()
##
DeclareGlobalFunction( "PqAPGDegree" );

#############################################################################
##
#F PQ_APG_PERMUTATIONS( <datarec> ) . . . . . . . . . . . A p-G menu option 7
##
DeclareGlobalFunction( "PQ_APG_PERMUTATIONS" );

#############################################################################
##
#F PqAPGPermutations( <i> ) . . . . . . . user version of A p-G menu option 7
#F PqAPGPermutations()
##
DeclareGlobalFunction( "PqAPGPermutations" );

#############################################################################
##
#F PQ_APG_ORBITS( <datarec> ) . . . . . . . . . . . . . . A p-G menu option 8
##
DeclareGlobalFunction( "PQ_APG_ORBITS" );

#############################################################################
##
#F PqAPGOrbits( <i> ) . . . . . . . . . . user version of A p-G menu option 8
#F PqAPGOrbits()
##
DeclareGlobalFunction( "PqAPGOrbits" );

#############################################################################
##
#F PQ_APG_ORBIT_REPRESENTATIVES( <datarec> ) . . . . . .  A p-G menu option 9
##
DeclareGlobalFunction( "PQ_APG_ORBIT_REPRESENTATIVES" );

#############################################################################
##
#F PqAPGOrbitRepresentatives( <i> ) . . . user version of A p-G menu option 9
#F PqAPGOrbitRepresentatives()
##
DeclareGlobalFunction( "PqAPGOrbitRepresentatives" );

#############################################################################
##
#F PQ_APG_ORBIT_REPRESENTATIVE( <datarec> ) . . . . . .  A p-G menu option 10
##
DeclareGlobalFunction( "PQ_APG_ORBIT_REPRESENTATIVE" );

#############################################################################
##
#F PqAPGOrbitRepresentative( <i> ) . . . user version of A p-G menu option 10
#F PqAPGOrbitRepresentative()
##
DeclareGlobalFunction( "PqAPGOrbitRepresentative" );

#############################################################################
##
#F PQ_APG_STANDARD_MATRIX_LABEL( <datarec> ) . . . . . . A p-G menu option 11
##
DeclareGlobalFunction( "PQ_APG_STANDARD_MATRIX_LABEL" );

#############################################################################
##
#F PqAPGStandardMatrixLabel( <i> ) . . . user version of A p-G menu option 11
#F PqAPGStandardMatrixLabel()
##
DeclareGlobalFunction( "PqAPGStandardMatrixLabel" );

#############################################################################
##
#F PQ_APG_MATRIX_OF_LABEL( <datarec> ) . . . . . . . . . A p-G menu option 12
##
DeclareGlobalFunction( "PQ_APG_MATRIX_OF_LABEL" );

#############################################################################
##
#F PqAPGMatrixOfLabel( <i> ) . . . . . . user version of A p-G menu option 12
#F PqAPGMatrixOfLabel()
##
DeclareGlobalFunction( "PqAPGMatrixOfLabel" );

#############################################################################
##
#F PQ_APG_IMAGE_OF_ALLOWABLE_SUBGROUP( <datarec> ) . . . A p-G menu option 13
##
DeclareGlobalFunction( "PQ_APG_IMAGE_OF_ALLOWABLE_SUBGROUP" );

#############################################################################
##
#F PqAPGImageOfAllowableSubgroup( <i> )  user version of A p-G menu option 13
#F PqAPGImageOfAllowableSubgroup()
##
DeclareGlobalFunction( "PqAPGImageOfAllowableSubgroup" );

#############################################################################
##
#F PQ_APG_RANK_CLOSURE_OF_INITIAL_SEGMENT( <datarec> ) . A p-G menu option 14
##
DeclareGlobalFunction( "PQ_APG_RANK_CLOSURE_OF_INITIAL_SEGMENT" );

#############################################################################
##
#F PqAPGRankClosureOfInitialSegment( <i> )  user version of A p-G menu option 14
#F PqAPGRankClosureOfInitialSegment()
##
DeclareGlobalFunction( "PqAPGRankClosureOfInitialSegment" );

#############################################################################
##
#F PQ_APG_ORBIT_REPRESENTATIVE_OF_LABEL( <datarec> ) . . A p-G menu option 15
##
DeclareGlobalFunction( "PQ_APG_ORBIT_REPRESENTATIVE_OF_LABEL" );

#############################################################################
##
#F PqAPGOrbitRepresentativeOfLabel( <i> )  user version of A p-G menu option 15
#F PqAPGOrbitRepresentativeOfLabel()
##
DeclareGlobalFunction( "PqAPGOrbitRepresentativeOfLabel" );

#############################################################################
##
#F PQ_APG_WRITE_COMPACT_DESCRIPTION( <datarec> ) . . . . A p-G menu option 16
##
DeclareGlobalFunction( "PQ_APG_WRITE_COMPACT_DESCRIPTION" );

#############################################################################
##
#F PqAPGWriteCompactDescription( <i> ) . user version of A p-G menu option 16
#F PqAPGWriteCompactDescription()
##
DeclareGlobalFunction( "PqAPGWriteCompactDescription" );

#############################################################################
##
#F PQ_APG_AUTOMORPHISM_CLASSES( <datarec> ) . . . . . .  A p-G menu option 17
##
DeclareGlobalFunction( "PQ_APG_AUTOMORPHISM_CLASSES" );

#############################################################################
##
#F PqAPGAutomorphismClasses( <i> ) . . . user version of A p-G menu option 17
#F PqAPGAutomorphismClasses()
##
DeclareGlobalFunction( "PqAPGAutomorphismClasses" );

#E  anupqi.gd . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here 
