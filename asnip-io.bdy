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

with Ada.Characters.Handling;
with ASnip.Support;
with ASnip.Lang_Token.Ada_Like;
with ASnip.Token;
with set_env_var;

with Char_IO;

package body ASnip.IO is

   output: STREAM_ACCESS := null;
   write: WRITER := null;

   procedure print_special(text: STR) is
      begin
         write(text);
      end;

   procedure set_output(channel: STREAM_ACCESS) is
      begin
         output := channel;
      end;

   -- NOTE: `ISO_8859` text just converted to CHAR. Only the Ada 95 "native"
   -- character set (WIDE_CHARACTER, really) is used for now.

   procedure set_reader(encoding: STRING := "") is
      begin
         if encoding /= "" then
            set_env_var("LC_CTYPE", encoding);
         end if;
         case Support.input_encoding is
            when ISO_8859 => next_char := Char_IO.R8859'access;
            when UTF_8 => next_char := Char_IO.RUTF8'access;
            when UTF_16 => next_char := Char_IO.RUTF16'access;
            when UTF_16LE => next_char := Char_IO.RUTF16LE'access;
         end case;
      end set_reader;


   procedure set_writer(encoding: STRING := "") is
      begin
         if encoding /= "" then
            set_env_var("LC_CTYPE", encoding);
         end if;
         case Support.input_encoding is
            when ISO_8859 => write := IO.write_iso_8859'access;
            when UTF_8 => write := IO.write_utf_8'access;
            when UTF_16 => write := IO.write_utf_16'access;
            when UTF_16LE => write := IO.write_utf_16le'access;
         end case;
      end set_writer;


   procedure write_ada_like(c: Lang_Token.Sequences.CURSOR) is
         use ASnip.Lang_Token.Ada_Like, Printers;
         a_t: constant ADA_LIKE_OBJ'class :=
           ADA_LIKE_OBJ'class(Lang_Token.Sequences.element(c));
         t: ADA_LIKE_OBJ renames ADA_LIKE_OBJ(a_t);
      begin
         case t.kind is
            when Attr =>
               write(prefix_of_attr(ATTR_TOKEN(a_t)));
               write(image_of_attr(ATTR_TOKEN(a_t)));
               write(suffix_of_attr(ATTR_TOKEN(a_t)));
            when Chr =>
               write(prefix_of_chr(t));
               write(image_of_chr(t));
               write(suffix_of_chr(t));
            when Cmt =>
               -- for a start, simply print
               write(prefix_of_cmt(t));
               write(image_of_cmt(t));
               write(suffix_of_cmt(t));
            when Del =>
               write(prefix_of_del(t));
               write(image_of_del(t));
               write(suffix_of_del(t));
            when Id =>
               write(prefix_of_id(t));
               write(image_of_id(t));
               write(suffix_of_id(t));
            when Num =>
               write(prefix_of_num(t));
               write(image_of_num(t));
               write(suffix_of_num(t));
            when Op =>
               write(prefix_of_op(t));
               write(image_of_op(t));
               write(suffix_of_op(t));
            when Res =>
               write(prefix_of_res(RES_TOKEN(a_t)));
               write(image_of_res(RES_TOKEN(a_t)));
               write(suffix_of_res(RES_TOKEN(a_t)));
            when Sep =>
               write(prefix_of_sep(t));
               write(image_of_sep(t));
               write(suffix_of_sep(t));
            when Strng =>
               write(prefix_of_strng(t));
               write(image_of_strng(t));
               write(suffix_of_strng(t));
         end case;
      end write_ada_like;


   procedure write_iso_8859(text: STR) is
         use Ada.Characters.Handling;
      begin
         STRING'write(output, to_string(text));
      end;

   procedure write_simple(c: Token.Sequences.CURSOR) is
      begin
         write.all(Token.text(Token.Sequences.element(c)));
      end;

   procedure write_utf_8(text: STR) is
      begin
         STRING'write(output, Support.to_UTF_8(text));
      end;

   procedure write_utf_16(text: STR) is
      begin
         -- hmm... endianness?
         STR'write(output, text);
      end;

   procedure write_utf_16le(text: STR) is
      begin
         -- hmm... endianness?
         STR'write(output, text);
      end;

end ASnip.IO;

