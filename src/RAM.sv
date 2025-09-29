`timescale 1ns / 1ps

module RAM (
    //Global Signals
    input  logic        PCLK,
    input  logic        PRESET,
    // APB Interface Signals
    input  logic [ 11:0] PADDR, // 32'h1000_0fff까지이니까 fff-> 12비트
    input  logic        PWRITE,
    input  logic        PENABLE,
    input  logic [31:0] PWDATA,
    input  logic        PSEL,
    output logic [31:0] PRDATA,
    output logic        PREADY
);

    // fff(12비트)면 2^12승이지만, 4byte로 잡았기 때문에 나누기 4해서 2^10
    logic [31:0] mem[0:2**10-1]; 

    always_ff @( posedge PCLK ) begin
        PREADY <= 1'b0;
        if(PSEL && PENABLE) begin
            PREADY <= 1'b1;
            if (PWRITE) mem[PADDR[11:2]] <= PWDATA;
            else PRDATA <= mem[PADDR[11:2]];
        end
    end

endmodule
