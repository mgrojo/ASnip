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

with binary_search;
with Ada.Strings.Wide_Fixed;

package body ASnip.Ada_Language is


   -- set up the binary search for keywords

   function "<"(a, b: WORD) return BOOLEAN;
      -- `a` is sorted before `b` by characters
      -- ! pre: same letter case of ASCII characters in `a` and `b`

   function "="(a, b: WORD) return BOOLEAN;
      -- same characters
      -- ! pre: same letter case of ASCII characters in `a` and `b`

   -- NOTE: `is_reserved_word` arranges for proper character case


   function "<"(a, b: WORD) return BOOLEAN is
      begin
         return a.all < b.all;
      end "<";

   function "="(a, b: WORD) return BOOLEAN is
      begin
         return a'length = b'length and then
            a.all = b.all;
      end "=";

   function contains is new binary_search
      (ELEMENT => WORD,
       INDEX => WORDS_IDX,
       SORTED_LIST => WORDLIST);


   -- Perform comparison such that upper and lower case ASCII letters
   -- are considered equal. (For searching lists of reserved words.)
   -- See `Support.Comp_Mapping`

   use Ada.Strings.Wide_Maps, Ada.Strings.Wide_Fixed;



   function is_reserved_word(list: WORDLIST; s: STR) return BOOLEAN is
         S_ascii_up: aliased constant STR :=
            translate(s, Support.Comp_Mapping);
      begin
         return contains(list, S_ascii_up'unchecked_access);
      end is_reserved_word;


end ASnip.Ada_Language;
