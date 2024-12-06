`include "prod.v"

module cons(input clk,input rst_b,input val,input [7:0]data,output reg [7:0]sum);

reg [7:0]prev;
reg [7:0]alt_sum;
integer i=0;
always @(posedge clk,negedge rst_b) begin

if(~rst_b) begin
prev<=0;
sum<=0;
alt_sum<=0;
i=0;
end
else
if (val) begin
if (data>prev)
begin
alt_sum<=alt_sum+data;
prev<=data;
i=i+1;
end
else begin
prev<=0;

if(i>1)
sum<=sum+alt_sum;

alt_sum<=data;
i=1;
end
end
end

endmodule

//`include "prod_tb.v"
`include "prod.v"

module cons_tb();

reg clk;
reg rst_b;
wire val;
wire [7:0]data;
wire [7:0]sum;

prod DUT_PROD(.clk(clk), .rst_b(rst_b), .data(data), .val(val));
cons DUT_CONS(.clk(clk), .rst_b(rst_b), .data(data), .val(val), .sum(sum));

initial begin
clk=1'b0;
repeat (42) #(50) clk=~clk;
end

initial begin
rst_b=1;
#25;
rst_b=0;
#25;
rst_b=1;
end

endmodule
