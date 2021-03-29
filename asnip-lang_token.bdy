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

with Ada.Tags;
package body ASnip.Lang_Token is

   function equals(a, b: LANG_TOKEN_OBJ'class) return BOOLEAN is
         use Ada.Tags;
      begin
         return a.position = b.position and then a'tag = b'tag and then a = b;
      end;

   procedure extend_text(t: in out LANG_TOKEN_OBJ'class; token_text: STR) is
         use VStrings;
      begin
         append(t.source_text, token_text);
      end;

   function source_text(t: LANG_TOKEN_OBJ) return STR is
         use VStrings;
      begin
         return to_wide_string(t.source_text);
      end;

end ASnip.Lang_Token;
