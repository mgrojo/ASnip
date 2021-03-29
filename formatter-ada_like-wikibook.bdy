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

with Ada.Strings.Wide_Maps, Ada.Strings.Wide_Bounded;
with Ada.Characters.Handling;

-- NOTES:
-- `&` becomes [[Ada Programming/Delimiters/&|&]], not {{Ada/operator|&}}
-- or similar because the letter seems disallowed
--
-- "or else" ~> or#Boolean_shortcut_operator
-- "and then" ... not implemented yet, instead these are considere two tokens.

package body Formatter.Ada_Like.WiKiBook is

   function maybe_prefix(t: ADA_LIKE_OBJ; kind: ASnip.STR) return ASnip.STR;
      -- a WiKi prefix is to be output for known tokens only
      -- post: is_known(t) = (result = default_prefix & kind);
      --       not is_known(t) = (result = "")

   function maybe_suffix(t: ADA_LIKE_OBJ) return ASnip.STR;
      -- a WiKi suffix is to be output for known tokens only
      -- post: is_known(t) = (result = default_suffix);
      --       not is_known(t) = (result = "")


   pragma inline(maybe_prefix, maybe_suffix);

   package Library_Packages is

      -- ----------------------------------------------------------------
      -- The state machine for hierarchical library package names
      -- ----------------------------------------------------------------

      max_pack_length: constant POSITIVE := 200;
         -- maximum number of characters of hierarchical package names


      type MACHINE_STATE is (Started, Separator, Pack, Dot, Reset);
         -- possible machine states for scanning hierachical package names
         --           "package, ..."   sep       id        "."
         -- ================================================================
         -- Reset        Started        *         *         *
         -- Started         *       Separator     *         *
         -- Separator       *       Separator   Pack        *
         -- Pack            !           !         !        Dot
         -- Dot             !           !       Pack        !
         --
         -- Plan: When the machine enters state "Pack", an id token is
         -- added to the template and the id counter is increased. See
         -- `add_name_part`. '*' means that `state := Reset`, that the id
         -- counter becomes `0`, and that the template becomes an empty
         -- string. '!' means the same except the template is completed, ready
         -- for fetching (once). See `restart` and `template`.

      procedure restart;
         -- see the description of `MACHINE_STATE`  

      procedure add_name_part(name: ASnip.STR);
         -- add the name `name` to the template text, increase `id_counter`

      function template return ASnip.STR;
         -- the template text collected, if any
         -- Side effect: once called, the string will be gone

      state: MACHINE_STATE := Reset;
         -- machine state as described in the spec

   end Library_Packages;

   package body Library_Packages is

      package Str_Store is
         new Ada.Strings.Wide_Bounded.Generic_Bounded_Length(max_pack_length);

      store: Str_Store.BOUNDED_WIDE_STRING :=
         Str_Store.Null_Bounded_Wide_String;
         -- a queue for ids forming a library package name. See `add_name_part`

      id_counter: NATURAL := 0;
         -- number of id tokens part of a hierarchical package name so far

      pack_name_prefix: constant ASnip.STR := "{{Ada/package";
         -- prefix of  WiKiBook Ada template for expressing a hierarchical
         -- package name

      pack_name_suffix: constant ASnip.STR := "}}";
         -- suffix of  WiKiBook Ada template for expressing a hierarchical
         -- package name


      procedure add_name_part(name: ASnip.STR) is
         begin
            Str_Store.append(store, '|');
            Str_Store.append(store, name);
            id_counter := id_counter + 1;
         end add_name_part;

      procedure restart is
         begin
            case state is
               when Pack | Dot =>
                  -- Single id package names don't have a counter before
                  -- the first '|' as in {{Ada/package 2|...

                  if id_counter > 1 then
                     Str_Store.insert(store, 1, 
                        pack_name_prefix & NATURAL'wide_image(id_counter));
                     Str_Store.append(store, pack_name_suffix);
                  else
                     Str_Store.insert(store, 1, pack_name_prefix);
                     Str_Store.append(store, pack_name_suffix);
                  end if;

                  -- dot hack: when the machine has read a dot as the last
                  -- token, but no id token following it, emit a dot template
                  -- (dots are implicit in {{Ada/package 2|etc}}, if not
                  -- emitted, there will be a missing dot.)

                  if state = Dot then
                     Str_Store.append(store, "{{Ada/delimiter 2|dot|.}}");
                  end if;

               when Reset | Started | Separator =>
                  store := Str_Store.Null_Bounded_Wide_String;
            end case;

            state := Reset;
            id_counter := 0;
         end restart;


      function template return ASnip.STR is
            result: constant ASnip.STR := Str_Store.to_wide_string(store);
         begin
            store := Str_Store.Null_Bounded_Wide_String;
            return result;
         end;

   end Library_Packages;


   default_prefix: constant ASnip.STR := "{{Ada/";
      -- AdaWiKi templates start with this

   default_suffix: constant ASnip.STR := "}}";
      -- AdaWiKi templates end with this

   function check_eot return ASnip.STR is
         use Library_Packages;
      begin
         case state is
            when Pack | Dot =>
               restart;
               return template;
            when Started | Separator | Reset =>
               return "";
         end case;
      end;

   function maybe_prefix(t: ADA_LIKE_OBJ; kind: ASnip.STR) return ASnip.STR is
      begin
         if is_known(t) then
            return default_prefix & kind;
         else
            return "";
         end if;
      end;

   function maybe_suffix(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         if is_known(t) then
            return default_suffix;
         else
            return "";
         end if;
      end;

   ---

   -- `check_eot` is called by almost all prefix functions. Since ASnip
   -- does not rely on input being valid Ada, and since no input is
   -- skipped, partial library package names in `Library_Packages.store`
   -- will nevertheless be terminated, and output, although they aren't
   -- really library package names when only partial. Every token kind
   -- that cannot become part of a library package name terminates the
   -- name's assembly.

   function prefix_of_attr(t: ATTR_TOKEN) return ASnip.STR is
      begin
         return check_eot & default_prefix & "attribute";
      end;

   function image_of_attr(t: ATTR_TOKEN) return ASnip.STR is
      begin
         return "|" & token_text(t);
      end;

   function suffix_of_attr(t: ATTR_TOKEN) return ASnip.STR is
      begin
         return default_suffix;
      end;


   function prefix_of_chr(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         return check_eot & "";
      end;

   function image_of_chr(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         return source_text(t);
      end;

   function suffix_of_chr(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         return default_suffix;
      end;


   function prefix_of_cmt(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         return check_eot & default_prefix & "comment";
      end;

   function image_of_cmt(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         -- this is where comment parsing could be done
         return "|" & source_text(t);
      end;

   function suffix_of_cmt(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         return default_suffix;
      end;


   function prefix_of_del(t: ADA_LIKE_OBJ) return ASnip.STR is
         use Library_Packages;
      begin
         case state is
            when Pack => 
               if source_text(t) = "." then
                  state := Dot;
                  return "";
               else
                  restart;
                  return template &  maybe_prefix(t, "delimiter");
               end if;

            when Separator
                  -- syntax error, package name must start with id
               | Dot
                  -- syntax error, expecting id after "."
               | Started
                  -- syntax error, missing separator
               =>
               restart;
               return template & maybe_prefix(t, "delimiter");

            when Reset =>
               return maybe_prefix(t, "delimiter");

         end case;
         -- ! post: state = Reset or else ("." and state = Dot)
      end prefix_of_del;

   function image_of_del(t: ADA_LIKE_OBJ) return ASnip.STR is
         del_txt: constant ASnip.STR := source_text(t);

         function del1 return ASnip.STR;
            -- the correct markup for single character delimiters.
            -- ! pre: del_txt(del_txt'first) in to_set("|()',.:;!");

         function del2 return ASnip.STR;
            -- the correct markup for two character delimiters.
            -- ! pre: del_txt(del_txt'first) in to_set("<>.=:")
            --        del_txt(del_txt'first + 1) suitable

         function del1 return ASnip.STR is
            begin
               case del_txt(del_txt'first) is
                  when '|' | '!' => -- a redirection for '!'
                     return " 2|vertical_line|&#124;";
                  when '(' => return "|(";
                  when ')' => return "|)";
                  when ''' => return "|'";
                  when ',' => return "|,";
                  when '.' => return " 2|dot|.";
                  when ':' => return "|:";
                  when ';' => return "|;";
                  when others => raise Program_Error;
               end case;
            end del1;

         function del2 return ASnip.STR is
               d2: ASnip.CHAR renames del_txt(del_txt'first + 1);
            begin
               case del_txt(del_txt'first) is
                  when '<' =>
                     case d2 is
                        when '<' => return " 2|left_label|<<";
                        when '>' => return " 2|box|<>";
                        when others => raise Program_Error;
                     end case;
                  when '>' =>
                     case d2 is
                        when '>' => return " 2|right_label|>>";
                        when others => raise Program_Error;
                     end case;
                  when '.' =>
                     case d2 is
                        when '.' => return " 2|double_dot|..";
                        when others => raise Program_Error;
                     end case;
                  when '=' =>
                     case d2 is
                        when '>' => return " 2|1=arrow|2==>";
                        when others => raise Program_Error;
                     end case;
                  when ':' =>
                     case d2 is
                        when '=' => return "|1=:=";
                        when others => raise Program_Error;
                     end case;
                  when others =>
                     raise Program_Error;
               end case;
            end del2;

         use type Library_Packages.MACHINE_STATE;
            -- for "="

      begin -- `image_of_del`
         if Library_Packages.state = Library_Packages.Dot then
            pragma assert(source_text(t) = ".");
            -- a dot in a library package name, see the postcondition
            -- of `prefix_of_del`
            return "";
         end if;

         pragma assert(Library_Packages.state = Library_Packages.Reset);

         if is_known(t) then
            if del_txt'length = 1 then
               return del1;
            else
               return del2;
            end if;
         else
            return del_txt;
         end if;
      end image_of_del;

   function suffix_of_del(t: ADA_LIKE_OBJ) return ASnip.STR is
         use type Library_Packages.MACHINE_STATE;
            -- for "="
      begin
         if Library_Packages.state = Library_Packages.Dot then
            -- see the postcondition of `prefix_of_del`
            return "";
         else
            return maybe_suffix(t);
         end if;
      end suffix_of_del;


   function prefix_of_id(t: ADA_LIKE_OBJ) return ASnip.STR is
         use Library_Packages;
      begin
         case state is
            when Separator | Dot =>
               state := Pack;
            when Reset | Started | Pack =>
               null;
         end case;
         return "";
      end;

   function image_of_id(t: ADA_LIKE_OBJ) return ASnip.STR is
         use Library_Packages;
      begin
         if state = Pack then
            add_name_part(token_text(t));
            return "";
         else
            return token_text(t);
         end if;
      end image_of_id;


   function suffix_of_id(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         return "";
      end;


   -- It appears that "&" poses problem in MediaWiKi Ada templates
   -- The workaround is to use WiKi links.

   function prefix_of_op(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         if source_text(t) = "&" then
            return check_eot & "[[Ada Programming/Delimiters/&";
         else
            return check_eot & default_prefix & "operator";
         end if;
      end;

   function image_of_op(t: ADA_LIKE_OBJ) return ASnip.STR is
         op_txt: constant ASnip.STR := source_text(t);

         function op1 return ASnip.STR;
            -- one character operators except "&". Some can be used as
            -- written, others need one more word in the WiKi template.
            pragma inline(op1);

         function op2 return ASnip.STR;
            -- two character operators. One of them can be used as written,
            -- the others need one more word in the WiKi template.
            pragma inline(op2);

         function op1 return ASnip.STR is
            begin
               case op_txt(op_txt'first) is
                  when '<' => return " 2|less_than|<";
                  when '>' => return " 2|greater_than|>";
                  when '=' => return "|1==";
                  when '*' | '+' | '/' |  '-' =>
                     return "|" & op_txt;
                  when others => raise Program_Error;
               end case;
            end op1;

         function op2 return ASnip.STR is
            begin
               pragma assert(op_txt(op_txt'first + 1) = '='
                                or else op_txt(op_txt'first + 1) = '*');
               case op_txt(op_txt'first) is
                  when '<' => return " 2|1=less_than_or_equal_to|2=" & op_txt;
                  when '>' => return " 2|1=greater_than_or_equal_to|2=" & op_txt;
                  when '/' => return "|1=" & op_txt;
                  when '*' => return "|" & op_txt;
                  when others => raise Program_Error;
               end case;
            end op2;

      begin -- `image_of_op`
         pragma assert(op_txt'length <= 2);

         if not is_known(t) then
            return op_txt;
         elsif op_txt = "&" then
            return "|&";
         elsif op_txt'length = 1 then
            return op1;
         else
            return op2;
         end if;

      end image_of_op;

   function suffix_of_op(t: ADA_LIKE_OBJ) return ASnip.STR is
         op_txt: constant ASnip.STR := source_text(t);
      begin
         if op_txt = "&" then
            return "]]";
         else
            return default_suffix;
         end if;
      end;


   function prefix_of_num(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         return check_eot & "";
      end;

   function image_of_num(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         return token_text(t);
      end;

   function suffix_of_num(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         return "";
      end;


   function prefix_of_res(t: RES_TOKEN) return ASnip.STR is
      begin
         return check_eot & default_prefix & "keyword";
      end;

   function image_of_res(t: RES_TOKEN) return ASnip.STR is
         use Ada.Characters.Handling;
         tkw: constant STRING := to_lower(to_string(token_text(t)));
            -- a keyword that triggers the state machine
      begin
         if tkw = "with" or else tkw = "use" or else tkw = "package" then
            Library_Packages.state := Library_Packages.Started;
         end if;
         return "|" & token_text(t);
      end image_of_res;


   function suffix_of_res(t: RES_TOKEN) return ASnip.STR is
      begin
         return default_suffix;
      end;


   package Blanks is

      use Ada.Strings.Wide_Maps;

      -- ----------------------------------------------------------------
      -- Says what `ASnip.CHAR` is a blank so that prefix- and
      -- suffix-functions need not add markup to white separators.
      -- ----------------------------------------------------------------

      function Is_In (Element: ASnip.CHAR; Set: WIDE_CHARACTER_SET)
                     return BOOLEAN
         renames Ada.Strings.Wide_Maps.is_in;

      White: constant WIDE_CHARACTER_SET :=
         to_set(' ' & ASnip.CHAR'val(9)
                    & ASnip.CHAR'val(10)
                    & ASnip.CHAR'val(11)
                    & ASnip.CHAR'val(12)
                    & ASnip.CHAR'val(13));
   end Blanks;


   function prefix_of_sep(t: ADA_LIKE_OBJ) return ASnip.STR is
         use Library_Packages;
      begin
         case state is
            when Started | Separator =>
               state := Separator;
               return "";
            when Pack | Dot =>
               restart;
               return template;
            when Reset =>
               return "";
         end case;
      end prefix_of_sep;

   function image_of_sep(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         return source_text(t);
      end;

   function suffix_of_sep(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         return "";
      end;


   function prefix_of_strng(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         return check_eot & "";
      end;

   function image_of_strng(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         return source_text(t);
      end;

   function suffix_of_strng(t: ADA_LIKE_OBJ) return ASnip.STR is
      begin
         return "";
      end;

end Formatter.Ada_Like.WiKiBook;
