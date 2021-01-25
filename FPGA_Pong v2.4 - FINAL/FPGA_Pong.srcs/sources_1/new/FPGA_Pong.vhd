----------------------------------------------------------------------------------
---- VERSION 2.4 - FINAL
----------------------------------------------------------------------------------

library ieee;
use     ieee.std_logic_1164.all;
use     ieee.std_logic_unsigned.all;
--use     ieee.std_logic_arith.all;
--use     ieee.numeric_std.all;


entity FPGA_Pong is
Port (
        clk         :   in std_logic;
        ButtonInt   :   in std_logic                        :=  '0';
        Button2     :   in std_logic                        :=  '0';
        Button4     :   in std_logic                        :=  '0';
        leftScore   :   in integer                          range 0 to 5;
        rightScore  :   in integer                          range 0 to 5;
        led         :   inout std_logic_vector(7 downto 0)  := "00000000"
        );
end FPGA_Pong;



architecture Behavioral of FPGA_Pong is
type state is (IDLE,LtoR,RtoL,LScore,RScore,LWin,RWin);
signal  present_state       :   state;
signal  next_state          :   state;
signal  count               :   std_logic_vector(7 downto 0)    := "00000000";

-- Clock Signal Assignment:
signal  prescaled_clk       :   std_logic;
signal  new_clk             :   std_logic                       := '0';
signal  prescaler           :   std_logic_vector(23 downto 0)   := "101111101011110000100000"; --125MHz Clock add a zero at end for 2500Mhz;
signal  prescaler_counter   :   std_logic_vector(24 downto 0)   := (others => '0');
begin


----------------------------------------------------------------------------------
---- Clock Divider:
----------------------------------------------------------------------------------
prescaled_clk <= new_clk;
process(clk, new_clk) 
begin
    if (rising_edge(clk)) then
        prescaler_counter <= prescaler_counter + 1;
        if(prescaler_counter > prescaler) then
            new_clk <= not new_clk;
            prescaler_counter <= (others => '0');
        end if;
    end if;
end process;


----------------------------------------------------------------------------------
---- Resetting/Initialisation:
----------------------------------------------------------------------------------
process(prescaled_clk,ButtonInt)
begin
    if ButtonInt = '1' then
        present_state <= IDLE;                                   -- Initialise the program, allows system to be reset at any time
    elsif prescaled_clk' event and prescaled_clk = '1' then
        present_state <= next_state;
    end if;
end process;


----------------------------------------------------------------------------------
---- FSM Parameter Initialisation:
----------------------------------------------------------------------------------
process(prescaled_clk)
variable leftScore  :   integer;
variable rightScore :   integer;
variable holdCheck  :   boolean     :=  false;       -- holdCheck should default to false
variable testFix    :   boolean     :=  false;
variable direction  :   bit;      
begin
if(rising_edge(prescaled_clk)) then             -- Events occur on the rising edge of the clock signal
case (present_state) is                         -- Present-Next State Assignment


when IDLE =>    -- IDLE State:
    leftScore := 0;
    rightScore := 0;
    if Button4 = '1' then       -- If left player starts game
        direction := '0';       -- direction is left to right
        count <= "10000000";    -- set left LED
        next_state <= LtoR;     -- move to state 1
    elsif Button2 = '1' then    -- if right player starts
        direction := '1';       -- direction is right to left
        count <= "00000001";    -- set right LED
        next_state <= RtoL;     -- move to state 2
    else 
        next_state <= IDLE;     -- otherwise loop idle state
    end if;
    

