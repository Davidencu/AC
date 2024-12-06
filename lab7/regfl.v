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

module regfl_tb();

reg [63:0]d;
reg [2:0]s;
reg we;
reg rst_b;
reg clk;
wire [511:0]q;

regfl instancee(.d(d), .s(s), .we(we), .rst_b(rst_b), .clk(clk), .q(q));

task urand64(output reg [63:0]r);
begin
r[63:32]=$urandom;
r[31:0]=$urandom;
end
endtask

localparam CLK_PERIOD = 100;
localparam RUNNING_CYCLES = 50;
initial begin
clk = 1'd0;
repeat (2*RUNNING_CYCLES) #(CLK_PERIOD/2) clk = ~clk;
end

initial begin
urand64(d);
urand64(s);
repeat (RUNNING_CYCLES) #(CLK_PERIOD) begin urand64(d); urand64(s); end
end

initial begin
rst_b=0;
we=1;
#25;
rst_b=0;
#25;
rst_b=1;
#550;
we=0;
#100;
we=1;

end
endmodule