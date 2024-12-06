`include"lfsr5b.v"
`include"check.v"
`include"sisr4b.v"

module bist(input clk,input rst_b,output [3:0]sig);

wire [4:0]q;
wire h;
lfsr5b inst0(.clk(clk), .rst_b(rst_b), .q(q));
check inst1(.i(q), .o(h));
sisr4b inst2(.clk(clk), .rst_b(rst_b), .i(h), .q(sig));

endmodule

module bist_tb();

reg clk;
reg rst_b;
wire [3:0]sig;

bist DUT_BIST(.clk(clk), .rst_b(rst_b), .sig(sig));

initial begin
clk=1'b0;
repeat (70) #(50) clk=~clk;
end

initial begin
rst_b=0;
#25;
rst_b=1;
end
endmodule

