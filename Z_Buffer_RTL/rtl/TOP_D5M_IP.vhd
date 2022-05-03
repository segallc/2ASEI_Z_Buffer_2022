--
-- Camille SEGALL et Clément TARDY le 11/04/2022
-- 
-- Acquisition d'images 256x256 8 bits RVB
--
--  KEY3 : start acquisition
--  KEY2 : stop acquisition 
--  KEY1 : augmente temps acquisition si SW0 = 0
--  	   : diminue temps acquisition si SW0 = 1
--  KEY0 : RESETn
-- (gestion par D5M_IP.v)
--
--  SW1 : couleurs si 0
--        N&B si 1
-- (gestion par image_process.vhd)
--
-- 
-- Nota : signaux VGA indispensables: VGA R/V/B(7..1)
--												  VGA / _CLK / VS / HS / SYNC_N / BLANK_N
-- 

LIBRARY ieee;
USE ieee.std_logic_1164.all; 
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

LIBRARY work;

ENTITY TOP_D5M_IP IS 
	PORT
	(
		CLOCK_50 :  IN  STD_LOGIC;
		CCD_FVAL :  IN  STD_LOGIC;
		CCD_LVAL :  IN  STD_LOGIC;
		CCD_PIXCLK :  IN  STD_LOGIC;
		I2C_SCLK :  INOUT  STD_LOGIC;
		I2C_SDAT :  INOUT  STD_LOGIC;
		CCD_DATA :  IN  STD_LOGIC_VECTOR(11 DOWNTO 0);
		KEY :  IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
		SW :  IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
		CCD_MCCLK :  OUT  STD_LOGIC;
		TRIGGER :  OUT  STD_LOGIC;
		RESETn :  OUT  STD_LOGIC;
		VGA_VS :  OUT  STD_LOGIC;
		VGA_HS :  OUT  STD_LOGIC;
		LEDG :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		VGA_B :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		VGA_G :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		VGA_R :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		VGA_CLK : OUT STD_LOGIC;
		VGA_BLANK_N : OUT STD_LOGIC;
		VGA_SYNC_N : OUT STD_LOGIC;
		VGA_HS_OBS : OUT STD_LOGIC;
		VGA_VS_OBS : OUT STD_LOGIC;
		VGA_BLANK_N_OBS : OUT STD_LOGIC;
		VGA_G7_OBS : OUT STD_LOGIC
	);
END TOP_D5M_IP;

ARCHITECTURE bdf_type OF TOP_D5M_IP IS 

attribute chip_pin          		: string;

--Carte DE1-SOC
attribute chip_pin of CLOCK_50  : signal is "AF14";

attribute chip_pin of VGA_HS  : signal is "B11"; --
attribute chip_pin of VGA_VS  : signal is "D11"; --

attribute chip_pin of VGA_CLK  : signal is "A11";
attribute chip_pin of VGA_BLANK_N  : signal is "F10";
attribute chip_pin of VGA_SYNC_N  : signal is "C10";		
		
--
attribute chip_pin of VGA_G  : signal is "E11,F11,G12,G11,G10,H12,J10,J9";
attribute chip_pin of VGA_R  : signal is "F13,E12,D12,C12,B12,E13,C13,A13";
attribute chip_pin of VGA_B  : signal is "J14,G15,F15,H14,F14,H13,G13,B13";
--
--attribute chip_pin of LEDR  : signal is "G19,F19,E19,F21,F15,G15,G16,H16";
attribute chip_pin of LEDG  : signal is "W20,Y19,W19,W17,V18,V17,W16,V16";
attribute chip_pin of KEY  : signal is "Y16,W15,AA15,AA14";
attribute chip_pin of SW  : signal is "AE12,AD10,AC9,AE11,AD12,AD11,AF10,AF9,AC12,AB12";

---- Camera GPIO_1 Camera D5M
attribute chip_pin of CCD_FVAL :  signal is "AK24";
attribute chip_pin of CCD_LVAL :   signal is "AJ24";
attribute chip_pin of CCD_PIXCLK :   signal is "AB17";
attribute chip_pin of I2C_SCLK :   signal is "AK23";
attribute chip_pin of I2C_SDAT :   signal is "AG23";
attribute chip_pin of CCD_MCCLK  : signal is "AK27";
attribute chip_pin of CCD_DATA  : signal is "AA21,AC23,AD24,AE23,AE24,AF25,AF26,AG25,AG26,AH24,AH27,AJ27";
attribute chip_pin of TRIGGER  : signal is "AH25";
attribute chip_pin of RESETn  : signal is "AJ26";

-- Controle timing VGA_B GPIO_0 (en haut gauche droite)
attribute chip_pin of VGA_HS_OBS  : signal is "AC18";      -- GPIO_0(0)
attribute chip_pin of VGA_VS_OBS  : signal is "Y17";        -- GPIO_0(1)
attribute chip_pin of VGA_BLANK_N_OBS  : signal is "AD17";  -- GPIO_0(2)
attribute chip_pin of VGA_G7_OBS  : signal is "Y18";  -- GPIO_0(3)

