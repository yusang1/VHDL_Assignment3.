library ieee;
use ieee.std_logic_1164.all;
use std.env.all;
entity tb_d_latch is end;
architecture sim of tb_d_latch is
signal d, en: std_logic := '0';
signal q: std_logic;
begin
uut: entity work.d_latch port map(d => d, en => en, q => q);
process begin
  -- Initialize
  d <= '0';
  en <= '1';
  wait for 10 ns;
  assert q = '0' report "Initialize" severity failure;
  -- Transparent high
  d <= '1';
  en <= '1';
  wait for 10 ns;
  assert q = '1' report "Transparent high" severity failure;
  -- Transparent low
  d <= '0';
  en <= '1';
  wait for 10 ns;
  assert q = '0' report "Transparent low" severity failure;
  -- Close
  en <= '0';
  wait for 10 ns;
  assert q = '0' report "Close" severity failure;
  -- Hold despite D change
  d <= '1';
  wait for 10 ns;
  assert q = '0' report "Hold despite D change" severity failure;
  -- Reopen
  en <= '1';
  wait for 10 ns;
  assert q = '1' report "Reopen" severity failure;
  report "PASS d_latch";
  stop; wait;
end process;
end;
