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
output reg is_legal;
output reg change_row,valid,busy;

// State
parameter [2:0] Load_Mat1 = 3'b000, Load_Mat2 = 3'b001, Mat_Mul = 3'b010, Wating = 3'b011, Illegal = 3'b100, Done = 3'b101;
reg [2:0] Current_State, Next_State;

// Matrix 1
reg signed [7:0] Mat1[3:0][3:0];
reg [2:0] Mat1_Row, Mat1_Col, Mat1_Cur_Row, Mat1_Cur_Col;

// Matrix 2
reg signed [7:0] Mat2[3:0][3:0];
reg [2:0] Mat2_Row, Mat2_Col, Mat2_Cur_Row, Mat2_Cur_Col;

reg [2:0] i;

// State Register
always @(posedge clk or posedge rst) 
begin
    if (rst)
        Current_State <= Load_Mat1;
    else
        Current_State <= Next_State;
end

// Next State
always @(*) 
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
                if (Mat1_Col == Mat2_Row + 1) 
                    Next_State <= Mat_Mul;
                else
                    Next_State <= Illegal;
            end
            else 
                Next_State <= Load_Mat2;
        end
     
        Mat_Mul: begin
            if ((Mat1_Cur_Row == Mat1_Row - 1) && (Mat2_Cur_Col == Mat2_Col - 1))
                Next_State <= Done;
            else
                Next_State <= Wating;
        end

        Wating: begin
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

// Output logic
always @(posedge clk or posedge rst) begin
    if (rst) begin
        out_data <= 0;
        is_legal <= 0;
        change_row <= 0;
        valid <= 0;
        busy <= 0;
    end
    else begin
        case (Current_State)
            Load_Mat1: begin
                out_data <= 0;
                is_legal <= 0;
                change_row <= 0;
                valid <= 0;
                busy <= 0;
            end
            Load_Mat2: begin
                out_data <= 0;
                is_legal <= 0;
                change_row <= 0;
                valid <= 0;
                if (row_end)
                    busy <= 1;
                else
                    busy <= 0;
            end

            Mat_Mul: begin
                for (i = 0; i < Mat1_Col; i = i + 1)
                    out_data <= out_data + Mat1[Mat1_Cur_Row][i] * Mat2[i][Mat2_Cur_Col];
                
                if (Mat2_Cur_Col == Mat2_Col - 1)
                    change_row <= 1;
                else
                    change_row <= 0;
                is_legal <= 1;
                valid <= 1;
                busy <= 1;
            end

            Wating: begin
                out_data <= 0;
                is_legal <= 0;
                change_row <= 0;
                valid <= 0;
                busy <= 0;             
            end

            Illegal: begin
                out_data <= 0;
                is_legal <= 0;
                change_row <= 0;
                valid <= 1;
                busy <= 0;             
            end

            Done: begin
                out_data <= 0;
                is_legal <= 0;
                change_row <= 0;
                valid <= 0;
                busy <= 0;            
            end
        endcase
    end
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
    end
    else begin
        case (Current_State)
            Load_Mat1: begin
                Mat1[Mat1_Row][Mat1_Col] <= in_data; 
                if (col_end) begin
                    Mat1_Row <= Mat1_Row + 1;
                    Mat1_Col <= 0;
                end
                else
                    Mat1_Col <= Mat1_Col + 1;

                if (row_end) begin
                    Mat1_Row <= Mat1_Row + 1;
                    Mat1_Col <= Mat1_Col + 1;                  
                end
            end

            Load_Mat2: begin
                Mat2[Mat2_Row][Mat2_Col] <= in_data; 
                if (col_end) begin
                    Mat2_Row <= Mat2_Row + 1;
                    Mat2_Col <= 0;
                end
                else
                    Mat2_Col <= Mat2_Col + 1;

                if (row_end) begin
                    Mat2_Row <= Mat2_Row + 1;
                    Mat2_Col <= Mat2_Col + 1;
                end
            end

            Mat_Mul: begin
                if (Mat2_Cur_Col == Mat2_Col - 1) begin
                    Mat1_Cur_Row <= Mat1_Cur_Row + 1;
                    Mat2_Cur_Col <= 0;
                end
                else
                    Mat2_Cur_Col <= Mat2_Cur_Col + 1;
            end

            Wating: begin
                
            end

            Illegal: begin

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
            end
        endcase
    end
end


endmodule
