`include "fac.v"

module add2b(
   input [1:0]x,
   input [1:0]y,
   input ci,
   output [1:0]sum,co
);

wire aux;

fac FAC0(
.ci(ci),
.x(x[0]),
.y(y[0]),
.o(sum[0]),
.co(aux)
);

fac FAC1(
.ci(aux),
.x(x[1]),
.y(y[1]),
.o(sum[1]),
.co(co)
);

endmodule

module add2b_tb();
   
reg [1:0]x;
reg [1:0]y;
reg ci;
wire [1:0]sum;
wire co;

add2b ADD2B_DUT(
.x(x), .y(y), .ci(ci), .sum(sum), .co(co)
);

integer i,j;
  initial begin
    $display("Time\tx\ty\tci\tsum\tco");
    $monitor("%0t\t%02b\t%02b\t%b\t%02b\t%b", $time, x, y, ci, sum, co);
    for(i=0;i<=3;i=i+1)
	begin
		{x[1], x[0]}=i;
		for(j=0;j<=7;j=j+1)
		begin
			{y[1], y[0], ci}=j;
    			#100;
		end
  	end
  end
  
endmodule

