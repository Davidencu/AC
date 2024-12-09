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

module fdivby5(input clr,input c_up,input clk,input rst_b,output fdclk);

wire [2:0] q;
rgst #(.w(3)) instance0 (.clk(clk), .rst_b(rst_b), .ld(c_up), .clr(clr|q[2]), .d( { (q[0]&q[1])^q[2], q[0]^q[1], ~q[0] } ), .q(q));
assign fdclk=~(q[2]|q[1]|q[0]);

endmodule

module fdivby5_tb();

reg clr;
reg c_up;
reg clk;
reg rst_b;
wire fdclk;

fdivby5 uut(.clr(clr), .c_up(c_up), .clk(clk), .rst_b(rst_b), .fdclk(fdclk));

initial begin
clk=1'b0;
repeat (48) #(50) clk=~clk;
end

initial begin
rst_b=0;
c_up=1;
clr=0;
#25;
rst_b=1;
#575;
clr=1;
#100;
clr=0;
#500;
clr=1;
#100;
clr=0;
end

endmodule