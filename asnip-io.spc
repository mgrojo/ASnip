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
with ASnip.Token.Sequences;
with ASnip.Lang_Token.Sequences;
with ASnip.Printing.Ada_Like;

with Char_IO;

package ASnip.IO is

   use Ada.Streams;

   -- ----------------------------------------------------------------
   -- Input is done calling functions set up to match the input
   -- encoding.
   --
   -- Output uses the same encoding as input, either as found in
   -- environment variables, or as requested on the command line. The
   -- package has one output stream variable and one writer procedure
   -- variable. Initialise them using `set_output` and `set_writer`,
   -- respectively. This should be done before I/O starts.
   -- ----------------------------------------------------------------

   type STREAM_ACCESS is access all ROOT_STREAM_TYPE'class;

   type WRITER is access procedure (text: STR);
      -- objects point to one of the private procedures whose name
      -- matches "write_<encoding>"

   --type CHAR_READER is abstract tagged null record;
      --access function(source: access ROOT_STREAM_TYPE'class) return CHAR;

   type READER is access constant Char_IO.CHAR_READER'class;
   next_char: READER;

   procedure set_reader(encoding: STRING := "");

   procedure set_writer(encoding: STRING := "");
      -- assign a procedure to this package's `WRITER`.
      -- If `encoding = ""`, tries to guess the input encoding

   procedure set_output(channel: STREAM_ACCESS);
      -- make `channel` this package's output stream

   generic
      with package Printers is new ASnip.Printing.Ada_Like(<>);
   procedure write_ada_like(c: Lang_Token.Sequences.CURSOR);
      -- depending on the kind of token to which `c` is pointing , call
      -- the corresponding `prefix_of_*`, `image_of_*`, and `suffix_of_*`
      -- functions defined in `Writer`. * stands for the token kind

   procedure write_simple(c: Token.Sequences.CURSOR);
      -- write a simple token. Calls the `WRITER` set by `set_writer`

   procedure print_special(text: STR);
      -- for special cases when something else must be printed
      -- other than what is written using the subprograms from
      -- above, and in `Printing`

private

   procedure write_iso_8859(text: STR);
      -- since input is 8bit, everything in `text` is should be
      -- convertible to 8bit characters without loss

   procedure write_utf_8(text: STR);
   procedure write_utf_16le(text: STR);
   procedure write_utf_16(text: STR);

end ASnip.IO;
