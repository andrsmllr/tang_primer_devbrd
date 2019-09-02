create_clock -name refclk -period 3.76 [get_pins {oc_osc_inst/inst.osc_clk}]

create_generated_clock -name clk_266 -source [get_pins {oc_osc_inst/inst.osc_clk}] -divide_by 1 [get_pins {ip_pll_inst/pll_inst.clkc[0]}]
create_generated_clock -name clk_133 -source [get_pins {oc_osc_inst/inst.osc_clk}] -divide_by 2 [get_pins {ip_pll_inst/pll_inst.clkc[1]}]
create_generated_clock -name clk_66 -source [get_pins {oc_osc_inst/inst.osc_clk}] -divide_by 4 [get_pins {ip_pll_inst/pll_inst.clkc[2]}]
create_generated_clock -name clk_33 -source [get_pins {oc_osc_inst/inst.osc_clk}] -divide_by 8 [get_pins {ip_pll_inst/pll_inst.clkc[3]}]
create_generated_clock -name clk_16 -source [get_pins {oc_osc_inst/inst.osc_clk}] -divide_by 16 [get_pins {ip_pll_inst/pll_inst.clkc[4]}]
