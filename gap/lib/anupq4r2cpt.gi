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

#############################################################################
##
#F  JoinStringsWithSeparator( <list>[, <sep>] )
##
InstallGlobalFunction(JoinStringsWithSeparator, function(arg)
  local str, sep, res, i;
  str := List(arg[1], String);
  if Length(str) = 0 then return ""; fi;
  if Length(arg) > 1 then sep := arg[2]; else sep := ","; fi;
  res := ShallowCopy(str[1]);
  for i in [2 .. Length(str)] do
    Append(res, sep);
    Append(res, str[i]);
  od;
  return res;
end );

#############################################################################
##
#F  ResetOptionsStack( ) . . . . . . . . . . . . . . . . . remove all options
##
InstallGlobalFunction( ResetOptionsStack,
        function()
    if Length(OptionsStack)=0 then
      Info(InfoWarning,1,"Options stack is already empty");
    else
      repeat
        PopOptions();
      until IsEmpty(OptionsStack);
    fi;
end);

#############################################################################
##
#F  EvalString( <expr> ) . . . . . . . . . . . . evaluate a string expression
##
InstallGlobalFunction("EvalString", function( expr )
  local tmp;
  tmp := Concatenation( "return ", expr, ";" );
  return ReadAsFunction( InputTextString( tmp ) )();
end );

#############################################################################
##
#M  IsMatchingSublist( <list>,<sub>[,<ind>] )
##
InstallMethod( IsMatchingSublist,"list,sub,pos",IsFamFamX,
  [IsList,IsList,IS_INT], 0,
function( list,sub,first )
local last;

  last:=first+Length(sub)-1;
  return Length(list) >= last and list{[first..last]} = sub;
end);

# no installation restrictions to avoid extra installations for empty list
InstallOtherMethod( IsMatchingSublist,"list, sub",true,
  [IsObject,IsObject], 0,
function( list,sub )
  return IsMatchingSublist(list,sub,1);
end);

InstallOtherMethod( IsMatchingSublist,"empty list,sub,pos",true,
  [IsEmpty,IsList,IS_INT], 0,
function(list,sub,first )
  return not IsEmpty(sub);
end);

InstallOtherMethod( IsMatchingSublist,"list,empty,pos",true,
  [IsList,IsEmpty,IS_INT], 0, ReturnTrue);

#E  anupq4r2cpt.gi  . . . . . . . . . . . . . . . . . . . . . . . . ends here 
