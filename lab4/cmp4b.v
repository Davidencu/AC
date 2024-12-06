module cmp4b(input [3:0]x,[3:0]y,output lt,eq,gt);

wire lt1,eq1,gt1,lt0,eq0,gt0;

cmp2b CMP2B_0(
.x({x[3], x[2]}),
.y({y[3], y[2]}),
.lt(lt0),
.eq(eq0),
.gt(gt0)
);

cmp2b CMP2B_1(
.x({x[1], x[0]}),
.y({y[1], y[0]}),
.lt(lt1),
.eq(eq1),
.gt(gt1)
);

assign lt=lt0|(eq0&lt1);
assign eq=eq1&eq0;
assign gt=gt0|(eq0&gt1);

endmodule

module cmp4b_tb();

reg [3:0]x;
reg [3:0]y;
wire lt,eq,gt;

cmp4b DUT_CMP4B(.x(x), .y(y), .lt(lt), .eq(eq), .gt(gt));

integer index;
  initial begin
    $display("Time\tx\ty\tlt\teq\tgt");
    $monitor("%0t\t%04b\t%04b\t%b\t%b\t%b", $time, x, y, lt, eq, gt);
    for(index=0;index<256;index=index+1) begin
      {x[3], x[2], x[1], x[0], y[3], y[2], y[1], y[0]}=index;
    	#60;
    end
  end

endmodule