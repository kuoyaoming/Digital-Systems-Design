`timescale 1ns/1ns

module lab3_tb;

parameter DATA_LO_PERIOD      = 560_000; // 560us
parameter DATA0_HI_PERIOD  = 560_000; // 560us
parameter DATA1_HI_PERIOD  = 1690_000; // 560us

reg clk_50M;
reg reset_n;
wire [3:0] key;
reg ir;
wire [6:0] hex0;
wire [6:0] hex1;
wire [6:0] hex2;
wire [6:0] hex3;
wire [6:0] hex4;
wire [6:0] hex5;
wire [6:0] hex6;
wire [6:0] hex7;


hw03 u1(
                //////// CLOCK //////////
                .CLOCK_50(clk_50M),
                .KEY(key),
                //////// SEG7 //////////
                .HEX0(hex0),
                .HEX1(hex1),
                .HEX2(hex2),
                .HEX3(hex3),
                .HEX4(hex4),
                .HEX5(hex5),
                .HEX6(hex6),
                .HEX7(hex7),
                        //////// IR Receiver //////////
                .RXD(ir)                      
        );  


always
  #10 clk_50M = ~clk_50M;
  
assign key[0] = reset_n;
assign key[1] = reset_n;
assign key[2] = reset_n;
assign key[3] = reset_n;

initial
  begin
  reset_n = 0;  
  clk_50M = 0 ;
  ir = 0;
  
  #30 reset_n = 1;
  
  // ir random noise
  #1_000_000;
  ir = 1;
  #20_000_000;
  ir = 0;
  #1_000_000;
  ir = 1;
  #3_000_000;

  // ir packet 
  send_ir_leader();  
  send_ir_byte(8'h12);   // customer code
  send_ir_byte(8'h34);   // customer code
  send_ir_byte(8'h56);   // key code
  send_ir_byte(8'hA9);   // key code reverse
  send_ir_end();       
  
  #20_000_000;
  $finish;
  end
  
initial
  begin
  $monitor("time=%3d reset_n=%d hex0=%x hex1=%x hex2=%x hex3=%x hex4=%x hex5=%x hex6=%x hex7=%x",$time,reset_n,hex0,hex1,hex2,hex3,hex4,hex5,hex6,hex7);
  end
  
task send_ir_leader;  
 begin
  ir = 0;
  #9_000_000; // 9ms Lo
  ir = 1;
  #4_500_000; // 4.5ms Hi
 end
endtask 

task send_ir_byte;
  input [7:0] byte;
  integer i;
  begin
  $display("send ir = %x ",byte);
  for (i=0; i<8; i=i+1) 
     begin 
     ir = 0;
     #(DATA_LO_PERIOD);
     ir = 1;
     if(byte[0])
       #(DATA1_HI_PERIOD);
     else
       #(DATA0_HI_PERIOD); 
     byte = byte >> 1;       
     end      
  end   
endtask 

task send_ir_end;  
 begin
  ir = 0;
  #(DATA_LO_PERIOD);  
  ir = 1;  
 end
endtask
  
endmodule