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

with binary_search;
with Ada.Text_IO;
with Ada.Calendar;
procedure test_binsearch is

      use Ada;

      --subtype IDX is INTEGER range 10 .. 15;
      --type CHARVEC is array(IDX range <>) of CHARACTER;

      subtype IDX is INTEGER range 32 .. 1024;
      type CHARVEC is array(IDX range <>) of WIDE_CHARACTER;

      values: CHARVEC(IDX);
         
   
      function has is new binary_search
         (ELEMENT => WIDE_CHARACTER,
          INDEX => IDX,
          SORTED_LIST => CHARVEC);

      t1, t2: Calendar.TIME;
      use type Calendar.TIME;
   begin
      -- initialize values
      for k in values'range loop
         values(k) := WIDE_CHARACTER'val(k);
      end loop;

      -- make duplicate entries
      values(WIDE_CHARACTER'pos('a') - 1) := 'a';
      values(WIDE_CHARACTER'pos('f') + 1) := 'f';

      t1 := Calendar.clock;
      for k in 1 .. 1_500_000 loop
         if has(values, WIDE_CHARACTER'val(10)) then
            raise Program_Error;
         end if;
         if not   (has(values, 'a')
               and has(values, 'b')
               and has(values, 'c')
               and has(values, 'd')
               and has(values, 'e')
               and has(values, 'f')) then
            raise Program_Error;
         end if;
      end loop;
      t2 := Calendar.clock;

      --Text_IO.put_line("about" & NATURAL'image(NATURAL(t2 - t1)) & " seconds");
      Text_IO.put_line("about" & DURATION'image(t2 - t1) & " seconds");
   end test_binsearch;

