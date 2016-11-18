`timescale 1ns/10ps

module mux2to1(Y,S,I0,I1);
    
    parameter DSize = 32;
    
    input S; 
    input [DSize-1:0] I0, I1;
    output logic [DSize-1:0] Y;
    
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
