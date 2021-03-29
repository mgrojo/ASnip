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

with Ada.Strings.Wide_Maps.Wide_Constants;
with ASnip.Token;

package ASnip.Ada_Language.Tests is

   use Ada.Strings.Wide_Maps, Ada_Language, Token;

   -- ----------------------------------------------------------------
   -- for classifying token text
   -- ----------------------------------------------------------------

   subtype CHAR_SET is WIDE_CHARACTER_SET;

   Delimiter: constant CHAR_SET :=
      -- delimiters of length 1
      to_set(Syntax.Delimiter_1);

   Number: constant CHAR_SET :=
      -- characters that can occur in a number
      to_set(Syntax.Number_Letters);

   Ident_Start: constant CHAR_SET :=
      -- characters that can start an identifier
      Wide_Constants.Letter_Set
      or to_set(Syntax.Greek_Letters)
      or to_set(Syntax.European_Letters);

   Ident_or_Number: constant CHAR_SET :=
      --  characters found in a number or in an identfier
      Ident_Start
      or Number
      or to_set("_");

   Spaces: constant CHAR_SET :=
      -- defined to be white space
      to_set(" " & CHAR'val(9) & CHAR'val(10) & CHAR'val(13));


   function is_number(tok: TOKEN_OBJ) return BOOLEAN;
      -- `tok` is numeric from left to right

   function is_identifier(tok: TOKEN_OBJ) return BOOLEAN;
      -- `tok` has only identifier charcters and starts with
      -- a letter

   function is_line_end(tok: TOKEN_OBJ) return BOOLEAN;
      -- one of the known line ending characters.
      -- (HOWTO for VMS?)

end ASnip.Ada_Language.Tests;
