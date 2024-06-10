module mixColumns(in, out);

input [127:0] in;
output[127:0] out;

function [7:0] mb2;
	input [7:0] x;
	begin 
        // module x^8 + x^4 + x^3 + x + 1
        //    9'b(x << 1) xor 9'b(1'0001'1011)
        // => 8'b(x << 1) xor 8'b(0001'1011) (because x[8] = 1)
		if(x[7] == 1) 
            mb2 = ((x << 1) ^ 8'h1b);
		else 
            mb2 = x << 1; 
	end 	
endfunction

function [7:0] mb3;
    input [7:0] x;
    begin
        mb3 = mb2(x) ^ x;
    end 
endfunction

genvar i;

generate 
//MixColumns() can be written as a matrix multiplication in GF(2^8).
for(i = 0; i < 4; i = i + 1) begin 
    assign out[i*32 + 31 : i*32 + 24] = mb2(in[i*32 + 31 : i*32 + 24]) ^ mb3(in[i*32 + 23 : i*32 + 16]) ^ in[i*32 + 15 : i*32 + 8] ^ in[i*32 + 7 : i*32];
    assign out[i*32 + 23 : i*32 + 16] = in[i*32 + 31 : i*32 + 24] ^ mb2(in[i*32 + 23 : i*32 + 16]) ^ mb3(in[i*32 + 15 : i*32 + 8]) ^ in[i*32 + 7 : i*32];
    assign out[i*32 + 15 : i*32 + 8] = in[i*32 + 31 : i*32 + 24] ^ in[i*32 + 23 : i*32 + 16] ^ mb2(in[i*32 + 15 : i*32 + 8]) ^ mb3(in[i*32 + 7 : i*32]);
    assign out[i*32 + 7 : i*32] = mb3(in[i*32 + 31 : i*32 + 24]) ^ in[i*32 + 23 : i*32 + 16] ^ in[i*32 + 15 : i*32 + 8] ^ mb2(in[i*32 + 7 : i*32]);
end
endgenerate

endmodule