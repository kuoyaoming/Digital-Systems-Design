module hw3(
	clk_50M,
	reset_n,    
	write,
	write_value,
	write_complete,    
	spi_csn,
	spi_sck,
	spi_do,
	spi_di
	);

input clk_50M;
input reset_n;
input write;
input[7:0] write_value;

output write_complete;
output spi_csn;
output spi_sck;
output spi_do;
output spi_di;

reg write_complete=0;
reg spi_csn=1;
reg spi_sck=0;
reg [3:0] ST=0;
reg [7:0] cnt=0;
reg [7:0] i=0;
reg [7:0] data=0;

assign spi_do = data[7];

always @(posedge clk_50M) begin
	
	case(ST)
		0: begin//latch
			write_complete <= 0;
			if(write) begin
				data[7:0] <= write_value;
				ST <= ST+1;
			end
		end
		
		1: begin//begin
			spi_csn <= 0;
			if(cnt>=200) begin
				cnt <= 0;
				ST <= ST+1;
			end
			else begin
				cnt <= cnt+1;
			end
		end
		
		2: begin//sent
			if(i<8) begin
				if(cnt>=0&&cnt<=25) begin
					cnt <= cnt+1;
					spi_sck <= 1; 
				end
				else if(cnt>25&&cnt<50)begin
					cnt <= cnt+1;
					spi_sck <= 0;
				end
				else if(cnt>=50)begin
					cnt <= 0;
					i <= i+1;
					data <= {data,1'b0};
				end
			end
			else begin
				ST <= ST+1;
				i <= 0;
			end
		end
		
		3: begin//done
			if(cnt>200) begin
				cnt <= 0;
				ST <= ST+1;
				spi_csn <= 1;
				write_complete <= 1;
			end
			else begin
				cnt <= cnt+1;
			end
		end
		
		4: begin//latch
			write_complete <= 0;
			if(write) begin
				data[7:0] <= write_value;
				ST <= ST+1;
			end
		end
		
		5: begin//begin
			spi_csn <= 0;
			if(cnt>=200) begin
				cnt <= 0;
				ST <= ST+1;
			end
			else begin
				cnt <= cnt+1;
			end
		end
		
		6: begin//sent
			if(i<8) begin
				if(cnt>=0&&cnt<=25) begin
					cnt <= cnt+1;
					spi_sck <= 1; 
				end
				else if(cnt>25&&cnt<50)begin
					cnt <= cnt+1;
					spi_sck <= 0;
				end
				else if(cnt>=50)begin
					cnt <= 0;
					i <= i+1;
					data <= {data,1'b0};
				end
			end
			else begin
				ST <= ST+1;
				write_complete <= 1;
				i <= 0;
			end
		end
		
		7: begin//latch
			write_complete <= 0;
			if(write) begin
				data[7:0] <= write_value;
				ST <= ST+1;
			end
		end
		
		8: begin//sent
			if(i<8) begin
				if(cnt>=0&&cnt<=25) begin
					cnt <= cnt+1;
					spi_sck <= 1; 
				end
				else if(cnt>25&&cnt<50)begin
					cnt <= cnt+1;
					spi_sck <= 0;
				end
				else if(cnt>=50)begin
					cnt <= 0;
					i <= i+1;
					data <= {data,1'b0};
				end
			end
			else begin
				write_complete <= 1;
				ST <= ST+1;
				i <= 0;
			end
		end
		
		9: begin//latch
			write_complete <= 0;
			if(write) begin
				data[7:0] <= write_value;
				ST <= ST+1;
			end
		end
		
		10: begin//sent
			if(i<8) begin
				if(cnt>=0&&cnt<=25) begin
					cnt <= cnt+1;
					spi_sck <= 1; 
				end
				else if(cnt>25&&cnt<50)begin
					cnt <= cnt+1;
					spi_sck <= 0;
				end
				else if(cnt>=50)begin
					cnt <= 0;
					i <= i+1;
					data <= {data,1'b0};
				end
			end
			else begin
				ST <= ST+1;
				i <= 0;
			end
		end
		
		11: begin//done
			if(cnt>200) begin
				cnt <= 0;
				ST <= 0;
				spi_csn <= 1;
				write_complete <= 1;
			end
			else begin
				cnt <= cnt+1;
			end
		end
		
		default: begin
			ST <= 0;
		end
		
	endcase
end
endmodule
