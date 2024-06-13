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
wire [127:0] fullkeysTemp [round:0];
wire [127:0] statesTemp [round:0];
wire [127:0] fullkeys [round:0];
reg [127:0] states [round:0];
wire [127:0] afterSubBytes;
wire [127:0] afterShiftRows;

keyExpansion KE(clk, rst, K, fullkeys);
addRoundKey addRK1 (clk, rst, P, K, statesTemp[0]);

assign valid = (states[round] !== 128'hx) ? 1:0;
assign C = states[round];

genvar i;
generate
	
    for(i = 1; i < round; i = i + 1) begin
        encryptRound ER(clk, rst, statesTemp[i - 1], fullkeys[i], statesTemp[i]);
    end
    lastEncryptRound LER(clk, rst, statesTemp[round - 1], fullkeys[round], statesTemp[round]);

endgenerate

integer j;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        
    end
    else begin
        for(j = 0; j <= round; j = j + 1) begin
            states[j] <= statesTemp[j];
        end
    end
end


endmodule