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

with Ada.Strings.Wide_Maps;
with Ada.IO_Exceptions;
with ASnip.Ada_Language.Tests;
with ASnip.IO, Char_IO;
   pragma Elaborate_All(ASnip.IO);
--with ASnip.Lang_Token.Sequences;

package body ASnip.Token.Ada_Scanner is

   package Walls renames ASnip.Lang_Token.Sequences;

   procedure produce_Ada_tokens
      (scanner: in out ADA_SCANNER_OBJ; queue: in out Walls.VECTOR) is separate;

   procedure produce_simple_tokens(scanner: in out ADA_SCANNER_OBJ) is

         use Token.Sequences, Ada.Strings.Wide_Maps, Ada_Language.Tests;


         package BIO is
            -- buffers

            Max_Token_Length: constant := 1024;

            subtype BUFFER_INDEX is POSITIVE range 1 .. Max_Token_Length;

            text: STR(BUFFER_INDEX);
               -- for tokens comprised of more than a single character

            last: BUFFER_INDEX'base := 0;
               -- index of last character stored in `text` if any
               -- ! assert text'first - 1 = 0

            c: CHAR;
               -- one charcter is read at a time

            pos: POSITIVE := 1;
               -- number of the charcter last read, i.e. number of
               -- charcaters read so far

         end BIO;



         procedure flush_previous;
            -- append a text token and reset `BIO.last`


         procedure flush_previous is
            begin
               if BIO.last /= 0 then
                  append(scanner.simple_toks,
                     TOKEN_OBJ'(lo => BIO.pos - BIO.last + 1,
                                hi => BIO.pos,
                                kind => Id_Num, --?
                                text => BIO.text(1 .. BIO.last)));
                  BIO.last := 0;
               end if;
            end flush_previous;

         use type IO.READER;
         --use type IO.STREAM_ACCESS;

         state: LEXICAL_KIND := Unk;

      begin  -- `produce_simple_tokens`

         pragma assert(scanner.stage = Start);
         --pragma assert(scanner.source /= null);  -- TODO!
         pragma assert(IO.next_char /= null);

         scanner.unknown := False;


         IO.set_reader;
         loop
            BIO.c := Char_IO.read_next_char(IO.next_char.all, scanner.source);

            if
               BIO.c = '"'
               -- treat string brackets like delimiters here
               or is_in(BIO.c, Delimiter)
            then
               if state /= Del then
                  flush_previous;
                  state := Del;
               end if;

               append(scanner.simple_toks,
                  TOKEN_OBJ'(lo => BIO.pos,
                             hi => BIO.pos,
                             kind => Del,
                             text => (1 => BIO.c)));

            elsif is_in(BIO.c, Ident_or_Number) then
               if state /= Id_Num then
                  flush_previous;
                  state := Id_Num;
               end if;

               BIO.last := BIO.last + 1;
               BIO.text(BIO.last) := BIO.c;

            elsif is_in(BIO.c, Spaces) then
               if state /= Spc then
                  flush_previous;
                  state := Spc;
               end if;

               append(scanner.simple_toks,
                  TOKEN_OBJ'(lo => BIO.pos,
                             hi => BIO.pos,
                             kind => Spc,
                             text => (1 => BIO.c)));

            else
               scanner.unknown := True;

               if state /= Unk then
                  flush_previous;
                  state := Unk;
               end if;

               append(scanner.simple_toks,
                  TOKEN_OBJ'(lo => BIO.pos,
                             hi => BIO.pos,
                             kind => Unk,
                             text => (1 => BIO.c)));
            end if;

            BIO.pos := BIO.pos + 1;
         end loop;

      exception
         when Ada.IO_Exceptions.End_Error =>
            flush_previous;
            append(scanner.simple_toks, Bottom);
         when Ada.IO_Exceptions.Device_Error =>
            -- Pipes in windows?
            flush_previous;
            append(scanner.simple_toks, Bottom);
      end produce_simple_tokens;


   function successful(scanner: ADA_SCANNER_OBJ) return BOOLEAN is
      begin
         return not scanner.unknown;
      end;


   procedure visit_all_simple_tokens(scanner: ADA_SCANNER_OBJ) is
         use Token.Sequences;

         c: CURSOR := first(scanner.simple_toks);
      begin
         while has_element(c) loop
            process(c);
            next(c);
         end loop;
      end;

end ASnip.Token.Ada_Scanner;
