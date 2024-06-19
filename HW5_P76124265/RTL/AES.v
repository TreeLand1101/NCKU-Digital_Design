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
reg [127:0] fullkeys [round - 1:0];
reg [127:0] states [round - 1:0];
wire [127:0] fullkeysTemp [round - 1:0];
wire [127:0] statesTemp [round - 1:0];
wire [127:0] result;
reg [3:0] roundCnt;

addRoundKey addRK1 (P, K, statesTemp[0]);
keyExpansion KE(K, 1, fullkeysTemp[0]);

genvar i;
generate
        
    for(i = 1; i < round; i = i + 1) begin : main_loop
        keyExpansion KE(fullkeys[i - 1], i + 1, fullkeysTemp[i]);
        encryptRound ER(states[i - 1], fullkeys[i - 1], statesTemp[i]);
    end
    lastEncryptRound LER(states[round - 1], fullkeys[round - 1], result);

endgenerate

integer j;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        roundCnt <= 0;
        valid <= 0;
        C <= 0;
        for(j = 0; j < round; j = j + 1) begin : initial_loop
            fullkeys[j] <= 0;
            states[j] <= 0;
        end
    end
    else begin
        for(j = 0; j < round; j = j + 1) begin : assign_loop
            fullkeys[j] <= fullkeysTemp[j];
            states[j] <= statesTemp[j];
        end
        if (roundCnt > 10) begin
            C <= result;
            valid <= 1;
        end
        else begin
            C <= 0;
            valid <= 0;
            roundCnt <= roundCnt + 1;
        end
    end
end

endmodule