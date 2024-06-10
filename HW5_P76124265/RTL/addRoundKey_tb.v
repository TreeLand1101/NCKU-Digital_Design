module addRoundKey_tb;

reg [127:0] in;
reg [127:0] key;
wire [127:0] out;	


addRoundKey m (in, key, out);


initial begin
	$monitor("input= %H, output= %h, key = %h, ans = 193de3bea0f4e22b9ac68d2ae9f84808", in, out, key);
	in = 128'h3243f6a8885a308d313198a2e0370734;
	key = 128'h2b7e151628aed2a6abf7158809cf4f3c;
end
endmodule