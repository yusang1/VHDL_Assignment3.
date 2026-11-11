library ieee;
use ieee.std_logic_1164.all;
use std.env.all;
entity tb_d_ff is end;
architecture sim of tb_d_ff is
signal d, clk: std_logic := '0';
signal q: std_logic;
begin
uut: entity work.d_ff port map(d => d, clk => clk, q => q);
process begin
  -- Initialize low phase
  clk <= '0';
  d <= '0';
  wait for 10 ns;
  -- Rising capture zero
  clk <= '1';
  wait for 10 ns;
  assert q = '0' report "Rising capture zero" severity failure;
  -- High phase hold
  d <= '1';
  wait for 10 ns;
  assert q = '0' report "High phase hold" severity failure;
  -- Falling edge hold
  clk <= '0';
  wait for 10 ns;
  assert q = '0' report "Falling edge hold" severity failure;
  -- Rising capture one
  clk <= '1';
  wait for 10 ns;
  assert q = '1' report "Rising capture one" severity failure;
  -- High phase hold one
  d <= '0';
  wait for 10 ns;
  assert q = '1' report "High phase hold one" severity failure;
  -- Falling hold one
  clk <= '0';
  wait for 10 ns;
  assert q = '1' report "Falling hold one" severity failure;
  -- Rising capture zero
  clk <= '1';
  wait for 10 ns;
  assert q = '0' report "Rising capture zero" severity failure;
  report "PASS d_ff";
  stop; wait;
end process;
end;
