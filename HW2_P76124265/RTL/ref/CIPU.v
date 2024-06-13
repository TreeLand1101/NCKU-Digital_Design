// 
// Designer: P76124265
//

module CIPU(
input       clk, 
input       rst,
input       [7:0]people_thing_in,
input       ready_fifo,
input       ready_lifo,
input       [7:0]thing_in,
input       [3:0]thing_num,
output reg valid_fifo,
output reg valid_lifo,
output reg valid_fifo2,
output reg [7:0]people_thing_out,
output reg [7:0]thing_out,
output reg done_thing,
output reg done_fifo,
output reg done_lifo,
output reg done_fifo2);

// FIFO
reg [1:0] FIFO_CurrentState, FIFO_Nextstate;
parameter [1:0] FIFO_Start = 2'b00, FIFO_Read = 2'b01, FIFO_Valid = 2'b10, FIFO_Done_FIFO = 2'b11;
reg [7:0] FIFO_Array[15:0];
reg [4:0] Array_Size;
reg [4:0] i;

// FIFOLIFO
reg [2:0] FIFOLIFO_CurrentState, FIFOLIFO_Nextstate;
parameter [2:0] FIFOLIFO_Start = 3'b000, FIFOLIFO_Read = 3'b001, FIFOLIFO_Valid = 3'b010, FIFOLIFO_Done_Thing = 3'b011, FIFOLIFO_Done_LIFO = 3'b100, FIFOLIFO_Valid2 = 3'b101, FIFOLIFO_Done_FIFO2 = 3'b110;
reg [7:0] LIFO_Stack[15:0];
reg [4:0] Stack_Top; 
reg [4:0] j;
reg thing_num_zero;


// FIFO State register
always @(posedge clk or posedge rst) 
begin
    if (rst) begin
        FIFO_CurrentState <= FIFO_Start;
    end
    else
        FIFO_CurrentState <= FIFO_Nextstate;
end

