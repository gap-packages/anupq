#############################################################################
####
##
#W  anupq4r2cpt.gi         ANUPQ package                          Greg Gamble
##
##  This file declares and installs functions not in GAP 4.2, unless  already
##  provided, for backward compatibility.
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
if "Chomp" in ANUPQ_PROVIDE_FUNCTIONS then
  InstallGlobalFunction(Chomp, function(str)
    if IsString(str) and str <> "" and str[Length(str)] = '\n' then
      return str{[1 .. Length(str) - 1]};
    else
      return str;
    fi;
  end);
fi;

#############################################################################
##
#F  JoinStringsWithSeparator( <list>[, <sep>] )
##
if "JoinStringsWithSeparator" in ANUPQ_PROVIDE_FUNCTIONS then
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
  end);
fi;

#############################################################################
##
#F  ResetOptionsStack( ) . . . . . . . . . . . . . . . . . remove all options
##
if "ResetOptionsStack" in ANUPQ_PROVIDE_FUNCTIONS then
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
fi;

#############################################################################
##
#F  EvalString( <expr> ) . . . . . . . . . . . . evaluate a string expression
##
if "EvalString" in ANUPQ_PROVIDE_FUNCTIONS then
  InstallGlobalFunction( EvalString, function( expr )
    local tmp;
    tmp := Concatenation( "return ", expr, ";" );
    return ReadAsFunction( InputTextString( tmp ) )();
  end);
fi;

#############################################################################
##
#M  IsMatchingSublist( <list>,<sub>[,<ind>] )
##
if "IsMatchingSublist" in ANUPQ_PROVIDE_FUNCTIONS then
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
fi;

#############################################################################
##
#F  StringFile( <name> ) . . . . . .  return content of file <name> as string
##
if "StringFile" in ANUPQ_PROVIDE_FUNCTIONS then
  InstallGlobalFunction( StringFile, function( name )
    local stream, string;
    stream := InputTextFile(name);
    string := ReadAll(stream);
    CloseStream(stream);
    return string;
  end);
fi;

#############################################################################
##
#F  FileDescriptorOfStream( <stream> )
#F  UNIXSelect( <arg> )
##
if "FileDescriptorOfStream" in ANUPQ_PROVIDE_FUNCTIONS then
  InstallGlobalFunction( FileDescriptorOfStream, stream -> 1 );
fi;
if "UNIXSelect" in ANUPQ_PROVIDE_FUNCTIONS then
  InstallGlobalFunction( UNIXSelect, function( arg )
    Sleep(1); #so we don't chew up CPU
    return 1;
  end);
fi;

#############################################################################
##
#M  ReadAllLine( <iostream>[, <nofail>][, <IsAllLine>] ) . .  read whole line
##
if "ReadAllLine" in ANUPQ_PROVIDE_FUNCTIONS then
  InstallMethod( ReadAllLine, "iostream,boolean,function", 
          [ IsInputOutputStream, IsBool, IsFunction ],
      function(iostream, nofail, IsAllLine)
      local line, fd, moreOfline;
      line := ReadLine(iostream);
      if nofail or line <> fail then
          fd := FileDescriptorOfStream(iostream);
          if line = fail then
            line := "";
          fi;
          while not IsAllLine(line) do
              UNIXSelect([fd], [], [], fail, fail);
              moreOfline := ReadLine(iostream);
              if moreOfline <> fail then
                  Append(line, moreOfline);
              fi;
          od;
      fi;
      return line;
  end);
          
  InstallOtherMethod( ReadAllLine, "iostream,boolean", 
          [ IsInputOutputStream, IsBool ],
      function(iostream, nofail)
      return ReadAllLine(iostream, nofail, 
                         line -> 0 < Length(line) and 
                                 line[Length(line)] = '\n');
  end);
          
  InstallOtherMethod( ReadAllLine, "iostream,function", 
          [ IsInputOutputStream, IsFunction ],
      function(iostream, IsAllLine)
      return ReadAllLine(iostream, false, IsAllLine);
  end);
          
  InstallOtherMethod( ReadAllLine, "iostream", 
          [ IsInputOutputStream ],
      iostream -> ReadAllLine(iostream, false)
  );
          
  # For an input stream that is not an input/output stream it's really
  # inappropriate to call ReadAllLine. We provide the functionality of
  # ReadLine only, in this case.
  InstallMethod( ReadAllLine, "stream,boolean,function", 
          [ IsInputStream, IsBool, IsFunction ],
      function(stream, nofail, IsAllLine)
      return ReadLine(stream); #ignore other arguments
  end);
          
  InstallOtherMethod( ReadAllLine, "stream,boolean", 
          [ IsInputStream, IsBool ],
      function(stream, nofail)
      return ReadLine(stream); #ignore other argument
  end);
          
  InstallOtherMethod( ReadAllLine, "stream,function", 
          [ IsInputStream, IsFunction ],
      function(stream, IsAllLine)
      return ReadLine(stream); #ignore other argument
  end);
          
  InstallOtherMethod( ReadAllLine, "stream", 
          [ IsInputStream ], ReadLine
  );
fi;
        
#############################################################################
##
##  We don't need this anymore.
##
Unbind( ANUPQ_PROVIDE_FUNCTIONS );

#E  anupq4r2cpt.gi  . . . . . . . . . . . . . . . . . . . . . . . . ends here 
