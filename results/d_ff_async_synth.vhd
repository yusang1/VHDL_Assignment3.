library ieee;
use ieee.std_logic_1164.all;
entity d_ff_async is
  port (
    d, clk, set, clr: in std_logic;
    q: out std_logic
  );
end entity;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture rtl of d_ff_async is
  signal wrap_d: std_logic;
  signal wrap_clk: std_logic;
  signal wrap_set: std_logic;
  signal wrap_clr: std_logic;
  signal wrap_q: std_logic;
  signal n6 : std_logic;
  signal n10 : std_logic;
  signal n11 : std_logic;
begin
  wrap_d <= d;
  wrap_clk <= clk;
  wrap_set <= set;
  wrap_clr <= clr;
  q <= wrap_q;
  wrap_q <= n11;
  -- /workspace/output/assignment3/vhdl/d_ff_async.vhd:10:5
  n6 <= '1' when wrap_clr = '0' else '0';
  -- /workspace/output/assignment3/vhdl/d_ff_async.vhd:3:8
  n10 <= wrap_clr or wrap_set;
  -- /workspace/output/assignment3/vhdl/d_ff_async.vhd:11:5
  process (wrap_clk, n10, n6)
  begin
    if n10 = '1' then
      n11 <= n6;
    elsif rising_edge (wrap_clk) then
      n11 <= wrap_d;
    end if;
  end process;
end rtl;
