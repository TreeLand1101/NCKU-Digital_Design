module subBytes_tb;
reg [127:0] in;
wire [127:0]out;

subBytes sb(in,out);

initial begin
$monitor("input= %h ,output= %h, ans = d42711aee0bf98f1b8b45de51e415230",in,out);
in=128'h193de3bea0f4e22b9ac68d2ae9f84808;
end
endmodule