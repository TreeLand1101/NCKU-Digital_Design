// 
// Designer: P76124265
//

module AES(
    input clk,
    input rst,
    input [127:0] P,
    input [127:0] K,
    output reg [127:0] C,
    output reg valid
    );

// write your design here //

parameter round = 10;
wire [(128 * (round + 1)) - 1 :0] fullkeys;
wire [127:0] states [round + 1:0];
wire [127:0] afterSubBytes;
wire [127:0] afterShiftRows;



endmodule