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

with ASnip.Lang_Token.Construction.Ada_Like;

separate(Asnip.Token.Ada_Scanner)
procedure produce_Ada_tokens
   (scanner: in out ADA_SCANNER_OBJ; queue: in out Walls.VECTOR) is
      use Lang_Token.Construction, Lang_Token.Construction.Ada_Like;

      w: ADA_WORKPIECE(queue'access);
      c: Bricks.CURSOR := Bricks.first(scanner.simple_toks);
      consumed: NATURAL;
         -- number of "bricks" used for an Ada like token
   begin
      move_window(WORKPIECE(w), c);
      for k in 2 .. WORKPIECE(w).max_l loop
         Bricks.next(c);
         move_window(WORKPIECE(w), c);
      end loop;

      loop
         make_lang_token(w, consumed, queue);
         exit when consumed = 0;
         for k in 1 .. consumed loop
            -- shift new tokens in
            Bricks.next(c);
            move_window(w, c);
         end loop;
      end loop;

      scanner.unknown := True; --TODO
      scanner.stage := Combined;

   end produce_Ada_tokens;
