module ALSU_tb();

	reg [2:0] A,B,op;
	reg clk,rst,cin,serial_in,red_op_A,red_op_B,direction,bypass_B,bypass_A;
	wire [15:0] leds;
	wire [5:0] out;
	integer i;
	ALSU DUT(A,B,op,cin,serial_in,direction,red_op_A,red_op_B,bypass_A,bypass_B,clk,rst,leds,out);
	initial begin
	        clk = 0;
	        forever
	        #1 clk =~clk;
	end
	initial begin
	        rst=1;
	        A=0;
	        B=0;
	        #50;
	        rst=0;
	        bypass_A=1; //out=A 
	        bypass_B=1;
	        red_op_A=0;
	        red_op_B=1;
	        direction=0; 
	        cin=0;
	        serial_in=0;
		for(i=0;i<1000;i=i+1) begin
			A=$random;
			B=$random;
		end
		#50
		bypass_A=0;
		bypass_B=1;     //out=B
		for(i=0;i<1000;i=i+1) begin
			A=$random;
			B=$random;
			serial_in=$random;
			cin=$random;
		end
		#50
		bypass_B=0;
		red_op_A=1;
		op=3'b000;     //reduction &A
		for(i=0;i<1000;i=i+1) begin
			A=$random;
			B=$random;
			serial_in=$random;
			cin=$random;
		end
		#50
		red_op_A=0;
		op=3'b000;      // AND
		for(i=0;i<1000;i=i+1) begin
			A=$random;
			B=$random;
			serial_in=$random;
			cin=$random;
		end
		#50
		red_op_A=1;
		op=3'b001;    //reduction ^A
		for(i=0;i<1000;i=i+1) begin
			A=$random;
			B=$random;
			serial_in=$random;
			cin=$random;
		end
		#50
		red_op_A=0;
		op=3'b001;    //XOR
		for(i=0;i<1000;i=i+1) begin
			A=$random;
			B=$random;
			serial_in=$random;
			cin=$random;
		end
		red_op_B=0;
		#50
		op=3'b010;   //ADDITION
		for(i=0;i<1000;i=i+1) begin
			A=$random;
			B=$random;
			serial_in=$random;
			cin=$random;
		end
		#50
		op=3'b011;   //MULTIPLICATION
		for(i=0;i<1000;i=i+1) begin
			A=$random;
			B=$random;
			serial_in=$random;
			cin=$random;
		end
		#50
		op=3'b100;
		direction=1; //shift left
		for(i=0;i<1000;i=i+1) begin
			A=$random;
			B=$random;
			serial_in=$random;
			cin=$random;
		end
		#50
		op=3'b100;
		direction=0; //shift left
		for(i=0;i<1000;i=i+1) begin
			A=$random;
			B=$random;
			serial_in=$random;
			cin=$random;
		end
		#50
		op=3'b101;
		direction=1; //rotate left
		for(i=0;i<1000;i=i+1) begin
			A=$random;
			B=$random;
			serial_in=$random;
			cin=$random;
		end
		#50
		op=3'b101;
		direction=0; //rotate right
		for(i=0;i<1000;i=i+1) begin
			A=$random;
			B=$random;
			serial_in=$random;
			cin=$random;
		end
		#50
		op=3'b110;  //invalid case
		for(i=0;i<1000;i=i+1) begin
			A=$random;
			B=$random;
			serial_in=$random;
			cin=$random;
		end
		#50
		op=3'b111;  //invalid case
		for(i=0;i<1000;i=i+1) begin
			A=$random;
			B=$random;
			serial_in=$random;
			cin=$random;
		end
		#50
		red_op_A=1;  //invalid
		red_op_B=1;
		for(i=0;i<1000;i=i+1) begin
			A=$random;
			B=$random;
			op=$random;
			serial_in=$random;
			cin=$random;
		end
		#50
		$stop;
	end
	initial begin
		$monitor("A=%b, B=%b, bypass_A=%b, bypass_B=%b, op=%b, direction=%b, red_op_A=%b, red_op_B=%b, serial_in=%b, out=%b",
				A,B,bypass_A,bypass_B,op,direction,red_op_A,red_op_B,serial_in,out);
	end

endmodule