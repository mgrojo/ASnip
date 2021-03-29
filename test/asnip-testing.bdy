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

with ASnip.Ada_Language;
with ASnip.Token.Ada_Scanner;
with ASnip.IO, Char_IO;
with set_env_var;

with Ada.Text_IO;
with Ada.Streams.Stream_IO;

with Interfaces;

package body ASnip.Testing is

   package Report_IO renames Ada.Text_IO;

   function to_UTF_8 (s: STR) return STRING;
      -- `s` as a string of `CHARACTER` octets, UTF-8 encoded


   procedure reading is
         c: CHAR;
         use Ada, Ada.Streams.Stream_IO;

         input_file: FILE_TYPE;
         output_file: FILE_TYPE;
         input: STREAM_ACCESS;
         output: STREAM_ACCESS;

      begin

         U8: begin
            open(input_file, In_File, "text.8");
            create(output_file, Out_File, "text.8.test");
            input := stream(input_file);
            output := stream(output_file);
            -- set explicitly, could use `set_reader` parameter, see below
            set_env_var("LC_CTYPE", "fr_FR.UTF-8");
            IO.set_reader;
            IO.set_writer;
            loop
               c := Char_IO.read_next_char(IO.next_char.all, input);
               STRING'write(output, to_UTF_8((1 => c)));
            end loop;
         exception
            when End_Error =>
               close(input_file);
               close(output_file);
            when Status_Error =>
               Report_IO.put_line("U8!");
               raise;
         end U8;

         U16: begin
            open(input_file, In_File, "text.16");
            create(output_file, Out_File, "text.16.test");
            input := stream(input_file);
            output := stream(output_file);
            set_env_var("LC_CTYPE","fr.UTF-16");
            IO.set_reader;
            IO.set_writer;
            loop
               c := Char_IO.read_next_char(IO.next_char.all, input);
               CHAR'write(output, c);
            end loop;
         exception
            when End_Error =>
               close(input_file);
               close(output_file);
            when Status_Error =>
               Report_IO.put_line("U16!");
               raise;
         end U16;

         U16x: begin
            open(input_file, In_File, "text.16x");
            create(output_file, Out_File, "text.16x.test");
            input := stream(input_file);
            output := stream(output_file);
            IO.set_reader("fr_FR.UTF-16BE");
            IO.set_writer("fr_FR.UTF-16BE");
            loop
               c := Char_IO.read_next_char(IO.next_char.all, input);
               CHAR'write(output, c);
            end loop;
         exception
            when End_Error =>
               close(input_file);
               close(output_file);
            when Status_Error =>
               Report_IO.put_line("U16x!");
               raise;
         end U16x;

         --unsetenv(new_string("LC_CTYPE")); --?
      end reading;


   procedure reserved_word_search is
         use Ada_Language;
      begin
         if not is_reserved_word(Keywords, "aborT") then
            raise Program_Error;
         end if;
         if is_reserved_word(Keywords, "aborT_") then
            raise Program_Error;
         end if;
         if is_reserved_word(Keywords, "_aborT") then
            raise Program_Error;
         end if;
         if is_reserved_word(Keywords, "_aborT_") then
            raise Program_Error;
         end if;
         if is_reserved_word(Keywords, "abortion") then
            raise Program_Error;
         end if;
         if is_reserved_word(Keywords, "abo") then
            raise Program_Error;
         end if;
         if is_reserved_word(Keywords, "bor") then
            raise Program_Error;
         end if;
         if is_reserved_word(Keywords, "ort") then
            raise Program_Error;
         end if;
         if is_reserved_word(Keywords, "") then
            raise Program_Error;
         end if;

         if not (is_reserved_word(Keywords, "range") and
                 is_reserved_word(Attributes, "range"))
         then
            raise Program_Error;
         end if;

      end reserved_word_search;


   -- Open one of the source files for reading (this one, actually),
   -- pass it to a scanner object and have it tokenized (phase 1, simple
   -- tokens). Then, write the result into another file for comparison.
   -- The will have to be be equal. See the Makefile in this directory.

   -- So that this isn't too trivial, here are some non-7bit characters:
   -- Is Chaikovsky, Petr Ilyich, written Чайковский ?
   -- Σωκράτης hasn't died of cancer, has he?
   -- The author lives in 德國.

   procedure simple_tokenizing is

         use Token, Ada.Streams.Stream_IO;


         procedure print_simple is
            new Ada_Scanner.visit_all_simple_tokens(process => IO.write_simple);

         input_file_name: constant STRING := "asnip-testing.bdy";
         output_file_name: constant STRING := "asnip-testing.bdy.test";
         input_file: FILE_TYPE;
         output_file: FILE_TYPE;
         input: STREAM_ACCESS;
         output: STREAM_ACCESS;

      begin

         Report_IO.put(" input " & input_file_name & ".");
         open(input_file, In_File, input_file_name);
         create(output_file, Out_File, output_file_name);
         input := stream(input_file);
         output := stream(output_file);

         -- IO.set_reader; --?
         IO.set_writer;
         IO.set_output(IO.STREAM_ACCESS(output));

         declare
            scanner: Ada_Scanner.ADA_SCANNER_OBJ(input);
         begin
            Ada_Scanner.produce_simple_tokens(scanner);
            print_simple(scanner);
         end;
         close(input_file);
         close(output_file);
      end simple_tokenizing;

   function to_UTF_8 (s: STR) return STRING is

      use Interfaces;

      result: STRING(1.. 4 * s'length);
      --  Unicode has at most 4 bytes for a UTF-8 encoded character

      k: POSITIVE := result'first;
      --  in the loop, points to the first insertion position of a
      -- "byte sequence". (Can't use range because `s = ""` is possible.)

      bits: UNSIGNED_32 := 2#0#;
      --  the bits representing the WIDE_CHARACTER

      subtype CH is Character;
      --  abbreviation

      B6: constant := 2#111111#;

   begin

      for j in s'range loop
         bits := WIDE_CHARACTER'pos(s(j));


         if bits <= 2#1111111# then
            result(k) := Ch'Val(bits);
            k := k + 1;

         elsif bits <= 2#11111_111111# then
            result(k .. k + 1) :=
              (Ch'val(2#110_00000# or (shift_right(bits, 1 * 6) and 2#11111#)),
               Ch'val(2#10_000000# or (shift_right(bits, 0 * 6) and B6)));
            k := k + 2;

         elsif
           bits = 16#fffe#
           or bits = 16#ffff#
         then
            -- ignore non-characters
            null;

         elsif bits <= 2#1111_111111_111111# then
            result(k .. k + 2) :=
              (Ch'val(2#1110_0000# or (shift_right(bits, 2 * 6) and 2#1111#)),
               Ch'val(2#10_000000# or (shift_right(bits, 1 * 6) and B6)),
               Ch'val(2#10_000000# or (shift_right(bits, 0 * 6) and B6)));
            k := k + 3;

         elsif bits <= 2#111_111111_111111_111111# then
            result(k .. k + 3) :=
              (Ch'val(2#11110_000# or (shift_right(bits, 3 * 6) and 2#111#)),
               Ch'val(2#10_000000# or (shift_right(bits, 2 * 6) and B6)),
               Ch'val(2#10_000000# or (shift_right(bits, 1 * 6) and B6)),
               Ch'val(2#10_000000# or (shift_right(bits, 0 * 6) and B6)));
            k := k + 4;

         else
            -- not Unicode
            raise Constraint_Error;

         end if;
      end loop;

      return result(1.. k - 1);

   end to_UTF_8;

end ASnip.Testing;

