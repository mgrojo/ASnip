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

with ASnip.Token.Sequences,
   ASnip.Lang_Token.Sequences;

package ASnip.Lang_Token.Construction is

   package Bricks renames Token.Sequences;
   package Walls renames Lang_Token.Sequences;

   -- ----------------------------------------------------------------
   -- A "window" is showing some tokens to look at from the "stream" of
   -- simple tokens. One procedure makes an Ada like token from the
   -- simple tokens currently seen through the window, if possible. The
   -- other procedure moves the stream "behind" the window.
   -- ----------------------------------------------------------------

   type WORKPIECE
      -- "material" currently processed by the scanner. An object holds
      -- everything together

      (queue: access Walls.VECTOR;
         -- Lang tokens are appended here

      max_l: POSITIVE) is abstract tagged limited private;
         -- need some simple tokens to decide the next language token.
         -- NOTE: The number must be large enough for the language

   procedure move_window(thing: in out WORKPIECE; t: Bricks.CURSOR);
      -- shift `thing`'s window by one stream position, and add `t` in
      -- the freed position. Assumes `t` to be a cursor pointing to
      -- the next token

   procedure make_lang_token
      (thing: in out WORKPIECE; needed: out NATURAL; queue: in out Walls.VECTOR)
      is abstract;
      -- looking at the tokens through `thing`'s window, find the next
      -- language token and return the number of simple tokens that were
      -- needed to construct the language token. The language token is
      -- added to `thing.queue`.

private


   type WINDOW is array(POSITIVE range <>) of Bricks.CURSOR;

   type WORKPIECE
     (queue: access Walls.VECTOR;
      max_l: POSITIVE) is abstract tagged limited record

      finished: BOOLEAN := False;
         -- `True` when some token has been started, and completed

      ts: WINDOW(1 .. max_l);

   end record;

end ASnip.Lang_Token.Construction;
