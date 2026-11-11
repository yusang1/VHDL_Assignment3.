library ieee;
use ieee.std_logic_1164.all;
use std.env.all;
entity tb_d_ff_async is end;
architecture sim of tb_d_ff_async is
signal d, clk, set, clr: std_logic := '0';
signal q: std_logic;
begin
uut: entity work.d_ff_async port map(d => d, clk => clk, set => set, clr => clr, q => q);
process begin
  -- Async clear low clock
  d <= '0';
  clk <= '0';
  set <= '0';
  clr <= '1';
  wait for 10 ns;
  assert q = '0' report "Async clear low clock" severity failure;
  -- Release clear
  clr <= '0';
  wait for 10 ns;
  assert q = '0' report "Release clear" severity failure;
  -- Async set low clock
  set <= '1';
  wait for 10 ns;
  assert q = '1' report "Async set low clock" severity failure;
  -- Clear priority both active
  clr <= '1';
  wait for 10 ns;
  assert q = '0' report "Clear priority both active" severity failure;
  -- Set remains asserted
  clr <= '0';
  wait for 10 ns;
  assert q = '1' report "Set remains asserted" severity failure;
  -- Release set
  set <= '0';
  wait for 10 ns;
  assert q = '1' report "Release set" severity failure;
  -- Normal capture zero
  clk <= '1';
  wait for 10 ns;
  assert q = '0' report "Normal capture zero" severity failure;
  -- High phase data hold
  d <= '1';
  wait for 10 ns;
  assert q = '0' report "High phase data hold" severity failure;
  -- Async set high clock
  set <= '1';
  wait for 10 ns;
  assert q = '1' report "Async set high clock" severity failure;
  -- Clear priority high clock
  clr <= '1';
  wait for 10 ns;
  assert q = '0' report "Clear priority high clock" severity failure;
  -- Release controls high clock
  set <= '0';
  clr <= '0';
  wait for 10 ns;
  assert q = '0' report "Release controls high clock" severity failure;
  -- Falling hold
  clk <= '0';
  wait for 10 ns;
  assert q = '0' report "Falling hold" severity failure;
  -- Normal capture one
  clk <= '1';
  wait for 10 ns;
  assert q = '1' report "Normal capture one" severity failure;
  -- Async clear high clock
  clr <= '1';
  wait for 10 ns;
  assert q = '0' report "Async clear high clock" severity failure;
  -- Release clear high clock
  clr <= '0';
  wait for 10 ns;
  assert q = '0' report "Release clear high clock" severity failure;
  -- Prepare zero
  clk <= '0';
  d <= '0';
  wait for 10 ns;
  assert q = '0' report "Prepare zero" severity failure;
  -- Capture zero again
  clk <= '1';
  wait for 10 ns;
  assert q = '0' report "Capture zero again" severity failure;
  report "PASS d_ff_async";
  stop; wait;
end process;
end;
