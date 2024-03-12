// 
// Designer: P76124265
//
module Q_Comparator(
    input signed [4:0] Din,
    input signed [4:0] Q,
    output [1:0] Tmp
);

/*Write your design here*/

assign Tmp[0] = (Din >= 0);
assign Tmp[1] = (Din >= Q);


endmodule