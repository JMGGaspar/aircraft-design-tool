% Aircraft design tool
%
% Mario Bras (mbras@uvic.ca) and Ricardo Marques (ricardoemarques@uvic.ca) 2019
%
% This file is subject to the license terms in the LICENSE file included in this distribution

function vehicle = cg_analysis(mission, vehicle)
vehicle_mass = sum_masses(vehicle);
for i = 1 : length(mission.segments)
    [~, vehicle_segment_id] = find_by_name(vehicle.segments, mission.segments{i}.name);
    for j = 1 : length(vehicle.components)
        if (isfield(vehicle.components{j}, 'position'))
            vehicle.segments{vehicle_segment_id}.cg_position = vehicle.segments{vehicle_segment_id}.cg_position + vehicle.components{j}.mass * vehicle.components{j}.position;
        end
    end
    vehicle.segments{vehicle_segment_id}.cg_position = vehicle.segments{vehicle_segment_id}.cg_position / vehicle_mass;
end
