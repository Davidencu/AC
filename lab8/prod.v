
module prod(input clk,input rst_b,output reg val,output reg [7:0]data);
integer nr_date_valide=0,nr_date_invalide=0,i=0;
always @(posedge clk,negedge rst_b) begin
if(~rst_b) begin
data<=0;
val<=0;
nr_date_valide<=$urandom_range(3,5);
nr_date_invalide<=$urandom_range(1,3);
i=0;
end

else if (i<nr_date_valide) begin
data<=$urandom_range(0,5);
val<=1;
i=i+1;
end
else if(i==nr_date_valide) begin
data<=8'hz;
val<=0;
i=i+1;
end
else if(i<nr_date_valide+nr_date_invalide) begin
data<=8'hz;
val<=0;
i=i+1;
end
else if(i==nr_date_valide+nr_date_invalide) begin
data<=$urandom_range(0,5);
val<=1;
nr_date_valide<=$urandom_range(3,5);
nr_date_invalide<=$urandom_range(1,3);
i=1;
end
end

endmodule

module prod_tb();

reg clk;
reg rst_b;
wire val;
wire [7:0]data;

prod DUT_PROD(.clk(clk), .rst_b(rst_b), .val(val), .data(data));

initial begin
clk=1'b0;
repeat (80) #(50) clk=~clk;
end

initial begin
rst_b=1;
#25;
rst_b=0;
#25;
rst_b=1;
end

endmodule
