module ocmult #(
  parameter OPWIDTH = 18
) (
  input wire                  clk_i,
  input wire                  rst_i,
  input wire                  ce_i,
  input wire  [OPWIDTH-1:0]   opa_i,
  input wire  [OPWIDTH-1:0]   opb_i,
  output wire [2*OPWIDTH-1:0] prod_o
);

reg [OPWIDTH-1:0]   opa, opb;
reg [2*OPWIDTH-1:0] prod;
always @ (posedge clk_i)
begin
  if (rst_i == 1'b1) begin
    prod <= 'd0;
  end else if (ce_i == 1'b1) begin
    opa <= opa_i;
    opb <= opb_i;
    prod <= opa * opb;
  end
end

assign prod_o = prod;

endmodule
