`timescale 1ns/10ps

module mux4to1(Y, S0, S1, I0, I1, I2, I3);
  
parameter DSize = 32;

output logic [DSize-1:0] Y;

input S0, S1; 
input [DSize-1:0] I0, I1, I2, I3;

always_comb begin
    case({S1,S0})
        2'b00:
            Y = I0;
        2'b01:
            Y = I1;
        2'b10:
            Y = I2;
        2'b11:
            Y = I3;
        default:
            Y = 2'b00;
    endcase 
    //Y=({S1,S0}==2'b00)?I0:
         //({S1,S0}==2'b01)?I1:
         //({S1,S0}==2'b10)?I2:
         //({S1,S0}==2'b11)?I3:2'b00;
end


endmodule
