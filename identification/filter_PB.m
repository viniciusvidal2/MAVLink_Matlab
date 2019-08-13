
function [r] = filter_PB(t, hdg,tau)


%% Derivada + Filtro Passa - baixo
    sys_1 = tf([1 0], [tau 1]);
        
%% Filtro Passa - baixo    
    sys_2 = tf([0 1], [tau 1]);   
   
%% Calc. da Derivada

    % vel. (r)
    r(1) = 0;
    for i = 2 : length(t)      
        r(i) = [hdg(i) - hdg(i-1)]/(t(i)-t(i-1));
        r(i) = - r(i);
        % Tratamento salto de (pi) p/ (-pi)
%         if abs (yaw(i) - yaw(i-1)) > pi/2
%             r2(i) = r2(i-1);
%         end
    end  
%    [r ] = lsim(sys_1, hdg,t, r(1));
%    [r2 ] = lsim(sys_2, r,t, r(1));
   
    r   = deg2rad(r);