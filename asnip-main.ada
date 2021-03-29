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

with Ada.Text_IO;
with standard_input_stream, standard_output_stream;
with Ada.Command_Line;
with Ada.Characters.Handling;
with Ada.Exceptions;

with ASnip.Token.Ada_Scanner;
with ASnip.Printing.Ada_Like;

with ASnip.IO;

with Formatter.Ada_Like.HTML,
   Formatter.Ada_Like.Plain_Text,
   Formatter.Ada_Like.WEB,
   Formatter.Ada_Like.WiKiBook;

with ASnip.Lang_Token.Sequences;

procedure ASnip.main is

   use Ada.Text_IO, Token;

   input: IO.STREAM_ACCESS;
   output: IO.STREAM_ACCESS;

   lang: SUPPORTED_LANGUAGE;
   format: Formatter.SUPPORTED_FORMAT;

   invalid_command_line: exception;

begin  -- `ASnip.main`

   -- ----------------------------------------------------------------
   -- Scan the command line. First, choose input language and output
   -- format from respective arguments, if possible. Then assign the
   -- reader and writer procedures. Start the machine using these
   -- settings.
   -- ----------------------------------------------------------------

   if Ada.Command_Line.argument_count = 4 or
      Ada.Command_Line.argument_count = 6
   then
      declare
         use Ada.Command_Line;

         lang_word: constant STRING :=
           Ada.Characters.Handling.to_lower(argument(2));
         format_word: constant STRING :=
           Ada.Characters.Handling.to_upper(argument(4));
      begin
         if argument(1) /= "from" or argument(3) /= "generate" then
            raise invalid_command_line;
         end if;

         if lang_word = "ada" then
            lang := L_Ada;
         else
            raise invalid_command_line;
         end if;

         if format_word = "HTML" then
            format := Formatter.HTML;
         elsif format_word = "TEXT" then
            format := Formatter.Plain_Text;
         elsif format_word = "TEX" then
            format := Formatter.TeX;
         elsif format_word = "WIKIBOOK" then
            format := Formatter.WiKiBook;
         else
            raise invalid_command_line;
         end if;
      end;
   else
      raise invalid_command_line;
   end if;

   if Ada.Command_Line.argument_count = 6 then
      -- an encoding has been specified

         force_enc:
         declare
            use Ada.Command_Line;
         begin
            if argument(5) /= "encoding" then
               raise invalid_command_line;
            end if;
            if argument(6) = "UTF-16" or
               argument(6) = "UTF-16LE" or
               argument(6) = "UTF-8" or
               (argument(6)'length >= 8 and then
                argument(6)(1..8) = "ISO-8859")
            then
               IO.set_reader(argument(6));
               IO.set_writer(argument(6));
            else
               raise invalid_command_line;
            end if;
         end force_enc;
   else
      IO.set_writer;
      IO.set_reader;
   end if;

   open_files:
   begin
      input := standard_input_stream;
      output := standard_output_stream;
   exception
      when e: Use_Error | Name_Error =>
         put_line("Failed opening input file or output file");
         put_line(Ada.Exceptions.exception_information(e));
   end open_files;


   IO.set_output(output);
   -- `input` will be part of the scanner object

   pragma assert(lang'valid);
   pragma assert(format'valid);

   run:
   declare
      scanner: Ada_Scanner.ADA_SCANNER_OBJ(input);
      atoks: Lang_Token.Sequences.VECTOR;
   begin
      case lang is
         when L_Ada =>
            format_Ada:
            declare
               --use Lang_Token.Ada_Like;
            begin
               Ada_Scanner.produce_simple_tokens(scanner);
               Ada_Scanner.produce_Ada_tokens(scanner, atoks);

               case format is
                  when Formatter.HTML =>
                     declare
                        use Formatter.Ada_Like.HTML;
                        package HTML_Printers is new ASnip.Printing.Ada_Like;

                        procedure tok_to_HTML is
                           new IO.write_ada_like(HTML_Printers);

                        procedure print_as_HTML is
                           new Printing.visit_all_Ada_tokens(tok_to_HTML);

                     begin
                        print_as_HTML(atoks);
                     end;

                  when Formatter.Plain_Text =>
                     declare
                        use Formatter.Ada_Like.Plain_Text;
                        package Identities is new ASnip.Printing.Ada_Like;

                        procedure tok_to_text is
                           new IO.write_ada_like(Printers => Identities);

                        procedure print_as_text is
                           new Printing.visit_all_Ada_tokens(tok_to_text);

                     begin
                        print_as_text(atoks);
                     end;

                  when Formatter.TeX =>
                     declare
                        use Formatter.Ada_Like.WEB;
                        package Macros is new ASnip.Printing.Ada_Like;

                        procedure tok_to_TeX is
                           new IO.write_ada_like(Printers => Macros);

                        procedure print_as_TeX is
                           new Printing.visit_all_Ada_tokens(tok_to_TeX);
                     begin
                        print_as_TeX(atoks);
                     end;

                  when Formatter.WiKiBook =>
                     declare
                        use Formatter.Ada_Like.WiKiBook;
                        package Templates is new ASnip.Printing.Ada_Like;

                        procedure tok_to_WiKi is
                           new IO.write_ada_like(Printers => Templates);

                        procedure print_as_WiKi is
                           new Printing.visit_all_Ada_tokens(tok_to_WiKi);
                     begin
                        print_as_WiKi(atoks);
                        IO.print_special(check_eot);
                     end;
               end case;

            end format_Ada;

      end case;
   end run;

exception


   when e: invalid_command_line =>
      put_line(current_error,
         -- $Format: "         \"ASnip $ProjectVersion$ ($ProjectDate$)\");"$
         "ASnip R1.1 (Tue, 23 May 2006 13:24:56 +0200)");
      put_line(current_error,
               "usage: asnip from {lang} generate {format}" &
               " [encoding {encoding}]");
      new_line(current_error);
      put_line(current_error, Ada.Exceptions.exception_name(e));

end ASnip.main;
