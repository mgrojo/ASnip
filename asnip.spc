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

-- ASnip is a program for "decorating" pieces of program text.
-- It outputs RTF, HTML, TeX, or AdaWiKi.

-- The program will process incomplete or incorrect source text,
-- so you can format wrong code, or multilanguage code, too.

package ASnip is

   pragma pure;

   subtype CHAR is WIDE_CHARACTER;
      -- internal character type

   subtype STR is WIDE_STRING;
      -- internal string type

   type SUPPORTED_LANGUAGE is (L_Ada);
      -- enumerates all languages for which the scanner can produce
      -- language tokens (from simple tokens).

private

   type SUPPORTED_ENCODING is (ISO_8859, UTF_8, UTF_16, UTF_16LE);
      -- The identifiers are a bit pompous considering that the program
      -- knows about WIDE_CHARACTERs and how to transform 8bit encodings
      -- into 16bit, and back. But then the names reflect what this
      -- program does to examine the environment for hints as to how it
      -- should read and write characters.

end ASnip;

-- $Date: Fri, 05 May 2006 03:17:20 +0200 $ $Source: asnip.spc $

