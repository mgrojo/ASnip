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

with Interfaces;
with Ada.Exceptions;

with Ada.Characters.Handling;

      package body Char_IO is

      use Interfaces;

      subtype BYTE is UNSIGNED_8;

      -- `next_char_8` reads bytes and scans them for UTF-8 sequences.
      -- However, since only the BMP is covered by the program now
      -- (Ada 95), only a maximum of three bytes is checked. Longer
      -- byte sequences will make the function fail, even though the
      -- sequences might be valid UTF-8 sequences.

      function read_next_char
         (the_reader: READS_UTF_8; source: access ROOT_STREAM_TYPE'class) return CHAR
         is
            c: BYTE;
            code: UNSIGNED_16 := 0;
         begin
            BYTE'read(source, c);
            --debug_count := debug_count + 1;

            if (c and 2#1111_0000#) = 2#1110_0000# then
               -- two bytes to follow

               code := shift_left(UNSIGNED_16(c and 2#1111#), 2 * 6);
               BYTE'read(source, c);

               if (c and 2#11_000000#) = 2#10_000000# then
                  -- another byte

                  code := code or shift_left(UNSIGNED_16(c and 2#111111#), 6);
                  BYTE'read(source, c);

                  if (c and 2#11_000000#) = 2#10_000000# then
                     code := code or (UNSIGNED_16(c and 2#111111#));
                  else
                     raise malformed_encoding;
                  end if;

               else
                  raise malformed_encoding;
               end if;

            elsif (c and 2#111_00000#) = 2#110_00000# then
               -- one byte to follow

               code := shift_left(UNSIGNED_16(c and 2#11111#), 6);
               BYTE'read(source, c);

               if (c and 2#11_000000#) = 2#10_000000# then
                  code := code or UNSIGNED_16(c and 2#111111#);
               else
                  raise malformed_encoding;
               end if;

            elsif (c and 2#1000_0000#) = 2#0# then
               code := UNSIGNED_16(c);
            else
               Ada.Exceptions.raise_exception
                 (malformed_encoding'identity,
                  "current byte is '" & BYTE'image(c) & "'");
               --raise malformed_encoding;
            end if;

            return CHAR'val(code);
         end read_next_char;


      function read_next_char
         (the_reader: READS_UTF_16; source: access ROOT_STREAM_TYPE'class) return CHAR
         is
            c: CHAR;
         begin
            CHAR'read(source, c);
            return c;
         end read_next_char;

      function read_next_char
         (the_reader: READS_UTF_16LE;source: access ROOT_STREAM_TYPE'class) return CHAR
         is
            u: UNSIGNED_16;
         begin
            UNSIGNED_16'read(source, u);
            u := rotate_left(u, 8);
            return CHAR'val(u);
         end read_next_char;

      function read_next_char(the_reader: READS_8859;
                              source: access ROOT_STREAM_TYPE'class)
                                 return CHAR is
            c: CHARACTER;
            use Ada.Characters.Handling;
         begin
            CHARACTER'read(source, c);
            return to_wide_character(c);
         end read_next_char;

   end Char_IO;
