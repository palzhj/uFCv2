`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    11:09:49 06/18/2017
// Design Name:
// Module Name:    top
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module top
#(
  parameter         USE_CHIPSCOPE = 0,
  parameter [31:0]  SYN_DATE      = 32'h1911_0100, // the date of compiling
  parameter [7:0]   FPGA_VER      = 8'h00,         // the code version
  parameter [31:0]  BASE_IP_ADDR  = 32'hC0A8_0A10  // 192.168.10.16
)(
// System
  input           RST_B,          // from S7
  input           REFCLK_P,       // 200MHz
  input           REFCLK_N,
  inout           SRCC_P,         // from/to the cross-point switch, 156.25MHz
  inout           SRCC_N,
  inout   [6 : 0] MRCC_P,         
  inout   [6 : 0] MRCC_N, 
  // MRCC0: PLL
  // MRCC1: WR 125MHz
  // MRCC2: WR 20MHz 
  // MRCC3: S7 250MHz
  // MRCC4: S7 
  // MRCC5: S7
  // MRCC6: S7 
  input           LEMO_CLK_IN_P,  // front pannel
  input           LEMO_CLK_IN_N,
//  I/O
  input   [7 : 0] DIPSW,          // DIPSW[7:0]
  inout   [3 : 0] TESTPIN,        // Test Pin
  output  [2 : 0] SYSLED,         // LEDC(Green), LEDB(Blue), LEDA(Red)
  inout   [9 : 0] IO_P,           // user-defined io from/to S7
  inout   [9 : 0] IO_N,
// LEMO interface
  input           LEMO_IN,        // front pannel
  inout   [1 : 0] LEMO_INOUT,     // rear pannel
  output  [1 : 0] LEMO_INOUT_DE,  // High for output
// IIC
  inout           FPGA_SCL,       // I2C
  inout           FPGA_SDA,
// FLASH Interface
  // output          FLASH_CLK,
  // inout   [3 : 0] FLASH_D,
  // output          FLASH_CS_B,
// DAC
  output          DAC_CLK,        // WR DAC
  output          DAC_MOSI,
  output  [1 : 0] DAC_NCS,
// FMC0
  input           FMC0_PRSNT_B,   // active low
  inout   [33: 0] FMC0_LA_P,
  inout   [33: 0] FMC0_LA_N,
  inout   [23: 0] FMC0_HA_P,
  inout   [23: 0] FMC0_HA_N,
  input   [3 : 0] FMC0_DP_M2C_P,
  input   [3 : 0] FMC0_DP_M2C_N,
  output  [3 : 0] FMC0_DP_C2M_P,
  output  [3 : 0] FMC0_DP_C2M_N,
  input           MGTCLK118_P0,   // Reference Clock: 156.25MHz
  input           MGTCLK118_N0,
  input           MGTCLK118_P1,   // Reference Clock
  input           MGTCLK118_N1,
// FMC1
  input           FMC1_PRSNT_B,
  inout   [33: 0] FMC1_LA_P,
  inout   [33: 0] FMC1_LA_N,
  inout   [23: 0] FMC1_HA_P,
  inout   [23: 0] FMC1_HA_N,
  input   [3 : 0] FMC1_DP_M2C_P,
  input   [3 : 0] FMC1_DP_M2C_N,
  output  [3 : 0] FMC1_DP_C2M_P,
  output  [3 : 0] FMC1_DP_C2M_N,
  input           MGTCLK116_P0,   // Reference Clock: 156.25MHz
  input           MGTCLK116_N0,
  input           MGTCLK116_P1,   // Reference Clock
  input           MGTCLK116_N1,
// DDR3
  output  [1 : 0] DDR3_CLK_P,
  output  [1 : 0] DDR3_CLK_N,
  output  [1 : 0] DDR3_CKE,
  output  [1 : 0] DDR3_S,
  output  [1 : 0] DDR3_ODT,
  output  [15: 0] DDR3_ADDR,
  output  [2 : 0] DDR3_BA,
  output          DDR3_CAS_B,
  output          DDR3_RAS_B,
  output          DDR3_WE_B,
  output          DDR3_RESET_B,
  input           DDR3_TEMP_EVENT,
  inout   [63: 0] DDR3_D,
  inout   [7 : 0] DDR3_DQS_P,
  inout   [7 : 0] DDR3_DQS_N,
  output  [7 : 0] DDR3_DM,
// SFP
  output  [1 : 0] SFP_TX_P,
  output  [1 : 0] SFP_TX_N,
  input   [1 : 0] SFP_RX_P,
  input   [1 : 0] SFP_RX_N,
  input   [1 : 0] SFP_RX_LOS,
  input   [1 : 0] SFP_DETECT,
  input           MGTCLK117_P0,   // Reference Clock, 156.25MHz
  input           MGTCLK117_N0,
  input           MGTCLK117_P1,   // Reference Clock, 125MHz
  input           MGTCLK117_N1,
// AMC Rocket IO
  output          AMC_TX_P0,      // AMC P0 Eth Bank 117
  output          AMC_TX_N0,
  input           AMC_RX_P0,
  input           AMC_RX_N0,
  output          AMC_TX_P1,      // AMC P1 Eth Bank 117
  output          AMC_TX_N1,
  input           AMC_RX_P1,
  input           AMC_RX_N1,
  output          AMC_TX_P4,      // AMC P4-7 PCIe Bank 115
  output          AMC_TX_N4,
  input           AMC_RX_P4,
  input           AMC_RX_N4,
  output          AMC_TX_P5,      // AMC P4-7 PCIe Bank 115
  output          AMC_TX_N5,
  input           AMC_RX_P5,
  input           AMC_RX_N5,
  output          AMC_TX_P6,      // AMC P4-7 PCIe Bank 115
  output          AMC_TX_N6,
  input           AMC_RX_P6,
  input           AMC_RX_N6,
  output          AMC_TX_P7,      // AMC P4-7 PCIe Bank 115
  output          AMC_TX_N7,
  input           AMC_RX_P7,
  input           AMC_RX_N7,
  output          AMC_TX_P12,       // AMC P12-15 LVDS
  output          AMC_TX_N12,
  input           AMC_RX_P12,
  input           AMC_RX_N12,
  output          AMC_TX_P13,       // AMC P12-15 LVDS
  output          AMC_TX_N13,
  input           AMC_RX_P13,
  input           AMC_RX_N13,
  output          AMC_TX_P14,       // AMC P12-15 LVDS
  output          AMC_TX_N14,
  input           AMC_RX_P14,
  input           AMC_RX_N14,
  output          AMC_TX_P15,       // AMC P12-15 LVDS
  output          AMC_TX_N15,
  input           AMC_RX_P15,
  input           AMC_RX_N15,
  input           MGTCLK115_P0,   // Reference Clock: 100MHz
  input           MGTCLK115_N0,
  input           MGTCLK115_P1,   // Reference Clock
  input           MGTCLK115_N1
);

wire rst;
assign rst = ~RST_B;

wire clk200;
IBUFDS #(
  .DIFF_TERM    ("TRUE"),       // Differential Termination
  .IBUF_LOW_PWR ("FALSE"),      // Low power="TRUE", Highest performance="FALSE"
  .IOSTANDARD   ("LVDS_25")     // Specify the input I/O standard
) IBUFGDS_clk200 (
  .O            (clk200),       // Buffer output
  .I            (REFCLK_P),     // Diff_p buffer input (connect directly to top-level port)
  .IB           (REFCLK_N)      // Diff_n buffer input (connect directly to top-level port)
);

wire clkpll;
IBUFDS #(
  .DIFF_TERM    ("TRUE"),       // Differential Termination
  .IBUF_LOW_PWR ("FALSE"),      // Low power="TRUE", Highest performance="FALSE"
  .IOSTANDARD   ("LVDS_25")     // Specify the input I/O standard
) IBUFGDS_clkpll (
  .O            (clkpll),       // Buffer output
  .I            (MRCC_P[0]),    // Diff_p buffer input (connect directly to top-level port)
  .IB           (MRCC_N[0])     // Diff_n buffer input (connect directly to top-level port)
);

wire clk125_wr;
IBUFDS #(
  .DIFF_TERM    ("TRUE"),       // Differential Termination
  .IBUF_LOW_PWR ("FALSE"),      // Low power="TRUE", Highest performance="FALSE"
  .IOSTANDARD   ("LVDS_25")     // Specify the input I/O standard
) IBUFGDS_clk125_wr (
  .O            (clk125_wr),    // Buffer output
  .I            (MRCC_P[1]),    // Diff_p buffer input (connect directly to top-level port)
  .IB           (MRCC_N[1])     // Diff_n buffer input (connect directly to top-level port)
);

wire clk20_wr;
IBUFDS #(
  .DIFF_TERM    ("TRUE"),       // Differential Termination
  .IBUF_LOW_PWR ("FALSE"),      // Low power="TRUE", Highest performance="FALSE"
  .IOSTANDARD   ("LVDS_25")     // Specify the input I/O standard
) IBUFGDS_clk20_wr (
  .O            (clk20_wr),     // Buffer output
  .I            (MRCC_P[2]),    // Diff_p buffer input (connect directly to top-level port)
  .IB           (MRCC_N[2])     // Diff_n buffer input (connect directly to top-level port)
);

wire clkddr_in, clkddr;
IBUFDS #(
  .DIFF_TERM    ("TRUE"),       // Differential Termination
  .IBUF_LOW_PWR ("FALSE"),      // Low power="TRUE", Highest performance="FALSE"
  .IOSTANDARD   ("LVDS_25")     // Specify the input I/O standard
) IBUFGDS_clkddr (
  .O            (clkddr_in),     // Buffer output
  .I            (MRCC_P[3]),    // Diff_p buffer input (connect directly to top-level port)
  .IB           (MRCC_N[3])     // Diff_n buffer input (connect directly to top-level port)
);

BUFG BUFG_ddr (
  .O(clkddr), // 1-bit output: Clock output
  .I(clkddr_in)  // 1-bit input: Clock input
);

OBUFDS #(
  .IOSTANDARD("LVDS_25"),       // Specify the output I/O standard
  .SLEW("FAST")                 // Specify the output slew rate
) OBUFDS_clks7_1 (
  .O(MRCC_P[4]),                // Diff_p output (connect directly to top-level port)
  .OB(MRCC_N[4]),               // Diff_n output (connect directly to top-level port)
  .I(clkpll)                    // Buffer input
);

OBUFDS #(
  .IOSTANDARD("LVDS_25"),       // Specify the output I/O standard
  .SLEW("FAST")                 // Specify the output slew rate
) OBUFDS_clks7_2 (
  .O(MRCC_P[5]),                // Diff_p output (connect directly to top-level port)
  .OB(MRCC_N[5]),               // Diff_n output (connect directly to top-level port)
  .I(clk125_wr)                 // Buffer input
);

OBUFDS #(
  .IOSTANDARD("LVDS_25"),       // Specify the output I/O standard
  .SLEW("FAST")                 // Specify the output slew rate
) OBUFDS_clks7_3 (
  .O(MRCC_P[6]),                // Diff_p output (connect directly to top-level port)
  .OB(MRCC_N[6]),               // Diff_n output (connect directly to top-level port)
  .I(clk20_wr)                  // Buffer input
);

wire clklemo;
IBUFDS #(
  .DIFF_TERM    ("TRUE"),       // Differential Termination
  .IBUF_LOW_PWR ("FALSE"),      // Low power="TRUE", Highest performance="FALSE"
  .IOSTANDARD   ("LVDS_25")     // Specify the input I/O standard
) IBUFGDS_clklemo (
  .O            (clklemo),      // Buffer output
  .I            (LEMO_CLK_IN_P),   // Diff_p buffer input (connect directly to top-level port)
  .IB           (LEMO_CLK_IN_N)    // Diff_n buffer input (connect directly to top-level port)
);

reg [33:0] cnt;
always @(posedge clkpll) cnt <= cnt + 1'b1;

assign TESTPIN = DIPSW[3:0];

// assign SYSLED[0] = cnt[24];
// assign SYSLED[1] = DIPSW[4];
// assign SYSLED[2] = DIPSW[6];

genvar j;

generate
wire  [9 : 0] s7_in;
for (j=0;j<=9;j=j+1) begin : s7_in_gen
  IBUFDS #(
    .DIFF_TERM("TRUE"),        // Differential Termination
    .IBUF_LOW_PWR("TRUE"),     // Low power="TRUE", Highest performance="FALSE"
    .IOSTANDARD("LVDS_25")     // Specify the input I/O standard
  ) IBUFDS_fmc0_in (
    .O(s7_in[j]),     // Buffer output
    .I(IO_P[j]),      // Diff_p buffer input (connect directly to top-level port)
    .IB(IO_N[j])      // Diff_n buffer input (connect directly to top-level port)
  );
end
endgenerate

// DDR3L
example_top ddr_test (
  .ddr3_dq            (DDR3_D[63:0]),
  .ddr3_dqs_n         (DDR3_DQS_N[7:0]),
  .ddr3_dqs_p         (DDR3_DQS_P[7:0]),
  .ddr3_addr          (DDR3_ADDR[15:0]),
  .ddr3_ba            (DDR3_BA[2:0]),
  .ddr3_ras_n         (DDR3_RAS_N),
  .ddr3_cas_n         (DDR3_CAS_N),
  .ddr3_we_n          (DDR3_WE_N),
  .ddr3_reset_n       (DDR3_RESET_B),
  .ddr3_ck_p          (DDR3_CLK_P[1:0]),
  .ddr3_ck_n          (DDR3_CLK_N[1:0]),
  .ddr3_cke           (DDR3_CKE[1:0]),
  .ddr3_cs_n          (DDR3_S[1:0]),
  .ddr3_dm            (DDR3_DM[7:0]),
  .ddr3_odt           (DDR3_ODT[1:0]),
  .sys_clk_i          (clkddr),
  .clk_ref_i          (clk200),
  .tg_compare_error   (SYSLED[1]),
  .init_calib_complete(SYSLED[2]),
  .sys_rst            (rst)
);

////////////////////////////////////////////////////////////////////////////////
// FMC test


generate
wire [23:0] fmc0_temp_in, fmc0_temp_out;
for (j=0;j<=23;j=j+1) begin : fmc0_in_gen
  IBUFDS #(
    .DIFF_TERM("TRUE"),       // Differential Termination
    .IBUF_LOW_PWR("TRUE"),     // Low power="TRUE", Highest performance="FALSE"
    .IOSTANDARD("LVDS_25")     // Specify the input I/O standard
  ) IBUFDS_fmc0_in (
    .O(fmc0_temp_in[j]),  // Buffer output
    .I(FMC0_HA_P[j]),  // Diff_p buffer input (connect directly to top-level port)
    .IB(FMC0_HA_N[j]) // Diff_n buffer input (connect directly to top-level port)
  );
  assign fmc0_temp_out[j] = (FMC0_PRSNT_B|DIPSW[5]) ? 1'b0: fmc0_temp_in[j];
  OBUFDS #(
    .IOSTANDARD("LVDS_25"), // Specify the output I/O standard
    .SLEW("FAST")           // Specify the output slew rate
  ) OBUFDS_fmc0_out (
    .O(FMC0_LA_P[j]),     // Diff_p output (connect directly to top-level port)
    .OB(FMC0_LA_N[j]),   // Diff_n output (connect directly to top-level port)
    .I(fmc0_temp_out[j])      // Buffer input
  );
end

for (j=24;j<=33;j=j+1) begin : fmc0_out1_gen
  OBUFDS #(
    .IOSTANDARD("LVDS_25"), // Specify the output I/O standard
    .SLEW("FAST")           // Specify the output slew rate
  ) OBUFDS_fmc0_out_high (
    .O(FMC0_LA_P[j]),     // Diff_p output (connect directly to top-level port)
    .OB(FMC0_LA_N[j]),   // Diff_n output (connect directly to top-level port)
    .I(cnt[j])      // Buffer input
  );
end

wire [23:0] fmc1_temp_in, fmc1_temp_out;
for (j=0;j<=23;j=j+1) begin : fmc1_in_gen
  IBUFDS #(
    .DIFF_TERM("TRUE"),       // Differential Termination
    .IBUF_LOW_PWR("TRUE"),     // Low power="TRUE", Highest performance="FALSE"
    .IOSTANDARD("LVDS_25")     // Specify the input I/O standard
  ) IBUFDS_fmc1_in (
    .O(fmc1_temp_in[j]),  // Buffer output
    .I(FMC1_HA_P[j]),  // Diff_p buffer input (connect directly to top-level port)
    .IB(FMC1_HA_N[j]) // Diff_n buffer input (connect directly to top-level port)
  );
  assign fmc1_temp_out[j] = (FMC1_PRSNT_B|DIPSW[7]) ? 1'b0: fmc1_temp_in[j];
  OBUFDS #(
    .IOSTANDARD("LVDS_25"), // Specify the output I/O standard
    .SLEW("FAST")           // Specify the output slew rate
  ) OBUFDS_fmc1_out (
    .O(FMC1_LA_P[j]),     // Diff_p output (connect directly to top-level port)
    .OB(FMC1_LA_N[j]),   // Diff_n output (connect directly to top-level port)
    .I(fmc1_temp_out[j])      // Buffer input
  );

end
for (j=24;j<=33;j=j+1) begin : fmc1_out1_gen
  OBUFDS #(
    .IOSTANDARD("LVDS_25"), // Specify the output I/O standard
    .SLEW("FAST")           // Specify the output slew rate
  ) OBUFDS_fmc1_out_high (
    .O(FMC1_LA_P[j]),     // Diff_p output (connect directly to top-level port)
    .OB(FMC1_LA_N[j]),   // Diff_n output (connect directly to top-level port)
    .I(cnt[j])      // Buffer input
  );
end

endgenerate

wire  [15:0] txp_o, txn_o, rxp_i, rxn_i;
wire  [3 :0] gtrefclk0p_i, gtrefclk0n_i, gtrefclk1p_i, gtrefclk1n_i;

assign txp_o = {FMC0_DP_C2M_P[3:0], SFP_TX_P[1:0], AMC_TX_P1, AMC_TX_P0, 
          FMC1_DP_C2M_P[3:0], AMC_TX_P7, AMC_TX_P6, AMC_TX_P5, AMC_TX_P4};
assign txn_o = {FMC0_DP_C2M_N[3:0], SFP_TX_N[1:0], AMC_TX_N1, AMC_TX_N0, 
          FMC1_DP_C2M_N[3:0], AMC_TX_N7, AMC_TX_N6, AMC_TX_N5, AMC_TX_N4};

assign rxp_i = {FMC0_DP_M2C_P[3:0], SFP_RX_P[1:0], AMC_RX_P1, AMC_RX_P0, 
          FMC1_DP_M2C_P[3:0], AMC_RX_P7, AMC_RX_P6, AMC_RX_P5, AMC_RX_P4};
assign rxn_i = {FMC0_DP_M2C_N[3:0], SFP_RX_N[1:0], AMC_RX_N1, AMC_RX_N0, 
          FMC1_DP_M2C_N[3:0], AMC_RX_N7, AMC_RX_N6, AMC_RX_N5, AMC_RX_N4};

assign gtrefclk0p_i = {MGTCLK118_P0, MGTCLK117_P0, MGTCLK116_P0, MGTCLK115_P0};
assign gtrefclk0n_i = {MGTCLK118_N0, MGTCLK117_N0, MGTCLK116_N0, MGTCLK115_N0};

assign gtrefclk1p_i = {MGTCLK118_P1, MGTCLK117_P1, MGTCLK116_P1, MGTCLK115_P1};
assign gtrefclk1n_i = {MGTCLK118_N1, MGTCLK117_N1, MGTCLK116_N1, MGTCLK115_N1};

example_ibert_7series_gtx_0 example_ibert_7series_gtx_0
(
  // GT top level ports
  .SYSCLKP_I    (SRCC_P),
  .SYSCLKN_I    (SRCC_N),
  .TXP_O        (txp_o),
  .TXN_O        (txn_o),
  .RXP_I        (rxp_i),
  .RXN_I        (rxn_i),
  .GTREFCLK0P_I (gtrefclk0p_i),
  .GTREFCLK0N_I (gtrefclk0n_i),
  .GTREFCLK1P_I (gtrefclk1p_i),
  .GTREFCLK1N_I (gtrefclk1n_i)
);

assign SYSLED[0] = SFP_RX_LOS[0] | SFP_RX_LOS[1] & SFP_DETECT[0] & SFP_DETECT[1];

////////////////////////////////////////////////////////////////////////////////
// AMC

wire [15:12] amc_lvds;

IBUFDS #(
  .DIFF_TERM("TRUE"),       // Differential Termination
  .IBUF_LOW_PWR("TRUE"),     // Low power="TRUE", Highest performance="FALSE"
  .IOSTANDARD("LVDS_25")     // Specify the input I/O standard
) IBUFDS_amc_lvds_in12 (
  .O(amc_lvds[12]),  // Buffer output
  .I(AMC_RX_P12),  // Diff_p buffer input (connect directly to top-level port)
  .IB(AMC_RX_N12) // Diff_n buffer input (connect directly to top-level port)
);
OBUFDS #(
  .IOSTANDARD("LVDS_25"), // Specify the output I/O standard
  .SLEW("FAST")           // Specify the output slew rate
) OBUFDS_amc_lvds_out12 (
  .O(AMC_TX_P12),     // Diff_p output (connect directly to top-level port)
  .OB(AMC_TX_N12),   // Diff_n output (connect directly to top-level port)
  .I(amc_lvds[12])      // Buffer input
);

IBUFDS #(
  .DIFF_TERM("TRUE"),       // Differential Termination
  .IBUF_LOW_PWR("TRUE"),     // Low power="TRUE", Highest performance="FALSE"
  .IOSTANDARD("LVDS_25")     // Specify the input I/O standard
) IBUFDS_amc_lvds_in13 (
  .O(amc_lvds[13]),  // Buffer output
  .I(AMC_RX_P13),  // Diff_p buffer input (connect directly to top-level port)
  .IB(AMC_RX_N13) // Diff_n buffer input (connect directly to top-level port)
);
OBUFDS #(
  .IOSTANDARD("LVDS_25"), // Specify the output I/O standard
  .SLEW("FAST")           // Specify the output slew rate
) OBUFDS_amc_lvds_out13 (
  .O(AMC_TX_P13),     // Diff_p output (connect directly to top-level port)
  .OB(AMC_TX_N13),   // Diff_n output (connect directly to top-level port)
  .I(amc_lvds[13])      // Buffer input
);

IBUFDS #(
  .DIFF_TERM("TRUE"),       // Differential Termination
  .IBUF_LOW_PWR("TRUE"),     // Low power="TRUE", Highest performance="FALSE"
  .IOSTANDARD("LVDS_25")     // Specify the input I/O standard
) IBUFDS_amc_lvds_in14 (
  .O(amc_lvds[14]),  // Buffer output
  .I(AMC_RX_P14),  // Diff_p buffer input (connect directly to top-level port)
  .IB(AMC_RX_N14) // Diff_n buffer input (connect directly to top-level port)
);
OBUFDS #(
  .IOSTANDARD("LVDS_25"), // Specify the output I/O standard
  .SLEW("FAST")           // Specify the output slew rate
) OBUFDS_amc_lvds_out14 (
  .O(AMC_TX_P14),     // Diff_p output (connect directly to top-level port)
  .OB(AMC_TX_N14),   // Diff_n output (connect directly to top-level port)
  .I(amc_lvds[14])      // Buffer input
);

IBUFDS #(
  .DIFF_TERM("TRUE"),       // Differential Termination
  .IBUF_LOW_PWR("TRUE"),     // Low power="TRUE", Highest performance="FALSE"
  .IOSTANDARD("LVDS_25")     // Specify the input I/O standard
) IBUFDS_amc_lvds_in15 (
  .O(amc_lvds[15]),  // Buffer output
  .I(AMC_RX_P15),  // Diff_p buffer input (connect directly to top-level port)
  .IB(AMC_RX_N15) // Diff_n buffer input (connect directly to top-level port)
);
OBUFDS #(
  .IOSTANDARD("LVDS_25"), // Specify the output I/O standard
  .SLEW("FAST")           // Specify the output slew rate
) OBUFDS_amc_lvds_out15 (
  .O(AMC_TX_P15),     // Diff_p output (connect directly to top-level port)
  .OB(AMC_TX_N15),   // Diff_n output (connect directly to top-level port)
  .I(amc_lvds[15])      // Buffer input
);

////////////////////////////////////////////////////////////////////////////////

endmodule
