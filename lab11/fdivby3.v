module fdivby3 (input clk,input rst_b, input clr, input c_up, output fdclk);

localparam S0=0;
localparam S1=1;
localparam S2=2;

wire [2:0]st_nxt;
reg [2:0]st;

assign st_nxt[S0]=((~(c_up)|clr)&st[S0])|((c_up|clr)&st[S2])|(clr&st[S1]);
assign st_nxt[S1]=(c_up&~(clr)&st[S0])|(~(c_up)&~(clr)&st[S1]);
assign st_nxt[S2]=(~(c_up)&~clr&st[S2])|(c_up&~clr&st[S1]);

assign fdclk=st[S0];

always @(posedge clk,negedge rst_b) begin

if (~rst_b) begin
st<=0;
st[S0]<=1;
end
else
st<=st_nxt;

end

endmodule

module fdivby3_tb();

reg clr;
reg c_up;
reg clk;
reg rst_b;
wire fdclk;

fdivby3 uut(.clr(clr), .c_up(c_up), .clk(clk), .rst_b(rst_b), .fdclk(fdclk));

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
#375;
clr=1;
#100;
clr=0;
#100;
c_up=0;
#100;
c_up=1;
#400;
c_up=0;
#200;
c_up=1;
end

endmodule
