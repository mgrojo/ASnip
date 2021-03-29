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

with ASnip.Testing;
with Ada.Text_IO;

procedure driver is
      use Ada, ASnip;
   begin
      Text_IO.put_line("=== RUNNING TESTS ===");

      Text_IO.put("reserved_word_search:");
      Testing.reserved_word_search;
      Text_IO.put_line(" passed");

--        Text_IO.put("buffering:");
--        Testing.buffering;
--        Text_IO.put_line(" passed");

      Text_IO.put("reading:");
      Testing.reading;
      Text_IO.put_line(" passed if files are the same");

      Text_IO.put("simple tokenizing:");
      Testing.simple_tokenizing;
      Text_IO.put_line(" passed if files are the same");

   end driver;
