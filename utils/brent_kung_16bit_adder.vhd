library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity brent_kung_16bit_adder is
    port (
        A : in std_logic_vector(15 downto 0);
        B : in std_logic_vector(15 downto 0);
        Cin : in std_logic;
        Sum : out std_logic_vector(15 downto 0);
        Carry : buffer std_logic_vector(16 downto 0)
    );
end entity brent_kung_16bit_adder;

architecture Structural of brent_kung_16bit_adder is
    signal G1,P1 : std_logic_vector(15 downto 0);
    signal G2,P2 : std_logic_vector(7 downto 0);
    signal G3,P3 : std_logic_vector(3 downto 0);
    signal G4,P4 : std_logic_vector(1 downto 0);
    signal G5,P5 : std_logic;
    component AND_2
        port (
            A, B : in std_logic;
            Y : out std_logic
        );
    end component AND_2;
    component XOR_2
        port (
            A, B : in std_logic;
            Y : out std_logic
        );
    end component XOR_2;
    component APLUSBC
        port (
            A, B, C : in std_logic;
            Y : out std_logic
        );
    end component APLUSBC;
begin
    Carry(0) <= Cin;

    --Generate using AND and Propagate using XOR at level 1
    G1_level: for i in 0 to 15 generate 
        G1_GENERATE : AND_2 port map(A(i), B(i), G1(i));
        G1_PROPAGATE : XOR_2 port map(A(i), B(i), P1(i));
    end generate G1_level;

    --Generate using APLUSBC and Propagate using AND of propagate of previous stage at remaining levels
    G2_level: for i in 0 to 7 generate         
        G2_GENERATE : APLUSBC port map(G1(2*i+1), P1(2*i+1), G1(2*i), G2(i));
        G2_PROPAGATE : AND_2 port map(P1(2*i+1), P1(2*i), P2(i));
        INTERMEDIATE_CARRY_GENERATE : APLUSBC port map(G1(2*i), P1(2*i), Carry(2*i), Carry(2*i+1)); --Odd carries 1,3,5,7...
    end generate G2_level;

    G3_level: for i in 0 to 3 generate      
        G3_GENERATE : APLUSBC port map(G2(2*i+1), P2(2*i+1), G2(2*i), G3(i));
        G3_PROPAGATE : AND_2 port map(P2(2*i+1), P2(2*i), P3(i));
        INTERMEDIATE_CARRY_GENERATE : APLUSBC port map(G2(2*i), P2(2*i), Carry(4*i), Carry(4*i+2)); --Carries 2,6,10,14
    end generate G3_level;

    G4_level: for i in 0 to 1 generate      
        G4_GENERATE : APLUSBC port map(G3(2*i+1), P3(2*i+1), G3(2*i), G4(i));
        G4_PROPAGATE : AND_2 port map(P3(2*i+1), P3(2*i), P4(i));
        INTERMEDIATE_CARRY_GENERATE : APLUSBC port map(G3(2*i), P3(2*i), Carry(8*i), Carry(8*i+4)); --Carries 4,12
    end generate G4_level;

    C8_GENERATE : APLUSBC port map(G4(0), P4(0), Carry(0), Carry(8)); --Carry 8
    FINAL_GENERATE : APLUSBC port map(G4(1), P4(1), G4(0), G5);
    FINAL_PROPAGATE : AND_2 port map(P4(1), P4(0), P5);

    SUM_GENERATE : for i in 0 to 15 generate
        S : XOR_2 port map(P1(i), Carry(i), Sum(i)); --Generation of Sum using XOR of Propagate and intermediate carries
    end generate SUM_GENERATE; 

    FINAL_CARRY_OUT : APLUSBC port map(G5, P5, Carry(0), Carry(16)); --Final carry
    
    
end architecture Structural;