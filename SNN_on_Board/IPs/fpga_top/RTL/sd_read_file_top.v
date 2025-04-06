
//--------------------------------------------------------------------------------------------------------
// Module  : fpga_top
// Type    : synthesizable, FPGA's top, IP's example design
// Standard: Verilog 2001 (IEEE1364-2001)
// Function: an example of sd_file_reader, read a file from SDcard and send file content to UART
//           this example runs on Digilent Nexys4-DDR board (Xilinx Artix-7),
//           see http://www.digilent.com.cn/products/product-nexys-4-ddr-artix-7-fpga-trainer-board.html
//--------------------------------------------------------------------------------------------------------

module sd_read_file_top (
    // clock = 50MHz
    input  wire         clk,
    // when sdcard_pwr_n = 0, SDcard power on
    output wire         sdcard_pwr_n,
    // signals connect to SD bus
    output wire         sdclk,
    (* DONT_TOUCH = "TRUE" *) inout               sdcmd,
    input  wire         sddat0,
    output wire         sddat1, sddat2, sddat3,
    // 16 bit led to show the status of SDcard
    output wire [15:0]  led,
    input         rd_en,
    input         rstn,
    output        outen,
    output [7:0]  outbyte
);


assign led[15:9] = 0;

assign sdcard_pwr_n = 1'b0;                  // keep SDcard power-on

assign {sddat1, sddat2, sddat3} = 3'b111;    // Must set sddat1~3 to 1 to avoid SD card from entering SPI mode


wire [63:0] dbg_bus64_a;
wire [63:0] dbg_bus64_b;
wire [63:0] dbg_bus64_c;
wire [63:0] dbg_bus64_d;
wire [63:0] dbg_bus64_e;

wire rstn2 = rd_en ? rstn : 0;

//----------------------------------------------------------------------------------------------------
// sd_file_reader
//----------------------------------------------------------------------------------------------------

(* DONT_TOUCH = "true" *) sd_file_reader #(
    .FILE_NAME_LEN    ( 11             ),  // the length of "example.txt" (in bytes)
    .FILE_NAME        ( "example.txt"  ),  // file name to read
    .CLK_DIV          ( 2              )   // because clk=50MHz, CLK_DIV must ≥2
) u_sd_file_reader (
    .rstn             ( rstn2           ),
    .clk              ( clk            ),
    .sdclk            ( sdclk          ),
    .sdcmd            ( sdcmd          ),
    .sddat0           ( sddat0         ),
    .card_stat        ( led[3:0]       ),  // show the sdcard initialize status
    .card_type        ( led[5:4]       ),  // 0=UNKNOWN    , 1=SDv1    , 2=SDv2  , 3=SDHCv2
    .filesystem_type  ( led[7:6]       ),  // 0=UNASSIGNED , 1=UNKNOWN , 2=FAT16 , 3=FAT32 
    .file_found       ( led[  8]       ),  // 0=file not found, 1=file found
    .outen            ( outen          ),
    .outbyte          ( outbyte        ),
    .dbg_bus64_a        ( dbg_bus64_a      ),
    .dbg_bus64_b        ( dbg_bus64_b      ),
    .dbg_bus64_c        ( dbg_bus64_c      ),
    .dbg_bus64_d        ( dbg_bus64_d      ),
    .dbg_bus64_e        ( dbg_bus64_e      )
);

endmodule
