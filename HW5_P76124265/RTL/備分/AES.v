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
wire [127:0] fullkeys [round:0];
wire [127:0] states [round:0];
wire [127:0] afterSubBytes;
wire [127:0] afterShiftRows;

keyExpansion KE(K, fullkeys);

addRoundKey addRK1 (P, fullkeys[0], states[0]);

assign valid = 1;

genvar i;
generate
	
    for(i = 1; i < round; i = i + 1)
        encryptRound ER(states[i - 1], fullkeys[i - 1], states[i]);

    subBytes SB(states[round - 1], afterSubBytes);
    shiftRows SR(afterSubBytes, afterShiftRows);
    addRoundKey addRK2(afterShiftRows, fullkeys[round], states[round]);
    assign C = states[round];

endgenerate

endmodule