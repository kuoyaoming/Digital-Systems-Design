`timescale 1ns/10ps

module hw4_tb;

reg 	clk_50M;
reg 	reset_n;
reg 	write;
wire 	write_complete;
reg 	[7:0] write_control;
reg 	[15:0] write_addr;
reg 	[7:0] write_value;
wire	i2c_sda;
wire	i2c_scl;


hw4 u1 (
    .clk_50M(clk_50M),
    .reset_n(reset_n),    
    .write(write),
    .write_control(write_control),
    .write_addr(write_addr),
    .write_value(write_value),
    .write_complete(write_complete),       
    // i2c bus
    .i2c_sda(i2c_sda),
    .i2c_scl(i2c_scl)
    ); 
    
M24AA256 u2(
    .A0(1'b0), 
    .A1(1'b0), 
    .A2(1'b0), 
    .WP(1'b0), 
    .SDA(i2c_sda), 
    .SCL(i2c_scl), 
    .RESET(~reset_n)
    );

always
  #10 clk_50M = ~clk_50M;
  
initial
  begin
  reset_n = 0;    
  clk_50M = 0 ;
  write = 0;
  write_control = 8'h00;
  write_addr = 16'h00;
  write_value = 8'h00;
    
  #30 reset_n = 1;  
  
  #1_000_000;
  
  i2c_write(8'ha0,16'h0000,8'h12);  // i2c write byte
   
  #6_000_000;
 
  i2c_write(8'ha0,16'h0001,8'h34);  // i2c write byte
  
  #6_000_000;   
  
  $finish;
  end
  
initial
  begin
  $monitor("time=%3d memory_000=0x%x memory_001=0x%x",$time,u2.MemoryByte_000[7:0],u2.MemoryByte_001[7:0]);
  end

  
task i2c_write; 
 input [7:0] control;
 input [15:0] addr; 
 input [7:0] data;  
 begin
  write_control = control;  
  write_addr = addr;
  write_value = data;
  
  #1_000; // 
  write = 1;
  #1_000; // 
  write = 0;
  
  wait(write_complete == 1);
  $display("time=%3d control=0x%x addr=0x%x data=0x%x", $time,control,addr,data);
 
 end
endtask 


  
endmodule