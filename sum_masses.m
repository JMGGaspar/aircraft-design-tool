% Aircraft design tool
%
% Mario Bras (mbras@uvic.ca) and Ricardo Marques (ricardoemarques@uvic.ca) 2019
%
% This file is subject to the license terms in the LICENSE file included in this distribution

function mass = sum_masses(vehicle)
mass = 0;
for i = 1 : length(vehicle.components)
    m = vehicle.components{i}.mass;

    if isfield(vehicle.components{i}, 'reserve')
        m = m * (1 + vehicle.components{i}.reserve);
    end

    if isfield(vehicle.components{i}, 'number')
        m = m * vehicle.components{i}.number;
    end
    
    mass = mass + m;
end
