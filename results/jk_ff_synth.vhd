library ieee;
use ieee.std_logic_1164.all;
entity jk_ff is
  port (
    j, k, clk: in std_logic;
    q: out std_logic
  );
end entity;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture rtl of jk_ff is
  signal wrap_j: std_logic;
  signal wrap_k: std_logic;
  signal wrap_clk: std_logic;
  signal wrap_q: std_logic;
  signal qi : std_logic;
  signal n4 : std_logic_vector (1 downto 0);
  signal n6 : std_logic;
  signal n8 : std_logic;
  signal n10 : std_logic;
  signal n11 : std_logic;
  signal n13 : std_logic;
  signal n14 : std_logic_vector (3 downto 0);
  signal n18 : std_logic;
  signal n21 : std_logic;
begin
  wrap_j <= j;
  wrap_k <= k;
  wrap_clk <= clk;
  q <= wrap_q;
  wrap_q <= qi;
  -- /workspace/output/assignment3/vhdl/jk_ff.vhd:7:8
  qi <= n21; -- (signal)
  -- /workspace/output/assignment3/vhdl/jk_ff.vhd:11:14
  n4 <= wrap_j & wrap_k;
  -- /workspace/output/assignment3/vhdl/jk_ff.vhd:12:9
  n6 <= '1' when n4 = "00" else '0';
  -- /workspace/output/assignment3/vhdl/jk_ff.vhd:13:9
  n8 <= '1' when n4 = "01" else '0';
  -- /workspace/output/assignment3/vhdl/jk_ff.vhd:14:9
  n10 <= '1' when n4 = "10" else '0';
  -- /workspace/output/assignment3/vhdl/jk_ff.vhd:15:28
  n11 <= not qi;
  -- /workspace/output/assignment3/vhdl/jk_ff.vhd:15:9
  n13 <= '1' when n4 = "11" else '0';
  n14 <= n13 & n10 & n8 & n6;
  -- /workspace/output/assignment3/vhdl/jk_ff.vhd:11:7
  with n14 select n18 <=
    n11 when "1000",
    '1' when "0100",
    '0' when "0010",
    qi when "0001",
    'X' when others;
  -- /workspace/output/assignment3/vhdl/jk_ff.vhd:10:5
  process (wrap_clk)
  begin
    if rising_edge (wrap_clk) then
      n21 <= n18;
    end if;
  end process;
end rtl;
