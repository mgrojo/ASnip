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

generic

   type INDEX is range <>;
      -- only integer types, for simplicity

   type ELEMENT is limited private;
   with function "<"(a, b: ELEMENT) return BOOLEAN is <>;
   with function "="(a, b: ELEMENT) return BOOLEAN is <>;

   type SORTED_LIST is array(INDEX range <>) of ELEMENT;

function binary_search(container: SORTED_LIST; item: ELEMENT) return BOOLEAN;
   -- ! pre: items in `container` are ordered by "<", or otherwise "="
   -- ! post: result = (`item` is present in `container`)


-- ----------------------------------------------------------------
-- Three implementations of `binary_search`. They differ in execution
-- speed. The differences also differ among compilers.
-- ----------------------------------------------------------------


-- (1)
--function binary_search
--      (container: SORTED_LIST; item: ELEMENT) return BOOLEAN is
--   -- recursion using array slices of decreasing lengths
--
--      mid: constant INDEX := (container'first + container'last) / 2;
--   begin
--      if container'length = 0 then
--         return False;
--      elsif container'length = 1 then
--         return container(container'last) = item;
--      elsif container(mid) < item then
--         return binary_search(container(INDEX'succ(mid) .. container'last),
--                              item);
--      else
--         return binary_search(container(container'first .. mid), item);
--      end if;
--   end binary_search;

-- (2)
function binary_search
      (container: SORTED_LIST; item: ELEMENT) return BOOLEAN is
   -- uses array indexing in recursive calls

      function search(j, k: INDEX) return BOOLEAN;
         -- increase `j` or decrease `k` in recursive calls
         -- ! pre: j <= k

         pragma inline(search);

      function search(j, k: INDEX) return BOOLEAN is
            mid: constant INDEX := (j + k) / 2;
         begin
            if j = k then
               return container(k) = item;
            elsif container(mid) < item then
               return search(INDEX'succ(mid), k);
            else
               return search(j, mid);
            end if;
         end search;

   begin
      if container'length = 0 then
         return False;
      else
         return search(container'first, container'last);
      end if;
   end binary_search;


-- (3) The following version is like the above, but uses a loop and
-- "manual inlining". Probably the fastest.

--function binary_search
--      (container: SORTED_LIST; item: ELEMENT) return BOOLEAN is
--   -- array indexing and recursion replaced by a loop
--      j: INDEX;
--      k: INDEX;
--      mid: INDEX;
--   begin
--      if container'length = 0 then
--         return False;
--      else
--         j := container'first;
--         k := container'last;
--         -- ! assert j <= k
--         mid := (j + k) / 2;
--         while j < k loop
--            if container(mid) < item then
--               j := INDEX'succ(mid);
--            else
--               k := mid;
--            end if;
--            mid := (j + k) / 2;
--         end loop;
--         -- ! assert: j = k
--         return container(k) = item;
--      end if;
--   end binary_search;


