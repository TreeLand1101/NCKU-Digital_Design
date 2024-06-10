module addRoundKey(in, key, out);

input [127:0] in;
input [127:0] key;
output [127:0] out;

assign out = key ^ in;

endmodule