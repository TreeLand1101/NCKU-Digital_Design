// 
// Designer: P76124265
//

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

parameter [2:0] Load = 3'b000, Read_Cmd = 3'b001, Execute_Cmd = 3'b010, Max_Heapify = 3'b011, Parent_Swap = 3'b100, Done = 3'b101;
reg [2:0] Current_State, Next_State;

parameter [2:0] Build_Queue = 3'b000, Extract_Max = 3'b001, Increase_Value = 3'b010, Insert_Data = 3'b011, Write = 3'b100;

reg Build_Queue_Enable;
reg Extract_Max_Enable;
reg Increase_Value_Enable;
reg Insert_Data_Enable;
reg Write_Enable;

reg Max_Heapify_Done;

reg [7:0] Size;
reg [7:0] Array [255:0];
reg [7:0] i_temp, i;
wire [7:0] l, r, i_Parent;
reg Command_Done;

assign l = (Build_Queue_Enable || Extract_Max_Enable) ? (i << 1) + 1 : 0;
assign r = (Build_Queue_Enable || Extract_Max_Enable) ? (i << 1) + 2 : 0;
assign i_Parent = (Increase_Value_Enable || Insert_Data_Enable) ? (i - 1) >> 1 : 0;

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
                Next_State = Load;
            else
                Next_State = Done;  
        end

        Read_Cmd: begin
            Next_State = Execute_Cmd;
        end
     
        Execute_Cmd: begin
            if (Command_Done)
                Next_State = Done;
            else if ((Build_Queue_Enable && i_temp > 0) || (Extract_Max_Enable && (Size >= 1 && i_temp == Size)))
                Next_State = Max_Heapify;
            else if (Increase_Value_Enable || Insert_Data_Enable)
                Next_State = Parent_Swap;
            else
                Next_State = Execute_Cmd;
        end  

        Max_Heapify: begin
            if (Max_Heapify_Done)
                Next_State = Execute_Cmd;
            else
                Next_State = Max_Heapify;
        end

        Parent_Swap: begin
            if (Command_Done)
                Next_State = Done;
            else
                Next_State = Parent_Swap;
        end

        Done: begin
            Next_State = Read_Cmd;
        end
    endcase
end

// Output && Datapath
always @(posedge clk or posedge rst) 
begin
    if (rst) begin
        RAM_valid <= 0;
        RAM_A <= 0;
        RAM_D <= 0;
        busy <= 1;
        done <= 0;
        Size <= 0;
        i <= 0;
        i_temp <= 0;
        Command_Done <= 0;
        Build_Queue_Enable <= 0;
        Extract_Max_Enable <= 0;
        Increase_Value_Enable <= 0;
        Insert_Data_Enable <= 0;
        Write_Enable <= 0;
        Max_Heapify_Done <= 0;
    end
    else begin
        case (Current_State)
            Load: begin
                if (data_valid) begin
                    Array[Size] <= data;
                    Size <= Size + 1;
                end
            end

            Read_Cmd: begin
                case (cmd)
                    Build_Queue: begin
                        Build_Queue_Enable <= 1;
                        i_temp <= (Size >> 1);
                        i <= (Size >> 1);
                    end
                    Extract_Max: begin
                        Extract_Max_Enable <= 1;
                        i_temp <= Size;
                    end
                    Increase_Value: begin
                        Increase_Value_Enable <= 1;
                        if (value < Array[index])
                            Command_Done <= 1;
                        else begin
                            Array[index] <= value;
                            i <= index;
                        end
                    end
                    Insert_Data: begin
                        Insert_Data_Enable <= 1;
                        Size <= Size + 1;
                        Array[Size] <= value;
                        i <= Size;
                    end
                    Write: begin
                        Write_Enable <= 1;
                        i_temp <= 0;
                    end
                endcase
                busy <= 1;
            end
        
            Execute_Cmd: begin
                Max_Heapify_Done <= 0;
                if (Build_Queue_Enable) begin
                    if (i_temp == 0) begin
                        Command_Done <= 1;
                    end
                    else begin
                        i <= i_temp - 1;
                        i_temp <= i_temp - 1;
                    end
                end
                else if (Extract_Max_Enable) begin
                    if (i_temp - 1 == Size)
                        Command_Done <= 1;
                    else begin 
                        Array[0] <= Array[Size - 1];
                        Size <= Size - 1;
                        i <= 0;
                    end
                end
                else if (Increase_Value_Enable) begin
              
                end
                else if (Insert_Data_Enable) begin

                end
                else if (Write_Enable) begin
                    if (RAM_A < Size) begin
                        RAM_valid <= 1;
                        RAM_D <= Array[i_temp];
                        i_temp <= i_temp + 1;
                        RAM_A <= i_temp;
                    end
                    else begin
                        Write_Enable <= 0;
                        RAM_valid <= 0;
                        Command_Done <= 1;
                        done <= 1;
                    end
                end
                busy <= 1;
            end

            Max_Heapify: begin
                if ((l >= Size || Array[l] <= Array[i]) && (r >= Size || Array[r] <= Array[i])) begin
                    Max_Heapify_Done <= 1;
                end
                else if ((l < Size) && (Array[l] > Array[i]) && (r >= Size || Array[r] <= Array[l])) begin
                    i <= l;
                    Array[l] <= Array[i];
                    Array[i] <= Array[l];
                end
                else begin
                    i <= r;
                    Array[r] <= Array[i];
                    Array[i] <= Array[r];
                end
            end

            Parent_Swap: begin
                if (i > 0 && Array[i_Parent] < Array[i]) begin
                    Array[i_Parent] <= Array[i];
                    Array[i] <= Array[i_Parent];
                    i <= i_Parent;
                end
                else 
                    Command_Done <= 1;
            end

            Done: begin
                RAM_valid <= 0;
                RAM_A <= 0;
                RAM_D <= 0;
                busy <= 0;
                done <= 0;
                i <= 0;
                i_temp <= 0;
                Command_Done <= 0;
                Build_Queue_Enable <= 0;
                Extract_Max_Enable <= 0;
                Increase_Value_Enable <= 0;
                Insert_Data_Enable <= 0;
                Write_Enable <= 0;
                Max_Heapify_Done <= 0;
            end
        endcase
    end
end

endmodule