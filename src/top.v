module top(
  input  wire       clk_i,
  input  wire       rst_i,
  output wire       led1_o,
  output wire       led2_o,
  output wire       led3_o,
  output wire       led4_o,
  output wire       led5_o,
  input  wire [3:0] opa_i,
  input  wire [3:0] opb_i,
  output reg  [7:0] prod_o
);

/*
 * Generate clocks (IP).
 */
localparam integer F_CLK_266 = 266666666;
localparam integer F_CLK_133 = 133333333;
localparam integer F_CLK_66  = 66666666;
localparam integer F_CLK_33  = 33333333;
localparam integer F_CLK_16  = 16666666;

wire clk_266_ref;
oc_osc oc_osc_inst(
  .osc_dis(1'b0),
  .osc_clk(clk_266_ref)
);

wire clk_266, clk_133, clk_66, clk_33, clk_16;
wire pll_rst = 1'b0;
wire pll_lock;
ip_pll ip_pll_inst (
  .refclk(clk_266_ref),
  .reset(pll_rst),
  .extlock(pll_lock),
  .clk0_out(clk_266),
  .clk1_out(clk_133),
  .clk2_out(clk_66),
  .clk3_out(clk_33),
  .clk4_out(clk_16)
);

// Dummy logic to keep clocks, otherwise clocks get optimized away and SDC constraints cause failure.
reg led3;
always @ (posedge clk_33)
  led3 <= ~led3;
assign led3_o = led3;

reg led4;
always @ (posedge clk_16)
  led4 <= ~led4;  
assign led4_o = led4;

/*
 * Blink LED using clk_133.
 */
reg [31:0] cnt1;
reg strb1;
always @ (posedge clk_133)
begin
  if (rst_i == 1'b1) begin
  	cnt1 <= F_CLK_133;
  	strb1 <= 1'b0;
  end else begin
  	cnt1 <= cnt1 - 1;
  	strb1 <= 1'b0;
  	if (cnt1 == 0) begin
      cnt1 <= F_CLK_133;
      strb1 <= 1'b1;
    end
  end
end

reg led1;
always @ (posedge clk_133)
begin
  if (strb1 == 1'b1)
  	led1 <= ~led1;
end

assign led1_o = led1;

/*
 * Blink LED using clk_66.
 */
reg [31:0] cnt2;
reg strb2;
always @ (posedge clk_66)
begin
  if (rst_i == 1'b1) begin
  	cnt2 <= F_CLK_66;
  	strb2 <= 1'b0;
  end else begin
  	cnt2 <= cnt2 - 1;
  	strb2 <= 1'b0;
  	if (cnt2 == 0) begin
      cnt2 <= F_CLK_66;
      strb2 <= 1'b1;
    end
  end
end

reg led2;
always @ (posedge clk_66)
begin
  if (strb2 == 1'b1)
  	led2 <= ~led2;
end

assign led2_o = led2;

/*
 * Use DSP multiplier (IP).
 */
wire        dsp_clk = clk_133;
reg  [17:0] dsp_opa, dsp_opb;
wire [36:0] dsp_prod;
oc_dsp oc_dsp_inst(  
  .clk(dsp_clk),
  .rstan(1'b1),
  .rstbn(1'b1),
  .rstpdn(1'b1),
  .cea(1'b1),
  .ceb(1'b1),
  .cepd(1'b1),
  .a(dsp_opb),
  .b(dsp_opa),
  .p(dsp_prod)
);

always @ (posedge dsp_clk)
begin
  dsp_opa <= opa_i;
  dsp_opb <= opb_i;
  prod_o <= dsp_prod;
end

/*
 * Use on-chip BRAM (IP).
 */
localparam BRAM_AWIDTH = 10;
localparam BRAM_DWIDTH = 16;
wire                   bram_clk = clk_133;
reg                    bram_wea = 0;
reg  [BRAM_AWIDTH-1:0] bram_addra = 0;
reg  [BRAM_DWIDTH-1:0] bram_dia = 0;
wire [BRAM_DWIDTH-1:0] bram_doa;
bram bram_inst(
  .clka(bram_clk),
  .rsta(1'b0),
  .cea(1'b1),
  .wea(bram_wea),
  .addra(bram_addra),
  .dia(bram_dia),
  .doa(bram_doa)
);

always @ (posedge bram_clk)
begin
  bram_wea <= 1'b1;
  bram_addra <= bram_addra + 1;
  bram_dia <= bram_dia + 1;
end

assign led5_o = bram_doa[0];

/*
 * Use FIFO (IP).
 */
wire fifo_clk = clk_133;
reg  [31:0] fifo_di;
wire [31:0] fifo_do;
wire fifo_full;
wire fifo_empty;
wire fifo_we = !fifo_full;
wire fifo_re = !fifo_empty;

ip_fifo ip_fifo_inst(
  .rst(1'b0),
  .clkw(fifo_clk),
  .we(1'b1),
  .di(fifo_di),
  .full_flag(fifo_full),
  .afull_flag(),
  .clkr(fifo_clk),
  .re(1'b1),
  .do(fifo_do),
  .empty_flag(fifo_empty),
  .aempty_flag()
);

always @ (posedge fifo_clk)
begin
  fifo_di <= fifo_do ^ 32'h1234;
end

/*
 * Controller for on-chip SDRAM.
 */

wire        sdram_clk = clk_133;
wire        sdram_rst_n = !rst_i;
reg         sdram_valid;
wire        sdram_ready;
reg  [3:0]  sdram_wstrb;
reg  [31:0] sdram_addr;
reg  [31:0] sdram_wdata;
wire [31:0] sdram_rdata;

sys_sdram sdram_ctl_inst (
  .clk(sdram_clk),
  .rst_n(sdram_rst_n),
  .i_valid(sdram_valid),
  .o_ready(sdram_ready),
  .i_addr(sdram_addr),
  .i_wdata(sdram_wdata),
  .i_wstrb(sdram_wstrb),
  .o_rdata(sdram_rdata)
);

/*
 * Use on-chip ADC (IP).
 */
wire adc_clk = clk_16;
wire adc_s = 1'b0;
wire adc_pd = 1'b0;
wire adc_eoc;
wire adc_soc = !adc_eoc;
wire [11:0] adc_dout;
oc_adc oc_adc_inst(
  .clk(adc_clk),
  .s(adc_s),
  .pd(adc_pd),
  .soc(adc_soc),
  .eoc(adc_eoc),
  .dout(adc_dout)
);

/*
 * Use on-chip power monitoring (primitive).
 */
wire powermon_pwd_dwn_n;
EG_PHY_PWRMNT #(
  .MNT_LVL(5) //1-7 1:1.86v 2:2.00v 3:2.17v 4:2.36v 5:2.60v 6:2.89v 7:3.25v
) pwrmnt_inst (
  .sel_pwr(1'b0),
  .pwr_mnt_pd(1'b0),
  .pwr_dwn_n(powermon_pwd_dwn_n)
);

/*
 * Use on-chip device identifier "DNA" (primitive).
 */
wire dna;
EG_LOGIC_DNA dna_inst(
  .clk(clk_16),
  .shift_en(1'b1),
  .dout(dna),
  .din()
);

endmodule
