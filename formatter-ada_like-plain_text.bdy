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

package body Formatter.Ada_Like.Plain_Text is


   function default_image(t: ADA_LIKE_OBJ) return ASnip.STR;
      -- identity
      pragma inline(default_image);

   function default_prefix(t: ADA_LIKE_OBJ) return ASnip.STR;
      -- nothing
      pragma inline(default_prefix);

   function default_suffix(t: ADA_LIKE_OBJ) return ASnip.STR;
      -- nothing
      pragma inline(default_suffix);


   function default_image(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         return token_text(t);
      end default_image;

   function default_prefix(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         return "";
      end;

   function default_suffix(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         return "";
      end;


   ---

   function prefix_of_attr(t: ATTR_TOKEN) return ASnip.STR is
      begin
         return default_prefix(ADA_LIKE_OBJ(t));
      end;

   function image_of_attr(t: ATTR_TOKEN) return ASnip.STR is
      begin
         return token_text(t);
      end;

   function suffix_of_attr(t: ATTR_TOKEN) return ASnip.STR is
      begin
         return default_suffix(ADA_LIKE_OBJ(t));
      end;


   function prefix_of_chr(t: ADA_LIKE_OBJ) return ASnip.STR
      renames default_prefix;

   function image_of_chr(t: ADA_LIKE_OBJ) return ASnip.STR
      renames default_image;

   function suffix_of_chr(t: ADA_LIKE_OBJ) return ASnip.STR
      renames default_suffix;


   function prefix_of_cmt(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         return "--";
      end;

   function image_of_cmt(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         -- this is where comment parsing could be done
         return default_image(t);
      end;

   function suffix_of_cmt(t: ADA_LIKE_OBJ) return ASnip.STR
      renames default_suffix;


   function prefix_of_del(t: ADA_LIKE_OBJ) return ASnip.STR
      renames default_prefix;

   function image_of_del(t: ADA_LIKE_OBJ) return ASnip.STR
      renames default_image;

   function suffix_of_del(t: ADA_LIKE_OBJ) return ASnip.STR
     renames default_suffix;


   function prefix_of_id(t: ADA_LIKE_OBJ) return ASnip.STR
      renames default_prefix;

   function image_of_id(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         return token_text(t);
      end;

   function suffix_of_id(t: ADA_LIKE_OBJ) return ASnip.STR
     renames default_suffix;


   function prefix_of_op(t: ADA_LIKE_OBJ) return ASnip.STR
      renames default_prefix;

   function image_of_op(t: ADA_LIKE_OBJ) return ASnip.STR
      renames default_image;

   function suffix_of_op(t: ADA_LIKE_OBJ) return ASnip.STR
      renames default_suffix;


   function prefix_of_num(t: ADA_LIKE_OBJ) return ASnip.STR
      renames default_prefix;

   function image_of_num(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         return token_text(t);
      end;

   function suffix_of_num(t: ADA_LIKE_OBJ) return ASnip.STR
      renames default_suffix;


   function prefix_of_res(t: RES_TOKEN) return ASnip.STR is
      begin
         return default_prefix(ADA_LIKE_OBJ(t));
      end;

   function image_of_res(t: RES_TOKEN) return ASnip.STR is
      begin
         return token_text(t);
      end;

   function suffix_of_res(t: RES_TOKEN) return ASnip.STR is
      begin
         return default_suffix(ADA_LIKE_OBJ(t));
      end;


   function prefix_of_sep(t: ADA_LIKE_OBJ) return ASnip.STR
      renames default_prefix;

   function image_of_sep(t: ADA_LIKE_OBJ) return ASnip.STR
      renames default_image;

   function suffix_of_sep(t: ADA_LIKE_OBJ) return ASnip.STR
      renames default_suffix;


   function prefix_of_strng(t: ADA_LIKE_OBJ) return ASnip.STR
      renames default_prefix;

   function image_of_strng(t: ADA_LIKE_OBJ) return ASnip.STR
      renames default_image;

   function suffix_of_strng(t: ADA_LIKE_OBJ) return ASnip.STR
      renames default_suffix;

end Formatter.Ada_Like.Plain_Text;
