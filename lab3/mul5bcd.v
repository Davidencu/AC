module mul5bcd (
  input [3:0] i,
  output reg [3:0] d, u
);
  
  reg [5:0]aux;
  
  always @(*) begin
    aux=5*i;
    if(aux<10)
      	d=0'd0;
    if(0'd10<= aux && aux<0'd20)
      d=4'd1;
    if(0'd20<= aux && aux<0'd30)
      d=4'd2;
    if(0'd30<= aux && aux<0'd40)
      d=4'd3;
    if(0'd40<= aux && aux<0'd50)
      d=4'd4;
    u=aux%0'd10;
  end
  
endmodule


module mul5bcd_tb;
  reg [3:0] i;
  wire [3:0] d, u;

  mul5bcd mul5bcd_i (.i(i), .d(d), .u(u));

  integer k;
  initial begin
    $display("Time\ti\t\td\t\tu");
    $monitor("%0t\t%b(%4d)\t%b(%4d)\t%b(%4d)", $time, i, i, d, d, u, u);
    i = 0;
    for (k = 1; k < 10; k = k + 1)
      #10 i = k;
  end
endmodule