// FIFO next state
always @(FIFO_CurrentState or ready_fifo or people_thing_in or i or done_fifo) 
begin
    case (FIFO_CurrentState)
        FIFO_Start: begin
            if (ready_fifo) 
                FIFO_Nextstate = FIFO_Read;    
            else 
                FIFO_Nextstate = FIFO_Start;
        end

        FIFO_Read: begin
            if (people_thing_in == 8'h24)
                FIFO_Nextstate = FIFO_Valid;
            else
                FIFO_Nextstate = FIFO_Read;
        end
     
        FIFO_Valid: begin
            if (i < Array_Size)
                FIFO_Nextstate = FIFO_Valid;
            else
                FIFO_Nextstate = FIFO_Done_FIFO;
        end

        FIFO_Done_FIFO:
            if (done_fifo)
                FIFO_Nextstate = FIFO_Start;
            else
                FIFO_Nextstate = FIFO_Done_FIFO;
    endcase
end

// FIFO output logic
always @(posedge clk or posedge rst) 
begin
    if (rst)
        people_thing_out <= 0; 
    else begin
        case (FIFO_CurrentState)
            FIFO_Start: people_thing_out <= 0; 
            FIFO_Read: people_thing_out <= 0;
            FIFO_Valid: people_thing_out <= FIFO_Array[i];
            FIFO_Done_FIFO: people_thing_out <= 0;
        endcase
    end
end

// FIFO datapath
always @(posedge clk or posedge rst) 
begin
    if (rst) begin
        Array_Size <= 0;
        i <= 0; 
        valid_fifo <= 0;
        done_fifo <= 0;    
    end
    else begin
        case (FIFO_CurrentState)
            FIFO_Start: begin

            end

            FIFO_Read: begin
                if (people_thing_in >= 8'h41 && people_thing_in <= 8'h5A) begin
                    Array_Size <= Array_Size + 1;
                    FIFO_Array[Array_Size] <= people_thing_in;
                end
            end
        
            FIFO_Valid: begin
                if (i < Array_Size) begin
                    valid_fifo <= 1;
                    i <= i + 1;
                end
                else
                    valid_fifo <= 0;
            end

            FIFO_Done_FIFO: begin
                if (done_fifo)
                    done_fifo <= 0;
                else
                    done_fifo <= 1;
            end  
        endcase
    end
end


// FIFOLIFO State register
always @(posedge clk or posedge rst) 
begin
    if (rst)
        FIFOLIFO_CurrentState <= FIFOLIFO_Start;
    else
        FIFOLIFO_CurrentState <= FIFOLIFO_Nextstate;
end


// FIFOLIFO next state
always @(FIFOLIFO_CurrentState or ready_lifo or thing_in or thing_num_zero or j or done_thing or done_lifo or done_fifo2) 
begin
    case (FIFOLIFO_CurrentState)
        FIFOLIFO_Start: begin
            if (ready_lifo)
                FIFOLIFO_Nextstate = FIFOLIFO_Read;
            else
                FIFOLIFO_Nextstate = FIFOLIFO_Start;
        end

        FIFOLIFO_Read: begin
            if (thing_in == 8'h3B)
                FIFOLIFO_Nextstate = FIFOLIFO_Valid;
            else if (thing_in == 8'h24)
                FIFOLIFO_Nextstate = FIFOLIFO_Done_LIFO;
            else
                FIFOLIFO_Nextstate = FIFOLIFO_Read;
        end

        FIFOLIFO_Valid: begin
            if (thing_num_zero) 
                FIFOLIFO_Nextstate = FIFOLIFO_Valid;
            else if (j == 0)
                FIFOLIFO_Nextstate = FIFOLIFO_Done_Thing;
            else
                FIFOLIFO_Nextstate = FIFOLIFO_Valid;
        end

        FIFOLIFO_Done_Thing: begin
            if (done_thing)
                FIFOLIFO_Nextstate = FIFOLIFO_Read;
            else
                FIFOLIFO_Nextstate = FIFOLIFO_Done_Thing;
        end 

        FIFOLIFO_Done_LIFO: begin
            if (done_lifo)
                FIFOLIFO_Nextstate = FIFOLIFO_Valid2;
            else
                FIFOLIFO_Nextstate = FIFOLIFO_Done_LIFO;
        end       

        FIFOLIFO_Valid2: begin
            if (j < Stack_Top)
                FIFOLIFO_Nextstate = FIFOLIFO_Valid2;
            else
                FIFOLIFO_Nextstate = FIFOLIFO_Done_FIFO2;
        end

        FIFOLIFO_Done_FIFO2: begin
            if (done_fifo2)
                FIFOLIFO_Nextstate = FIFOLIFO_Start;
            else
                FIFOLIFO_Nextstate = FIFOLIFO_Done_FIFO2;
        end        
    endcase
end

// FIFOLIFO output logic
always @(posedge clk or posedge rst) 
begin
    if (rst)
        thing_out <= 8'h30;
    else begin
        case (FIFOLIFO_CurrentState)
            FIFOLIFO_Start: thing_out <= 8'h30;
            FIFOLIFO_Read: thing_out <= 8'h30;
            FIFOLIFO_Valid: begin
                if (thing_num_zero)
                    thing_out <= 8'h30;
                else
                    thing_out <= LIFO_Stack[Stack_Top - 1];
            end
            FIFOLIFO_Done_Thing: thing_out <= 8'h30;
            FIFOLIFO_Done_LIFO: thing_out <= 8'h30;
            FIFOLIFO_Valid2: thing_out <= LIFO_Stack[j];
            FIFOLIFO_Done_FIFO2: thing_out <= thing_out <= 8'h30;
        endcase
    end
end


// FIFOLIFO datapath
always @(posedge clk or posedge rst) 
begin
    if (rst) begin
        Stack_Top <= 0;
        j <= 0;
        valid_lifo <= 0;
        done_lifo <= 0;
        valid_fifo2 <= 0;
        done_fifo2 <= 0; 
        done_thing <= 0;
        thing_num_zero <= 0;
    end
    else begin
        case (FIFOLIFO_CurrentState)
            FIFOLIFO_Start: begin

            end
            
            FIFOLIFO_Read: begin
                if (thing_in == 8'h24)
                    j <= 0;
                else begin
                    if (thing_num == 0)
                        thing_num_zero <= 1;
                    j <= thing_num;
                    if (thing_in != 8'h3B) begin
                        LIFO_Stack[Stack_Top] <= thing_in;
                        Stack_Top <= Stack_Top + 1;                        
                    end
                end

            end

            FIFOLIFO_Valid: begin
                if (thing_num_zero) begin
                    thing_num_zero <= 0;
                    valid_lifo <= 1; 
                end
                else if (j == 0)
                    valid_lifo <= 0; 
                else begin
                    Stack_Top <= Stack_Top - 1;
                    j <= j - 1;
                    valid_lifo <= 1;
                end                  
            end

            FIFOLIFO_Done_Thing: begin 
                if (done_thing)
                    done_thing <= 0;
                else
                    done_thing <= 1;
            end

            FIFOLIFO_Done_LIFO: begin 
                if (done_lifo)
                    done_lifo <= 0;
                else
                    done_lifo <= 1;
            end

            FIFOLIFO_Valid2: begin 
                if (j < Stack_Top) begin
                    valid_fifo2 <= 1;
                    j <= j + 1;
                end
                else
                    valid_fifo2 <= 0; 
            end

            FIFOLIFO_Done_FIFO2: begin 
                if (done_fifo2)
                    done_fifo2 <= 0;
                else
                    done_fifo2 <= 1;
            end
        endcase
    end
end 

endmodule