library ieee;
use ieee.std_logic_1164.all;
use std.env.all;
entity tb_jk_ff is end;
architecture sim of tb_jk_ff is
signal j, k, clk: std_logic := '0';
signal q: std_logic;
begin
uut: entity work.jk_ff port map(j => j, k => k, clk => clk, q => q);
process begin
  -- Prepare reset
  j <= '0';
  k <= '1';
  clk <= '0';
  wait for 10 ns;
  -- Reset
  clk <= '1';
  wait for 10 ns;
  assert q = '0' report "Reset" severity failure;
  -- Prepare hold
  clk <= '0';
  j <= '0';
  k <= '0';
  wait for 10 ns;
  assert q = '0' report "Prepare hold" severity failure;
  -- Hold zero
  clk <= '1';
  wait for 10 ns;
  assert q = '0' report "Hold zero" severity failure;
  -- Prepare set
  clk <= '0';
  j <= '1';
  k <= '0';
  wait for 10 ns;
  assert q = '0' report "Prepare set" severity failure;
  -- Set
  clk <= '1';
  wait for 10 ns;
  assert q = '1' report "Set" severity failure;
  -- Prepare hold one
  clk <= '0';
  j <= '0';
  k <= '0';
  wait for 10 ns;
  assert q = '1' report "Prepare hold one" severity failure;
  -- Hold one
  clk <= '1';
  wait for 10 ns;
  assert q = '1' report "Hold one" severity failure;
  -- Prepare toggle
  clk <= '0';
  j <= '1';
  k <= '1';
  wait for 10 ns;
  assert q = '1' report "Prepare toggle" severity failure;
  -- Toggle to zero
  clk <= '1';
  wait for 10 ns;
  assert q = '0' report "Toggle to zero" severity failure;
  -- Falling hold
  clk <= '0';
  wait for 10 ns;
  assert q = '0' report "Falling hold" severity failure;
  -- Toggle to one
  clk <= '1';
  wait for 10 ns;
  assert q = '1' report "Toggle to one" severity failure;
  -- High phase hold
  j <= '0';
  k <= '1';
  wait for 10 ns;
  assert q = '1' report "High phase hold" severity failure;
  report "PASS jk_ff";
  stop; wait;
end process;
end;
