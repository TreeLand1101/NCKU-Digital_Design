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
wire [127:0] fullkeys [round + 1:0];
wire [127:0] states [round + 1:0];
wire [127:0] afterSubBytes;
wire [127:0] afterShiftRows;

// keyExpansion KE(key, fullkeys);

// addRoundKey addRK1 (in, states[0], fullkeys[((128*(Nr+1))-1)-:128]);

// genvar i;
// generate
	
// 	for(i = 1; i < round; i = i + 1)
// 		encryptRound er(states[i-1],fullkeys[(((128*(Nr+1))-1)-128*i)-:128],states[i]);

// 	subBytes sb(states[Nr-1],afterSubBytes);
// 	shiftRows sr(afterSubBytes,afterShiftRows);
// 	addRoundKey addrk2(afterShiftRows,states[Nr],fullkeys[127:0]);
// 	assign out=states[Nr];

// endgenerate

endmodule