%% Hilditch algorithm
function PIC = Hild(PIC)
C = 1;    % sign variable

while C
    C = 0;  
    [row, col] = find(PIC == 1);    % Store all pixel positions with value 1
    PIC_DEL = ones(size(PIC));
    count = 0; % Store the quantity to be removed in each iteration, if it is 0, the refinement is over
    
    for i = 1:length(row)
        
        % Get the value of 1 pixel coordinate
        X = row(i);
        Y = col(i);
        
        % 3*3 matrix (stored in one-dimensional matrix P in the following order)
        % X4 X3 X2
        % X5 P  X1
        % X6 X7 X8
        P = [PIC(X, Y+1), PIC(X-1, Y+1), PIC(X-1, Y), ...
             PIC(X-1, Y-1), PIC(X, Y-1), PIC(X+1, Y-1), ...
             PIC(X+1, Y), PIC(X+1, Y+1), PIC(X, Y+1)];
        
        % condition2：X1、X3、X5、X7 not all equal to 1
        C2 = P(1) + P(3) + P(5) + (7);
        if C2 == 1*4
            continue;
        end
        
        % condition3：Non-fine line tip, at least two of X1~X8 are 1
        if sum(P(1:8)) < 1*2
            continue;
        end
        
        % condition4：Not the last remaining point to be processed, at least one black neighbor (value 1) has not been removed
        w = 0;
        for m = X-1:X+1
            for n = Y-1:Y+1
                if m == X && n == Y
                    continue;
                end
                if PIC(m, n) == 1 && PIC_DEL(m, n) == 1
                    w = w + 1;
                end
            end
        end
        if w < 1
            continue;
        end
        
        % condition5：Calculate the number of connections (inverted when calculating 8 connections)
        
        if c_number(P) ~= 1
            continue;
        end
        
        % condition6：Removal together with any neighbors that have been removed will not change connectivity, just calculate X3 and X5
        if PIC_DEL(X-1, Y) == 0
            P3 = [PIC(X, Y+1), PIC(X-1, Y+1), 0, ...
                  PIC(X-1, Y-1), PIC(X, Y-1), PIC(X+1, Y-1), ...
                  PIC(X+1, Y), PIC(X+1, Y+1), PIC(X, Y+1)];
             if c_number(P3) ~= 1
                 continue;
             end
        end
        
        % condition6：X5
        if PIC_DEL(X, Y-1) == 0
            P5 = [PIC(X, Y+1), PIC(X-1, Y+1), PIC(X-1, Y), ...
                  PIC(X-1, Y-1), 0, PIC(X+1, Y-1), ...
                  PIC(X+1, Y), PIC(X+1, Y+1), PIC(X, Y+1)];
             if c_number(P5) ~= 1
                 continue;
             end
        end
        
        PIC_DEL(X, Y) = 0;
        count = count + 1;
    end
    if count ~= 0
        PIC = PIC .* PIC_DEL;    % Update PIC (note that it will be updated only after the entire PIC iteration)
        C = 1;
    end
end