COMPONENT b1
	PORT (  clk : IN STD_LOGIC;
			rst : IN STD_LOGIC;
			req_1 : IN STD_LOGIC;
			ack_1 : OUT STD_LOGIC;
			req_2 : OUT STD_LOGIC;
			ack_2 : IN STD_LOGIC;
			point_A : IN STD_LOGIC_VECTOR (23 DOWNTO 0);
			point_B : IN STD_LOGIC_VECTOR (23 DOWNTO 0);
			point_C : IN STD_LOGIC_VECTOR (23 DOWNTO 0);
			point_out_a : OUT STD_LOGIC_VECTOR (23 DOWNTO 0);
			point_out_b : OUT STD_LOGIC_VECTOR (23 DOWNTO 0)
	);
END COMPONENT;

COMPONENT starter
	PORT (  clk : 		 IN STD_LOGIC;
			rst : 		 IN STD_LOGIC;
			req_1 : 	 OUT STD_LOGIC;
			ack_1 : 	 IN STD_LOGIC;
			key1 : 	 	 IN STD_LOGIC;
			color : 	 OUT STD_LOGIC_VECTOR (23 DOWNTO 0);
			point_rega : OUT STD_LOGIC_VECTOR (23 DOWNTO 0);
			point_regb : OUT STD_LOGIC_VECTOR (23 DOWNTO 0);
			point_regc : OUT STD_LOGIC_VECTOR (23 DOWNTO 0)
	);
END COMPONENT;

