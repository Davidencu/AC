module sadd(input clk,rst_b,[1:0]i,output reg o);

reg [1:0]st;
reg [1:0]st_nxt;

localparam S0_ST = 1'b0;
localparam S1_ST = 1'b1;


always @(st,i) begin
case(st)
	S0_ST: if (~i[1]) st_nxt=S0_ST;
		else if (i[0]) st_nxt=S1_ST;
		else st_nxt=S0_ST;
	S1_ST: if (i[1]) st_nxt=S1_ST;
		else if (i[0]) st_nxt=S1_ST;
		else st_nxt=S0_ST;
endcase
end

always @(st,i) begin
	o=1'b0;
	case(st)
	S0_ST: if (i[1]^i[0]) o=1'b1;
		else o=1'b0;
	S1_ST: if (i[1]^i[0]) o=1'b0;
		else o=1'b1;
	endcase
end

always @(posedge clk,negedge rst_b) begin //ATENTIE, schimbarea starii in starea urmatoare este influentata de clock si reset
	if (~rst_b) st<=S0_ST;
	else st<=st_nxt;
end

endmodule

module sadd_tb();

localparam CLK_PERIOD=100;
localparam CLK_CYCLES=10;

reg [1:0]i;
reg clk;
reg rst_b;
wire o;

sadd DUT_SADD(.clk(clk), .rst_b(rst_b), .i(i), .o(o));

initial begin
repeat (2*CLK_CYCLES) #(CLK_PERIOD/2) clk = ~clk; //repeat iti repeta instructiunile de un numar finit de ori, de aceea este recomandat
end

initial begin
clk=0;
rst_b=1;
{i[1], i[0]}=2'b01;
#5;
rst_b=~rst_b;
#5;
rst_b=~rst_b;
#90;
{i[1], i[0]}=2'b11;
#100;
{i[1], i[0]}=2'b10;
#100;
{i[1], i[0]}=2'b00;
#100;
{i[1], i[0]}=2'b00;
#100;

end

endmodule