when LtoR =>    -- Left to Right:
    case count is
        when "00000010" =>
            if (direction = '0' and Button2 = '1') then
                holdCheck := true;
                testFix := true;
                count <= '0' & count(7 downto 1);
                next_state <= LtoR;
            else
                holdCheck := false;
                testFix := true;
                count <= '0' & count(7 downto 1);
                next_state <= LtoR;
            end if;           
        
        when "00000001" =>
            if (Button2 = '1' and holdCheck = false) then 
                direction := '1';                           -- direction is right to left
                count <= "00000001";
                next_state <= RtoL;
            else
                count <= '0' & count(7 downto 1);           -- Decrement "count", shift LED right
                next_state <= LtoR;                         -- Loop State
            end if;           
        
        when "00000000" =>
            if (direction = '0' AND testFix = true) then
                leftScore := leftScore + 1;
                holdCheck := false;
                testFix := false;
                next_state <= LScore;
            end if;            
        
        when others =>
            count <= '0' & count(7 downto 1);           -- Decrement "count", shift LED right
            next_state <= LtoR;                          -- Loop State
    end case;
    

when RtoL =>    -- Right to Left:
    case count is
        when "01000000" =>
            if (Direction = '1' and Button4 = '1') then
                holdCheck := true;
                testFix := true;
                count <= count(6 downto 0) & '0'; 
                next_state <= RtoL;
            else
                holdCheck := false;
                testFix := true;
                count <= count(6 downto 0) & '0';
                next_state <= RtoL; 
            end if;
        
        when "10000000" =>
            if (Button4 = '1' and holdCheck = false) then
                direction := '0';                           -- direction is left to right
                count <= "10000000";                        -- Initialise Count
                next_state <= LtoR;
            else
                count <= count(6 downto 0) & '0';           -- Increment "count", shift LED left
                next_state <= RtoL;                         -- Loop state
            end if; 
        
        when "00000000" =>
            if (Direction = '1' AND testFix = true) then
                rightScore := rightScore + 1;               -- Increment Right Player's Score
                holdCheck := false;
                testFix := false;
                next_state <= RScore; 
            end if;
        
        when others =>
            count <= count(6 downto 0) & '0';               -- Increment "count", shift LED left
            next_state <= RtoL;                             -- Loop state
    end case;


when LScore =>  -- Left Scores:
    if (Button2 = '1') then
        direction := '1';
        count <= "00000001";
        next_state <= RtoL;
    elsif (leftScore < 5) then
        next_state <= LScore;
    else
        next_state <= LWin;
    end if;
    

when RScore =>  -- Right Scores:
    if (Button4 = '1') then
        direction := '0';
        count <= "10000000";
        next_state <= LtoR;
    elsif (rightScore < 5) then
        next_state <= RScore;
    else
        next_state <= RWin;
    end if;


when others =>
    next_state <= present_state;


end case;
end if;
end process;


----------------------------------------------------------------------------------
----FSM Output Functions:
----------------------------------------------------------------------------------
process(prescaled_clk) 
begin 
if prescaled_clk' event and prescaled_clk = '1' then
case (present_state) is 


when IDLE =>    -- Idle State
    led(7 downto 0) <= "00010000";
    if led <= "00010000" then
        led(7 downto 0) <= "00001000";
        if led <= "00001000" then
            led(7 downto 0) <= "00010000";
        end if;
    end if;


when LtoR =>    -- Left to Right
    led(7 downto 0) <= count;


when RtoL =>    -- Right to Left
    led(7 downto 0) <= count;


when LScore =>  -- Left Score
    led(7 downto 0) <= "11110000";
    if led <= "11110000" then
        led(7 downto 0) <= "00000000";
        if led <= "00000000" then
            led(7 downto 0) <= "11110000";
        end if;
    end if;
    

when RScore =>  -- Right Score
    led(7 downto 0) <= "00001111";
    if led <= "00001111" then
        led(7 downto 0) <= "00000000";
        if led <= "00000000" then
            led(7 downto 0) <= "00001111";
        end if;
    end if;


when LWin =>    -- Left Wins
    led(7 downto 0) <= "10000000";
    if led <= "00010000" then
        led(7 downto 0) <= "10000000";
    else
        led <= '0' & led(7 downto 1);
    end if; 


when RWin =>-- Right Wins
    led(7 downto 0) <= "00000001";
    if led <= "00001000" then
        led(7 downto 0) <= "00000001";
    else
        led <= led(6 downto 0) & '0';
    end if;   


end case;
end if;
end process;
end Behavioral;