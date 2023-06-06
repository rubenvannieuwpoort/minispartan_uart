library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity main is
	port (
		clk: in std_logic;
		rx: in std_logic;
		tx: out std_logic := '1';
		led: out std_logic_vector(7 downto 0)
	);
end main;

architecture behavioral of main is
	constant data: std_logic_vector(7 downto 0) := "00100001";

	signal state: std_logic_vector(1 downto 0) := (others => '0');
	signal counter: std_logic_vector(30 downto 0) := (others => '0');
	signal bits_transmitted: std_logic_vector(3 downto 0) := (others => '0');
	signal leds: std_logic_vector(7 downto 0) := (others => '0');
begin
	led(7 downto 0) <= leds;

	process(clk)
	begin
		if rising_edge(clk) then
			if state = "00" and unsigned(counter) = 50000000 then
				tx <= '0';
				state <= "01";
				counter <= (others => '0');
				bits_transmitted <= (others => '0');
			elsif state = "01" and unsigned(counter) = 5208 then
				if to_integer(unsigned(bits_transmitted)) < 8 then
					tx <= data(to_integer(unsigned(bits_transmitted)));
					bits_transmitted <= std_logic_vector(unsigned(bits_transmitted) + 1);
					counter <= (others => '0');
				else
					tx <= '1';
					state <= "00";
					counter <= (others => '0');
					leds <= (others => '1');
				end if;
			else
				counter <= std_logic_vector(unsigned(counter) + 1);
			end if;
		end if;
	end process;
end behavioral;
