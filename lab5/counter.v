`timescale 1ns / 1ns
module counter #(parameter w=8, parameter iv = {w{1'b1}}) (input c_up,rst_b,clr,clk,output reg [w-1:0]q);

always@(posedge clk or negedge rst_b) begin

if(!rst_b)
q<=iv;

else if(clr)
q<=iv;
else if (c_up)
q<=q+1;

end

endmodule

module counter_tb();

parameter w=8,iv={w{1'b1}};
localparam CLK_PERIOD = 100;
reg clk;
reg rst_b;
reg c_up;
reg clr;
wire [w-1:0]q;

counter DUT_COUNTER(.c_up(c_up), .rst_b(rst_b), .clr(clr), .clk(clk), .q(q));

initial begin
repeat (30) #(CLK_PERIOD/2) clk = ~clk;
end

initial begin


clk = 1'd0;

c_up=1'b1;
clr=1'b0;
rst_b=1'b1;
#5;
rst_b=1'b0;
#5;
rst_b=1'b1;
#190;
clr=1'b1;
#100;
clr=1'b0;
#100;
c_up=1'b0;
#100;
c_up=1'b1;
#200;



end

endmodule
