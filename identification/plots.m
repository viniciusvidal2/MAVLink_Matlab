
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