--------------------------------------------------------------------------
-- ASnip Source Code Decorator
-- Copyright (C) 2006, Georg Bauhaus
-- 
-- 1. Permission is hereby granted to use, copy, modify and/or distribute
--    this package, provided that:
--        * copyright notices are retained unchanged,
--        * any distribution of this package, whether modified or not,
--          includes this license text.
-- 2. Permission is hereby also granted to distribute binary programs which
--    depend on this package. If the binary program depends on a modified
--    version of this package, you are encouraged to publicly release the
--    modified version of this package.
-- 
-- THIS PACKAGE IS PROVIDED "AS IS" AND WITHOUT WARRANTY. ANY EXPRESS OR
-- IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
-- WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
-- DISCLAIMED. IN NO EVENT SHALL THE AUTHORS BE LIABLE TO ANY PARTY FOR
-- ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
-- DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THIS PACKAGE.
--------------------------------------------------------------------------
--                                                eMail: bauhaus@arcor.de

-- Win32 version of `get_env_var`

with Interfaces.C.Strings;  use Interfaces.C, Interfaces.C.Strings;

function get_env_var(name: STRING) return STRING is
      function GetEnvironmentVariableA
         (nm: chars_ptr; buf: chars_ptr; sz: int) return int;
	     pragma import(StdCall, GetEnvironmentVariableA,
                           "GetEnvironmentVariableA");

      buf: aliased char_array := (1 .. 20 => ' ');
      rc: int := GetEnvironmentVariableA
         (new_string(name), to_chars_ptr(buf'unchecked_access), buf'length - 1);
   begin
      if rc /= 0 and then rc < buf'length then
         return to_Ada(buf);
      else
         return "";
      end if;
   end get_env_var;


