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

with Ada.Streams;
with ASnip;  use ASnip;

package Char_IO is
      
   subtype ROOT_STREAM_TYPE is Ada.Streams.ROOT_STREAM_TYPE;

      malformed_encoding: exception;

      -- functions actually performing I/O. BMP only.

      type CHAR_READER is abstract tagged null record;
      --access function(source: access ROOT_STREAM_TYPE'class) return CHAR;
      function read_next_char
         (the_reader: CHAR_READER;
         source: access ROOT_STREAM_TYPE'class) return CHAR is abstract;

      type READS_UTF_8 is new CHAR_READER with null record;
      function read_next_char
         (the_reader: READS_UTF_8;
         source: access ROOT_STREAM_TYPE'class) return CHAR;

      type READS_UTF_16 is new CHAR_READER with null record;
      function read_next_char
         (the_reader: READS_UTF_16;
         source: access ROOT_STREAM_TYPE'class) return CHAR;

      type READS_UTF_16LE is new CHAR_READER with null record;
      function read_next_char
         (the_reader: READS_UTF_16LE;
         source: access ROOT_STREAM_TYPE'class) return CHAR;
         -- byte order issue?

      type READS_8859 is new CHAR_READER with null record;
      function read_next_char
         (the_reader: READS_8859;
         source: access ROOT_STREAM_TYPE'class) return CHAR;

   R8859: aliased constant Char_IO.READS_8859 := (null record);
   RUTF8: aliased constant Char_IO.READS_UTF_8 := (null record);
   RUTF16: aliased constant Char_IO.READS_UTF_16 := (null record);
   RUTF16LE: aliased constant Char_IO.READS_UTF_16LE := (null record);

end Char_IO;
