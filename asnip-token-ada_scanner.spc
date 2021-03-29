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

with ASnip.IO;
with ASnip.Token.Sequences;
with ASnip.Lang_Token.Sequences;
with Ada.Streams;

package ASnip.Token.Ada_Scanner is

   pragma elaborate_body;

   -- ----------------------------------------------------------------
   -- Find Ada like tokens in input
   -- ----------------------------------------------------------------

   -- The scanner starts reading one `CHAR` at a time and classifies it
   -- as either
   --  * a delimiter
   --  * part of a number or of an identifier
   --  * white space
   --  * unkown
   -- In any case, a simple token is added to an internal list. Then
   -- the tokens are combined to form Ada like tokens where possible.
   -- Again, the resulting tokens are added to an internal list. The two
   -- lists are available for inspection using `CURSOR`s. The function
   -- `successful` can be called to find out whether anything has been
   -- treated as unknown.

   subtype STREAM_ACCESS is IO.STREAM_ACCESS;
   subtype ROOT_STREAM_TYPE is Ada.Streams.ROOT_STREAM_TYPE;

   type ADA_SCANNER_OBJ
      (source: access ROOT_STREAM_TYPE'class) is limited private;
      -- assumes `source` to be open for reading

   procedure produce_simple_tokens(scanner: in out ADA_SCANNER_OBJ);
      -- group the characters from `scanner.source` into simple tokens
      -- and store these tokens in an internal list. The tokens are not
      -- yet language tokens. For example, two delimiters that would
      -- form a single delimiter or operator in the language are still
      -- two separate tokens after this stage of processing.

   generic
      with procedure process(c: Token.Sequences.CURSOR);
   procedure visit_all_simple_tokens(scanner: ADA_SCANNER_OBJ);
      -- read only view of the tokens found by `produce_simple_tokens`


   procedure produce_Ada_tokens(scanner: in out ADA_SCANNER_OBJ;
                                queue: in out Lang_Token.Sequences.VECTOR);
      -- After `produce_simple_tokens` has run, combine the simple tokens into
      -- Ada like tokens. Store these tokens in another internal list.
      -- Comments are treated specially, the text after the comment
      -- characters is made a single token.

   function successful(scanner: ADA_SCANNER_OBJ) return BOOLEAN;
      -- when called immediately after `produce_simple_tokens` has run,
      -- indicates that there hasn't been any unknown input.
      -- When called after `produce_Ada_tokens` has run, ... TBD

private

   type STATE is
      -- tokenizing phases

      (Start,
         -- the scanner has been initialized

       Dissected,
         -- `source` has been dissected

       Combined);
         -- simple tokens have been combined


   type ADA_SCANNER_OBJ

      (source: access ROOT_STREAM_TYPE'class)          is limited record

      simple_toks: Token.Sequences.VECTOR;
         -- result of stage 1, simple tokens. Input to stage 2.

      stage: STATE := Start;
         -- for checking the proper order of processing

      unknown: BOOLEAN;
         -- unknown input during finding simple tokens,
         -- or unknown tokens during token combining phase

   end record;


end ASnip.Token.Ada_Scanner;
