`timescale 1ns/10ps

`include "mux4to1.sv"

module extension(instruction,
                 S0,
                 S1,
                 Y);
     
    parameter DSize = 32;           
    
    input [19:0] instruction;
    input S0,S1;
    
    output logic [DSize-1:0]Y;
    
    logic [DSize-1:0]fiveZE;
    logic [DSize-1:0]fifteenSE;
    logic [DSize-1:0]fifteenZE;
    logic [DSize-1:0]twentySE; 
    
    mux4to1 extension_sle(.Y(Y), 
                          .S0(S0), .S1(S1), 
                          .I0(fiveZE), .I1(fifteenSE), .I2(fifteenZE), .I3(twentySE));
    always_comb begin
                          
        fiveZE  = {27'b0_000000_00000_00000_00000_00000,instruction[14:10]};
        fifteenSE = {{17{instruction[14]}},instruction[14:0]}; //{} !!!!!!!!
        fifteenZE = {17'b0_000000_00000_00000,instruction[14:0]};
        twentySE = {{12{instruction[19]}},instruction[19:0]};
    //assign twentySE = {{12{instruction[14]}},instruction[19:0]};
    end
           
endmodule
