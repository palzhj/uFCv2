`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    11:09:49 11/02/2019
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
module top_S7
#(
  parameter         USE_CHIPSCOPE = 0,
  parameter [31:0]  SYN_DATE      = 32'h1911_0100, // the date of compiling
  parameter [7:0]   FPGA_VER      = 8'h00,         // the code version
  parameter [31:0]  BASE_IP_ADDR  = 32'hC0A8_0A10  // 192.168.10.16
)(
//  I/O
  input   [7 : 0] DIPSW,          // DIPSW[7:0]
  inout   [3 : 0] TESTPIN,        // Test Pin
  output  [2 : 0] SYSLED,         // LEDC(Green), LEDB(Blue), LEDA(Red)
// CLK
  inout           CLK_INOUT_P,    // from/to the cross-point switch
  inout           CLK_INOUT_N,
  input   [1 : 0] CLK_IN_P,
  input   [1 : 0] CLK_IN_N,
  // CLK_IN0: PLL
  // CLK_IN1: WR 125MHz
  output  [3 : 0] CLK_OUT_P,
  output  [3 : 0] CLK_OUT_N,
  input           FMC0_GTXCLK_M2C_P,
  input           FMC0_GTXCLK_M2C_N,
  input           FMC1_GTXCLK_M2C_P,
  input           FMC1_GTXCLK_M2C_N,
  input           FMC0_CLK_M2C_P,
  input           FMC0_CLK_M2C_N,
  input           FMC1_CLK_M2C_P,
  input           FMC1_CLK_M2C_N,
  output          FMC0_CLK_C2M_P,
  output          FMC0_CLK_C2M_N,
  output          FMC1_CLK_C2M_P,
  output          FMC1_CLK_C2M_N,
  output  [2 : 0] FPGA_GTXCLK_P,
  output  [2 : 0] FPGA_GTXCLK_N,
// IIC
  inout           FPGA_SCL,       // I2C
  inout           FPGA_SDA,
// FPGA interface
  input           FPGA_RST_B,     // from MCU
  input           FPGA_PROG_B,    
  output          FPGA_DONE,
  output          FPGA_INIT_B,
  output          FPGA_RST_B_K7,  // to FPGA K7
  output          FPGA_PROG_B_K7,
  input           FPGA_DONE_K7,
  input           FPGA_INIT_B_K7,
  inout   [9 : 0] IO_P,           // user-defined io from/to K7
  inout   [9 : 0] IO_N,
// FLASH Interface
  // output          FLASH_CLK,
  // inout   [3 : 0] FLASH_D,
  // output          FLASH_CS_B,

// MCU interface
  input           MCU_CLK,
  input           MCU_SPI1_SCK,
  input           MCU_SPI1_NSS,
  input           MCU_SPI1_MOSI,
  output          MCU_SPI1_MISO,
  input           MCU_SPI2_SCK,
  input           MCU_SPI2_NSS,
  input           MCU_SPI2_MOSI,
  output          MCU_SPI2_MISO,   
  input           MCU_UART_TX,
  output          MCU_UART_RX,
// AMC interface
  output  [20:17] AMC_TX,
  input   [20:17] AMC_RX,
  output  [20:17] AMC_TX_DE,
  output  [20:17] AMC_RX_DE,
// JTAG
  // AMC
  input           AMC_TCK,
  input           AMC_TMS,
  input           AMC_TDI,
  output          AMC_TDO,
  input           AMC_TRST_B,
  // Connector
  input           CON_TCK,
  input           CON_TMS,
  input           CON_TDI,
  output          CON_TDO,
  // FMC0
  input           FMC0_PRSNT_B,   // active low
  output          FMC0_PRSNT_B_L,
  output          FMC0_TCK,
  output          FMC0_TMS,
  output          FMC0_TDI,
  input           FMC0_TDO,
  // FMC1
  input           FMC1_PRSNT_B,   // active low
  output          FMC1_PRSNT_B_L,
  output          FMC1_TCK,
  output          FMC1_TMS,
  output          FMC1_TDI,
  input           FMC1_TDO,
  // FPGA
  output          FPGA_TCK,
  output          FPGA_TMS,
  output          FPGA_TDI,
  input           FPGA_TDO
);

wire rst;
assign rst = ~FPGA_PROG_B;

wire clk100_in, clk100;
IBUFDS #(
  .DIFF_TERM    ("TRUE"),       // Differential Termination
  .IBUF_LOW_PWR ("FALSE"),      // Low power="TRUE", Highest performance="FALSE"
  .IOSTANDARD   ("LVDS_25")     // Specify the input I/O standard
) IBUFGDS_clk100 (
  .O            (clk100_in),    // Buffer output
  .I            (CLK_INOUT_P),    // Diff_p buffer input (connect directly to top-level port)
  .IB           (CLK_INOUT_N)     // Diff_n buffer input (connect directly to top-level port)
);

BUFG BUFG_clk100 (
  .O(clk100), // 1-bit output: Clock output
  .I(clk100_in)  // 1-bit input: Clock input
);

wire clkpll_in, clkpll;
IBUFDS #(
  .DIFF_TERM    ("TRUE"),       // Differential Termination
  .IBUF_LOW_PWR ("FALSE"),      // Low power="TRUE", Highest performance="FALSE"
  .IOSTANDARD   ("LVDS_25")     // Specify the input I/O standard
) IBUFGDS_clkpll (
  .O            (clkpll_in),       // Buffer output
  .I            (CLK_IN_P[0]),    // Diff_p buffer input (connect directly to top-level port)
  .IB           (CLK_IN_N[0])     // Diff_n buffer input (connect directly to top-level port)
);

BUFG BUFG_clkpll (
  .O(clkpll), // 1-bit output: Clock output
  .I(clkpll_in)  // 1-bit input: Clock input
);

wire clk125_in, clk125;
IBUFDS #(
  .DIFF_TERM    ("TRUE"),       // Differential Termination
  .IBUF_LOW_PWR ("FALSE"),      // Low power="TRUE", Highest performance="FALSE"
  .IOSTANDARD   ("LVDS_25")     // Specify the input I/O standard
) IBUFGDS_clk125 (
  .O            (clk125_in),    // Buffer output
  .I            (CLK_IN_P[1]),    // Diff_p buffer input (connect directly to top-level port)
  .IB           (CLK_IN_N[1])     // Diff_n buffer input (connect directly to top-level port)
);

BUFG BUFG_clk125 (
  .O(clk125), // 1-bit output: Clock output
  .I(clk125_in)  // 1-bit input: Clock input
);

OBUFDS #(
  .IOSTANDARD("LVDS_25"),       // Specify the output I/O standard
  .SLEW("FAST")                 // Specify the output slew rate
) OBUFDS_clks7_0 (
  .O(CLK_OUT_P[0]),                // Diff_p output (connect directly to top-level port)
  .OB(CLK_OUT_N[0]),               // Diff_n output (connect directly to top-level port)
  .I(clk100)                    // Buffer input
);

OBUFDS #(
  .IOSTANDARD("LVDS_25"),       // Specify the output I/O standard
  .SLEW("FAST")                 // Specify the output slew rate
) OBUFDS_clks7_1 (
  .O(CLK_OUT_P[1]),                // Diff_p output (connect directly to top-level port)
  .OB(CLK_OUT_N[1]),               // Diff_n output (connect directly to top-level port)
  .I(clk100)                    // Buffer input
);

OBUFDS #(
  .IOSTANDARD("LVDS_25"),       // Specify the output I/O standard
  .SLEW("FAST")                 // Specify the output slew rate
) OBUFDS_clks7_2 (
  .O(CLK_OUT_P[2]),                // Diff_p output (connect directly to top-level port)
  .OB(CLK_OUT_N[2]),               // Diff_n output (connect directly to top-level port)
  .I(clk100)                 // Buffer input
);

OBUFDS #(
  .IOSTANDARD("LVDS_25"),       // Specify the output I/O standard
  .SLEW("FAST")                 // Specify the output slew rate
) OBUFDS_clks7_3 (
  .O(CLK_OUT_P[3]),                // Diff_p output (connect directly to top-level port)
  .OB(CLK_OUT_N[3]),               // Diff_n output (connect directly to top-level port)
  .I(clk100)                  // Buffer input
);

wire fmc0_gtxclk_in, fmc1_gtxclk_in;
IBUFDS #(
  .DIFF_TERM    ("TRUE"),       // Differential Termination
  .IBUF_LOW_PWR ("FALSE"),      // Low power="TRUE", Highest performance="FALSE"
  .IOSTANDARD   ("LVDS_25")     // Specify the input I/O standard
) IBUFGDS_fmc0_gtxclk_in (
  .O            (fmc0_gtxclk_in),    // Buffer output
  .I            (FMC0_GTXCLK_M2C_P),    // Diff_p buffer input (connect directly to top-level port)
  .IB           (FMC0_GTXCLK_M2C_N)     // Diff_n buffer input (connect directly to top-level port)
);
IBUFDS #(
  .DIFF_TERM    ("TRUE"),       // Differential Termination
  .IBUF_LOW_PWR ("FALSE"),      // Low power="TRUE", Highest performance="FALSE"
  .IOSTANDARD   ("LVDS_25")     // Specify the input I/O standard
) IBUFGDS_fmc1_gtxclk_in (
  .O            (fmc1_gtxclk_in),    // Buffer output
  .I            (FMC1_GTXCLK_M2C_P),    // Diff_p buffer input (connect directly to top-level port)
  .IB           (FMC1_GTXCLK_M2C_N)     // Diff_n buffer input (connect directly to top-level port)
);

wire fmc0_clk_in, fmc1_clk_in;
IBUFDS #(
  .DIFF_TERM    ("TRUE"),       // Differential Termination
  .IBUF_LOW_PWR ("FALSE"),      // Low power="TRUE", Highest performance="FALSE"
  .IOSTANDARD   ("LVDS_25")     // Specify the input I/O standard
) IBUFGDS_fmc0_clk_in (
  .O            (fmc0_clk_in),    // Buffer output
  .I            (FMC0_CLK_M2C_P),    // Diff_p buffer input (connect directly to top-level port)
  .IB           (FMC0_CLK_M2C_N)     // Diff_n buffer input (connect directly to top-level port)
);
IBUFDS #(
  .DIFF_TERM    ("TRUE"),       // Differential Termination
  .IBUF_LOW_PWR ("FALSE"),      // Low power="TRUE", Highest performance="FALSE"
  .IOSTANDARD   ("LVDS_25")     // Specify the input I/O standard
) IBUFGDS_fmc1_clk_in (
  .O            (fmc1_clk_in),    // Buffer output
  .I            (FMC1_CLK_M2C_P),    // Diff_p buffer input (connect directly to top-level port)
  .IB           (FMC1_CLK_M2C_N)     // Diff_n buffer input (connect directly to top-level port)
);

OBUFDS #(
  .IOSTANDARD("LVDS_25"),       // Specify the output I/O standard
  .SLEW("FAST")                 // Specify the output slew rate
) OBUFDS_fmc0_clk_out (
  .O(FMC0_CLK_C2M_P),                // Diff_p output (connect directly to top-level port)
  .OB(FMC0_CLK_C2M_N),               // Diff_n output (connect directly to top-level port)
  .I(clk100)                  // Buffer input
);
OBUFDS #(
  .IOSTANDARD("LVDS_25"),       // Specify the output I/O standard
  .SLEW("FAST")                 // Specify the output slew rate
) OBUFDS_fmc1_clk_out (
  .O(FMC1_CLK_C2M_P),                // Diff_p output (connect directly to top-level port)
  .OB(FMC1_CLK_C2M_N),               // Diff_n output (connect directly to top-level port)
  .I(clk100)                  // Buffer input
);

OBUFDS #(
  .IOSTANDARD("LVDS_25"),       // Specify the output I/O standard
  .SLEW("FAST")                 // Specify the output slew rate
) obufds_gtxclks7_0 (
  .O(FPGA_GTXCLK_P[0]),                // Diff_p output (connect directly to top-level port)
  .OB(FPGA_GTXCLK_N[0]),               // Diff_n output (connect directly to top-level port)
  .I(clk125)                    // Buffer input
);

OBUFDS #(
  .IOSTANDARD("LVDS_25"),       // Specify the output I/O standard
  .SLEW("FAST")                 // Specify the output slew rate
) obufds_gtxclks7_1 (
  .O(FPGA_GTXCLK_P[1]),                // Diff_p output (connect directly to top-level port)
  .OB(FPGA_GTXCLK_N[1]),               // Diff_n output (connect directly to top-level port)
  .I(clk125)                    // Buffer input
);

OBUFDS #(
  .IOSTANDARD("LVDS_25"),       // Specify the output I/O standard
  .SLEW("FAST")                 // Specify the output slew rate
) obufds_gtxclks7_2 (
  .O(FPGA_GTXCLK_P[2]),                // Diff_p output (connect directly to top-level port)
  .OB(FPGA_GTXCLK_N[2]),               // Diff_n output (connect directly to top-level port)
  .I(clk125)                 // Buffer input
);

reg [25:0] cnt0;
always @(posedge clk100) cnt0 <= cnt0 + 1'b1;

reg [25:0] cnt1;
always @(posedge clk125) cnt1 <= cnt1 + 1'b1;

reg [25:0] cnt2;
always @(posedge clkpll) cnt2 <= cnt2 + 1'b1;

assign SYSLED[0] = ~cnt0[25];
assign SYSLED[1] = ~cnt1[25];
assign SYSLED[2] = ~cnt2[25];

assign TESTPIN = DIPSW[3:0];

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

////////////////////////////////////////////////////////////////////////////////
// FPGA
assign FPGA_PROG_B_K7 = FPGA_PROG_B;
assign FPGA_INIT_B    = FPGA_INIT_B_K7;
assign FPGA_DONE      = FPGA_DONE_K7;
assign FPGA_RST_B_K7  = FPGA_RST_B;

////////////////////////////////////////////////////////////////////////////////
// MCU
wire clk_mcu;
BUFG BUFG_clkmcu (
  .O(clk_mcu), // 1-bit output: Clock output
  .I(MCU_CLK)  // 1-bit input: Clock input
);

reg spi1_temp;
always @(posedge MCU_SPI1_SCK) 
  if(~MCU_SPI1_NSS) spi1_temp <= MCU_SPI1_MOSI;

assign MCU_SPI1_MISO = spi1_temp;

reg spi2_temp;
always @(posedge MCU_SPI2_SCK) 
  if(~MCU_SPI2_NSS) spi2_temp <= MCU_SPI2_MOSI;

assign MCU_SPI2_MISO = spi2_temp;

reg uart_temp;
always @(posedge clk_mcu) uart_temp <= MCU_UART_TX;

assign MCU_UART_RX = ~uart_temp;

////////////////////////////////////////////////////////////////////////////////
// AMC
assign AMC_TX = AMC_RX;
assign AMC_TX_DE = 4'b0;
assign AMC_RX_DE = 4'b0;

////////////////////////////////////////////////////////////////////////////////
// JTAG
assign FMC0_PRSNT_B_L = FMC0_PRSNT_B;
assign FMC1_PRSNT_B_L = FMC1_PRSNT_B;

wire tck = DIPSW[7] ? CON_TCK: AMC_TCK; // on = L = AMC
wire tms = DIPSW[7] ? CON_TMS: AMC_TMS;
wire tdi = DIPSW[7] ? CON_TDI: AMC_TDI;
wire tdo;

assign CON_TDO = DIPSW[7] ? tdo: 1'bz;
assign AMC_TDO = DIPSW[7] ? 1'bz: tdo;

assign FPGA_TCK = tck;
assign FMC0_TCK = FMC0_PRSNT_B_L ? 1'bz: tck;  // L = present
assign FMC1_TCK = FMC1_PRSNT_B_L ? 1'bz: tck;

assign FPGA_TMS = tms;
assign FMC0_TMS = FMC0_PRSNT_B_L ? 1'bz: tms;
assign FMC1_TMS = FMC1_PRSNT_B_L ? 1'bz: tms;

assign FPGA_TDI = tdi;
assign FMC0_TDI = FMC0_PRSNT_B_L ? 1'bz: FPGA_TDO;
assign FMC1_TDI = FMC1_PRSNT_B_L ? 1'bz: (FMC0_PRSNT_B_L ? FPGA_TDO: FMC0_TDO);
assign tdo      = FMC1_PRSNT_B_L ? (FMC0_PRSNT_B_L ? FPGA_TDO :FMC0_TDO): FMC1_TDO;

endmodule
