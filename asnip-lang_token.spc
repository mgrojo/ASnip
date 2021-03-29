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

with Ada.Strings.Wide_Bounded;

package ASnip.Lang_Token is

   --pragma preelaborate;
   -- body uses Ada.Tags

   -- ----------------------------------------------------------------
   -- Various lexical elements of some language. Not necessarily
   -- the final language tokens.
   -- ----------------------------------------------------------------

   type LANG_TOKEN_OBJ(position: POSITIVE) is
      abstract tagged private;
      -- a language token that prints, too

   function equals(a, b: LANG_TOKEN_OBJ'class) return BOOLEAN;
      -- at least same `position`, same type, and then dispatches to "=" of
      -- the type

   function source_text(t: LANG_TOKEN_OBJ) return STR;
      -- the characters of source text leading to `t`


   max_token_chars: constant POSITIVE := 300;

private

   procedure extend_text(t: in out LANG_TOKEN_OBJ'class; token_text: STR);
      -- append `token_text` to text already stored in `t`

   package VStrings is
      new Ada.Strings.Wide_Bounded.Generic_Bounded_Length(max_token_chars);
   subtype VSTR is VStrings.BOUNDED_WIDE_STRING;

   type LANG_TOKEN_OBJ

      (position: POSITIVE)            is abstract tagged record
         -- intent: `position` of the first simple token used for this
         -- language token

      source_text: VSTR := VStrings.Null_Bounded_Wide_String;
         -- source text corresponding to this token as accumulated

   end record;


end ASnip.Lang_Token;
