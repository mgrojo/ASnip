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

package ASnip.Token is

   --pragma pure;

   type TOKEN_OBJ(<>) is private;
      -- represents a piece of input from which language tokens will
      -- be constructed later

   function same_kind(a, b: TOKEN_OBJ) return BOOLEAN;
      -- the same kind of token

   Bottom: constant TOKEN_OBJ;
      -- end of input

   type LEXICAL_KIND is (Id_Num, Spc, Del, Unk);
      -- the simple tokens that this scanner distinguishes

   function position(t: TOKEN_OBJ) return POSITIVE;
      -- number of the first character of `t` in the input sequence

   function kind(t: TOKEN_OBJ) return LEXICAL_KIND;
      -- `t`'s lexical kind

   function text(t: TOKEN_OBJ) return STR;
      -- input text of `t`


private


   type TOKEN_OBJ

      (lo: POSITIVE;
         -- index of first character read for this token

      hi: POSITIVE;
         --  index of last character read for this token)

      kind: LEXICAL_KIND) is tagged record  -- -> constrained/known?
         -- text category

      text: WIDE_STRING(lo .. hi);
         -- a section of input text from `line` between
         -- `hi` and `lo` inclusive

   end record;


   -- NOTE on `TOKEN_OBJ`: with some/most compilers it seems better
   -- not to declare an object without constraining it at the same
   -- time. Otherwise huge objects might be created, or the program
   -- even crashes due to storage exhaustion. (Reminder to author:
   -- Defaults for the discriminants aren't possible because the type
   -- is tagged.)


   Bottom: constant TOKEN_OBJ := TOKEN_OBJ'(42, 41, Unk, "");
      -- all other tokens have at least one character

end ASnip.Token;

