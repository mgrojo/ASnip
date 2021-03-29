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

-- Win32 version of `set_env_var`.

with Interfaces.C.Strings;  use Interfaces.C, Interfaces.C.Strings;

procedure set_env_var(name: STRING; value: STRING) is
      function SetEnvironmentVariableA(name, value: chars_ptr) return int;
         pragma Import(Stdcall, SetEnvironmentVariableA,
                                "SetEnvironmentVariableA");
   begin
      -- Assume `Win32.FALSE = 0`.
      if SetEnvironmentVariableA(new_string(name),
                                 new_string(value)) /= 0 then
          return;
      end if;
      raise Storage_Error;
   end set_env_var;
