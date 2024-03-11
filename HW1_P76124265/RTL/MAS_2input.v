// 
// Designer: P76124265
//
`include "ALU.v"
`include "Q_Comparator.v"


module MAS_2input(
    input signed [4:0] Din1,
    input signed [4:0] Din2,
    input [1:0] Sel,
    input signed[4:0] Q,
    output [1:0] Tcmp,
    output signed [4:0] TDout,
    output signed [3:0] Dout
);

/*Write your design here*/
wire signed [4:0] w1;
wire [1:0] w2;
wire [4:0] w3;

ALU ALU_inst(.Din1(Din1), .Din2(Din2), .Sel(Sel), .Tmp(w1));
assign TDout = w1;
Q_Comparator Q_Comparator_instQ_Comparator(.Din(w1), .Q(Q), .Tmp(w2));
assign Tcmp = w2;
ALU ALU_inst2(.Din1(w1), .Din2(Q), .Sel(w2), .Tmp(w3));
assign Dout = w3[3:0];

endmodule