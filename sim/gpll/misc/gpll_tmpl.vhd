component gpll is
    port(
        rstn_i: in std_logic;
        clki_i: in std_logic;
        lock_o: out std_logic;
        clkop_o: out std_logic
    );
end component;

__: gpll port map(
    rstn_i=>,
    clki_i=>,
    lock_o=>,
    clkop_o=>
);
