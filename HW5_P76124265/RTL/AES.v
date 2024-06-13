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

keyExpansion KE(K, fullkeys);
addRoundKey addRK1 (P, K, states[0]);

assign valid = (states[round] !== 128'hx) ? 1:0;
assign C = states[round];

genvar i;
generate
	
    for(i = 1; i < round; i = i + 1) begin
        encryptRound ER(states[i - 1], fullkeys[i], states[i]);
    end
    lastEncryptRound LER(states[round - 1], fullkeys[round], states[round]);

endgenerate

endmodule