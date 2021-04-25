`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:35:16 03/27/2021 
// Design Name: 
// Module Name:    CLK 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module CLK(
    input clk,
   // input reset,
    output reg clk1hz
    );
	reg [19:0] counter = 0;
	parameter freq = 100000/2;
initial begin
	clk1hz = 0;
end
always@(posedge clk)
begin	
	/*if(reset == 1)
	begin
		clk1hz <= 0;
		counter <= 0;
	end //reset == 1
	else*/
	begin
		counter <= counter + 1;
		if(counter == freq)
		begin 
			counter <= 0;
			clk1hz <= ~clk1hz;
		end // counter == freq 
		
	end // else (if(reset == 1))
end
endmodule
