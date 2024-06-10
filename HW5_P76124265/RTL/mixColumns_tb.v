module mixColumns_tb;
reg [0:127] in;

wire [0:127] out;	


mixColumns m (in,out);


initial begin
$monitor("input= %H , output= %h, ans = 046681e5e0cb199a48f8d37a2806264c",in,out);
in= 128'hd4bf5d30e0b452aeb84111f11e2798e5;
end
endmodule