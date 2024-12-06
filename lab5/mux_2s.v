`include"dec24.v"

module mux_2s #(
parameter w=4 // width parameter
) (input[w-1:0] d0, d1, d2, d3, //4 data inputs
input [1:0]s , // selection input
output [w-1:0]o // data output
);

wire [3:0]aux;

dec24 DEC_1(
   .i(s),
   .o(aux)
);

assign o = (aux[0]) ? d0 : (aux[1]) ? d1 : (aux[2]) ? d2 : (aux[3]) ? d3 : {w{1'bz}};

endmodule

module mux_2s_tb();

parameter w=4;

reg [w-1:0]d0,d1,d2,d3;
reg [1:0]s;
wire [w-1:0]o;

mux_2s DUT_MUX(.d0(d0), .d1(d1), .d2(d2), .d3(d3), .s(s), .o(o)); 

integer i;

initial begin

d0=4'b1011;
d1=4'b0101;
d2=4'b0001;
d3=4'b1000;


$display("Time\ts\to");
$monitor("%0t\t%02b\t%04b", $time, s, o);
for(i=0;i<w;i=i+1)
begin
    {s[1], s[0]}=i;
    #60;
end

end

endmodule

