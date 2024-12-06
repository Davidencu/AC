module pktmux(input pad_pkt,input zero_pkt,input mgln_pkt,input [63:0]msg_len,input [63:0]pkt,output reg [63:0]o);

always @(*) begin
if(pad_pkt) begin
o={1'b1, {63{1'b0}}};
end
else if(zero_pkt) begin
o={64{1'b0}};
end
else if(mgln_pkt) begin
o=msg_len;
end
else if(~mgln_pkt & ~pad_pkt & ~zero_pkt) begin
o=pkt;
end
end

endmodule

module pktmux_tb();

reg pad_pkt;
reg zero_pkt;
reg mgln_pkt;
reg [63:0]msg_len;
reg [63:0]pkt;
wire [63:0]o;

task urand64 (output reg [63:0]r);
begin
r [63:32]= $urandom;
r [31:0] = $urandom;
end
endtask

localparam CLK_PERIOD = 100;
localparam RUNNING_CYCLES = 50;

pktmux p(.pad_pkt(pad_pkt), .zero_pkt(zero_pkt), .mgln_pkt(mgln_pkt), .msg_len(msg_len), .pkt(pkt), .o(o));


reg clk;
initial begin
clk = 1'd0;
repeat (2*RUNNING_CYCLES) #(CLK_PERIOD/2) begin urand64(msg_len); urand64(pkt); end
end

initial begin
pad_pkt=0;
zero_pkt=0;
mgln_pkt=0;
#100;
pad_pkt=1;
#100;
pad_pkt=0;
zero_pkt=1;
#100;
zero_pkt=0;
mgln_pkt=1;
#100;
mgln_pkt=0;
#100;

end

endmodule