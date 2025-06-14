library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity alu is
port(
	a		:	in std_logic_vector(31 downto 0);
	b		:	in std_logic_vector(31 downto 0);
	op		:	in std_logic_vector(2 downto 0);
	result:	out std_logic_vector(31 downto 0);
	zero	: 	out std_logic;
	Cout	:	out std_logic
	);
end alu;

architecture Behavior of alu is
	component adder32
	port(
		Cin	:	in std_logic;
		x,y	:	in std_logic_vector(31 downto 0);
		s		:	out std_logic_vector(31 downto 0);
		Cout	:	out std_logic
		);
	end component;
	
	signal result_s	:	std_logic_vector(31 downto 0):= (others => '0');
	signal result_add	:	std_logic_vector(31 downto 0):= (others => '0');
	signal result_sub	:	std_logic_vector(31 downto 0):= (others => '0');
	signal Cout_s		:	std_logic := '0';
	signal Cout_add	:	std_logic := '0';
	signal Cout_sub	:	std_logic := '0';
	signal zero_s		:	std_logic;
	
begin
	add0	:	adder32 port map (op(2), a, b, result_add, Cout_add);
	sub0	:	adder32 port map (op(2), a, not b, result_sub, Cout_sub);
	
	process (a, b, op)
	begin
		case (op) is
			when "000" => -- 000 means a and b
				result_s <= a and b;
				Cout_s <= '0';
			when "001" => -- 001 means a or b
				result_s <= a or b;
				Cout_s <= '0';
			when "010" => -- 010 means a + b
				result_s <= result_add;
				Cout_s <= Cout_add;
			when "011" => -- 011 means b
				result_s <= b;
				Cout_s <= '0';
			when "110" => -- 110 means a - b
				result_s <= result_sub;
				Cout_s <= Cout_sub;
			when "100" => -- 100 means sll a
				result_s <= a(30 downto 0) & '0';
				Cout_s <= a(31);
			when "101" => -- 101 means srl a
				result_s <= '0' & a(31 downto 1);
				Cout_s <= '0';
			when others => -- else a
				result_s <= a;
				Cout_s <= '0';
		end case;
		
		case (result_s) is
			when (others => '0') =>
				zero_s <= '1';
			when others =>
				zero_s <= '0';
		end case;
	end process;
	
	result <= result_s;
	Cout <= Cout_s;
	zero <= zero_s;
	end Behavior;