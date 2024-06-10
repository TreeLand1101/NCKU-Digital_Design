module AES_Encrypt_tb;
reg [127:0] in1;
wire [127:0] out1;
reg [127:0] key1;

reg [127:0] in2;
wire [127:0] out2;
reg [191:0] key2;

reg [127:0] in3;
wire [127:0] out3;
reg [255:0] key3;

AES a(in1,key1,out1);
AES #(192,12,6) b(in2,key2,out2);
AES #(256,14,8) c(in3,key3,out3);


initial begin
$monitor("in128= %h, key128= %h ,out128= %h",in1,key1,out1);
in1=128'h193de3bea0f4e22b9ac68d2ae9f84808;
key1=128'h2b7e151628aed2a6abf7158809cf4f3c;

end

endmodule