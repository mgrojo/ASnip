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

with ASnip.Support;
with Ada.Strings.Wide_Maps.Wide_Constants;

package body ASnip.Ada_Language.Tests is


   function not_a_char(c: CHAR) return BOOLEAN;
      -- not an identifier character
      -- see `is_identifier`

   function not_a_num(c: CHAR) return BOOLEAN;
      -- not a number character
      -- see `is_number`


   function is_identifier(tok: TOKEN_OBJ) return BOOLEAN is
         function index_non_char is
            new Support.find_first(test => not_a_char);
         token_text: constant STR := text(tok);
      begin
         if not is_in(token_text(token_text'first), Ident_Start) then
            return False;
         else
            return index_non_char(token_text(token_text'first + 1 ..
                                             token_text'last)) = 0;
         end if;
      end is_identifier;

   function is_line_end(tok: TOKEN_OBJ) return BOOLEAN is
         token_text: constant STR := text(tok);
      begin
         return token_text'length = 1 and then
           (CHAR'pos(token_text(token_text'first)) = 10
            or CHAR'pos(token_text(token_text'first)) = 13);
      end;


   function is_number(tok: TOKEN_OBJ) return BOOLEAN is
         function index_non_num is
            new Support.find_first(test => not_a_num);
         token_text: constant STR := text(tok);
      begin
         if not is_in(token_text(token_text'first),
                      Wide_Constants.Decimal_Digit_Set)
         then
            return False;
         else
            return index_non_num(token_text(token_text'first + 1 ..
                                            token_text'last)) = 0;
         end if;
      end is_number;


   function not_a_char(c: CHAR) return BOOLEAN is
      begin
         return not is_in(c, Ident_or_Number);
      end;


   function not_a_num(c: CHAR) return BOOLEAN is
      begin
         return not is_in(c, Number);
      end;

end ASnip.Ada_Language.Tests;
