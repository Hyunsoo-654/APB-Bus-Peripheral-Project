`timescale 1ns / 1ps

module GPO_Periph (
    //Global Signals
    input  logic        PCLK,
    input  logic        PRESET,
    // APB Interface Signals
    input  logic [ 2:0] PADDR,
    input  logic        PWRITE,
    input  logic        PENABLE,
    input  logic [31:0] PWDATA,
    input  logic        PSEL,
    output logic [31:0] PRDATA,
    output logic        PREADY,
    // External Port
    output logic [ 7:0] gpo
);
    logic [7:0] cr;
    logic [7:0] odr;
    
    APB_SlaveInf_GPO U_APB_SlaveInf_GPO (.*);
    GPO U_GPO (.*);

endmodule

module APB_SlaveInf_GPO (
    //Global Signals
    input  logic        PCLK,
    input  logic        PRESET,
    // APB Interface Signals
    input  logic [ 2:0] PADDR,
    input  logic        PWRITE,
    input  logic        PENABLE,
    input  logic [31:0] PWDATA,
    input  logic        PSEL,
    output logic [31:0] PRDATA,
    output logic        PREADY,
    // Internal Port
    output logic [ 7:0] cr,
    output logic [ 7:0] odr
);

    logic [31:0] slv_reg0, slv_reg1;

    assign cr  = slv_reg0;
    assign odr = slv_reg1;

    always_ff @(posedge PCLK, posedge PRESET) begin
        if (PRESET) begin
            slv_reg0 <= 0;
            slv_reg1 <= 0;

        end else begin
            PREADY <= 1'b0;
            if (PSEL && PENABLE) begin
                PREADY <= 1'b1;
                if (PWRITE) begin
                    case (PADDR[2])
                        2'd0: slv_reg0 <= PWDATA;
                        2'd1: slv_reg1 <= PWDATA;
                    endcase
                end else begin
                    case (PADDR[2])
                        2'd0: PRDATA <= slv_reg0;
                        2'd1: PRDATA <= slv_reg1;
                    endcase
                end
            end
        end
    end

endmodule

module GPO (
    input  logic [7:0] cr,
    input  logic [7:0] odr,
    output logic [7:0] gpo

);
    genvar i;
    generate
        for (i = 0; i < 8; i++) begin
            assign gpo[i] = cr[i] ? odr[i] : 1'bz;
        end
    endgenerate

    // assign gpo = cr[0] ? odr[0] : 1'bz;
    // assign gpo = cr[1] ? odr[1] : 1'bz;
    // assign gpo = cr[2] ? odr[2] : 1'bz;
    // assign gpo = cr[3] ? odr[3] : 1'bz;
    // assign gpo = cr[4] ? odr[4] : 1'bz;
    // assign gpo = cr[5] ? odr[5] : 1'bz;
    // assign gpo = cr[6] ? odr[6] : 1'bz;
    // assign gpo = cr[7] ? odr[7] : 1'bz;


endmodule
