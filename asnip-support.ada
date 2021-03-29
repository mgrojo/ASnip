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

private package ASnip.Support is

   type WORD is access constant WIDE_STRING;
      -- used for constant definitions of reserved words


   function "+"(s: WIDE_STRING) return WORD;
      -- an allocated WORD object storing the characters of `s`

   generic
      with function test(c: CHAR) return BOOLEAN;
   function find_first(container: STR) return NATURAL;
      -- index of the first character in `container` such that `test`
      -- yields true when applied to the character, or 0

   subtype WORDS_IDX is POSITIVE range 1 .. 2_000;
      -- at most that many reserved words

   type WORDLIST is array(WORDS_IDX range <>) of WORD;
      -- Lists of reserved language words

   use Ada.Strings.Wide_Maps;

   Comp_Mapping: constant WIDE_CHARACTER_MAPPING :=
      -- for making a comparison of reserved names case insensitive
      to_mapping("abcdefghijklmnopqrstuvxyz",
                 "ABCDEFGHIJKLMNOPQRSTUVXYZ");

   type LOCALE_ENV_VAR_NAMES is (LC_CTYPE, LANG, LC_ALL);
      -- names of environment variables telling the character set in use

   function input_encoding return SUPPORTED_ENCODING;
      -- The character encoding found in the enviroment.
      -- If there is none, returns the default. (Currently this
      -- is ISO_8859, for hysteric raisins.)

   function to_UTF_8 (s: STR) return STRING;
      -- `s` as a string of `CHARACTER` octets, UTF-8 encoded

end;

with get_env_var;
with Ada.Command_Line;
with Ada.Strings.Wide_Fixed;
with Ada.Strings.Fixed;
with Ada.Characters.Handling;
with Interfaces;
package body ASnip.Support is

   no_encoding_found: exception;


   function encoding_from_environment return SUPPORTED_ENCODING;
      -- The character encoding found in the enviroment, if any. Uses
      -- the values in `LOCALE_ENV_VAR_NAMES`.

   function encoding_from_command_line return SUPPORTED_ENCODING;
      -- The character encoding found as the first command line
      -- argument, if any. TODO rework/remove...!



   function "+"(s: WIDE_STRING) return WORD is
         use Ada.Strings.Wide_Fixed;
      begin
         return new STR'(translate(s, Comp_Mapping));
      end "+";


   function encoding_from_command_line return SUPPORTED_ENCODING is
         use Ada.Command_Line, Ada.Strings.Fixed, Ada.Characters.Handling;
      begin
         if argument_count = 6 then
            declare
               arg: constant STRING := to_upper(argument(6));
            begin
               if arg = "UTF_8" or arg = "UTF-8" or arg = "UTF8" then
                  return UTF_8;

               elsif arg = "UTF_16" or arg = "UTF-16" or arg = "UTF16" then
                  return UTF_16;

               elsif index(arg, "ISO") > 0 and then index(arg, "8859") > 0 then
                  return ISO_8859;
               end if;
            end;
         end if;
         raise no_encoding_found;
      end encoding_from_command_line;


   function encoding_from_environment return SUPPORTED_ENCODING is
         use Ada.Characters.Handling, Ada.Strings.Fixed;

         var: LOCALE_ENV_VAR_NAMES := LOCALE_ENV_VAR_NAMES'first;
      begin

         -- (Possible enhancement: See whether there is a BE or LE suffix
         -- after UTF-16. Make all `IO.next_char_16*` functions read byte-wise
         -- then, and rotate when necessary.)

         env_search:
         loop
            declare
               locale: constant STRING :=
                  get_env_var(LOCALE_ENV_VAR_NAMES'image(var));
            begin
               if locale /= "" then
                  declare
                     val: constant STRING := to_upper(locale);
                  begin
                     if index(source => val, pattern => "8859") > 0 then
                        return ISO_8859;

                     elsif index(source => val, pattern => "UTF-8") > 0 then
                        return UTF_8;

                     elsif index(source => val, pattern => "UTF-16") > 0 then
                        if index(source => val, pattern => "LE") > 0 then
                           return UTF_16LE;
                        else
                           return UTF_16;
                        end if;
                     end if;
                  end;
               end if;
            end;

            exit when var = LOCALE_ENV_VAR_NAMES'last;
               -- nothing found

            var := LOCALE_ENV_VAR_NAMES'succ(var);
         end loop env_search;

         raise no_encoding_found;
      end encoding_from_environment;

   function find_first(container: STR) return NATURAL is
      begin
         for k in container'range loop
            if test(container(k)) then
               return k;
            end if;
         end loop;
         return 0;
      end;

   function input_encoding return SUPPORTED_ENCODING is
      begin
         return encoding_from_command_line;
      exception
         when no_encoding_found =>
            begin
               return encoding_from_environment;
            exception
               when no_encoding_found =>
                  return ISO_8859;
            end;
      end input_encoding;


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

end ASnip.Support;
