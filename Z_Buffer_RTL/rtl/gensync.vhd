library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity gensync is
    Port ( CLK : in std_logic;
           reset : in std_logic;
           HSYNC : out std_logic;
           VSYNC : out std_logic;
		   IMG : out std_logic;
		   IMGY_out : out std_logic;
           X : out std_logic_vector(9 downto 0);
           Y : out std_logic_vector(8 downto 0)
           --read_X : out std_logic_vector(6 downto 0);
           --read_Y : out std_logic_vector(6 downto 0)
           );
end gensync;

architecture Behavioral of gensync is
signal 	comptX : std_logic_vector (9 downto 0);
signal 	comptY : std_logic_vector (9 downto 0);
signal 	Yaux : std_logic_vector (9 downto 0);
signal 	pulseX : std_logic;
signal 	pulseY: std_logic;
signal 	IMGX : std_logic;
signal 	IMGY : std_logic;
begin
Y<=Yaux(8 downto 0);

IMG<=IMGX AND IMGY;
IMGY_out <= IMGY;
process (clk)
begin 
	 if (CLK'event and CLK='1') then
		HSYNC<=pulseX;
		VSYNC<=pulseY;      
		  if (comptX<800 and (reset  ='1')) then  --800		 	
		 	  comptX<=comptX+1;
		  else 
	 		  comptX<="0000000000";
		  end if;
		  if comptX=0 then 
			  if (comptY<521 and reset='1') then --521  
				comptY<=comptY+1;
			  else 
				comptY<="0000000000";
			  end if;
		  end if;
	 end if;
end process;


process (comptX)
begin 
	if (comptX<92) then -- 86
		X<="0000000000";
		pulseX<='0';
		IMGX<='0';
	elsif (comptX<(92+46)) then -- 96+48 --92+46 -- 46
			X <= "0000000000";
			pulseX<='1';
			IMGX<='0';
	 elsif (comptX <(92+46+(128))) then -- 96+48+640  --92+46+576 affichage pixels --64
				X <= comptX-92-46-118;
				IMGX<='0';
				pulseX<='1';
		elsif (comptX <(92+46+630)) then -- 96+48+640  --92+46+576 affichage pixels --64
											   -- on perd 10 pixels a droite...
				X <= comptX-92-46-118;
				IMGX<='1';
				pulseX<='1';
			else 
				X<="0000000000";
				pulseX<='1';
				IMGX<='0';
	end if;
end process;

process (comptY)
begin 
	if (comptY<2) then --2
		Yaux<="0000000000";
		pulseY<='0';
		IMGY<='0';
	elsif (comptY<(2+29)) then --2+29  --2+26	
			Yaux<="0000000000";
			pulseY<='1';
			IMGY<='0';		
		elsif (comptY<(2+29+480)) then -- 2+29+480  -- 2+26+432 -- +128	
				Yaux<=comptY-2-29;   -- -2-29 -- -26
				pulseY<='1';
				IMGY<='1';
			else 
				Yaux<="0000000000";
				pulseY<='1';
				IMGY<='0';
	end if;
end process;

end Behavioral;
