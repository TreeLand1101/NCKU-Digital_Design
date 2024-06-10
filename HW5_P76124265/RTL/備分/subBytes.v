module subBytes(in, out);
input [127:0] in;
output [127:0] out;

genvar i;
generate 
    for(i = 0; i < 128; i = i + 8) begin
	    sbox s(in[i + 7:i], out[i + 7:i]);
	end
endgenerate


endmodule