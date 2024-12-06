`include"d_ff.v"
module lfsr5b(input clk,input rst_b,output [4:0]q);

genvar i;
generate
for(i=0;i<5;i=i+1) begin: d_ff
if(i==0)
d_ff inst0(.clk(clk), .set_b(rst_b), .rst_b(1'b1), .d(q[4]), .q(q[i]));
else if (i==2)
d_ff inst1(.clk(clk), .set_b(rst_b), .rst_b(1'b1), .d(q[i-1]^q[4]), .q(q[i]));
else
d_ff inst2(.clk(clk), .set_b(rst_b), .rst_b(1'b1), .d(q[i-1]), .q(q[i]));
end
endgenerate

endmodule

module lfsr5b_tb();

reg clk;
reg rst_b;
wire [4:0]q;

lfsr5b DUT_L(.clk(clk), .rst_b(rst_b), .q(q));

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