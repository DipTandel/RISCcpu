LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY pc IS
PORT(
		clr	:IN STD_LOGIC;
		clk	:IN STD_LOGIC;
		ld		:IN STD_LOGIC;
		inc	:IN STD_LOGIC;
		d 		:IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		q 		:OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END pc;

ARCHITECTURE Behavior OF pc IS
-- fill here

	component add
		port (
			A	:	in std_logic_vector(31 downto 0);
			B	:	out std_logic_vector(31 downto 0)
		);
	end component;
	
	component mux2to1
		port (
			s			:	in std_logic;
			w0, w1	:	in std_logic_vector(31 downto 0);
			f			:	out std_logic_vector(31 downto 0)
		);
	end component;
	
	component register32
		port	(
			d		:	in std_logic_vector(31 downto 0);
			ld		:	in std_logic;
			clr	:	in std_logic;
			clk	:	in std_logic;
			Q		:	out std_logic_vector(31 downto 0)
		);
	end component;
	
	signal add_out :	std_logic_vector(31 downto 0);
	signal mux_out	:	std_logic_vector(31 downto 0);
	signal q_out	:	std_logic_vector(31 downto 0);
begin
	add0:	add port map(q_out, add_out);
	mux0:	mux2to1 port map (inc, d, add_out, mux_out);
	reg0:	register32 port map (mux_out, ld, clr, clk, q_out);
	q <= q_out;
END Behavior; 