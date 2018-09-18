module hw4(
    clk_50M,
    reset_n,    
    write,
    write_control,
    write_addr,
    write_value,
    write_complete,  
    i2c_sda,
    i2c_scl
    );

input clk_50M;
input reset_n;
input write;
input [7:0]write_control;
input [15:0]write_addr;
input [7:0]write_value;

output reg write_complete;
output reg i2c_sda;
output reg i2c_scl;

reg [31:0] data;
reg [7:0] cnt;
reg [3:0] ST;
reg [7:0] i;
reg [1:0] ii;


always@(posedge clk_50M or negedge reset_n)begin
	if(!reset_n) begin
		write_complete <= 0;
		i2c_scl <= 1;
		i2c_sda <= 1;
		data <= 0;
		cnt <= 0;
		ST <= 0;
		i <= 0;
		ii <= 0;
	end
	else begin
		case(ST)
			0: begin//latch
				write_complete <= 0;
				if(write) begin
					data[31:24] <= write_control;
					data[23:8] <= write_addr;
					data[7:0] <= write_value;
					ST <= ST+1;
				end
			end
			
			1: begin//Start condition
				if(cnt>=0&&cnt<30) begin
					i2c_sda <= 0;
					cnt <= cnt+1;
				end
				else if(cnt>=30&&cnt<95) begin
					i2c_scl <= 0;
					cnt <= cnt+1;
				end
				else if(cnt>=95) begin
					ST <= ST+1;
					cnt <= 0;
				end
			end
			
			2: begin//Sent
				if(i<8) begin
					i2c_sda <= data[31];
					if(cnt>=0&&cnt<30) begin
						cnt <= cnt+1;
						i2c_scl <= 1; 
					end
					else if(cnt==30)begin
						cnt <= cnt+1;
						i2c_scl <= 0;
						data <= {data,1'b0};
					end
					else if(cnt>=30&&cnt<95)begin
						cnt <= cnt+1;
					end
					else if(cnt>=95)begin
						cnt <= 0;
						i <= i+1;
					end
				end
				else begin
					if(ii<3)begin
						ii <= ii+1;
						ST <= ST+1;
					end
					else begin
						ii <= 0;
						ST <= 4;
					end
					i <= 0;
				end
			end
			
			3: begin
				if(cnt>=0&&cnt<30) begin
					cnt <= cnt+1;
					i2c_scl <= 1; 
				end
				else if(cnt>=30&&cnt<95) begin
					cnt <= cnt+1;
					i2c_scl <= 0; 
				end
				else if(cnt>=95) begin
					cnt <= 0;
					ST <= 2;
				end
			end
			
			4: begin//Stop condition
				if(cnt>=0&&cnt<30) begin
					i2c_scl <= 1;
					cnt <= cnt+1;
				end
				else if(cnt>=30&&cnt<95) begin
					i2c_sda <= 1;
					cnt <= cnt+1;
				end
				else if(cnt>=95) begin
					ST <= 0;
					cnt <= 0;
					write_complete <= 1;
				end
			end
			
		endcase
	end
end

endmodule 