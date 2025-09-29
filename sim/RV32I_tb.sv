`timescale 1ns / 1ps

module RV32I_tb ();

    logic clk;
    logic reset;
    logic [7:0] gpo;
    logic [7:0] gpi;
    
    MCU U_MCU (.*);

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;

        #10;
        reset = 0;

    end
endmodule
