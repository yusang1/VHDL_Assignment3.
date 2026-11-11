library ieee;
use ieee.std_logic_1164.all;
entity jk_ff is
  port(j, k, clk: in std_logic; q: out std_logic);
end entity;
architecture rtl of jk_ff is
signal qi: std_logic;
begin
  process(clk) begin
    if rising_edge(clk) then
      case j & k is
        when "00" => null;
        when "01" => qi <= '0';
        when "10" => qi <= '1';
        when "11" => qi <= not qi;
        when others => qi <= 'X';
      end case;
    end if;
  end process;
  q <= qi;
end architecture;
