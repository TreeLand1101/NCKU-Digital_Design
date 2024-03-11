// 
// Designer: P76124265
//
module ALU(
    input signed [4:0] Din1,
    input signed [4:0] Din2,
    input [1:0] Sel,
    output signed [4:0] Tmp,
);

/*Write your design here*/

always @(Din1 or Din2 or Sel)
begin
    if (Sel == 4'b00)
        Tmp = Din1 + Din2;
    else if (Sel == 4'b11)
        Tmp = Din1 - Din2;
    else
        Tmp = Din1;
end

endmodule