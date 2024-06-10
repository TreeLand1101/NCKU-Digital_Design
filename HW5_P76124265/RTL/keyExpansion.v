module keyExpansion (key, fullkeys);

parameter round = 10;
input [0:127] key;  
output reg [0:127] fullkeys [round:0];

reg [0:31] temp;
reg [0:31] afterRot; 
reg [0:31] afterSubword;
reg [0:31] roundRcon;

integer i;

always @(*) begin
    fullkeys[0] = key;   
    for (i = 1; i < round + 1; i = i + 1) begin
        temp = fullkeys[i - 1][96:127]; 
        afterRot = rotWord(temp); 
        afterSubword = subWord(afterRot);
        roundRcon = rcon(i); 
        temp = afterSubword ^ roundRcon;
        fullkeys[i][0:31] = fullkeys[i - 1][0:31] ^ temp;
        fullkeys[i][32:63] = fullkeys[i - 1][32:63] ^ fullkeys[i][0:31];
        fullkeys[i][64:95] = fullkeys[i - 1][64:95] ^ fullkeys[i][32:63]; 
        fullkeys[i][96:127] = fullkeys[i - 1][96:127] ^ fullkeys[i][64:95]; 
    end
end


function [0:31] rotWord;
    input [0:31] word;
    begin
        rotWord = {word[8:31], word[0:7]};
    end
endfunction

function [0:31] subWord;
    input [0:31] word;
    begin
        subWord[0:7] = mapping(word[0:7]);
        subWord[8:15] = mapping(word[8:15]);
        subWord[16:23] = mapping(word[16:23]);
        subWord[24:31] = mapping(word[24:31]);
    end
endfunction

