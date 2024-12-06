`timescale 1ns / 1ns
`include"dec24_with_enable.v"
`include"rgst.v"
`include"mux_2s8b.v"

module regfl_4x8 (
input clk,
input rst_b, // asynch
input [7:0] wr_data,
input [1:0] wr_addr,
input wr_e,
output [7:0] rd_data,
input [1:0] rd_addr
);

wire [3:0]o;
wire [7:0]d3,d2,d1,d0;

dec24_with_enable DEC24(
.i(wr_addr),
.enable(wr_e),
.o(o)
);

rgst RGST0(.clk(clk), .ld(o[0]), .rst_b(rst_b), .clr(0), .d(wr_data), .q(d0));

rgst RGST1(.clk(clk), .ld(o[1]), .rst_b(rst_b), .clr(0), .d(wr_data), .q(d1));

rgst RGST2(.clk(clk), .ld(o[2]), .rst_b(rst_b), .clr(0), .d(wr_data), .q(d2));

rgst RGST3(.clk(clk), .ld(o[3]), .rst_b(rst_b), .clr(0), .d(wr_data), .q(d3));

mux_2s8b MUX0( .d0(d0), .d1(d1), .d2(d2), .d3(d3), .s(rd_addr), .o(rd_data));

endmodule

module regfl_4x8_tb();

localparam CLK_PERIOD = 100;

reg clk;
reg rst_b;
reg [7:0]wr_data;
reg [1:0]wr_addr;
reg wr_e;
wire [7:0]rd_data;
reg [1:0]rd_addr;

regfl_4x8 DUT_REGF1_4X8(.clk(clk), .rst_b(rst_b), .wr_data(wr_data), .wr_addr(wr_addr), .wr_e(wr_e), .rd_data(rd_data), .rd_addr(rd_addr));

initial begin

repeat (30) #(CLK_PERIOD/2) clk = ~clk;
end

initial begin
    clk=1'd0;
    wr_addr=2'h0;
    wr_data=8'ha2;
    rd_addr=2'h3;
    rst_b=1;
    wr_e=1;
    #5;
    rst_b=0;
    #5;
    rst_b=1;
    #90;
    wr_addr=2'h2;
    wr_data=8'h2e;
rd_addr=2'h0;
    #100;
    wr_addr=2'h1;
    wr_data=8'h98;
rd_addr=2'h1;
    wr_e=0;
    #100;
    wr_addr=2'h3;
    wr_data=8'h55;
rd_addr=2'h2;
    wr_e=1;
    #100;
    wr_addr=2'h0;
    wr_data=8'h20;
rd_addr=2'h0;
    #100;
    wr_addr=2'h1;
    wr_data=8'hff;
rd_addr=2'h3;
    #100;
    wr_addr=2'h3;
    wr_data=8'hc7;
rd_addr=2'h1;
    #100;
    wr_addr=2'h2;
    wr_data=8'hb5;
rd_addr=2'h2;
    wr_e=0;
    #100;
    wr_addr=2'h3;
    wr_data=8'h91;
rd_addr=2'h3;
    wr_e=1;
    #100;


end

endmodule