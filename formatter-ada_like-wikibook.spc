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

with ASnip.Lang_Token.Ada_Like;

package Formatter.Ada_Like.WiKiBook is

   pragma elaborate_body;

   use ASnip.Lang_Token.Ada_Like;

   -- ----------------------------------------------------------------
   -- Functions producing MediaWiKi markup as used with the Ada
   -- wiki book at http://en.wikibooks.org. For use with the
   -- `ASnip.Printing.Ada_Like` generic interface package.
   -- ----------------------------------------------------------------

   -- NOTES:
   -- Not every dotted name of a package like `A.B.C` is automatically
   -- decorated as {{Ada/package|A|B|C}}. For example deciding that "is
   -- new A.B.C" is part of an instantiation of generic package `A.B.C`
   -- needs more information than is available here now. (And by design,
   -- ASnip must decorate incorrect input, too.) The functions have access
   -- to the current token and a small state machine. The machine is
   -- started by a `RES_TOKEN` that stands for "package", "with", or "use".
   -- Separator tokens move it to the next state. An identifier token will
   -- move it again. Then the machine enters a loop of dots and identifiers.
   -- It stops when some other token is read.
   --
   --   LP        ->  "package" Separator Pack
   --   Separator ->  sep | sep Separator
   --   Pack      ->  id | id "." Pack

   function prefix_of_attr(t: ATTR_TOKEN) return ASnip.STR;

   function image_of_attr(t: ATTR_TOKEN) return ASnip.STR;

   function suffix_of_attr(t: ATTR_TOKEN) return ASnip.STR;


   function prefix_of_chr(t: ADA_LIKE_OBJ) return ASnip.STR;

   function image_of_chr(t: ADA_LIKE_OBJ) return ASnip.STR;

   function suffix_of_chr(t: ADA_LIKE_OBJ) return ASnip.STR;


   function prefix_of_cmt(t: ADA_LIKE_OBJ) return ASnip.STR;

   function image_of_cmt(t: ADA_LIKE_OBJ) return ASnip.STR;

   function suffix_of_cmt(t: ADA_LIKE_OBJ) return ASnip.STR;


   function prefix_of_del(t: ADA_LIKE_OBJ) return ASnip.STR;

   function image_of_del(t: ADA_LIKE_OBJ) return ASnip.STR;

   function suffix_of_del(t: ADA_LIKE_OBJ) return ASnip.STR;


   function prefix_of_id(t: ADA_LIKE_OBJ) return ASnip.STR;

   function image_of_id(t: ADA_LIKE_OBJ) return ASnip.STR;

   function suffix_of_id(t: ADA_LIKE_OBJ) return ASnip.STR;


   function prefix_of_num(t: ADA_LIKE_OBJ) return ASnip.STR;

   function image_of_num(t: ADA_LIKE_OBJ) return ASnip.STR;

   function suffix_of_num(t: ADA_LIKE_OBJ) return ASnip.STR;


   function prefix_of_sep(t: ADA_LIKE_OBJ) return ASnip.STR;

   function image_of_sep(t: ADA_LIKE_OBJ) return ASnip.STR;

   function suffix_of_sep(t: ADA_LIKE_OBJ) return ASnip.STR;


   function prefix_of_op(t: ADA_LIKE_OBJ) return ASnip.STR;

   function image_of_op(t: ADA_LIKE_OBJ) return ASnip.STR;

   function suffix_of_op(t: ADA_LIKE_OBJ) return ASnip.STR;


   function prefix_of_res(t: RES_TOKEN) return ASnip.STR;

   function image_of_res(t: RES_TOKEN) return ASnip.STR;

   function suffix_of_res(t: RES_TOKEN) return ASnip.STR;


   function prefix_of_strng(t: ADA_LIKE_OBJ) return ASnip.STR;

   function image_of_strng(t: ADA_LIKE_OBJ) return ASnip.STR;

   function suffix_of_strng(t: ADA_LIKE_OBJ) return ASnip.STR;


   function check_eot return ASnip.STR;
      -- in case the library package construction hits end of
      -- input, it will not have finished. But end of input
      -- signals the end of package construction. Makes sure
      -- nothing is lost.


end Formatter.Ada_Like.WiKiBook;

