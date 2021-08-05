% Aircraft design tool
%
% Mario Bras (mbras@uvic.ca) and Ricardo Marques (ricardoemarques@uvic.ca) 2019
%
% This file is subject to the license terms in the LICENSE file included in this distribution

function vehicle = emissions_analysis(mission, vehicle)
global constants;

% Pollutant emissions
emissions_pb = % TODO: Production of batteries
emissions_cf = % TODO: Fuel consumption
emissions_pf = % TODO: Production of fuel
emissions_eg = % TODO: Electric grid
emissions_eol = % TODO: End-of-life

% Noise emissions
k2 = 4.259e-1; % s^3/m^3

thrust = vehicle.mass * constants.g; % Rotor thrust
vclimb_segment = find_by_type(mission.segments, 'vertical_climb');

for i = 1 : length(vehicle.components)
    % Pollutant emissions
    if is_type(vehicle.components{i}, 'energy.electric')
        e = vehicle.components{i}.energy * (emissions_pb + emissions_eg + emissions_eol);
        vehicle.components{i}.emissions = e;
    end

    if is_type(vehicle.components{i}, 'energy.fuel')
        e = vehicle.components{i}.energy * (emissions_cf + emissions_pf);
        vehicle.components{i}.emissions = e;
    end

    if is_type(vehicle.components{i}, 'driver.rotor')
        % Vortex noise
        spl = 20 * log10(k2 * vehicle.components{i}.tip_velocity * sqrt(vehicle.components{i}.number * thrust / vehicle.components{i}.rotor_solidity) / mean(vclimb_segment.density) / mean(vclimb_segment.altitude));

        % Rotational noise
        spl = spl + % TODO: Complete

        vehicle.components{i}.sound_pressure_level = spl;
    end
end