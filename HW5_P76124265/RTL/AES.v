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

addRoundKey addRK1 (P, K, states[0]);

assign fullkeys[0] = K;

genvar i;
generate
        
    for(i = 1; i < round; i = i + 1) begin : AES_loop
        keyExpansion KE(fullkeys[i - 1], i, fullkeys[i]);
        encryptRound ER(states[i - 1], fullkeys[i], states[i]);
    end
    keyExpansion KE(fullkeys[round - 1], round, fullkeys[round]);
    lastEncryptRound LER(states[round - 1], fullkeys[round], states[round]);

endgenerate

always@(posedge clk or posedge rst) begin
    if(rst) begin
        valid <= 0;
    end
    else begin
        if(states[round] !== 128'hx)
            valid <= 1;
        else
            valid <= 0;

        C <= states[round];      
    end
end

endmodule