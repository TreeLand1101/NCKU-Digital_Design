// 
// Designer: P76124265
//

`timescale 1ns/10ps
module MM( in_data, col_end, row_end, is_legal, out_data, rst, clk , change_row,valid,busy);
input           clk;
input           rst;
input           col_end;
input           row_end;
input      [7:0]     in_data;

output reg signed [19:0]   out_data;
output is_legal;
output reg change_row,valid,busy;

// State
parameter [2:0] Load_Mat1 = 3'b000, Load_Mat2 = 3'b001, Mat_Mul = 3'b010, Illegal = 3'b011, Validation = 3'b100, Done = 3'b101;
reg [2:0] Current_State, Next_State;

// Matrix 1
reg signed [7:0] Mat1[20:0];
reg [3:0] Mat1_Row, Mat1_Col, Mat1_Cur_Row, Mat1_Cur_Col;

// Matrix 2
reg signed [7:0] Mat2[20:0];
reg [3:0] Mat2_Row, Mat2_Col, Mat2_Cur_Row, Mat2_Cur_Col;

reg [3:0] i;
reg [3:0] Out_Data_Cnt;

// State Register
always @(posedge clk or posedge rst) 
begin
    if (rst)
        Current_State <= Load_Mat1;
    else
        Current_State <= Next_State;
end

// Next State
always @(Current_State or row_end or Out_Data_Cnt) 
begin
    case (Current_State)
        Load_Mat1: begin
            if (row_end) 
                Next_State <= Load_Mat2;    
            else 
                Next_State <= Load_Mat1;
        end

        Load_Mat2: begin
            if (row_end) begin
                if ((Mat1_Row != Mat2_Col) || (Mat1_Col != Mat2_Row)) 
                    Next_State <= Illegal;
                else
                    Next_State <= Mat_Mul;
            end
            else 
                Next_State <= Load_Mat2;
        end
     
        Mat_Mul: begin
            if (Out_Data_Cnt > 0)
                Next_State <= Validation;
            else
                Next_State <= Done;
        end

        Validation: begin
            Next_State <= Mat_Mul;
        end

        Illegal: begin
            Next_State <= Done;
        end

        Done: begin
            Next_State <= Load_Mat1;
        end
    endcase
end

// Datapath
always @(posedge clk or posedge rst) begin
    if (rst) begin
        Mat1_Row <= 0;
        Mat1_Col <= 0;
        Mat1_Cur_Row <= 0;
        Mat1_Cur_Col <= 0;
        Mat2_Row <= 0;
        Mat2_Col <= 0;
        Mat2_Cur_Row <= 0;
        Mat2_Cur_Col <= 0;
        i <= 0;
        Out_Data_Cnt <= 0;
        out_data <= 0;
        valid <= 0;
        busy <= 0;
    end
    else begin
        case (Current_State)
            Load_Mat1: begin
                Mat1[i] <= in_data; 
                if (col_end) begin
                    Mat1_Row <= Mat1_Row + 1;
                    Mat1_Col <= i + 1;
                end
                if (row_end) 
                    i <= 0;
                else
                    i <= i + 1;
            end

            Load_Mat2: begin
                Mat2[i] <= in_data; 
                if (col_end) begin
                    Mat2_Row <= Mat2_Row + 1;
                    Mat2_Col <= i + 1;
                end
                if (row_end) begin
                    busy <= 1;
                    Out_Data_Cnt <= i;
                end
                else
                    i <= i + 1;
            end

            Mat_Mul: begin
                out_data <= out_data + Mat1[Mat1_Cur_Row * Mat1_Col + Mat1_Cur_Col] * Mat2[Mat2_Cur_Row * Mat2_Col + Mat2_Cur_Col];
                Out_Data_Cnt <= Out_Data_Cnt - 1;
            end

            Validation: begin
                valid <= 0;
            end

            Illegal: begin
                valid <= 1;
            end

            Done: begin
                Mat1_Row <= 0;
                Mat1_Col <= 0;
                Mat1_Cur_Row <= 0;
                Mat1_Cur_Col <= 0;
                Mat2_Row <= 0;
                Mat2_Col <= 0;
                Mat2_Cur_Row <= 0;
                Mat2_Cur_Col <= 0;
                i <= 0;
                Out_Data_Cnt <= 0;
                out_data <= 0;
                valid <= 0;
                busy <= 0;
            end
        endcase
    end
end


endmodule
