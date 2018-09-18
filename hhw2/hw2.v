module hw2(clk_50M,reset_n,write,write_value,uart_txd);

	input clk_50M;
	input reset_n;
	input write;
	input [7:0] write_value;
	output uart_txd ;
	
	reg [9:0] d_r;
	reg write_f;
	reg [9:0] d_i;
	reg load_f;
	wire clkb;
	
	F_Div F_Div(
		.CLK(clk_50M),
		.RST(reset_n),
		.CLK_Out(clkb)
		);
	
	always @( posedge clk_50M or negedge reset_n )begin
		if( !reset_n )begin
			d_r <= 10'h3ff;
			load_f <= 0;
		end
		else begin
			if( write == 0 && write_f == 1 )begin		//negedge write
				load_f <= 1;
				d_i <= { 
					1'b0,
					write_value[0],
					write_value[1],
					write_value[2],
					write_value[3],
					write_value[4],
					write_value[5],
					write_value[6],
					write_value[7],
					1'b1
					};		//load data
			end
			else if( clkb == 1 )begin		//115200hz
				if( load_f == 1 )begin
				load_f <= 0;
				d_r <= d_i;
				end
				else if( write == 0 && write_f == 0 )begin		//after load
					d_r <= { d_r[8:0], 1'b1 };		//shift 1 bit
				end
			end
			
			write_f <= write;		//write last state
		end
	end

	assign uart_txd = d_r[9];		//send data
	
endmodule 