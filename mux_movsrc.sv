`timescale 1ns/10ps
`include "port_define.sv"

module mux_movsrc(Y,S,I0,I1);
    
    input S; 
    input [`RegBus] I0, I1;
    output logic [`RegBus] Y;
    
    always_comb begin 
        case(S)
            1'b0:begin
                Y = I0;
            end
            1'b1:begin
                Y = I1;
            end
            default:begin
                Y = 1'bx;
            end
        endcase
   end

endmodule
