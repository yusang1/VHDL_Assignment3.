library ieee;
use ieee.std_logic_1164.all;
entity rs_latch is
  port(s, r: in std_logic; q, qn: out std_logic);
end entity;
architecture rtl of rs_latch is
signal qi, qni: std_logic;
begin
  -- Cross-coupled NORs. S=R=1 forces both outputs low.
  qi <= not (r or qni);
  qni <= not (s or qi);
  q <= qi; qn <= qni;
end architecture;
