// 
// Designer: P76124265
//
`include "Functions.v"

module MPQ(clk,rst,data_valid,data,cmd_valid,cmd,index,value,busy,RAM_valid,RAM_A,RAM_D,done);
input clk;
input rst;
input data_valid;
input [7:0] data;
input cmd_valid;
input [2:0] cmd;
input [7:0] index;
input [7:0] value;
output reg busy;
output reg RAM_valid;
output reg[7:0]RAM_A;
output reg [7:0]RAM_D;
output reg done;

parameter [2:0] Load = 3'b000;
parameter [2:0] Read_Cmd = 3'b001;
parameter [2:0] Execute_Cmd = 3'b010;
parameter [2:0] Validate = 3'b011;
parameter [2:0] Done = 3'b011;

parameter [2:0] Build_Queue = 3'b011;
parameter [2:0] Extract_Max = 3'b011;
parameter [2:0] Increase_Value = 3'b011;
parameter [2:0] Insert_Data = 3'b011;
parameter [2:0] Write = 3'b011;

reg [7:0] Size
reg [7:0] Array [7:0];
reg [7:0] l, r;

reg [2:0] Current_State, Next_State;

// State Register
always @(posedge clk or posedge rst) 
begin
    if (rst)
        Current_State <= Load;
    else
        Current_State <= Next_State;
end

// Next State
always @(*) 
begin
    case (Current_State)
        Load: begin
            if (data_valid)
                Next_State <= Load;
            else
                Next_State <= Execute_Cmd;
        end

        Read_Cmd: begin
            Next_State <= Execute_Cmd;
        end
     
        Execute_Cmd: begin
            if (EXECUTING)
                Next_State <= Execute_Cmd;
            else
                Next_State <= Done;
        end

        Output: begin
            if (RAM_A < Size)
                Next_State <= Output;
            else
                Next_State <= Done;
        end        

        Done: begin
            Next_State <= Load;
        end
    endcase
end

// Output logic && Datapath
always @(posedge clk or posedge rst) begin
    if (rst) begin
        RAM_A <= 0;
        RAM_D <= 0;
        busy <= 0;
        done <= 0;
    end
    else begin
        case (Current_State)
            Load: begin
                RAM_A <= 0;
                RAM_D <= 0;
                busy <= 0;
                done <= 0;
            end

            Read_Cmd: begin
                RAM_A <= 0;
                RAM_D <= 0;
                busy <= 1;
                done <= 0;
            end
        
            Execute_Cmd: begin

                case (cmd)
                    Build_Queue: begin
                        Build_Queue Build_Queue_inst(.Array(Array), .i(RAM_A));
                    end

                    Extract_Max: begin
                        Extract_Max Extract_Max_inst(.Array(Array), .index(index), .value(value));
                    end

                    Increase_Value: begin
                        Increase_Value Increase_Value_inst(.Array(Array));
                    end

                    Insert_Data: begin
                        Insert_Data Insert_Data_inst(.Array(Array), .index(index));
                    end

                    Write: begin
                        Write Write_inst(.Array(Array), .index(index));
                    end
                endcase

                RAM_A <= 0;
                RAM_D <= 0;
                busy <= 1;
                done <= 0;
            end

            Output: begin
                RAM_A <= RAM_A + 1;
                RAM_D <= Array[RAM_A];
                busy <= 1;
                if (RAM_A < Size)
                    done <= 0;
                else
                    done <= 1;
            end

            Done: begin
                RAM_A <= 0;
                RAM_D <= 0;
                busy <= 0;
                done <= 0;
            end
        endcase
    end
end

endmodule