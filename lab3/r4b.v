`include "mux4b.v"
`include "dflipflop.v"

module r4b (
  input clk, rst_b, ld, sh, sh_in,
  input [3:0] d,
  output [3:0] q
);
  
  wire [3:0]aux;
  
  mux4b MUX_1(
    .i({q[3], sh_in, d[3], q[3]}),
    .sel({sh, ld}),
    .o(aux[3])
  );
  
mux4b MUX_2(
  .i({q[2], q[3], d[2], q[2]}),
  .sel({sh, ld}),
  .o(aux[2])
);
  
mux4b MUX_3(
  .i({q[1], q[2], d[1], q[1]}),
  .sel({sh, ld}),
  .o(aux[1])
);
  
mux4b MUX_4(
  .i({q[0], q[1], d[0], q[0]}),
  .sel({sh, ld}),
  .o(aux[0])
);
  
  dflipflop DFF_1(
    .clk(clk),
    .rst(rst_b),
    .d(aux[3]),
    .q(q[3])
  );
  
dflipflop DFF_2(
    .clk(clk),
    .rst(rst_b),
  .d(aux[2]),
  .q(q[2])
);
  
dflipflop DFF_3(
    .clk(clk),
    .rst(rst_b),
  .d(aux[1]),
  .q(q[1])
);
  
dflipflop DFF_4(
    .clk(clk),
    .rst(rst_b),
  .d(aux[0]),
  .q(q[0])
);
  
  
  
endmodule

module r4b_tb;
  reg clk, rst_b, ld, sh, sh_in;
  reg [3:0] d;
  wire [3:0] q;

  r4b r4b_i (.clk(clk), .rst_b(rst_b), .ld(ld), .sh(sh), .sh_in(sh_in), .d(d), .q(q));

  initial begin
    {clk, rst_b} = 0;
    #5 rst_b = 1;
    #45 clk = 1;
    repeat (60)
      #50 clk = ~clk;
  end

  integer k, l;
  initial begin
    $dumpfile("dump.vcd");  $dumpvars;
    $display("Time\top\td\tsh_in\tq");
    {d, sh_in} = 0; {ld, sh} = 0;
    for (k = 0; k < 32; k = k + 1) begin
      $display("%0t\t%s\t%b\t%b\t%b", $time, (ld) ? "LOAD" : (sh) ? "SHIFT" : "NO_OP", d, sh_in, q);
      #100 l = $urandom; {d, sh_in} = l[6:2]; {ld, sh} = l[1:0] % 3;
    end
    $display("%0t\t%s\t%b\t%b\t%b", $time, (ld) ? "LOAD" : (sh) ? "SHIFT" : "NO_OP", d, sh_in, q);
    
  end
endmodule