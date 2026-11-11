library ieee;
use ieee.std_logic_1164.all;
entity rs_latch is
  port (
    s, r: in std_logic;
    q, qn: out std_logic
  );
end entity;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture rtl of rs_latch is
  signal wrap_s: std_logic;
  signal wrap_r: std_logic;
  signal wrap_q: std_logic;
  signal wrap_qn: std_logic;
  signal qi : std_logic;
  signal qni : std_logic;
  signal n2 : std_logic;
  signal n3 : std_logic;
  signal n4 : std_logic;
  signal n5 : std_logic;
begin
  wrap_s <= s;
  wrap_r <= r;
  q <= wrap_q;
  qn <= wrap_qn;
  wrap_q <= qi;
  wrap_qn <= qni;
  -- /workspace/output/assignment3/vhdl/rs_latch.vhd:7:8
  qi <= n3; -- (signal)
  -- /workspace/output/assignment3/vhdl/rs_latch.vhd:7:12
  qni <= n5; -- (signal)
  -- /workspace/output/assignment3/vhdl/rs_latch.vhd:10:16
  n2 <= wrap_r or qni;
  -- /workspace/output/assignment3/vhdl/rs_latch.vhd:10:9
  n3 <= not n2;
  -- /workspace/output/assignment3/vhdl/rs_latch.vhd:11:17
  n4 <= wrap_s or qi;
  -- /workspace/output/assignment3/vhdl/rs_latch.vhd:11:10
  n5 <= not n4;
end rtl;
