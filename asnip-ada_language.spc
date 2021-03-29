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

with Ada.Strings.Wide_Maps;
with ASnip.Support;
pragma elaborate(ASnip.Support);

private package ASnip.Ada_Language is
   -- constants etc. for describing the tokens that will be found in input text

   use Support;

   function is_reserved_word(list: WORDLIST; s: STR) return BOOLEAN;
      -- `s` is on the `list` of reserved words


   -- NOTE: words on the lists must be in alphabetical order.

   Num_Ada_keywords: constant := 72;
      -- Ada 2005, copied from draft 13 of AARM Ada 2005

   Keywords: constant WORDLIST(1 .. num_Ada_keywords) :=
     (+"abort",
      +"abs",
      +"abstract",
      +"accept",
      +"access",
      +"aliased",
      +"all",
      +"and",
      +"array",
      +"at",
      +"begin",
      +"body",
      +"case",
      +"constant",
      +"declare",
      +"delay",
      +"delta",
      +"digits",
      +"do",
      +"else",
      +"elsif",
      +"end",
      +"entry",
      +"exception",
      +"exit",
      +"for",
      +"function",
      +"generic",
      +"goto",
      +"if",
      +"in",
      +"interface",
      +"is",
      +"limited",
      +"loop",
      +"mod",
      +"new",
      +"not",
      +"null",
      +"of",
      +"or",
      +"others",
      +"out",
      +"overriding",
      +"package",
      +"pragma",
      +"private",
      +"procedure",
      +"protected",
      +"raise",
      +"range",
      +"record",
      +"rem",
      +"renames",
      +"requeue",
      +"return",
      +"reverse",
      +"select",
      +"separate",
      +"subtype",
      +"synchronized",
      +"tagged",
      +"task",
      +"terminate",
      +"then",
      +"type",
      +"until",
      +"use",
      +"when",
      +"while",
      +"with",
      +"xor");

   num_Ada_attributes: constant := 90;
      -- Ada 2005

   Attributes: constant WORDLIST(1 .. Num_Ada_attributes) :=
     (+"Access",
      +"Address",
      +"Adjacent",
      +"Aft",
      +"Alignment",
      +"Base",
      +"Bit_Order",
      +"Body_Version",
      +"Callable",
      +"Caller",
      +"Ceiling",
      +"Class",
      +"Component_Size",
      +"Compose",
      +"Constrained",
      +"Copy_Sign",
      +"Count",
      +"Definite",
      +"Delta",
      +"Denorm",
      +"Digits",
      +"Exponent",
      +"External_Tag",
      +"First",
      +"Floor",
      +"Fore",
      +"Fraction",
      +"Identity",
      +"Image",
      +"Class",
      +"Input",
      +"Last",
      +"Leading_Part",
      +"Length",
      +"Machine",
      +"Machine_Emax",
      +"Machine_Emin",
      +"Machine_Mantissa",
      +"Machine_Overflows",
      +"Machine_Radix",
      +"Machine_Rounding",
      +"Machine_Rounds",
      +"Max",
      +"Max_Size_In_Storage_Elements",
      +"Min",
      +"Mod",
      +"Model",
      +"Model_Emin",
      +"Model_Epsilon",
      +"Model_Mantissa",
      +"Model_Small",
      +"Modulus",
      +"Output",
      +"Partition_Id",
      +"Pos",
      +"Pred",
      +"Priority",
      +"Range",
      +"Read",
      +"Remainder",
      +"Round",
      +"Rounding",
      +"Safe_First",
      +"Safe_Last",
      +"Scale",
      +"Scaling",
      +"Signed_Zeros",
      +"Size",
      +"Small",
      +"Storage_Pool",
      +"Storage_Size",
      +"Stream_Size",
      +"Succ",
      +"Tag",
      +"Terminated",
      +"Truncation",
      +"Unbiased_Rounding",
      +"Unchecked_Access",
      +"Val",
      +"Valid",
      +"Value",
      +"Version",
      +"Wide_Image",
      +"Wide_Value",
      +"Wide_Wide_Image",
      +"Wide_Wide_Value",
      +"Wide_Wide_Width",
      +"Wide_Width",
      +"Width",
      +"Write");



   package Syntax is
      -- token descriptions

      use Ada.Strings.Wide_Maps;

      -- some characters are covered by Ada 95 character sets
      -- already. Add some more.

      Greek_Letters: constant WIDE_CHARACTER_RANGES :=
         -- greek small and capital letters
         WIDE_CHARACTER_RANGES'
           (WIDE_CHARACTER_RANGE'
              (WIDE_CHARACTER'val(16#03B1#),
               WIDE_CHARACTER'val(16#03C9#)),
            WIDE_CHARACTER_RANGE'
               (WIDE_CHARACTER'val(16#0391#),
                WIDE_CHARACTER'val(16#03A9#)));

      European_Letters: constant WIDE_CHARACTER_RANGE :=
         -- some more European characters
         WIDE_CHARACTER_RANGE'
            (WIDE_CHARACTER'val(16#0100#),
             WIDE_CHARACTER'val(16#017E#));

      Number_Letters: constant WIDE_CHARACTER_SEQUENCE :=
         -- characters occuring in numeric literals
         "0123456789#aAbBcCdDeEfF";


      subtype STR_2 is WIDE_STRING(1 .. 2);

      -- NOTE: `Delimiter_1` must include `Operator_1`

      Operator_1: constant WIDE_CHARACTER_SEQUENCE :=
         -- single character operators
         "&*+/<=>-";

      Operator_2: constant array(1..4) of STR_2 :=
         -- two-character operators
         ("**", ">=", "<=", "/=");

      Delimiter_1: constant WIDE_CHARACTER_SEQUENCE :=
         -- single character delimiters
         "&'()*+,./:;<=>|!-";

      Delimiter_2:  constant array(1..10) of STR_2 :=
         -- two-character delimiters
         ("=>", "..", "**", ":=",
          "/=", ">=", "<=",
          "<<", ">>", "<>");

      -- Note: string brackets '"' need special cases

   end Syntax;

end ASnip.Ada_Language;


-- $Date: Fri, 05 May 2006 22:53:49 +0200 $


