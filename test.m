clear;

addpath('./casadi');

import casadi.*;
import CasadiTuner.OptiGUI;
% todo how to automatically tell user to import casadi?

opti = Opti();
x = opti.variable();
opti_gui = OptiGUI(opti, "sample_save_file.mat");

% this is how we can add callbacks manually
% it will appear in the form of a button
opti_gui.add_callback("say hello", @(opti_gui) disp("hello"));
opti_gui.add_callback("wait for 2 sec", @wait_and_print);

% todo. later write a callback that can get all the parameters.

bound = opti_gui.parameter_scalar('bound', 0, 1, 10);
activate_quad = opti_gui.parameter_bool('activate_quad', true);
activate_linear = opti_gui.parameter_bool('activate_linear', true);

opti.minimize(activate_quad * (x^2) + activate_linear * (x));
opti.subject_to(x >= bound);

opti.solver('ipopt');

opti_gui.tune();


% sample callback
function wait_and_print(opti_gui)
    pause(2);
    disp("finished waiting");
end