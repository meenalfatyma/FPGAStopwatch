`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:10:38 05/18/2024 
// Design Name: 
// Module Name:    stopwatchuptoseconds 
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



module stopwatchuptoseconds(
    input clk,
    input rst,
    input start,
    output reg [6:0] sseg_data,
    output reg dp,
    output reg [7:0] ssg_ctrl
);

reg [3:0] seconds10;
reg [3:0] seconds1;
reg [3:0] minutes10; 
reg [3:0]minutes1;
reg [3:0] hours10;
reg [3:0] hours1; 
reg [63:0] count; 
wire clk_out;

always @ (posedge clk or posedge rst) begin
    if (rst)
        count <= 0;
    else if (count == 100000000) 
	 begin
        count <= 0;
	end
    else if (start) 
        count <= count + 1;
end

assign clk_out = (count == 100000000) ? 1'b1 : 1'b0; 


always @ (posedge clk or posedge rst) begin
    if (rst) begin
        seconds10 <= 0;
        seconds1 <= 0;
        minutes10 <= 0;
        minutes1 <= 0;
        hours10 <= 0;
        hours1 <= 0;
    end else if (clk_out) begin
        
            if (seconds10 == 9) begin
                seconds10 <= 0;
                if (seconds1 == 5) begin
                    seconds1 <= 0;
                    if (minutes10 == 9) begin
                        minutes10 <= 0;
                        if (minutes1 == 5) begin
                            minutes1 <= 0;
                            if (hours10 == 9) begin
                                hours10 <= 0;
                                if (hours1 == 9)
                                    hours1 <= 0;
                                else
                                    hours1 <= hours1 + 1;
                            end else
                                hours10 <= hours10 + 1;
                        end else
                            minutes1 <= minutes1 + 1;
                    end else
                        minutes10 <= minutes10 + 1;
                end else
                    seconds1 <= seconds1 + 1;
            end else
                seconds10 <= seconds10 + 1;
       
    end
end

reg [27:0] counter; 

always @ (posedge clk or posedge rst) begin
    if (rst)
        counter <= 0;
    else
        counter <= counter + 1;
end

reg [6:0] sseg;

always @ (*) begin
    case(counter[16:14])
        3'b000: begin
            ssg_ctrl = 8'b11111111;
            dp = 1'b1;
        end
        3'b001: begin 
		             

            ssg_ctrl = 8'b11111111;
            dp = 1'b1;
        end
        3'b010: begin
		              sseg = seconds10;

            ssg_ctrl = 8'b11111011;
            dp = 1'b1;
        end
        3'b011: begin
		              sseg = seconds1;

            ssg_ctrl = 8'b11110111;
            dp = 1'b1;
        end
        3'b100: begin
		              sseg = minutes10;

            ssg_ctrl = 8'b11101111;
            dp = 1'b0;
        end
        3'b101: begin
		              sseg = minutes1;

            ssg_ctrl = 8'b11011111;
            dp = 1'b1;
        end
        3'b110: begin
            sseg = hours10;
            ssg_ctrl = 8'b10111111;
            dp = 1'b0;
        end
        3'b111: begin
		              sseg = hours1;

            ssg_ctrl = 8'b01111111;
            dp = 1'b1;
        end
    endcase
    
    // Segment data assignment
    case(sseg) 
        4'd0 : sseg_data = 7'b1000000;
        4'd1 : sseg_data = 7'b1111001;
        4'd2 : sseg_data = 7'b0100100;
        4'd3 : sseg_data = 7'b0110000;
        4'd4 : sseg_data = 7'b0011001;
        4'd5 : sseg_data = 7'b0010010;
        4'd6 : sseg_data = 7'b0000010;
        4'd7 : sseg_data = 7'b1111000;
        4'd8 : sseg_data = 7'b0000000; 
        4'd9 : sseg_data = 7'b0010000;
        default : sseg_data = 7'b0111111;
    endcase
end

endmodule
