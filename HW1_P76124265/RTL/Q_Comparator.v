// 
// Designer: P76124265
//
module Q_Comparator(
    input signed [4:0] Din,
    input signed [4:0] Q,
    output [1:0] Tmp,
);

/*Write your design here*/

always @(Din or Q)
begin
    Tmp[0] = (0 > Din);
    Tmp[1] = (Din > Q);
end

endmodule