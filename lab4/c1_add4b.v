`include"fac.v"
`include"hac.v"

module c1_add4b(input [3:0]x,[3:0]y, output [3:0]o);

wire [7:0]aux;
wire [3:0]tmp;

fac FAC_0(
  .ci(0),
  .x(x[0]),
  .y(y[0]),
  .o(tmp[0]),
  .co(aux[0])
);

fac FAC_1(
  .ci(aux[0]),
  .x(x[1]),
  .y(y[1]),
  .o(tmp[1]),
  .co(aux[1])
);

fac FAC_2(
  .ci(aux[1]),
  .x(x[2]),
  .y(y[2]),
  .o(tmp[2]),
  .co(aux[2])
);

fac FAC_3(
  .ci(aux[2]),
  .x(x[3]),
  .y(y[3]),
  .o(tmp[3]),
  .co(aux[3])
);

hac HAC_0(
  .x(aux[3]),
  .y(tmp[0]),
  .o(o[0]),
  .co(aux[4])
);

hac HAC_1(
  .x(aux[4]),
  .y(tmp[1]),
  .o(o[1]),
  .co(aux[5])
);

hac HAC_2(
  .x(aux[5]),
  .y(tmp[2]),
  .o(o[2]),
  .co(aux[6])
);

hac HAC_3(
  .x(aux[6]),
  .y(tmp[3]),
  .o(o[3]),
  .co(aux[7])
);

endmodule

module c1_add4b_tb();

reg [3:0]x;
reg [3:0]y;
wire [3:0]o;

c1_add4b DUT_C1(
.x(x),
.y(y),
.o(o)
);

integer i;
  initial begin
    $display("Time\tx\ty\to");
    $monitor("%0t\t%b\t%b\t%b", $time, x, y, o);
    for(i=0;i<=256;i=i+1)
	begin
	{x[3], x[2], x[1], x[0], y[3], y[2], y[1], y[0]}=i;
    	#60;
  	end
  end
  
endmodule
