`timescale 1ns/1ns

module hw2_tb;

parameter BIT_PERIOD      = 8680; // (1/115200)*1,000,000,000

reg clk_50M;
reg reset_n;
reg write;
reg [7:0] write_value;
wire	uart_txd;
reg [7:0] RX_Serial;

integer ii;

hw2 u1 (
    clk_50M,
    reset_n,
    write,
    write_value,
    uart_txd
    );

always
  #10 clk_50M = ~clk_50M;
  
initial
  begin
  reset_n = 0;  
  write = 0;
  write_value = 8'h21;
  clk_50M = 0 ;
  #30 reset_n = 1;
  
  #205 write = 1;
  #512 write = 0;
  #300_000
  
  write_value = 8'h43;
  #345 write = 1;
  #273 write = 0;
  #300_000
  
  write_value = 8'h65;
  #445 write = 1;
  #173 write = 0;
  #300_000
      
  $finish;
  end

  
always@(posedge clk_50M)
 begin       
     wait(write == 1);       // wait write pulse  
     wait(write == 0);
     wait(uart_txd == 0);    // wait start bit
      
      #(BIT_PERIOD);
      #(BIT_PERIOD/2);      
      
      // receive Data Byte
      for (ii=0; ii<8; ii=ii+1)
        begin
          RX_Serial[ii] <= uart_txd;
          #(BIT_PERIOD);
        end            
      $display("uart rx data = %d ", RX_Serial);     
 end
  

initial
  begin
  $monitor("time=%3d reset_n=%d write=%d write_value=%d uart_txd=%d",$time,reset_n,write,write_value,uart_txd);
  end
  
endmodule