library ieee;
use ieee.std_logic_1164.all;
entity d_latch is
  port (
    d, en: in std_logic;
    q: out std_logic
  );
end entity;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture rtl of d_latch is
  signal wrap_d: std_logic;
  signal wrap_en: std_logic;
  signal wrap_q: std_logic;
  signal qi : std_logic;
  signal n5 : std_logic;
begin
  wrap_d <= d;
  wrap_en <= en;
  q <= wrap_q;
  wrap_q <= qi;
  -- /workspace/output/assignment3/vhdl/d_latch.vhd:7:8
  qi <= n5; -- (signal)
  -- /workspace/output/assignment3/vhdl/d_latch.vhd:9:3
  n5 <= wrap_d when wrap_en = '1' else n5;
end rtl;
