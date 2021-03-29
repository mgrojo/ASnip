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

package ASnip.Lang_Token.Ada_Like is

   -- ----------------------------------------------------------------
   -- A type derived from `LANG_TOKEN_OBJ` for classifying Ada like
   -- tokens.
   -- ----------------------------------------------------------------

   type ADA_KIND is (Attr, Chr, Cmt, Del, Id, Num, Op, Res, Sep, Strng);

   type ADA_LIKE_OBJ(lo: POSITIVE; kind: ADA_KIND) is
      new LANG_TOKEN_OBJ with private;
      -- tokens close to Ada's, distinguished by `kind`

   procedure check_is_Ada(tok: in out ADA_LIKE_OBJ);
      -- inspects the text to see whether it is proper Ada.
      -- Currently, distinguishes Ada separators and separators used in
      -- other languages, which are still permitted in input to asnip.
      -- (The simple tokens are mapped to separator tokens.)
      -- Also, checks identifiers that are too much off Ada standards.

   function is_known(tok: ADA_LIKE_OBJ) return BOOLEAN;
      -- See `check_is_Ada`

   type ATTR_TOKEN(lo: POSITIVE) is
      new ADA_LIKE_OBJ with private;

   procedure check_is_attribute(tok: in out ATTR_TOKEN);
      -- inspects the text to see whether it is a known attribute

   -- overriding
   function is_known(tok: ATTR_TOKEN) return BOOLEAN;
      -- the token text is an attribute name from the core language

   type RES_TOKEN(lo: POSITIVE) is
      new ADA_LIKE_OBJ with private;


private

   type ADA_LIKE_OBJ(lo: POSITIVE; kind: ADA_KIND) is
         new LANG_TOKEN_OBJ(lo) with record

      proper: BOOLEAN := True;
         -- this is a proper Ada like token. Some tokens, notably
         -- separators, are not Ada, but are o.K., too. They will have
         -- this attribute set to `False`. See `check_is_Ada_separator`.

   end record;

   type ATTR_TOKEN
     (lo: POSITIVE) is  new ADA_LIKE_OBJ(lo, Attr) with record

      known: BOOLEAN := False;
         -- A known Ada attribute? (Attributes are constructed when
         -- an identifier appears in an attribute position. This flag
         -- offers a possibility to distinguish between known attributes
         -- and unknown attributes. See `check_is_attribute`.

   end record;

   type RES_TOKEN

     (lo: POSITIVE) is new ADA_LIKE_OBJ(lo, Res) with record

      null;
         -- A `RES_TOKEN` is constructed only if a simple token has been
         -- found to be a reserved word, unlike an attribute wich is an
         -- attribute by its position in the input stream. Hence no need
         -- to have a `.known` component.

   end record;


end ASnip.Lang_Token.Ada_Like;
