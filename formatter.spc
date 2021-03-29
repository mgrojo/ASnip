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

with ASnip.Lang_Token;

package Formatter is

   -- ----------------------------------------------------------------
   -- Callbacks implementing the required functions in the formal part
   -- of `ASnip.Printing.*`. For each language, and then for each output
   -- format, provide a complete set in a corresponding grandchild package.
   -- The package is going to be used as the actual package parameter when
   -- instantiating a token printing prodecure `ASnip.IO.write_*_like`.
   -- ----------------------------------------------------------------

   type SUPPORTED_FORMAT is (Plain_Text, HTML, TeX, WiKiBook);

private

   subtype L is ASnip.Lang_Token.LANG_TOKEN_OBJ;

   -- classwide default implementations (they are not used...)

   function empty_prefix(t: L'class) return ASnip.STR;
      -- text to be placed before the `image`. ""

   function token_text(t: L'class) return ASnip.STR;
      -- copy of the source text (indirection not needed?...)

   function empty_suffix(t: L'class) return ASnip.STR;
      -- text to be appended to the `image`. ""

   pragma inline(empty_prefix, empty_suffix);

end Formatter;
