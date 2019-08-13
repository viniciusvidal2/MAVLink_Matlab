
clear; clc; close all; instrreset;

%% Add paths

    addpath('/home/accacio/MAVLink_Matlab/ardupilotmega')
    addpath('/home/accacio/MAVLink_Matlab/common')
    addpath('/home/accacio/MAVLink_Matlab')

    
%% Init Variables    

    %   Position  and Orientation
        t_gp  = [];                     % msg - Gloabal Position int
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
