module fac(
  input ci,
  input x,
  input y,
  output reg o,
  output reg co
);

always @* begin
  o=x^y^ci;
  co=(x&ci)|(y&ci)|(x&y);
end
  
endmodule

module fac_tb();
  
  reg ci;
  reg x;
  reg y;
  wire o;
  wire co;
  
  fac DUT_FAC(
    .ci(ci),
    .x(x),
    .y(y),
    .o(o),
    .co(co)
  );

  integer i;
  initial begin
    $display("Time\tx\ty\tci\to\tco");
    $monitor("%0t\t%b\t%b\t%b\t%b\t%b", $time, x, y, ci, o, co);
    for(i=0;i<=7;i=i+1)
	begin
	{x, y, ci}=i;
    	#100;
  	end
  end
  
endmodule