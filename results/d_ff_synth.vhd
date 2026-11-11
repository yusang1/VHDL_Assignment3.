library ieee;
use ieee.std_logic_1164.all;
entity d_ff is
  port (
    d, clk: in std_logic;
    q: out std_logic
  );
end entity;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture rtl of d_ff is
  signal wrap_d: std_logic;
  signal wrap_clk: std_logic;
  signal wrap_q: std_logic;
  signal n6 : std_logic;
begin
  wrap_d <= d;
  wrap_clk <= clk;
  q <= wrap_q;
  wrap_q <= n6;
  -- /workspace/output/assignment3/vhdl/d_ff.vhd:9:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n6 <= wrap_d;
    end if;
  end process;
end rtl;
