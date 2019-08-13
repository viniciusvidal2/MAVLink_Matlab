
function [x_new,y_new] =  f_NED_to_body(x,y,yaw)


for i = 1 : length(x)
    
    %% TRANSFORMAÇÃO
    
    % Body to NED     
     T = [  cos(yaw(i))  -sin(yaw(i))  0;
            sin(yaw(i))   cos(yaw(i))  0;
                  0           0        1];
    % NED to Body
    T = T';

    %% CÁLCULO DA ROTAÇÃO
    
    [R] = (T) * [x(i);y(i);1];
    
    x_new (i) = R(1);
    y_new (i) = R(2);
    
end
