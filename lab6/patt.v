module patt(input i,input clk,input rst_b,output reg o);

localparam S0=3'b000;
localparam S1=3'b001;
localparam S2=3'b010;
localparam S3=3'b011;
localparam S4=3'b100;

reg [2:0]st;
reg [2:0]st_nxt;

always @(st, i) begin //determinam starea urmatoare in functie de starea curenta si intrare
case (st)
S0: if(i) st_nxt=S1;
else st_nxt=S0;
S1: if(i) st_nxt=S1;
else st_nxt=S2;
S2: if(i) st_nxt=S3;
else st_nxt=S0;
S3: if(i) st_nxt=S4;
else st_nxt=S2;
S4: if(i)st_nxt=S1;
else st_nxt=S2;
endcase
end

always @(st) begin //iesirea depinde numai de starea curenta
case(st)
S0: o=0;
S1: o=0;
S2: o=0;
S3: o=0;
S4: o=1;
endcase
end

always @(posedge clk,negedge rst_b) begin
if(~rst_b) st<=S0; //aducem st la starea initiala
else st<=st_nxt; //altfel, st ia starea urmatoare
end

endmodule

module patt_tb();

reg clk;
reg rst_b;
reg i;
wire o;
patt DUT_PATT(.clk(clk), .rst_b(rst_b), .i(i), .o(o));

initial begin
clk=1'b0;
repeat (20) #(50) clk=~clk; 
end

initial begin
rst_b=1'b1;
i=1;
#25;
rst_b=1'b0;
#25;
rst_b=1'b1;
#50;
i=0;
#100;
i=1;
#200;
i=0;
#100;
i=1;
#200;
end

endmodule