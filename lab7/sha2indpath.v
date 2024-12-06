module dec #(parameter w=3)(
	input [w-1:0] s,
	input e,
	output reg [(2**w)-1:0] o
);
	always @ (*) begin
		o = 0;
		if (e)
  		  o[s] = 1;
	end
endmodule

module rgst #(
    parameter w=64
)(
    input clk,input rst_b,input ld,input clr, input [w-1:0] d, output reg [w-1:0] q
);
    always @ (posedge clk, negedge rst_b) begin
        if (!rst_b)                 q <= 0;
        else if (clr)               q <= 0;
        else if (ld)                q <= d;
end
endmodule

module regfl (input [63:0]d,input [2:0]s,input we,input rst_b,input clk,output [511:0]q);
	wire [7:0]wi;
	dec inst(.s(s), .e(we), .o(wi));
	genvar i;
	generate
	for(i=0;i<8;i=i+1) begin: rgst
	rgst inst0 (.ld(wi[7-i]),.d(d),.clr(1'b0),.rst_b(rst_b), .clk(clk), .q(q[63+64*i:64*i]));
	end
	endgenerate
endmodule

module pktmux(input pad_pkt,input zero_pkt,input mgln_pkt,input [63:0]msg_len,input [63:0]pkt,output reg [63:0]o);

always @(*) begin
if(pad_pkt) begin
o={1'b1, {63{1'b0}}};
end
else if(zero_pkt) begin
o={64{1'b0}};
end
else if(mgln_pkt) begin
o=msg_len;
end
else if(~mgln_pkt & ~pad_pkt & ~zero_pkt) begin
o=pkt;
end
end

endmodule

module cntr #(parameter w=3)(
    input clk, rst_b, c_up, clr, output reg [w-1:0] q
);
    always @ (posedge clk, negedge rst_b)
        if (!rst_b)					q <= 0;
        else if (c_up)				q <= q+1;
        else if (clr)				q <= 0;
endmodule

module sha2indpath(input st_pkt,input clr,input clk,input rst_b,input [63:0]pkt,input pad_pkt,input zero_pkt,input mgln_pkt,output wire[2:0]idx,output [511:0]blk);

wire [63:0]q;
wire [63:0]helper;
rgst #(.w(64)) inst0(.d(q+64'h8000000000000000),.clk(clk),.rst_b(rst_b),.ld(~(pad_pkt|zero_pkt|mgln_pkt)&st_pkt),.q(q),.clr(clr));
pktmux inst1(.pad_pkt(pad_pkt), .zero_pkt(zero_pkt), .mgln_pkt(mgln_pkt),.msg_len(q),.pkt(pkt),.o(helper));
regfl inst2(.s(idx),.d(helper),.we(st_pkt),.q(blk), .clk(clk), .rst_b(rst_b));
cntr #(.w(3)) inst3(.c_up(st_pkt), .clr(clr),.clk(clk),.rst_b(rst_b),.q(idx));

endmodule

module sha2indpath_tb();

reg st_pkt;
reg clr;
reg clk;
reg rst_b;
reg [63:0]pkt;
reg pad_pkt;
reg zero_pkt;
reg mgln_pkt;
wire [511:0]blk;
wire [2:0]idx;

localparam CLK_PERIOD = 100;
localparam RUNNING_CYCLES = 50;

sha2indpath instanc(.st_pkt(st_pkt), .clr(clr), .clk(clk), .rst_b(rst_b), .pkt(pkt), .pad_pkt(pad_pkt), .zero_pkt(zero_pkt), .mgln_pkt(mgln_pkt),.idx(idx),.blk(blk));

task urand64(output reg [63:0]r);
begin
r[63:32]=$urandom;
r[31:0]=$urandom;
end
endtask


initial begin
clk = 1'd0;
repeat (2*RUNNING_CYCLES) #(CLK_PERIOD/2) clk = ~clk;
end

initial begin
urand64(pkt);
repeat (RUNNING_CYCLES) #(CLK_PERIOD) urand64(pkt);
end

initial begin
rst_b=0;
clr=0;
st_pkt=1;
pad_pkt=0;
zero_pkt=0;
mgln_pkt=0;
#25;
rst_b=1;
#175;
clr=1;
#100;
clr=0;
#500;
st_pkt=0;
#100;
st_pkt=1;
#100;
pad_pkt=1;
#100;
pad_pkt=0;
zero_pkt=1;
#100;
zero_pkt=0;
mgln_pkt=1;
#100;
mgln_pkt=0;
#100;
end
endmodule
