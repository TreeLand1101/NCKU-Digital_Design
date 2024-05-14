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
output reg [7:0]RAM_A;
output reg [7:0]RAM_D;
output reg done;

parameter [1:0] State_Bit = 2;
parameter [State_Bit - 1:0] Load = 0;
parameter [State_Bit - 1:0] Read_Cmd = 1;
parameter [State_Bit - 1:0] Execute_Cmd = 2;
parameter [State_Bit - 1:0] Done = 3;

parameter [2:0] Command_Bit = 2;
parameter [Command_Bit - 1:0] Build_Queue = 0;
parameter [Command_Bit - 1:0] Extract_Max = 1;
parameter [Command_Bit - 1:0] Increase_Value = 2;
parameter [Command_Bit - 1:0] Insert_Data = 3;
parameter [Command_Bit - 1:0] Write = 4;

reg [7:0] Size;
reg [7:0] Array [7:0];
reg [7:0] i;

reg Build_Queue_Enable;
reg Extract_Max_Enable;
reg Increase_Value_Enable;
reg Insert_Data_Enable;
reg Max_Heapify_Enable;

reg Build_Queue_Done;
reg Extract_Max_Done;
reg Increase_Value_Done;
reg Insert_Data_Done;
reg Max_Heapify_Done;

Build_Queue Build_Queue(.Array(Array), .Size(Size), .enble(Build_Queue_Enable), .done(Build_Queue_Done));
Extract_Max Extract_Max(.Array(Array), .Size(Size), .enble(Extract_Max_Enable), .done(Extract_Max_Done));
Increase_Value Increase_Value(.Array(Array), .Size(Size), .index(index), .value(value), .enble(Increase_Value_Enable), .done(Increase_Value_Done));
Insert_Data Insert_Data(.Array(Array), .Size(Size), .value(value), .enble(Insert_Data_Enable), .done(Insert_Data_Done));
Max_Heapify Max_Heapify(.Array(Array), .Size(Size), .i(i), .enble(Max_Heapify_Enable), .done(Max_Heapify_Done));

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
                Next_State <= Read_Cmd;
        end

        Read_Cmd: begin
            Next_State <= Execute_Cmd;
        end
     
        Execute_Cmd: begin
            if (done)
                Next_State <= Done;
            else
                Next_State <= Execute_Cmd;
        end  

        Done: begin
            Next_State <= Load;
        end
    endcase
end

// Output logic && Datapath
always @(posedge clk or posedge rst) 
begin
    if (rst) begin
        RAM_A <= 0;
        RAM_D <= 0;
        busy <= 0;
        done <= 0;
        Size <= 0;
        Build_Queue_Enable <= 0;
        Extract_Max_Enable <= 0;
        Increase_Value_Enable <= 0;
        Insert_Data_Enable <= 0;
        Write_Enable <= 0;
    end
    else begin
        case (Current_State)
            Load: begin
                Array[Size] <= in_data;
                Size <= Size + 1;
            end

            Read_Cmd: begin
                busy <= 1;
            end
        
            Execute_Cmd: begin
                case (cmd)
                    Build_Queue: Build_Queue_Enable <= 1;
                    Extract_Max: Extract_Max_Enable <= 1;
                    Increase_Value: Increase_Value_Enable <= 1;
                    Insert_Data: Insert_Data_Enable <= 1;
                    Write: begin
                        if (RAM_A < Size) begin
                            RAM_A <= RAM_A + 1;
                            RAM_D <= Array[RAM_A];
                        end
                        else begin
                            busy <= 0;
                            done <= 1;
                        end
                    end
                endcase
            end

            Done: begin
                RAM_A <= 0;
                RAM_D <= 0;
                busy <= 0;
                done <= 0;
                Size <= 0;
                Build_Queue_Enable <= 0;
                Extract_Max_Enable <= 0;
                Increase_Value_Enable <= 0;
                Insert_Data_Enable <= 0;
                Write_Enable <= 0;
            end
        endcase
    end
end

endmodule