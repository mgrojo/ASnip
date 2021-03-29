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

with ASnip.Ada_Language.Tests;
with Ada.Strings.Wide_Maps;

package body ASnip.Lang_Token.Ada_Like is


   procedure check_is_Ada(tok: in out ADA_LIKE_OBJ) is
         txt: constant STR := source_text(tok);
         use Ada.Strings.Wide_Maps;
      begin
         case tok.kind is
            when Sep =>
               tok.proper := txt'length = 1
                 and then is_in(txt(txt'first),
                                Ada_Language.Tests.delimiter);
            when Id =>
               tok.proper := txt'length > 0
                 and then is_in(txt(txt'first),
                                Ada_Language.Tests.ident_start);
            when others =>
               null; -- use default
         end case;
      end check_is_Ada;

   procedure check_is_attribute(tok: in out ATTR_TOKEN) is
      begin
         tok.known := Ada_Language.is_reserved_word(Ada_Language.Attributes,
                                                    source_text(tok));
      end;

   function is_known(tok: ADA_LIKE_OBJ) return BOOLEAN is
      begin
         return tok.proper;
      end;

   function is_known(tok: ATTR_TOKEN) return BOOLEAN is
      begin
         pragma assert(tok.proper); -- just checking
         return tok.known;
      end;


end ASnip.Lang_Token.Ada_Like;
