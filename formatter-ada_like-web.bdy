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


--TODO: use empty suffix?

package body Formatter.Ada_Like.WEB is


   begin_group: constant ASnip.STR := "{";
      -- begin a TeX group

   end_group: constant ASnip.STR := "}";
      -- end a TeX group

   function math_ensured(s: ASnip.STR) return ASnip.STR;
      -- makes sure `s` occurs in math mode

   function null_fix(t: ADA_LIKE_OBJ) return ASnip.STR;
      -- the empty string
      pragma inline(null_fix);


   function math_ensured(s: ASnip.STR) return ASnip.STR is
      begin
         return "\ifmmode" & s & "\else$" & s & "$\fi ";
      end;

   function null_fix(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         return "";
      end;

   function empty_prefix(t: ADA_LIKE_OBJ) return ASnip.STR renames null_fix;
   function empty_suffix(t: ADA_LIKE_OBJ) return ASnip.STR renames null_fix;


   function replace(s: ASnip.STR) return ASnip.STR;
      -- TeX character escapes

   function replace(s: ASnip.STR) return ASnip.STR is
         result: ASnip.STR(1 .. 4 * s'length);
            -- e.g. a string of all '~'
         k: POSITIVE range result'first .. result'last + 1 := result'first;
      begin
         for j in s'range loop
            case s(j) is
                  -- see also GCC Bug #27225
               when '{' | '}' | ' ' | '_' | '#' | '$' | '%' | '^' =>
                  result(k .. k + 1) := (1 => '\', 2 => s(j));
                  k := k + 2;
               when '&' =>
                  result(k .. k + 3) :=
                     (1 => '\', 2 => 'A', 3 => 'M', 4 => ' ');
                  k := k + 4;
               when '\' =>
                  result(k .. k + 3) :=
                     (1 => '\', 2 => 'B', 3 => 'S', 4 => ' ');
                  k := k + 4;
               when '`' =>
                  result(k .. k + 3) :=
                     (1 => '\', 2 => 'L', 3 => 'Q', 4 => ' ');
                  k := k + 4;
               when ''' =>
                  result(k .. k + 3) :=
                     (1 => '\', 2 => 'R', 3 => 'Q', 4 => ' ');
                  k := k + 4;
               when '~' =>
                  result(k .. k + 3) :=
                     (1 => '\', 2 => 'T', 3 => 'L', 4 => ' ');
                  k := k + 4;
               when others =>
                  result(k) := s(j);
                  k := k + 1;
            end case;
         end loop;
         return result(1 .. k - 1);
      end replace;


   ---

   function prefix_of_attr(t: ATTR_TOKEN) return ASnip.STR is
      begin
         return "\&" & begin_group; -- % boldface type for reserved words
      end;

   function image_of_attr(t: ATTR_TOKEN) return ASnip.STR is
      begin
         return token_text(t);
      end;

   function suffix_of_attr(t: ATTR_TOKEN) return ASnip.STR is
      begin
         return end_group;
      end;


   function prefix_of_chr(t: ADA_LIKE_OBJ) return ASnip.STR
      renames empty_prefix;

   function image_of_chr(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         return replace(token_text(t));
      end;

   function suffix_of_chr(t: ADA_LIKE_OBJ) return ASnip.STR
      renames empty_suffix;


   function prefix_of_cmt(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         return "\hbox{-{}-}\C" & begin_group;
      end;

   function image_of_cmt(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         return replace(token_text(t));
      end image_of_cmt;

   function suffix_of_cmt(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         return end_group;
      end;


   function prefix_of_del(t: ADA_LIKE_OBJ) return ASnip.STR
      renames empty_prefix;

   function image_of_del(t: ADA_LIKE_OBJ) return ASnip.STR is
         del_txt: constant ASnip.STR := token_text(t);
      begin
         if del_txt = ".." then
            return math_ensured("\to ");
         end if;
         return math_ensured(del_txt);
      end image_of_del;

   function suffix_of_del(t: ADA_LIKE_OBJ) return ASnip.STR
      renames empty_suffix;


   function prefix_of_id(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         return "\\" & begin_group; -- % italic type for identifiers
      end;

   function image_of_id(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         return replace(token_text(t));
      end;

   function suffix_of_id(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         return end_group;
      end;


   function prefix_of_op(t: ADA_LIKE_OBJ) return ASnip.STR
      renames empty_prefix;

   function image_of_op(t: ADA_LIKE_OBJ) return ASnip.STR is
         op_txt: constant ASnip.STR := token_text(t);
      begin
         if op_txt = "&" then
            return replace(op_txt);
         end if;
         return math_ensured(op_txt);
      end;

   function suffix_of_op(t: ADA_LIKE_OBJ) return ASnip.STR
      renames empty_suffix;


   function prefix_of_num(t: ADA_LIKE_OBJ) return ASnip.STR
      renames empty_prefix;

   function image_of_num(t: ADA_LIKE_OBJ) return ASnip.STR is
         num_txt: constant ASnip.STR := replace(token_text(t));
      begin
         return "\ifmmode" & num_txt & "\else$" & num_txt & "$\fi ";
      end;

   function suffix_of_num(t: ADA_LIKE_OBJ) return ASnip.STR
      renames empty_suffix;


   function prefix_of_res(t: RES_TOKEN) return ASnip.STR is
      begin
         return "\&" & begin_group; -- % boldface type for reserved words
      end;

   function image_of_res(t: RES_TOKEN) return ASnip.STR is
      begin
         return token_text(t);
      end;

   function suffix_of_res(t: RES_TOKEN) return ASnip.STR is
      begin
         return end_group;
      end;


   function prefix_of_sep(t: ADA_LIKE_OBJ) return ASnip.STR
      renames empty_prefix;

   function image_of_sep(t: ADA_LIKE_OBJ) return ASnip.STR is
         sep_txt: constant ASnip.CHAR := source_text(t)(1);
      begin
         -- line ends: \CRmacro looking at next occurence of \LFmacro skipping
         if sep_txt = ' ' then
            return "\ ";
         elsif sep_txt = ASnip.CHAR'val(13) then
            return "";  -- Do nothing. Anyone a Mac that doesn't understand \n?
         elsif sep_txt = ASnip.CHAR'val(10) then
            return "\6" & ASnip.CHAR'val(10);
         elsif sep_txt = '{' or else sep_txt = '}' then
            return math_ensured(replace((1 => sep_txt)));
         else
            return replace(token_text(t));
         end if;
      end;

   function suffix_of_sep(t: ADA_LIKE_OBJ) return ASnip.STR
      renames empty_suffix;


   function prefix_of_strng(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         return "\." & begin_group;
      end;

   function image_of_strng(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         return replace(token_text(t));
      end image_of_strng;

   function suffix_of_strng(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         return end_group;
      end;

end Formatter.Ada_Like.WEB;
