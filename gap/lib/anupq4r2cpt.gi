#############################################################################
####
##
#W  anupq4r2cpt.gi      ANUPQ Share Package                       Greg Gamble
##
##  This file installs functions not in GAP 4.2 for backward compatibility.
##  This file is not read if the version of GAP is 4.3 or later.
##    
#H  @(#)$Id$
##
#Y  Copyright (C) 2001  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
##
Revision.anupq4r2cpt_gi :=
    "@(#)$Id$";

#############################################################################
##
#F  Chomp( <str> )  . . .  remove a trailing '\n' from a string if it has one
##
InstallGlobalFunction(Chomp, function(str)

  if IsString(str) and str <> "" and str[Length(str)] = '\n' then
    return str{[1 .. Length(str) - 1]};
  else
    return str;
  fi;
end);

#E  anupq4r2cpt.gi  . . . . . . . . . . . . . . . . . . . . . . . . ends here 
