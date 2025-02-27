%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% --- Lendo placa por Mavlink --- %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    clear; clc; close all; instrreset;

%% Add paths

    addpath('/home/accacio/MAVLink_Matlab/ardupilotmega')
    addpath('/home/accacio/MAVLink_Matlab/common')

%% CHANGE THESE

    serial_port_name = '/dev/ttyACM1';
    serial_baud_rate = 115200;

%% DO NOT CHANGE BELOW THIS POINT

    fprintf('\n connecting...');
    parse = parser();

% Open serial connection
    s_port = serial( serial_port_name );
    s_port.BaudRate = serial_baud_rate;
    s_port.InputBufferSize = 10000;

    fopen( s_port );
    flushinput( s_port );
    fprintf('\n connected...\n');

%% VARIABLES
    
    % Simulation Time
        tsim = 100.0;        
        t_gp = [];
        
    %   Position  and Orientation
        lat   = [];                     % msg - Gloabal Position int
        lon   = [];                     % msg - Gloabal Position int
        hdg   = [];                     % msg - Gloabal Position int
        
        roll  = [];                     % msg - Attitude 
        pitch = [];                     % msg - Attitude
        yaw   = [];                     % msg - Attitude
        
    % Velocidades
        vx  = [];                       % msg - Gloabal Position int
        vy  = [];                       % msg - Gloabal Position int
        
        t_att      = [];                % msg - Attitude 
        rollspeed  = [];                % msg - Attitude 
        pitchspeed = [];                % msg - Attitude
        yawspeed   = [];                % msg - Attitude
        
    % Radio Control
        t_rp = [];
        ch1  = [];
        ch2  = [];
        ch4  = [];
        ch6  = [];

%% SIMULATION

t = tic;
while toc(t) <  tsim
    
    if s_port.BytesAvailable > 100
        b = fread( s_port, s_port.BytesAvailable );   
        [parse, msg] = parse.byte_stream(b');        
       
        for i = 1:length( msg )
        fprintf( 'Msg (%d) %s\n', msg{i}.get_msgid(), class(msg{i}) );
            
            if msg{i}.get_msgid() == 33   % GLOBAL_POSITION_INT
                px4 = msg{i};       
                
                % Tempo
                    t_gp = [t_gp px4.get_prop_time_boot_ms()];
                    
                % Valocidades [vx vy vyaw]                
                    vx      = [vx, px4.get_prop_vx()];
                    vy      = [vy, px4.get_prop_vy()];
                
                % Posição [lat lon hdg]
                    lat = [lat, px4.get_prop_lat()];
                    lon = [lon, px4.get_prop_lon()];
                    hdg = [hdg, px4.get_prop_hdg()];
                    
            elseif msg{i}.get_msgid() == 35    % RC_CHANNELS_RAW
                px4 = msg{i};
                
                % Time
                    t_rp = [t_rp px4.get_prop_time_boot_ms() ];
                    
                % Radio Control
                    ch1 = [ch1 px4.get_prop_chan1_raw()];
                    ch2 = [ch2 px4.get_prop_chan2_raw()];
                    ch4 = [ch4 px4.get_prop_chan4_raw()];
                    ch6 = [ch6 px4.get_prop_chan6_raw()];
                
                % print...
                    fprintf('Ch01: %.4f\t Ch02: %.4f\t Ch04: %.4f\t Ch06: %.4f\n', px4.get_prop_chan1_raw(), px4.get_prop_chan2_raw(), px4.get_prop_chan4_raw(), px4.get_prop_chan6_raw()  )
                
            elseif msg{i}.get_msgid() == 30     % ATTITUDE
                px4 = msg{i};
                % Time
                    t_att = [t_att px4.get_prop_time_boot_ms() ];
                    
                % Angles
                    roll  = [ roll,  px4.get_prop_roll() ]; 
                    pitch = [ pitch, px4.get_prop_roll() ];
                    yaw   = [ yaw  , px4.get_prop_roll() ];

                % Angle Speed
                    rollspeed  = [ rollspeed,  px4.get_prop_rollspeed() ]; 
                    pitchspeed = [ pitchspeed, px4.get_prop_pitchspeed()];
                    yawspeed   = [ yawspeed  , px4.get_prop_yawspeed()  ];                    

            end

        end
            
    end
        
        
%         stats = parse.get_stats();
%         fprintf( 'Total Msg: %d\t Msg Errors: %d\t Unknown Msg:%d\n', ...
%                                 stats.total, stats.errors, stats.unknown );
   
end

fclose( s_port );


%% SAVE EXPERIMENT


%% Output file ".mat"
    % Time treated
        
        t_gp  = double([t_gp  - t_gp(1) ])/1000;
        t_rp  = double([t_rp  - t_rp(1) ])/1000;
        t_att = double([t_att - t_att(1)])/1000;
        
    % Derivation : Speed Yaw
        tau = 10;
        r = filtro(t_gp, hdg/100, tau); % [rad/s]
    % object: Data
        data.time = [t_gp; t_rp; t_att ];
        data.pose = [ lat;  lon; hdg  ];
        data.vel  = [  vx;  vy; yawspeed  ];        
        data.F    = [ ch2; ch1; ch4; ch6];           

    % Save result
        save('data_treated.mat','data');
        
%% Plots

figure
subplot(321),plot(t_gp,lat,'linewidth',2), grid minor, ylabel('Lat')
subplot(323),plot(t_gp,lon,'linewidth',2), grid minor, ylabel('Lon')
subplot(325),plot(t_gp,hdg/100,'linewidth',2), grid minor, ylabel('\psi [deg]')

subplot(322),plot(t_gp,vx,'linewidth',2), grid minor, ylabel(' v_{x} [m/s]  ')
subplot(324),plot(t_gp,vy,'linewidth',2), grid minor, ylabel(' v_{y} [m/s]  ')
subplot(326),plot(t_gp, r,'linewidth',2), grid minor, ylabel(' r     [rad/s]')

figure
subplot(321), plot(t_att, rad2deg(roll)  ,'linewidth',2), grid minor, ylabel('\theta [deg]')
subplot(323), plot(t_att, rad2deg(pitch) ,'linewidth',2), grid minor, ylabel('\phi [deg]')
subplot(325), plot(t_att, rad2deg(yaw  ) ,'linewidth',2), grid minor, ylabel('\psi [deg]')

subplot(322), plot(t_att, rollspeed ,'linewidth',2), grid minor, h1 = ylabel('$\textbf{$\dot{\theta}$} [rad/s]$');set(h1, 'Interpreter', 'latex');
subplot(324), plot(t_att, pitchspeed,'linewidth',2), grid minor, h1 = ylabel('$\dot{\phi}$ [rad/s]');set(h1, 'Interpreter', 'latex');
subplot(326), plot(t_att, yawspeed  ,'linewidth',2), grid minor, h1 = ylabel('$\dot{\psi}$ [rad/s]');set(h1, 'Interpreter', 'latex');

figure
subplot(221), plot(t_rp, ch2, 'linewidth',2), grid minor, ylabel('Ch2 [PWM]')
subplot(223), plot(t_rp, ch1, 'linewidth',2), grid minor, ylabel('Ch1 [PWM]')
subplot(222), plot(t_rp, ch4, 'linewidth',2), grid minor, ylabel('Ch4 [PWM]')
subplot(224), plot(t_rp, ch6, 'linewidth',2), grid minor, ylabel('Ch6 [PWM]')
