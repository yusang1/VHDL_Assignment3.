library ieee;
use ieee.std_logic_1164.all;
use std.env.all;
entity tb_rs_latch is end;
architecture sim of tb_rs_latch is
signal s, r: std_logic := '0';
signal q, qn: std_logic;
begin
uut: entity work.rs_latch port map(s => s, r => r, q => q, qn => qn);
process begin
  -- Reset
  s <= '0';
  r <= '1';
  wait for 10 ns;
  assert q = '0' report "Reset" severity failure;
  assert qn = '1' report "Qn: Reset" severity failure;
  -- Hold reset
  s <= '0';
  r <= '0';
  wait for 10 ns;
  assert q = '0' report "Hold reset" severity failure;
  assert qn = '1' report "Qn: Hold reset" severity failure;
  -- Set
  s <= '1';
  r <= '0';
  wait for 10 ns;
  assert q = '1' report "Set" severity failure;
  assert qn = '0' report "Qn: Set" severity failure;
  -- Hold set
  s <= '0';
  r <= '0';
  wait for 10 ns;
  assert q = '1' report "Hold set" severity failure;
  assert qn = '0' report "Qn: Hold set" severity failure;
  -- Forbidden both outputs zero
  s <= '1';
  r <= '1';
  wait for 10 ns;
  assert q = '0' report "Forbidden both outputs zero" severity failure;
  assert qn = '0' report "Qn: Forbidden both outputs zero" severity failure;
  -- Recover by reset
  s <= '0';
  r <= '1';
  wait for 10 ns;
  assert q = '0' report "Recover by reset" severity failure;
  assert qn = '1' report "Qn: Recover by reset" severity failure;
  report "PASS rs_latch";
  stop; wait;
end process;
end;
