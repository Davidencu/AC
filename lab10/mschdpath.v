module rgst #(
    parameter w=8
)(
    input clk, rst_b, ld, clr, input [w-1:0] d, output reg [w-1:0] q
);
    always @ (posedge clk, negedge rst_b)
        if (!rst_b)                 q <= 0;
        else if (clr)               q <= 0;
        else if (ld)                q <= d;
endmodule



module mschdpath(input [511:0]blk, input ld_mreg,input upd_mreg,input clk,input rst_b, output [31:0]m0);

wire [31:0]m[15:1];

function [31:0] RotireDr (input [31:0]x , input [4:0]p);
reg [63:0]tmp;
begin
tmp = {x,x}>>p;
RotireDr = tmp[31:0];
end
endfunction

function [31:0] sigma0 (input [31:0]x);
begin
sigma0=RotireDr(x, 7)^RotireDr(x, 18)^(x>>3);
end
endfunction

function [31:0] sigma1 (input [31:0]x);
begin
sigma1=RotireDr(x, 17)^RotireDr(x, 19)^(x>>10);
end
endfunction

function [31:0]mux (input [31:0]x, input [31:0]y, input [1:0]sel);
mux=({32{sel}}&x)|({32{~sel}}&y);
endfunction

genvar i;
generate
	for(i=0;i<16;i=i+1) begin: rgst
		if(i==0)
		begin
			rgst #(.w(32)) inst0(.clr(1'b0), .clk(clk), .rst_b(rst_b), .ld(upd_mreg), .d(mux(blk[511-i*32:512-(i+1)*32],m[i+1],ld_mreg)), .q(m0));
		end
		else if (i<15)
		begin
			rgst #(.w(32)) inst1(.clr(1'b0), .clk(clk), .rst_b(rst_b), .ld(upd_mreg), .d(mux(blk[511-i*32:512-(i+1)*32],m[i+1],ld_mreg)), .q(m[i]));
		end
		else
		begin
			rgst #(.w(32)) inst1(.clr(1'b0), .clk(clk), .rst_b(rst_b), .ld(upd_mreg), .d(mux(blk[511-i*32:512-(i+1)*32],(m0+sigma0(m[1])+m[9]+sigma1(m[14]))%33'h100000000,ld_mreg)), .q(m[i]));
		end
	end
endgenerate

endmodule

module mschdpath_tb();

reg [511:0]blk;
reg ld_mreg;
reg upd_mreg;
reg clk;
reg rst_b;
wire [31:0]m0;

mschdpath uut(.clk(clk), .rst_b(rst_b), .upd_mreg(upd_mreg), .ld_mreg(ld_mreg), .blk(blk), .m0(m0));

initial begin
clk=1'b0;
repeat (128) #(50) clk=~clk;
end

initial begin
rst_b=0;
#25;
rst_b=1;
end

initial begin
ld_mreg=1;
upd_mreg=1;
blk=512'h61626364303132338000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000040;
#100;
ld_mreg=0;
end

endmodule
