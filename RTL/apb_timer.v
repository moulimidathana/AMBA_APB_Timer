module apb_timer #(parameter WIDTH=8)(input PCLK,input PRESET_N,input PSEL,input PENABLE,input PWRITE,input [7:0]PADDR,input [31:0]PWDATA,output reg [31:0]PRDATA,output reg timer_done);
reg [WIDTH-1:0] load_val;
reg [WIDTH-1:0]count;
reg running;

always@(posedge PCLK or negedge PRESET_N) begin
	if(!PRESET_N) begin
		load_val<=0;
		running<=0;
	end
	else if(PSEL&&PENABLE&&PWRITE) begin
		case(PADDR)
			8'h00:load_val<=PWDATA[WIDTH-1:0];
			8'h04:running<=PWDATA[0];
		endcase
	end
end
	//APB READ PATH
always @(*) begin
	PRDATA=32'h0;
	if(PSEL&&!PWRITE)begin
		case(PADDR)
			8'h00:PRDATA={{(32-WIDTH){1'B0}},load_val};
			8'h04:PRDATA={31'b0,running};
			8'h08:PRDATA={31'b0,timer_done};
			default: PRDATA=32'h0;
		endcase
	end
	end
	always@(posedge PCLK or negedge PRESET_N)begin
		if(!PRESET_N)begin
			count<=0;
			timer_done<=0;
		end
		else if(running)begin
			if(count==0)begin
				count<=load_val;
				timer_done<=1;
				running<=0;
			end
			else begin
				count<=count-1;
				timer_done<=0;
			end
		end
	end
	endmodule
