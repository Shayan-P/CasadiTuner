clear;

addpath('./casadi');
addpath('./ui');

import casadi.*;
import CasadiTuner.*;
% todo how to automatically tell user to import casadi?

opti = Opti();
x = opti.variable();
opti_gui = OptiGUI(opti, @(opti) optimize_callback(opti, x)); % todo maybe pass the callback in the tune function?

opti.solver('ipopt');

bound = opti_gui.parameter_scalar('bound', 0, 1, 10);
activate_quad = opti_gui.parameter_bool('activate_quad', true);
activate_linear = opti_gui.parameter_bool('activate_linear', true);

opti.minimize(activate_quad * (x^2) + activate_linear * (x));
opti.subject_to(x >= bound);

opti_gui.tune();

% how to select the previous initial value: another window should open up
% how to pass callback value
% how to export/import settings that we want.
% should we be able to save it to a file?
% add the ability to use it as simple as possible (maybe just as a visualizer) + capability to use it in a more complicated way as well
% maybe divide variables into multiple parts? maybe multiple opti guis?

% think about composition...
    
function optimize_callback(opti, x)
    sol = opti.solve();
    disp("value of x is: ");
    disp(sol.value(x));
    disp("value of objective function: ");
    disp(sol.value(opti.f));
end