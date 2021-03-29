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

with Ada.Strings.Wide_Fixed, Ada.Strings.Wide_Maps;

package body Formatter.Ada_Like.HTML is

   subtype L is ADA_LIKE_OBJ;
      -- abbreviation

   function default_image(t: L'class) return ASnip.STR;
      -- replace every occurence of "<" with "&lt;" and every occurence
      -- of "&" with "&amp;"

   function default_prefix(t: L'class; ident: ASnip.STR) return ASnip.STR;
      -- start a <span> of class `"ada-" & ident`
      pragma inline(default_prefix);

   function unknown_prefix(t: L'class; ident: ASnip.STR) return ASnip.STR;
      -- start a <span> of class `"unk-" & ident`. (The token is not
      -- enough Ada like, hence "unk-" in place of "ada-".)
      pragma inline(unknown_prefix);

   function default_suffix(t: L'class) return ASnip.STR;
      -- end a <span>
      pragma inline(default_suffix);


   function default_image(t: L'class) return ASnip.STR is
         -- &/ map (\s -> if s = "<" then "&lt;" else s) token_text(t)
         -- &/ map (\s -> if s = "&" then "&amp;" else s) token_text(t)
         use Ada.Strings.Wide_Fixed;

         txt: constant ASnip.STR := token_text(t);
         result: ASnip.STR(txt'first .. txt'last -- expensive, for testing
                                        + 3 * count(txt, "<")
                                        + 4 * count(txt, "&"));
         k: POSITIVE := txt'first;
      begin
         for j in txt'range loop
            if txt(j) = '<' then
               workaround_27225:
                  -- Bug #27225 in GCC 4.1.0, slice not assigned properly
               begin
                  --result(k .. k + 3) := "&lt;";
                  result(k .. k + 3) := (1 => '&',
                                         2 => 'l',
                                         3 => 't',
                                         4 => ';');
                  --result(k) := '&';
                  --result(k + 1) := 'l';
                  --result(k + 2) := 't';
                  --result(k + 3) := ';';
               end workaround_27225;
               k := k + 4;
            elsif txt(j) = '&' then
               result(k .. k + 4) := (1 => '&',
                                      2 => 'a',
                                      3 => 'm',
                                      4 => 'p',
                                      5 => ';');
               k := k + 5;
            else
               result(k) := txt(j);
               k := k + 1;
            end if;
         end loop;
         pragma assert(txt'last < txt'first or else k = result'last + 1);
         return result;
      end default_image;


   function default_prefix(t: L'class; ident: ASnip.STR) return ASnip.STR is
      begin
         return "<span class='ada-" & ident & "'>";
      end;

   function default_suffix(t: L'class) return ASnip.STR is
      begin
         return "</span>";
      end;

   function unknown_prefix(t: L'class; ident: ASnip.STR) return ASnip.STR is
      begin
         return "<span class='unk-" & ident & "'>";
      end;

   ---

   function prefix_of_attr(t: ATTR_TOKEN) return ASnip.STR is
      begin
         return default_prefix(t, "attr");
      end;

   function image_of_attr(t: ATTR_TOKEN) return ASnip.STR is
      begin
         return token_text(t);
      end;

   function suffix_of_attr(t: ATTR_TOKEN) return ASnip.STR is
      begin
         return default_suffix(t);
      end;


   function prefix_of_chr(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         return default_prefix(t, "chr");
      end;

   function image_of_chr(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         return default_image(t);
      end;

   function suffix_of_chr(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         return default_suffix(t);
      end;


   function prefix_of_cmt(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         -- Hyphens placed before the `default_prefix`, so that they
         -- will not be included in the CSS formatted <span> for the
         -- comment text proper.
         return "--" & default_prefix(t, "cmt");
      end;

   function image_of_cmt(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         -- this is where comment parsing could be done
         return default_image(t);
      end;

   function suffix_of_cmt(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         return default_suffix(t);
      end;


   function prefix_of_del(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         return default_prefix(t, "del");
      end;

   function image_of_del(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         return default_image(t);
      end;

   function suffix_of_del(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         return default_suffix(t);
      end;


   function prefix_of_id(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         if is_known(t) then
            return default_prefix(t, "id");
         else
            return unknown_prefix(t, "id");
         end if;
      end;

   function image_of_id(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         return token_text(t);
      end;

   function suffix_of_id(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         return default_suffix(t);
      end;


   function prefix_of_op(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         return default_prefix(t, "op");
      end;

   function image_of_op(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         return default_image(t);
      end;

   function suffix_of_op(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         return default_suffix(t);
      end;


   function prefix_of_num(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         return default_prefix(t, "num");
      end;

   function image_of_num(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         return token_text(t);
      end;

   function suffix_of_num(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         return default_suffix(t);
      end;


   function prefix_of_res(t: RES_TOKEN) return ASnip.STR is
      begin
         return default_prefix(t, "res");
      end;

   function image_of_res(t: RES_TOKEN) return ASnip.STR is
      begin
         return token_text(t);
      end;

   function suffix_of_res(t: RES_TOKEN) return ASnip.STR is
      begin
         return default_suffix(t);
      end;


   package Blanks is

      use Ada.Strings.Wide_Maps;

      -- ----------------------------------------------------------------
      -- Says what `ASnip.CHAR` is a blank so that prefix- and
      -- suffix-functions need not wrap white separators in a <span>.
      -- (This is important when line ends are signalled by more
      -- than one (ASnip) separator, as is the case with CR+LF. HTML
      -- software might render wrapped \r and then wrapped \n as two
      -- line breaks.) Must be used constistently by prefix and suffix
      -- functions, otherwise output will not be well-formed.
      -- ----------------------------------------------------------------

      function Is_In (Element: ASnip.CHAR; Set: WIDE_CHARACTER_SET)
                     return BOOLEAN
         renames Ada.Strings.Wide_Maps.is_in;

      White: constant WIDE_CHARACTER_SET :=
         to_set(' ' & ASnip.CHAR'val(9)
                    & ASnip.CHAR'val(10)
                    & ASnip.CHAR'val(11)
                    & ASnip.CHAR'val(12)
                    & ASnip.CHAR'val(13));
   end Blanks;


   function prefix_of_sep(t: ADA_LIKE_OBJ) return ASnip.STR is
         use Blanks;
      begin
         if is_in(source_text(t)(1), White) then
            -- assume special blanks formatting is not necessary
            return "";
         elsif is_known(t) then
            return default_prefix(t, "sep");
         else
            return unknown_prefix(t, "sep");
         end if;
      end prefix_of_sep;

   function image_of_sep(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         return default_image(t);
      end;

   function suffix_of_sep(t: ADA_LIKE_OBJ) return ASnip.STR is
         use Blanks;
      begin
         if is_in(source_text(t)(1), White) then
            return "";
         else
            return default_suffix(t);
         end if;
      end suffix_of_sep;


   function prefix_of_strng(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         return default_prefix(t, "strng");
      end;

   function image_of_strng(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         return default_image(t);
      end;

   function suffix_of_strng(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         return default_suffix(t);
      end;

end Formatter.Ada_Like.HTML;
