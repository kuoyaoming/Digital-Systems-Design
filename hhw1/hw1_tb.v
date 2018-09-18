`timescale 1ns/1ns

module hw1_tb;
reg clk_50M;
reg reset_n;
reg pulse;
wire [15:0] cnt_value;

counter u1 (
    clk_50M,
    reset_n,
    pulse,
    cnt_value
    );
    

always
  #10 clk_50M = ~clk_50M;
  
initial
  begin
  reset_n = 0;  
  pulse = 0;
  clk_50M = 0 ;
  #30 reset_n = 1;
  #205 pulse = 1;
  #512 pulse = 0;
  #345 pulse = 1;
  #273 pulse = 0;
  #445 pulse = 1;
  #173 pulse = 0;
  #200;
  $finish;
  end
  
initial
  begin
  $monitor("time=%3d reset_n=%d pulse=%d cnt_value=%d",$time,reset_n,pulse,cnt_value);
  end
  
endmodule