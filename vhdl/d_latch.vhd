library ieee;
use ieee.std_logic_1164.all;
entity d_latch is
  port(d, en: in std_logic; q: out std_logic);
end entity;
architecture rtl of d_latch is
signal qi: std_logic;
begin
  process(d, en) begin
    if en = '1' then qi <= d; end if;
  end process;
  q <= qi;
end architecture;
