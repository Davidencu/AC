`include"d_ff.v"
module sisr4b(input clk,input rst_b,input i,output [3:0]q);
genvar j;
generate
for(j=0;j<4;j=j+1) begin: d_ff
if (j==0)
d_ff inst3(.d(i^q[3]), .clk(clk), .rst_b(rst_b), .set_b(1'b1), .q(q[j]));
else if (j==1)
d_ff inst4(.d(q[j-1]^q[3]), .clk(clk), .rst_b(rst_b), .set_b(1'b1), .q(q[j]));
else
d_ff inst5(.d(q[j-1]), .clk(clk), .rst_b(rst_b), .set_b(1'b1), .q(q[j]));
end
endgenerate
endmodule

module sisr4b_tb();

reg clk;
reg rst_b;
wire [3:0]q;
reg i;

sisr4b DUT_L(.clk(clk), .rst_b(rst_b), .q(q), .i(i));

initial begin
clk=1'b0;
repeat (70) #(50) clk=~clk;
end

initial begin
i=$urandom; 
repeat (35) #(100) i=$urandom; 
end

initial begin
rst_b=0;
#25;
rst_b=1;
end
endmodule