COMPONENT bresenham_fill
	PORT (  clk : 			 IN STD_LOGIC;
			rst : 			 IN STD_LOGIC;
			req_2 : 		 IN STD_LOGIC;
			ack_2 : 		 OUT STD_LOGIC;
			point_out_a_x :  IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			point_out_b_xy : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			rgb : 			 IN STD_LOGIC_VECTOR (23 DOWNTO 0);
			rdata : 		 OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
			gdata : 		 OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
			bdata : 		 OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
			waddr : 		 OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
			we : 			 OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT simple_ram_dual_clock
	PORT( data : 	   IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		  read_addr :  IN STD_LOGIC_VECTOR(15 DOWNTO 0); -- IMAGE 256 x 256
		  write_addr : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
	      we : 		   IN STD_LOGIC;
		  read_clk :   IN STD_LOGIC;
		  write_clk :  IN STD_LOGIC;
		  q : 		   OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT gensync
	PORT(CLK : 		IN STD_LOGIC;
		 reset : 	IN STD_LOGIC;
		 HSYNC :    OUT STD_LOGIC;
		 VSYNC :    OUT STD_LOGIC;
		 IMG :      OUT STD_LOGIC;
		 IMGY_out : OUT STD_LOGIC;
		 X : 		OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
		 Y : 		OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
	);
END COMPONENT;

COMPONENT image_process
		PORT(IMG	   : in std_logic;
		reset    : in std_logic;
		SW1     : in std_logic;
		VGA_HS	   : in std_logic;
		VGA_VS	   : in std_logic;
		VGA_CLK	   : in std_logic;
		X_Cont   : in std_logic_vector(7 downto 0);
		Y_Cont   : in std_logic_vector(7 downto 0);  -- image 256 x 256		
		r	   : in std_logic_vector(7 downto 0);
		g	   : in std_logic_vector(7 downto 0);
		b	   : in std_logic_vector(7 downto 0);
		r_out	: out std_logic_vector(7 downto 0);
		g_out	: out std_logic_vector(7 downto 0);
		b_out	: out std_logic_vector(7 downto 0)
		);
END COMPONENT;
		
COMPONENT altpll0
	PORT(inclk0 : IN STD_LOGIC;
		 c0 : OUT STD_LOGIC;
		 locked : OUT STD_LOGIC
	);
END COMPONENT;

SIGNAL	memr_ad :  STD_LOGIC_VECTOR(15 DOWNTO 0);  -- 256 x 256 carre
SIGNAL	memw_ad :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL  req_1, ack_1, req_2, ack_2 : STD_LOGIC;
SIGNAL  point_a, point_b, point_c, point_out_a, point_out_b, rgb : STD_LOGIC_VECTOR(23 DOWNTO 0);
SIGNAL	sCCD_VAL :  STD_LOGIC;
SIGNAL	CCD_MCCLK_i :  STD_LOGIC;
SIGNAL	VGA_G_i,VGA_B_i,VGA_R_i :  STD_LOGIC_VECTOR(11 DOWNTO 0);
SIGNAL	x_read :  STD_LOGIC_VECTOR(9 DOWNTO 0);
SIGNAL	X_write :  STD_LOGIC_VECTOR(11 DOWNTO 0);
SIGNAL	y_read :  STD_LOGIC_VECTOR(8 DOWNTO 0);
SIGNAL	Y_write :  STD_LOGIC_VECTOR(10 DOWNTO 0);
SIGNAL	rdclock :  STD_LOGIC;
SIGNAL	wren :  STD_LOGIC;
SIGNAL	IMG,CLK_25 :  STD_LOGIC;
SIGNAL	b,r,b_out,r_out,g,g_out :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	Noir_et_blanc_int :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	qg,qb,qr,g_out_in :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	IMGY_out,VGA_CLK_i :  STD_LOGIC;
SIGNAL	VGA_H_int,VGA_V_int,PWM_out :  STD_LOGIC;


BEGIN 

VGA_CLK <= CLK_25;
VGA_BLANK_N <=  IMG;
VGA_SYNC_N <= CLK_25;
VGA_HS <= VGA_H_int;
VGA_VS <= VGA_V_int;
VGA_HS_OBS <= VGA_H_int;
VGA_VS_OBS <= VGA_V_int;
VGA_BLANK_N_OBS <= IMG;
VGA_G7_OBS <= g_out_in(7);
g_out <= g_out_in;

VGA_R <= r_out;  -- sans le blanker
VGA_G <= g_out;
VGA_B <= b_out;

b2v_inst : b1
PORT MAP(clk => CLOCK_50,
		 rst => KEY(0),
		 req_1 => req_1,
		 ack_1 => ack_1,
		 req_2 => req_2,
		 ack_2 => ack_2,
		 point_a => point_a,
		 point_b => point_b,
		 point_c => point_c,
		 point_out_a => point_out_a,
		 point_out_b => point_out_b
);

b2v_inst1 : bresenham_fill
PORT MAP(clk => CLOCK_50,
		 rst => KEY(0),
		 req_2 => req_2,
		 ack_2 => ack_2,
		 point_out_a_x  => point_out_a (23 DOWNTO 16),
		 point_out_b_xy => point_out_b (23 DOWNTO 8),
		 rgb => rgb,
		 rdata => VGA_R_i(11 DOWNTO 4),
		 gdata => VGA_G_i(11 DOWNTO 4),
		 bdata => VGA_B_i(11 DOWNTO 4),
		 waddr => memw_ad,
		 we    => wren
);

b2v_inst2 : starter
PORT MAP(   clk => CLOCK_50,
			rst => KEY(0),
			req_1 => req_1,
			ack_1 => ack_1,
			color => rgb,
			point_rega => point_a,
			point_regb => point_b,
			point_regc => point_c,
			key1 => KEY(1)
);

b2v_inst3 : simple_ram_dual_clock
PORT MAP(data => VGA_G_i(11 DOWNTO 4),  -- noir et blanc depuis G
         read_addr => memr_ad,
		 write_addr => memw_ad,
		 we => wren,
		 read_clk => rdclock,
 	     write_clk => CCD_MCCLK_i,
		 q => g
);

b2v_inst31 : simple_ram_dual_clock
PORT MAP(data => VGA_R_i(11 DOWNTO 4),  -- noir et blanc depuis G
         read_addr => memr_ad,
		 write_addr => memw_ad,
		 we => wren,
		 read_clk => rdclock,
 	     write_clk => CCD_MCCLK_i,
		 q => r
);

b2v_inst32 : simple_ram_dual_clock
PORT MAP(data => VGA_B_i(11 DOWNTO 4),  -- noir et blanc depuis G
         read_addr => memr_ad,
		 write_addr => memw_ad,
		 we => wren,
		 read_clk => rdclock,
 	     write_clk => CCD_MCCLK_i,
		 q => b
);


		 
-- Pour 256x256
--memw_ad(7 DOWNTO 0) <= X_write(9 DOWNTO 2);
--memw_ad(15 DOWNTO 8) <= Y_write(9 DOWNTO 2);  -- 8 bits

memr_ad(7 DOWNTO 0) <= x_read(8 DOWNTO 1);
memr_ad(15 DOWNTO 8) <= y_read(8 DOWNTO 1);

b2v_inst4 : gensync
PORT MAP(CLK => CLK_25,
		 reset => KEY(0),
		 HSYNC => VGA_H_int,
		 VSYNC => VGA_V_int,
		 IMG => IMG,
		 IMGY_out => IMGY_out,
		 X => x_read,
		 Y => y_read);


b2v_inst5 : image_process
PORT MAP(IMG	 => IMG,
		reset  => KEY(0),
		SW1   => SW(1),
		VGA_HS => VGA_H_int,
		VGA_VS => VGA_V_int,
		VGA_CLK	 => CLK_25,
		X_Cont   => memr_ad(7 DOWNTO 0), 
		Y_Cont   => memr_ad(15 DOWNTO 8),  -- image 256 x 256
		r	=> r,
		g	=> g,
		b  => b,
		r_out	=> r_out,
		g_out	=> g_out_in,
		b_out	=> b_out);

rdclock <= CLK_25;
CCD_MCCLK  <= CCD_MCCLK_i;

b2v_inst9 : altpll0
PORT MAP(inclk0 => CLOCK_50,
		 c0 => CLK_25);

END bdf_type;
