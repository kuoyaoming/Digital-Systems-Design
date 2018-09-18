module F_Div( CLK, RST, CLK_Out ); //50MHz => 1KHz

    parameter    Div  = 9'd434;
    parameter    DivW = 9;

    input   CLK, RST;
    output  CLK_Out;
    reg     CLK_Out;
    reg     [DivW-1:0] CLK_Cnt = 0;

    always @( posedge CLK, negedge RST ) begin
        if( !RST )
            CLK_Cnt <= 0;
        else if( CLK_Cnt == Div-1 )
            CLK_Cnt <= 0;
        else
            CLK_Cnt <= CLK_Cnt + 1'b1;
    end
    always @( posedge CLK or negedge RST ) begin
        if( !RST )
            CLK_Out <= 0;
        else if( CLK_Cnt == 0 )
            CLK_Out <= 1;
        else
            CLK_Out <= 0;
    end

endmodule 