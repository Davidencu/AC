module cmp2b(
  input [1:0]x,
  input [1:0]y,
  output reg lt,
  output reg eq,
  output reg gt
);
  
always @* begin
  gt=x[1]&(~y[1])|x[0]&(~y[0])&(x[1]|(~y[1]));
  eq=(x[1]~^y[1])&(x[0]~^y[0]);
  lt=y[1]&(~x[1])|y[0]&(~x[0])&(y[1]|(~x[1]));
end
  
endmodule

module cmp2b_tb();
  
  reg [1:0]x;
  reg [1:0]y;
  
  wire lt;
  wire eq;
  wire gt;
  
  cmp2b DUT_CMP(
    .x(x),
    .y(y),
    .gt(gt),
    .eq(eq),
    .lt(lt)
  );
  
	integer index;
  initial begin
    $display("Time\tx\ty\tlt\teq\tgt");
    $monitor("%0t\t%02b\t%02b\t%b\t%b\t%b", $time, x, y, lt, eq, gt);
    for(index=0;index<16;index=index+1) begin
      {x[1], x[0], y[1], y[0]}=index;
    	#100;
    end
  end
  
endmodule