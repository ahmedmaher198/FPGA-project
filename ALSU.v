module ALSU(A_r,B_r,op_r,cin_r,serial_in_r,direction_r,red_op_A_r,red_op_B_r,bypass_A_r,bypass_B_r,clk,rst,leds,out);
	
	input [2:0] A_r,B_r,op_r;
	input clk,rst;
	input cin_r,serial_in_r,direction_r,red_op_A_r,red_op_B_r,bypass_A_r,bypass_B_r;
	output reg [5:0] out;
	output reg [15:0] leds;
	reg [2:0] A,B,op;
    reg cin,serial_in,direction,red_op_A,red_op_B,bypass_A,bypass_B;
	integer i;
	//reg [5:0] temp;
	parameter INPUT_PRIORTY = "A";
	parameter FULL_ADDER = "ON";
	always @(posedge clk or posedge rst) begin
		if (rst) 
			out <= 6'b000000;
		else begin
			leds <= 0;
			if (INPUT_PRIORTY == "A")begin
				if (bypass_A)
					out <= A;
				else if (bypass_B)
					out <= B;
				else begin
					case (op)
						3'b000 :
							begin
								if (red_op_A)
									out <=  & A;
								else 
									out <= A & B;
							end	
						3'b001 :
							begin
								if (red_op_A)
									out <=  ^ A;
								else 
									out <= A ^ B;
							end	
						3'b010 :
							begin
								if (red_op_A && red_op_B) begin
									out <= 6'b000000;
									for(i=0;i<2;i=i+1) begin
										leds <= ~leds;
									end
								end
									
								else if (FULL_ADDER == "ON")
						 			out <= A + B + cin;
						 		else
						 			out <= A + B;
						 	end

						3'b011 :
							begin
								if (red_op_A && red_op_B) begin
									out <= 6'b000000;
									for(i=0;i<2;i=i+1) begin
										leds <= ~leds;
									end
								end
								else 
									out <= A * B;
							end
						3'b100 : //shift
							begin 
								if (red_op_A && red_op_B) begin
									out <= 6'b000000;
									for(i=0;i<2;i=i+1) begin
										leds <= ~leds;
									end
								end
								else if (direction)
									out <= {out[4:0],serial_in};
								else
									out <=  {serial_in,out[5:1]};
							end 
						3'b101 : //rotate 
							begin 
								if (red_op_A && red_op_B) begin
									out <= 6'b000000;
									for(i=0;i<2;i=i+1) begin
										leds <= ~leds;
									end
								end
								else if (direction) begin
									/*temp[5:1] <= out[4:0];
									temp[0] <= out[5];
									out <= temp;*/
									out <= {out[4:0],out[5]};
								end
								else begin
									/*temp[4:0] <= out[5:1];
									temp[5] <= out[0];
									out <= temp;*/
									out <= {out[0],out[5:1]};
								end
							end 
						default : begin
							/*out <= 6'b000000;//leds blank*/
									out <= 6'b000000;
									for(i=0;i<2;i=i+1) begin
										leds <= ~leds;
									end
								
						end
					endcase
				end
			end
			else begin // priorty >> B
			if (bypass_B)
					out <= B;
				else if (bypass_A)
					out <= A;
				else begin
					case (op)
						3'b000 :
							begin
								if (red_op_B)
									out <= & B;
								else 
									out <= A & B;
							end	
						3'b001 :
							begin
								if (red_op_B)
									out <= ^ B;
								else 
									out <= A ^ B;
							end	
						3'b010 :
							begin
								if (red_op_A && red_op_B) begin
									out <= 6'b000000;
									for(i=0;i<2;i=i+1) begin
										leds <= ~leds;
									end
								end
								else if (FULL_ADDER == "ON")
						 			out <= A + B + cin;
						 		else
						 			out <= A + B;
						 	end

						3'b011 :
							begin
							if (red_op_A && red_op_B) begin
									out <= 6'b000000;
									for(i=0;i<2;i=i+1) begin
										leds <= ~leds;
									end
								end
							else 
								out <= A * B;
							end
						3'b100 : //shift
							begin 
								if (red_op_A && red_op_B) begin
									out <= 6'b000000;
									for(i=0;i<2;i=i+1) begin
										leds <= ~leds;
									end
								end
								else if (direction)
									out <= {out[4:0],serial_in};
								else
									out <=  {serial_in,out[5:1]};
							end 
						3'b101 : //rotate 
							begin 
								if (red_op_A && red_op_B) begin
									out <= 6'b000000;
									for(i=0;i<2;i=i+1) begin
										leds <= ~leds;
									end
								end
								else if (direction)begin
									/*temp[5:1] <= out[4:0];
									temp[0] <= out[5];
									out <= temp;*/
									out <= {out[4:0],out[5]};
								end
								else begin
									/*temp[4:0] <= out[5:1];
									temp[5] <= out[0];
									out <= temp;*/
									out <= {out[0],out[5:1]};
								end
							end 
						default : begin
							out <= 6'b000000;
									for(i=0;i<2;i=i+1) begin
										leds <= ~leds;
									end
						end
					endcase
				end
			end		
		end
	end
	always @(posedge clk) begin 
			A <= A_r;
			B <= B_r;
			op <= op_r;
			cin <= cin_r;
			serial_in <= serial_in_r;
			direction <= direction_r;
			red_op_A <= red_op_A_r;
			red_op_B <= red_op_B_r;
			bypass_A <= bypass_A_r;
			bypass_B <= bypass_B_r;
	end

endmodule