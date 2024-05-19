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

parameter [2:0] Load = 3'b000, Read_Cmd = 3'b001, Execute_Cmd = 3'b010, Done = 3'b011;
reg [2:0] Current_State, Next_State;

parameter [2:0] Build_Queue = 3'b000, Extract_Max = 3'b001, Increase_Value = 3'b010, Insert_Data = 3'b011, Write = 3'b100;

reg Build_Queue_Enable;
reg Extract_Max_Enable;
reg Increase_Value_Enable;
reg Insert_Data_Enable;
reg Write_Enable;

reg [7:0] Size;
reg [7:0] Array [255:0];
reg [7:0] i, i_temp;
wire [7:0] l, r;
reg [7:0] largest;
reg Max_Heapify_Running;
reg Command_Done;

assign l = (i << 1) + 1;
assign r = (i << 1) + 2;

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
            else
                Next_State = Execute_Cmd;
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
        Max_Heapify_Running <= 0;
        Build_Queue_Enable <= 0;
        Extract_Max_Enable <= 0;
        Increase_Value_Enable <= 0;
        Insert_Data_Enable <= 0;
        Write_Enable <= 0;
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
                    end
                    Insert_Data: begin
                        Insert_Data_Enable <= 1;
                    end
                    Write: begin
                        Write_Enable <= 1;
                        i_temp <= 0;
                    end
                endcase
                busy <= 1;
            end
        
            Execute_Cmd: begin
                if (Build_Queue_Enable) begin
                    if (!Max_Heapify_Running) begin
                        if (i_temp == 0) begin
                            Command_Done <= 1;
                        end
                        else begin
                            Max_Heapify_Running <= 1;
                            i_temp <= i_temp - 1;
                            i <= i_temp - 1;
                        end
                    end
                end
                else if (Extract_Max_Enable) begin
                    if ((Size < 1) || (!Max_Heapify_Running && (i_temp - 1 == Size)))
                        Command_Done <= 1;
                    else if(!Max_Heapify_Running) begin
                        Array[1] = Array[Size - 1];
                        Size = Size - 1;
                        i <= 1;
                        Max_Heapify_Running <= 1;
                    end
                    else
                        Max_Heapify_Running <= 1;
                end
                else if (Increase_Value_Enable) begin
                    
                end
                else if (Insert_Data_Enable) begin

                end
                else if (Write_Enable) begin
                    if (i_temp < Size) begin
                        RAM_valid <= 1;
                        RAM_D <= Array[i_temp];
                        i_temp <= i_temp + 1;
                        if (RAM_valid)
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

            Done: begin
                RAM_valid <= 0;
                RAM_A <= 0;
                RAM_D <= 0;
                busy <= 0;
                done <= 0;
                i <= 0;
                i_temp <= 0;
                Command_Done <= 0;
                Max_Heapify_Running <= 0;    
                Build_Queue_Enable <= 0;
                Extract_Max_Enable <= 0;
                Increase_Value_Enable <= 0;
                Insert_Data_Enable <= 0;
                Write_Enable <= 0;
            end
        endcase
    end
end

// Max_Heapify
always @(posedge clk or posedge rst) 
begin
    if (Max_Heapify_Running) begin
        if ((l >= Size || Array[l] <= Array[i]) && (r >= Size || Array[r] <= Array[i])) begin
            Max_Heapify_Running <= 0;
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
end

endmodule