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
wire signed w1 [4:0];
wire w2 [1:0];

always @(Sel or Din1 or Din2 or Q)
begin
    ALU(.Din1(Din1), .Din2(Din2), .Sel(Sel), .Tmp(w1));
    TDout = w1;
    Q_Comparator(.Din(w1), .Q(Q), .Tmp(w2));
    Tcmp = w2;
    ALU(.Din1(w1), .Din2(Q), .Sel(w2), .Tmp(Dout));
end

endmodule