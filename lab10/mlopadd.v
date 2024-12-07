module rgst #(parameter w=7)(input clk,input rst_b, input [w-1:0]d,output reg [w-1:0]q);

always @(posedge clk, negedge rst_b) begin
if(~rst_b)
q<=0;
else
q<=d;
end

endmodule

module mlopadd(input clk,input rst_b, input [11:0]x, output [11:0]a);

wire [11:0]wi;

rgst #(.w(12)) inst0 (.clk(clk), .rst_b(rst_b), .d(x), .q(wi));
rgst #(.w(12)) inst1 (.clk(clk), .rst_b(rst_b), .d(wi+a), .q(a));

endmodule

module mlopadd_tb();

integer i;
reg clk;
reg rst_b;
reg [11:0]x;
wire [11:0]a;

mlopadd uut(.clk(clk), .rst_b(rst_b), .x(x), .a(a));

initial begin
clk=1'd0;
repeat (200) #(50) clk=~clk;
end

initial begin
rst_b=0;
#25;
rst_b=1;
end

initial begin
for(i=1;i<99;i=i+2) begin
x=i;
#100;
end
end
endmodule