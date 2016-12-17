`timescale 1ns/10ps
`include "port_define.sv"

module DataMux(Z,S,A,B);
    
    input S; 
    input [`RegBus] A, B;
    output logic [`RegBus] Z;
    
    always_comb begin 
        case(S)
            1'b0:begin
                Z = A;
            end
            1'b1:begin
                Z = B;
            end
            default:begin
                Z = 1'bx;
            end
        endcase
   end

endmodule
