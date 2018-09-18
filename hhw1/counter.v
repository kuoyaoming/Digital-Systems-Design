module counter( clk, rst, in, out );
	
	input clk, rst, in;
	output reg [15:0] out;
	reg [15:0] rcut = 0;

	always @( posedge clk )begin
		if ( !rst )
			rcut <= 0;
		else if( in == 0)
			rcut <= 0;
		else
			rcut <= rcut + 1;
	end
	
	always @( negedge in )begin
		out <= rcut;
	end
	
endmodule 