function [7:0] mapping(input [7:0] word);  
begin
    case (word)
        8'h00: mapping = 8'h63;
        8'h01: mapping = 8'h7c;
        8'h02: mapping = 8'h77;
        8'h03: mapping = 8'h7b;
        8'h04: mapping = 8'hf2;
        8'h05: mapping = 8'h6b;
        8'h06: mapping = 8'h6f;
        8'h07: mapping = 8'hc5;
        8'h08: mapping = 8'h30;
        8'h09: mapping = 8'h01;
        8'h0a: mapping = 8'h67;
        8'h0b: mapping = 8'h2b;
        8'h0c: mapping = 8'hfe;
        8'h0d: mapping = 8'hd7;
        8'h0e: mapping = 8'hab;
        8'h0f: mapping = 8'h76;
        8'h10: mapping = 8'hca;
        8'h11: mapping = 8'h82;
        8'h12: mapping = 8'hc9;
        8'h13: mapping = 8'h7d;
        8'h14: mapping = 8'hfa;
        8'h15: mapping = 8'h59;
        8'h16: mapping = 8'h47;
        8'h17: mapping = 8'hf0;
        8'h18: mapping = 8'had;
        8'h19: mapping = 8'hd4;
        8'h1a: mapping = 8'ha2;
        8'h1b: mapping = 8'haf;
        8'h1c: mapping = 8'h9c;
        8'h1d: mapping = 8'ha4;
        8'h1e: mapping = 8'h72;
        8'h1f: mapping = 8'hc0;
        8'h20: mapping = 8'hb7;
        8'h21: mapping = 8'hfd;
        8'h22: mapping = 8'h93;
        8'h23: mapping = 8'h26;
        8'h24: mapping = 8'h36;
        8'h25: mapping = 8'h3f;
        8'h26: mapping = 8'hf7;
        8'h27: mapping = 8'hcc;
        8'h28: mapping = 8'h34;
        8'h29: mapping = 8'ha5;
        8'h2a: mapping = 8'he5;
        8'h2b: mapping = 8'hf1;
        8'h2c: mapping = 8'h71;
        8'h2d: mapping = 8'hd8;
        8'h2e: mapping = 8'h31;
        8'h2f: mapping = 8'h15;
        8'h30: mapping = 8'h04;
        8'h31: mapping = 8'hc7;
        8'h32: mapping = 8'h23;
        8'h33: mapping = 8'hc3;
        8'h34: mapping = 8'h18;
        8'h35: mapping = 8'h96;
        8'h36: mapping = 8'h05;
        8'h37: mapping = 8'h9a;
        8'h38: mapping = 8'h07;
        8'h39: mapping = 8'h12;
        8'h3a: mapping = 8'h80;
        8'h3b: mapping = 8'he2;
        8'h3c: mapping = 8'heb;
        8'h3d: mapping = 8'h27;
        8'h3e: mapping = 8'hb2;
        8'h3f: mapping = 8'h75;
        8'h40: mapping = 8'h09;
        8'h41: mapping = 8'h83;
        8'h42: mapping = 8'h2c;
        8'h43: mapping = 8'h1a;
        8'h44: mapping = 8'h1b;
        8'h45: mapping = 8'h6e;
        8'h46: mapping = 8'h5a;
        8'h47: mapping = 8'ha0;
        8'h48: mapping = 8'h52;
        8'h49: mapping = 8'h3b;
        8'h4a: mapping = 8'hd6;
        8'h4b: mapping = 8'hb3;
        8'h4c: mapping = 8'h29;
        8'h4d: mapping = 8'he3;
        8'h4e: mapping = 8'h2f;
        8'h4f: mapping = 8'h84;
        8'h50: mapping = 8'h53;
        8'h51: mapping = 8'hd1;
        8'h52: mapping = 8'h00;
        8'h53: mapping = 8'hed;
        8'h54: mapping = 8'h20;
        8'h55: mapping = 8'hfc;
        8'h56: mapping = 8'hb1;
        8'h57: mapping = 8'h5b;
        8'h58: mapping = 8'h6a;
        8'h59: mapping = 8'hcb;
        8'h5a: mapping = 8'hbe;
        8'h5b: mapping = 8'h39;
        8'h5c: mapping = 8'h4a;
        8'h5d: mapping = 8'h4c;
        8'h5e: mapping = 8'h58;
        8'h5f: mapping = 8'hcf;
        8'h60: mapping = 8'hd0;
        8'h61: mapping = 8'hef;
        8'h62: mapping = 8'haa;
        8'h63: mapping = 8'hfb;
        8'h64: mapping = 8'h43;
        8'h65: mapping = 8'h4d;
        8'h66: mapping = 8'h33;
        8'h67: mapping = 8'h85;
        8'h68: mapping = 8'h45;
        8'h69: mapping = 8'hf9;
        8'h6a: mapping = 8'h02;
        8'h6b: mapping = 8'h7f;
        8'h6c: mapping = 8'h50;
        8'h6d: mapping = 8'h3c;
        8'h6e: mapping = 8'h9f;
        8'h6f: mapping = 8'ha8;
        8'h70: mapping = 8'h51;
        8'h71: mapping = 8'ha3;
        8'h72: mapping = 8'h40;
        8'h73: mapping = 8'h8f;
        8'h74: mapping = 8'h92;
        8'h75: mapping = 8'h9d;
        8'h76: mapping = 8'h38;
        8'h77: mapping = 8'hf5;
        8'h78: mapping = 8'hbc;
        8'h79: mapping = 8'hb6;
        8'h7a: mapping = 8'hda;
        8'h7b: mapping = 8'h21;
        8'h7c: mapping = 8'h10;
        8'h7d: mapping = 8'hff;
        8'h7e: mapping = 8'hf3;
        8'h7f: mapping = 8'hd2;
        8'h80: mapping = 8'hcd;
        8'h81: mapping = 8'h0c;
        8'h82: mapping = 8'h13;
        8'h83: mapping = 8'hec;
        8'h84: mapping = 8'h5f;
        8'h85: mapping = 8'h97;
        8'h86: mapping = 8'h44;
        8'h87: mapping = 8'h17;
        8'h88: mapping = 8'hc4;
        8'h89: mapping = 8'ha7;
        8'h8a: mapping = 8'h7e;
        8'h8b: mapping = 8'h3d;
        8'h8c: mapping = 8'h64;
        8'h8d: mapping = 8'h5d;
        8'h8e: mapping = 8'h19;
        8'h8f: mapping = 8'h73;
        8'h90: mapping = 8'h60;
        8'h91: mapping = 8'h81;
        8'h92: mapping = 8'h4f;
        8'h93: mapping = 8'hdc;
        8'h94: mapping = 8'h22;
        8'h95: mapping = 8'h2a;
        8'h96: mapping = 8'h90;
        8'h97: mapping = 8'h88;
        8'h98: mapping = 8'h46;
        8'h99: mapping = 8'hee;
        8'h9a: mapping = 8'hb8;
        8'h9b: mapping = 8'h14;
        8'h9c: mapping = 8'hde;
        8'h9d: mapping = 8'h5e;
        8'h9e: mapping = 8'h0b;
        8'h9f: mapping = 8'hdb;
        8'ha0: mapping = 8'he0;
        8'ha1: mapping = 8'h32;
        8'ha2: mapping = 8'h3a;
        8'ha3: mapping = 8'h0a;
        8'ha4: mapping = 8'h49;
        8'ha5: mapping = 8'h06;
        8'ha6: mapping = 8'h24;
        8'ha7: mapping = 8'h5c;
        8'ha8: mapping = 8'hc2;
        8'ha9: mapping = 8'hd3;
        8'haa: mapping = 8'hac;
        8'hab: mapping = 8'h62;
        8'hac: mapping = 8'h91;
        8'had: mapping = 8'h95;
        8'hae: mapping = 8'he4;
        8'haf: mapping = 8'h79;
        8'hb0: mapping = 8'he7;
        8'hb1: mapping = 8'hc8;
        8'hb2: mapping = 8'h37;
        8'hb3: mapping = 8'h6d;
        8'hb4: mapping = 8'h8d;
        8'hb5: mapping = 8'hd5;
        8'hb6: mapping = 8'h4e;
        8'hb7: mapping = 8'ha9;
        8'hb8: mapping = 8'h6c;
        8'hb9: mapping = 8'h56;
        8'hba: mapping = 8'hf4;
        8'hbb: mapping = 8'hea;
        8'hbc: mapping = 8'h65;
        8'hbd: mapping = 8'h7a;
        8'hbe: mapping = 8'hae;
        8'hbf: mapping = 8'h08;
        8'hc0: mapping = 8'hba;
        8'hc1: mapping = 8'h78;
        8'hc2: mapping = 8'h25;
        8'hc3: mapping = 8'h2e;
        8'hc4: mapping = 8'h1c;
        8'hc5: mapping = 8'ha6;
        8'hc6: mapping = 8'hb4;
        8'hc7: mapping = 8'hc6;
        8'hc8: mapping = 8'he8;
        8'hc9: mapping = 8'hdd;
        8'hca: mapping = 8'h74;
        8'hcb: mapping = 8'h1f;
        8'hcc: mapping = 8'h4b;
        8'hcd: mapping = 8'hbd;
        8'hce: mapping = 8'h8b;
        8'hcf: mapping = 8'h8a;
        8'hd0: mapping = 8'h70;
        8'hd1: mapping = 8'h3e;
        8'hd2: mapping = 8'hb5;
        8'hd3: mapping = 8'h66;
        8'hd4: mapping = 8'h48;
        8'hd5: mapping = 8'h03;
        8'hd6: mapping = 8'hf6;
        8'hd7: mapping = 8'h0e;
        8'hd8: mapping = 8'h61;
        8'hd9: mapping = 8'h35;
        8'hda: mapping = 8'h57;
        8'hdb: mapping = 8'hb9;
        8'hdc: mapping = 8'h86;
        8'hdd: mapping = 8'hc1;
        8'hde: mapping = 8'h1d;
        8'hdf: mapping = 8'h9e;
        8'he0: mapping = 8'he1;
        8'he1: mapping = 8'hf8;
        8'he2: mapping = 8'h98;
        8'he3: mapping = 8'h11;
        8'he4: mapping = 8'h69;
        8'he5: mapping = 8'hd9;
        8'he6: mapping = 8'h8e;
        8'he7: mapping = 8'h94;
        8'he8: mapping = 8'h9b;
        8'he9: mapping = 8'h1e;
        8'hea: mapping = 8'h87;
        8'heb: mapping = 8'he9;
        8'hec: mapping = 8'hce;
        8'hed: mapping = 8'h55;
        8'hee: mapping = 8'h28;
        8'hef: mapping = 8'hdf;
        8'hf0: mapping = 8'h8c;
        8'hf1: mapping = 8'ha1;
        8'hf2: mapping = 8'h89;
        8'hf3: mapping = 8'h0d;
        8'hf4: mapping = 8'hbf;
        8'hf5: mapping = 8'he6;
        8'hf6: mapping = 8'h42;
        8'hf7: mapping = 8'h68;
        8'hf8: mapping = 8'h41;
        8'hf9: mapping = 8'h99;
        8'hfa: mapping = 8'h2d;
        8'hfb: mapping = 8'h0f;
        8'hfc: mapping = 8'hb0;
        8'hfd: mapping = 8'h54;
        8'hfe: mapping = 8'hbb;
        8'hff: mapping = 8'h16;
	endcase
end
endfunction


function[0:31] rcon;
    input [0:31] r; 
    begin
        case(r)
            4'h1: rcon = 32'h01000000;
            4'h2: rcon = 32'h02000000;
            4'h3: rcon = 32'h04000000;
            4'h4: rcon = 32'h08000000;
            4'h5: rcon = 32'h10000000;
            4'h6: rcon = 32'h20000000;
            4'h7: rcon = 32'h40000000;
            4'h8: rcon = 32'h80000000;
            4'h9: rcon = 32'h1b000000;
            4'ha: rcon = 32'h36000000;
            default: rcon = 32'h00000000;
        endcase
    end
endfunction

endmodule