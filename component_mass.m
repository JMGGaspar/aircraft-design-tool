% Aircraft design tool
%
% Mario Bras (mbras@uvic.ca) and Ricardo Marques (ricardoemarques@uvic.ca) 2019
%
% This file is subject to the license terms in the LICENSE file included in this distribution

function mass = component_mass(component)
mass = component.mass;

if isfield(component, 'reserve')
    mass = mass * (1 + components.reserve);
end

if isfield(component, 'number')
    mass = mass * component.number;
end
