module lastEncryptRound(in, key, out);
input [127:0] in;
output [127:0] out;
input [127:0] key;
wire [127:0] afterSubBytes;
wire [127:0] afterShiftRows;
wire [127:0] afterAddroundKey;

subBytes SB(in, afterSubBytes);
shiftRows SR(afterSubBytes, afterShiftRows);
addRoundKey addRK(afterShiftRows, key, out);
		
endmodule