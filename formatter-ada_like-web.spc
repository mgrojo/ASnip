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

package Formatter.Ada_Like.WEB is

   use ASnip.Lang_Token.Ada_Like;

   -- ----------------------------------------------------------------
   -- Functions producing TeX WEB macros for use with the
   -- `ASnip.Printing.Ada_Like` generic interface package.
   -- ----------------------------------------------------------------

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


end Formatter.Ada_Like.WEB;
