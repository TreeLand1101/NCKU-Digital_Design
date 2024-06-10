module encryptRound(in, key, out);
input [127:0] in;
output [127:0] out;
input [127:0] key;
wire [127:0] afterSubBytes;
wire [127:0] afterShiftRows;
wire [127:0] afterMixColumns;
wire [127:0] afterAddroundKey;

subBytes SB(in, afterSubBytes);
shiftRows SR(afterSubBytes, afterShiftRows);
mixColumns MC(afterShiftRows, afterMixColumns);
addRoundKey addRK(afterMixColumns, key, out);
		
endmodule