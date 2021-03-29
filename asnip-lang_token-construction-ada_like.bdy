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

with ASnip.Lang_Token.Ada_Like;
with ASnip.Ada_Language.Tests;

pragma assertion_policy(check);

package body ASnip.Lang_Token.Construction.Ada_Like is

   use Token, Lang_Token.Ada_Like, Ada_Language;

   procedure find_a_comment
     (start: Bricks.CURSOR; needed: in out NATURAL; result: out ADA_LIKE_OBJ);
      -- collect token from after "--". The hyphens are not included

   procedure find_a_string
     (start: Bricks.CURSOR; needed: in out NATURAL; result: out ADA_LIKE_OBJ);
      -- collect tokens from '"' to the matching '"'. The quotes will
      -- be included in `result`.


   procedure find_a_comment
     (start: Bricks.CURSOR; needed: in out NATURAL; result: out ADA_LIKE_OBJ)
      is
         c: Bricks.CURSOR := start;
         second_hyphen: constant TOKEN_OBJ := Bricks.element(c);
      begin
         pragma assert(text(second_hyphen)(position(second_hyphen)) = '-');
         needed := needed + 2;
         loop
            -- scan until end of line/file
            Bricks.next(c);
            declare
               t: constant TOKEN_OBJ := Bricks.element(c);
            begin
               exit when t = Bottom or Tests.is_line_end(t);
               extend_text(result, text(t));
            end;
            needed := needed + 1;
         end loop;
      end find_a_comment;

   procedure find_a_string
      (start: Bricks.CURSOR; needed: in out NATURAL; result: out ADA_LIKE_OBJ)
      is

         -- Initially, one '"' has been read, and the machine is in the
         -- STARTED state. "!" means append the text to the string token,
         -- "?" means push back the last token read.
         --
         --           "               ~"               eol
         -- ________________________________________________________________
         -- STARTED  (EOS, !)       (STARTED, !)     (STOP, ?)
         -- EOS      (STARTED, !)   (STOP, ?)        (STOP, ?)

         -- Pushing back is actually an implication of `needed`.
         -- `find_a_string` doesn't move a global corsor.

         type MACHINE_STATE is (Started, Eos);
         type INPUT is (Quote, Other, Eol);
            -- input character class

         procedure emit;
            -- add the current token's text to `result`

         function input_kind(current: Bricks.CURSOR) return INPUT;
            -- matches the column heading in the machine description

         function input_kind(current: Bricks.CURSOR) return INPUT is
               tok: constant TOKEN_OBJ := Bricks.element(current);
            begin
               if kind(tok) = Del and then text(tok)(position(tok)) = '"' then
                  return Quote;
               elsif
                  kind(tok) = Spc and then Tests.is_line_end(TOKEN_OBJ(tok))
               then
                  return Eol;
               else
                  return Other;
               end if;
            end input_kind;

         c: Bricks.CURSOR := start;
         state: MACHINE_STATE := Started;

         procedure emit is
               t: constant TOKEN_OBJ := Bricks.element(c);
            begin
               extend_text(result, text(t));
               needed := needed + 1;
            end emit;

      begin  -- `find_a_string`
         pragma assert(input_kind(start) = Quote);
         pragma assert(needed = 0);

         emit;
         M: loop
            Bricks.next(c);
            case state is
               when Started =>
                  case input_kind(c) is
                     when Quote =>
                        emit;
                        state := Eos;
                     when Eol =>
                        null;
                        exit M;
                     when Other =>
                        emit;
                        null;
                  end case;

               when Eos =>
                  case input_kind(c) is
                     when Quote =>
                        emit;
                        state := Started;
                     when Eol =>
                        null;
                        exit M;
                     when Other =>
                        null;
                        exit M;
                  end case;
            end case;
            -- ! assert old needed + 1 = needed;
         end loop M;
      end find_a_string;

   procedure make_lang_token(thing: in out ADA_WORKPIECE;
                             needed: out NATURAL;
                             queue: in out Walls.VECTOR)
      is
         use type Bricks.CURSOR;
         pragma assert(thing.ts(1) /= Bricks.no_element);

         procedure append_token(tok: TOKEN_OBJ; kind: ADA_KIND);
            -- creates an `ADA_LIKE_OBJ` object using information from `tok`
            -- and appends it to `queue`. This is a standard procedure
            -- for both making and appending most kinds of Ada like tokens.

         subtype DEL_OR_OP is ADA_KIND range Del .. Op;
            -- two character delimiters or operators, see `append_token_2`

         procedure append_token_2(tok1, tok2: TOKEN_OBJ; kind: DEL_OR_OP);
            -- creates an `ADA_LIKE_OBJ` object using information from `tok1`
            -- and `tok2` and appends it to `queue`. This is a standard
            -- procedure for both making and appending Ada like operators and
            -- delimiters consisting of two delimiter characters.

         procedure append_token(tok: TOKEN_OBJ; kind: ADA_KIND) is
               lang_tok: ADA_LIKE_OBJ(position(tok), kind);
            begin
               extend_text(lang_tok, text(tok));
               check_is_Ada(lang_tok);
               Walls.append(queue,
                            ADA_LIKE_OBJ'class(lang_tok));
               needed := needed + 1;
            end append_token;

         procedure append_token_2(tok1, tok2: TOKEN_OBJ; kind: DEL_OR_OP) is
               lang_tok: ADA_LIKE_OBJ(position(tok1), kind);
            begin
               extend_text(lang_tok, text(tok1));
               extend_text(lang_tok, text(tok2));
               check_is_Ada(lang_tok);
               Walls.append(queue,
                            ADA_LIKE_OBJ'class(lang_tok));
               needed := needed + 2;
            end append_token_2;


         t: constant TOKEN_OBJ := Bricks.element(thing.ts(1));

      begin -- `make_lang_token`

         needed := 0;
         if t = Bottom then
            return;
         end if;

         case kind(t) is

            -- A big switch that tests for the various kinds of simple
            -- tokens. The first distinction is made by querying `t`
            -- via the `kind` operation. This leaves some Ada decisions
            -- open, therefore there are some more nested tests, inspecting
            -- another simple token.

            when Id_Num =>
               if Tests.is_identifier(t) then
                  if is_reserved_word(Keywords, text(t)) then
                     declare
                        r: RES_TOKEN(position(t));
                     begin
                        extend_text(r, text(t));
                        Walls.append(queue,
                                     ADA_LIKE_OBJ'class(r));
                        needed := needed + 1;
                     end;
                  else
                     append_token(t, Id);
                  end if;
               elsif Tests.is_number(t) then
                  append_token(t, Num);
               else
                  -- For example, and `Id_Num` token starting with a number.
                  -- `check_is_Ada` will mark this in the lang token for use
                  -- with `is_known`.
                  append_token(t, Id);
               end if;

            when Spc =>
               declare
                  lt: ADA_LIKE_OBJ(position(t), Sep);
               begin
                  extend_text(lt, text(t));
                  Walls.append(queue,
                               LANG_TOKEN_OBJ'class(lt));
                  needed := needed + 1;
               end;

            when Del =>
               -- some delimiters can be the first in a sequence of two
               -- forming a single Ada token: '=', '>', '.', '*', ':', '/',
               -- '<'. See `Syntax.Delimiter_2`.
               pragma assert(WORKPIECE(thing).max_l >= 2);
               pragma assert(text(t)'length = 1);

               delimiters: declare
                  t2: constant TOKEN_OBJ := Bricks.element(thing.ts(2));
                  t2t: constant CHAR := text(t2)(position(t2));
                  next_is_delimiter: constant BOOLEAN := kind(t2) = Del;
               begin
                  case text(t)(position(t)) is
                     -- see `Syntax.Delimiter_1`

                     when '=' =>
                        if next_is_delimiter and then t2t = '>' then
                           -- "=>"
                           append_token_2(t, t2, Del);
                        else
                           append_token(t, Op);
                        end if;

                     when '&' | '+' => append_token(t, Op);
                        -- no doubt these are single character operators

                     when ''' => tick: begin
                        -- Phew... NOTE: there might not even be a
                        -- previous token at which to look. Chances are
                        -- that I'll have missed a few cases...

                        -- The next simple token can be of identifier
                        -- kind, as in 'r', or in 'range. The decision
                        -- whether or not the next token then becomes a
                        -- character literal or an attribute is based on the
                        -- length of the token text. If of another kind,
                        -- a lot of distinctions seem possible. KISS here.

                        case kind(t2) is
                           when Del =>
                              -- If the next token is a delimiter, then there
                              -- are a number of cases to consider.
                              case t2t is
                                 when '(' =>
                                    -- Possible bad luck: decide that the tick
                                    -- mark is part of X'(Value), not framing
                                    -- a left parenthesis character literal
                                    append_token(t, Del);
                                 when ''' =>
                                    -- interpret the next as a plain character
                                    append_token(t, Del);
                                    append_token(t2, Del);
                                 when '"' =>
                                    -- assume this is a character literal, do
                                    -- not for example assume that the tick
                                    -- mark comes from a string that is ended
                                    -- by this ".
                                    append_token(t, Del);
                                    append_token(t2, Chr);
                                 when others =>
                                    -- possibly the second tick mark in text
                                    -- like `'a';`, `'a',`, etc., and even
                                    -- `'a''attrib`. Giving up, mostly.
                                    append_token(t, Del);
                              end case;

                           when Spc =>
                              append_token(t, Del);
                              -- Bad luck if the next simple token after the
                              -- space or eol is an attribute name.

                           when Id_Num =>
                              if text(t2)'length > 1 then
                                 -- assume an attribute
                                 append_token(t, Del);
                                 attr_tok: declare
                                    a: ATTR_TOKEN(position(t2));
                                 begin
                                    check_is_attribute(a);
                                    extend_text(a, text(t2));
                                    Walls.append(queue,
                                                 ADA_LIKE_OBJ'class(a));
                                    needed := needed + 1;
                                 end attr_tok;
                              else
                                 pragma assert(text(t2)'length = 1);
                                 append_token(t, Del);
                                 append_token(t2, Chr);
                              end if;
                           when Unk =>
                              append_token(t, Del);
                        end case;
                     end tick;

                     when '(' | ')' | ',' | ';' | '|' | '!' =>
                        -- no doubt these are single character delimiters
                        append_token(t, Del);

                     when '*' =>
                        if next_is_delimiter and then t2t = '*' then
                           -- "**"
                           append_token_2(t, t2, Op);
                        else
                           append_token(t, Op);
                        end if;

                     when '.' =>
                        if next_is_delimiter and then t2t = '.' then
                           -- ".."
                           append_token_2(t, t2, Del);
                        else
                           append_token(t, Del);
                        end if;

                     when '/' =>
                        if next_is_delimiter and then t2t = '=' then
                           -- "/="
                           append_token_2(t, t2, Op);
                        else
                           append_token(t, Op);
                        end if;

                     when ':' =>
                        if next_is_delimiter and then t2t = '=' then
                           -- ":="
                           append_token_2(t, t2, Del);
                        else
                           append_token(t, Del);
                        end if;

                     when '<' =>
                        if next_is_delimiter then
                           case t2t is
                              when '=' =>
                                 -- "<="
                                 append_token_2(t, t2, Op);
                              when '<' | '>' =>
                                 -- "<<", "<>"
                                 append_token_2(t, t2, Del);
                              when others =>
                                 append_token(t, Op);
                           end case;
                        else
                           -- next is not a delimiter
                           append_token(t, Op);
                        end if;

                     when '>' =>
                        if next_is_delimiter then
                           case t2t is
                              when '>' =>
                                 -- ">>"
                                 append_token_2(t, t2, Del);
                              when '=' =>
                                 -- ">="
                                 append_token_2(t, t2, Op);
                              when others =>
                                 append_token(t, Op);
                           end case;
                        else
                           -- next is not a delimiter
                           append_token(t, Op);
                        end if;

                     when '-' =>
                        if next_is_delimiter and then t2t = '-' then
                           -- "--" (a comment)
                           declare
                              ct: ADA_LIKE_OBJ(position(t), Cmt);
                              old_needed: constant NATURAL := needed;
                           begin
                              find_a_comment(thing.ts(2), needed, ct);
                              Walls.append(queue,
                                           ADA_LIKE_OBJ'class(ct));
                              pragma assert(old_needed <= needed);
                           end;
                        else
                           append_token(t, Op);
                        end if;

                     when '"' =>
                        declare
                           st: ADA_LIKE_OBJ(position(t), Strng);
                           old_needed: constant NATURAL := needed;
                        begin
                           find_a_string(thing.ts(1), needed, st);
                           Walls.append(queue,
                                        ADA_LIKE_OBJ'class(st));
                           pragma assert(old_needed <= needed);
                        end;

                     when others =>
                        -- this shouldn't happen
                        raise Program_Error;

                  end case;

               end delimiters;

            when Unk =>
               Unk_Tok: declare
                  ut: ADA_LIKE_OBJ(position(t), Sep);
               begin
                  -- issue a warning, or report_unknown_token, etc.
                  extend_text(ut, text(t));
                  check_is_Ada(ut);
                  Walls.append(queue,
                               LANG_TOKEN_OBJ'class(ut));
                  needed := needed + 1;
               end Unk_Tok;
         end case;
      end make_lang_token;

end ASnip.Lang_Token.Construction.Ada_Like;
