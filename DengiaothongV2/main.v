`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:51:01 03/27/2021 
// Design Name: 
// Module Name:    main 
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
module main(
    input clk,
  //  input reset,
    input chedo,
    input den,
    output reg D1,
    output reg V1,
    output reg X1,
    output reg D2,
    output reg V2,
    output reg X2,
    output reg [7:0] Seg1,
    output reg [7:0] Seg2,
    output reg [1:0] CS1,
    output reg [1:0] CS2
    );
/*
chedo = 0: dieu khien tay
chedo = 1: dieu khien tu dong
	den = 0: line 1 xanh 2 do
	den = 1: line 1 do 2 xanh
*/
/*
times1,2 la cac so hien thi led 7 doan 
neu times == 0 la an so 
*/
	//Thoi gian cac den tinh luon ca 0
	//Chon thoi gian duoi 29 giay
	parameter timevang = 3; 
	parameter timexanh = 22;
	parameter timedo = 25; 
	//Quet 7 doan
	reg [3:0]CH1 = 0;
	reg [3:0]DV1 = 0;
	reg [3:0]CH2 = 0;
	reg [3:0]DV2 = 0;
	reg flag = 0;
	//Thoi gian hien thi 
	reg [4:0]times1 = 0;
	reg [4:0]times2 = 0; 
	//Xac dinh thoi gian trong manual
	reg [4:0] tmp = 0;
	//Phat hien chuyen mach tu manual sang auto
	reg [1:0]flaglight = 0;
	wire clk1hz;
	CLK U1(clk,clk1hz);
	
initial begin
	D1 = 0;
	V1 = 0;
	X1 = 1;
	times1 = timexanh;
	D2 = 1;
	V2 = 0;
	X2 = 0;
	times2 = timedo;
end

always@(posedge clk1hz)
begin
	if(chedo == 1)
	begin
		//Chuyen mach khi den vang thi tmp!=0 ==> hoat dong khong chinh xac
		tmp = 0;
		//Line 1 manual dang chay thi chuyen mach, dat l?i times
		if(flaglight == 1)
		begin
			flaglight = 0;
			D1 = 0;
			V1 = 0;
			X1 = 1;
			times1 = timexanh;
			D2 = 1;
			V2 = 0;
			X2 = 0;
			times2 = timedo;
		end
		//Line 2 manual dang chay thi chuyen mach, dat l?i times
		else if(flaglight == 2)
		begin
			flaglight = 0;
			D1 = 1;
			V1 = 0;
			X1 = 0;
			times1 = timedo;
			D2 = 0;
			V2 = 0;
			X2 = 1;
			times2 = timexanh;
		end
		//Khong phai chuyen mach thi hoat dong binh thuong
		else
		begin
			if(X1 == 1)
			begin
				//Line 1 dang chay nhung het thoi gian den xanh thi chuyen vang roi moi chuyen do
				if(times1 == 1)
				begin
					times1 = timevang;
					X1 = 0;
					V1 = 1;
					D1 = 0;
				end //times1 == 0
				else
					times1 = times1 - 1;
			end //X1 == 1
			else if (V1 == 1)
			begin
				//Line 1 den vang het times thi doi sang den do
				if(times1 == 1)
				begin
					times1 = timedo;
					X1 = 0;
					V1 = 0;
					D1 = 1;
				end //times1 == 0
				else
					times1 = times1 - 1;
			end //V1 == 1
			else
			begin
				//Line 1 het times den do thi doi sang den xanh
				if(times1 == 1)
				begin
					times1 = timexanh;
					X1 = 1;
					V1 = 0;
					D1 = 0;
				end //times1 == 0
				else
					times1 = times1 - 1;
			end// else ( else if(V1 == 1))
			
			if(X2 == 1)
			begin
				//Line 2 het times den xanh ==> doi sang den vang
				if(times2 == 1)
				begin
					times2 = timevang;
					X2 = 0;
					V2 = 1;
					D2 = 0;
				end //times1 == 0
				else
					times2 = times2 - 1;
			end //X2 == 1
			else if (V2 == 1)
			begin
				//Line 2 het times den vang ==> doi sang den do
				if(times2 == 1)
				begin
					times2 = timedo;
					X2 = 0;
					V2 = 0;
					D2 = 1;
				end //times1 == 0
				else
					times2 = times2 - 1;
			end //V2 == 1
			else
			begin
				//Line 2 het times den do ==> doi sang den xanh
				if(times2 == 1)
				begin
					times2 = timexanh;
					X2 = 1;
					V2 = 0;
					D2 = 0;
				end //times1 == 0
				else
					times2 = times2 - 1;
			end// else ( else if(V2 == 1))
		end//end flaglight == 0
	end //chedo == 1
	else
	begin
	//times set bang 0 va su dung tmp de de quan ly thoi gian 
	times1 = 0;
	times2 = 0;
		if(den == 0)
		begin
			flaglight = 1;
			if(X2 == 1 || V2 == 1)
			begin
				tmp = tmp + 1;
				if(tmp < timevang)
				begin
					V2 = 1;
					X2 = 0;
					D2 = 0;
					D1 = 1;
					X1 = 0;
					V1 = 0;
				end // tmp < timevang
				else
				begin
					tmp = 0;
					V2 = 0;
					X2 = 0;
					D2 = 1;
					D1 = 0;
					X1 = 1;
					V1 = 0;
				end //else (if(tmp < timevang))
			end //if(X2 == 1 || V2 == 1)
			else
			begin
				tmp = 0;
				V2 = 0;
				X2 = 0;
				D2 = 1;
				D1 = 0;
				X1 = 1;
				V1 = 0;
			end //else (if(X2 == 1) || (V2 == 1))
		end//den == 0
		else
		begin
			flaglight = 2;
			if(X1 == 1 || V1 == 1)
			begin
				tmp = tmp + 1;
				if(tmp < timevang)
				begin
					V1 = 1;
					X1 = 0;
					D1 = 0;
					D2 = 1;
					X2 = 0;
					V2 = 0;
				end // tmp < timevang
				else
				begin
					tmp = 0;
					V1 = 0;
					X1 = 0;
					D1 = 1;
					D2 = 0;
					X2 = 1;
					V2 = 0;
				end //else (if(tmp < timevang))
			end //X1 == 1 || V1 == 1
			else
			begin
				tmp = 0;
				V1 = 0;
				X1 = 0;
				D1 = 1;
				D2 = 0;
				X2 = 1;
				V2 = 0;
			end //else ((if X1 == 1 V1 == 1))
		end //else (if(den == 0))
	end
end
always@(posedge clk)
begin
	//Hien LED so khi chay tu dong va chuyen mach da xong
	if(chedo == 1 && flaglight == 0)
	begin
		//Moi chu ky clk hien 1 ben LED (Chuc/Don vi)
		flag = ~flag;
		if(flag == 1)
		begin
			/*Do khong chia truc tiep duoc thoi gian de tach so
			nen su dung dieu kien de tach so*/
			if(times1 < 4'b1010)
				CH1 = 0;
			else if(times1 < 5'b10100)
				CH1 = 1;
			else CH1 = 2;
			
			if(times2 < 4'b1010)
				CH2 = 0;
			else if(times2 < 5'b10100)
				CH2 = 1;
			else CH2 =2;
			
			//Chon den ben trai cua 7 doan cho no sang
			CS1 = 2'b10;
			CS2 = 2'b10;
			
			case(CH1)
				4'b0001 : Seg1 = 8'b10011111;
				4'b0010 : Seg1 = 8'b00100101;
				4'b0011 : Seg1 = 8'b00001101;
				4'b0100 : Seg1 = 8'b10011001;
				4'b0101 : Seg1 = 8'b01001001;
				4'b0110 : Seg1 = 8'b01000001;
				4'b0111 : Seg1 = 8'b00011111;
				4'b1000 : Seg1 = 8'b00000001;
				4'b1001 : Seg1 = 8'b00001001;
				4'b0000 : Seg1 = 8'b00000011;
			endcase
			case(CH2)
				4'b0001 : Seg2 = 8'b10011111;
				4'b0010 : Seg2 = 8'b00100101;
				4'b0011 : Seg2 = 8'b00001101;
				4'b0100 : Seg2 = 8'b10011001;
				4'b0101 : Seg2 = 8'b01001001;
				4'b0110 : Seg2 = 8'b01000001;
				4'b0111 : Seg2 = 8'b00011111;
				4'b1000 : Seg2 = 8'b00000001;
				4'b1001 : Seg2 = 8'b00001001;
				4'b0000 : Seg2 = 8'b00000011;
			endcase
		end
		else
		begin
			if(CH1 == 0)
				DV1 = times1;
			else if(CH1 == 1)
				DV1 = times1 - 4'b1010;
			else DV1 = times1 - 5'b10100;
			if(CH2 == 0)
				DV2 = times2;
			else if(CH2 == 1)
				DV2 = times2 - 4'b1010;
			else DV2 = times2 - 5'b10100;
			CS1 = 2'b01;
			CS2 = 2'b01;
			case(DV1)
				4'b0001 : Seg1 = 8'b10011111;
				4'b0010 : Seg1 = 8'b00100101;
				4'b0011 : Seg1 = 8'b00001101;
				4'b0100 : Seg1 = 8'b10011001;
				4'b0101 : Seg1 = 8'b01001001;
				4'b0110 : Seg1 = 8'b01000001;
				4'b0111 : Seg1 = 8'b00011111;
				4'b1000 : Seg1 = 8'b00000001;
				4'b1001 : Seg1 = 8'b00001001;
				4'b0000 : Seg1 = 8'b00000011;
			endcase
			case(DV2)
				4'b0001 : Seg2 = 8'b10011111;
				4'b0010 : Seg2 = 8'b00100101;
				4'b0011 : Seg2 = 8'b00001101;
				4'b0100 : Seg2 = 8'b10011001;
				4'b0101 : Seg2 = 8'b01001001;
				4'b0110 : Seg2 = 8'b01000001;
				4'b0111 : Seg2 = 8'b00011111;
				4'b1000 : Seg2 = 8'b00000001;
				4'b1001 : Seg2 = 8'b00001001;
				4'b0000 : Seg2 = 8'b00000011;
			endcase
		end
	end
	else
	begin
		CS1 = 2'b11;
		CS2 = 2'b11;
		//Chi sang 1 gach ngang 
		Seg1 = 8'b11111101;
		Seg2 = 8'b11111101;
	end
end

endmodule
