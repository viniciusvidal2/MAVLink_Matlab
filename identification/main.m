%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% --- Lendo placa por Mavlink --- %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Initializations ...
    main_init;

%% CHANGE THESE

    % Settings - Port USB
        serial_port_name = '/dev/ttyACM1';
        serial_baud_rate = 115200;
    % Simulation Time
        tsim = 30.0;     

%% DO NOT CHANGE BELOW THIS POINT

    fprintf('\n connecting...');
    
    % Open serial connection
    parse = parser();
    s_port = serial( serial_port_name );
    
    s_port.BaudRate = serial_baud_rate;
    s_port.InputBufferSize = 10000;

    fopen( s_port );
    flushinput( s_port );
    fprintf('\n connected...\n');

%% SIMULATION

t = tic;
fprintf('\n waiting simulation (Press any on the keyboard) ...\n'), pause
fprintf('\n Experiment Started ...\n');

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
fprintf('\n Experiment ended...\n');

%% SAVE EXPERIMENT - Output file ".mat"


    % Time treated        
        t_gp  = double([t_gp  - t_gp(1) ])/1000;
        t_rp  = double([t_rp  - t_rp(1) ])/1000;
        t_att = double([t_att - t_att(1)])/1000;
        
    % velocities: NED to Body
        vx = double(vx) * (1e-2);
        vy = double(vy) * (1e-2);    
        [vxb,vyb] =  f_NED_to_body(vx,vy,double(hdg/100));
    
    % Derivation : Speed Yaw
        tau = 10;
        r = filter_PB(t_gp, double(hdg/100), tau); % [rad/s]
        
    % object: Data
        data.time   = [t_gp; t_rp; t_att ];
        data.pose_i = [ lat;  lon; hdg   ];
        data.vel_i  = [  vx;  vy; yawspeed  ];        
        data.vel_b  = [ vxb; vyb; yawspeed  ];        
        data.F      = [ ch2; ch1; ch4; ch6  ];           

    % Save result
        save('data_treated.mat','data');
        
%% Plots (Fcn)
    plots;
