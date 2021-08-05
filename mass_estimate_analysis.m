% Aircraft design tool
%
% Mario Bras (mbras@uvic.ca) and Ricardo Marques (ricardoemarques@uvic.ca) 2019
%
% This file is subject to the license terms in the LICENSE file included in this distribution

function vehicle = mass_estimate_analysis(mission, vehicle)
global constants;

newton2lbf = 0.224809;
m2ft = 3.28084;
knot2m_s = 0.514444;
deg2rad = 0.017453;
kg2gal = 0.264172;
kg2lb = 2.204622;

cruise_segment = find_by_type(mission.segments, 'cruise');

sea_level_density = 1.225; % kg/m^3
equivalent_velocity = cruise_segment.velocity * sqrt(cruise_segment.density / sea_level_density);

int_fuel_percentage = 1; % Percentage of integral fuel tanks
n = 1.5; % Load factor
ac_present = true;
furnishings_present = true;
electrical_present = true;
surface_controls = true;
Avionics_mass_pure= 100; % kg
Avionics_mass = 2.117*(Avionics_mass_pure^0.933);

% Accumulate total fuel mass and number of fuel tanks
total_fuel_mass = 0;
number_fuel_tanks = 0;
for i = 1 : length(vehicle.components)
    if is_type(vehicle.components{i}, 'energy.fuel')
        total_fuel_mass = total_fuel_mass + vehicle.components{i}.mass;
        number_fuel_tanks = number_fuel_tanks + 1;
    end
end

number_engines = 0;
for i = 1 : length(vehicle.components)
    if (is_type(vehicle.components{i}, 'energy.prop') || is_type(vehicle.components{i}, 'engine.jet'))
        total_engine_mass = total_engine_mass + vehicle.components{i}.mass;
        number_engines = number_engines + 1;
    end
end

for i = 1 : length(vehicle.components)
    if is_type(vehicle.components{i}, 'fuselage')
        
        vehicle.components{i}.mass = 200 * ((vehicle.mass * constants.g * newton2lbf * n / 10^5)^0.286 * (vehicle.components{i}.length * m2ft / 10)^0.857 * (2 * vehicle.components{i}.diameter * m2ft) * (equivalent_velocity * knot2m_s/ 100)^0.338)^1.1 / newton2lbf / constants.g; % kg

        if (electrical_present || ac_present)
           
             %vehicle.components{i}.mass = vehicle.components{i}.mass + ; % Electronics

            if (electrical_present)
               
                 vehicle.components{i}.mass = vehicle.components{i}.mass + 426*(((total_fuel_mass*kg2lb+Avionics_mass*kg2lb)/100)^0.1);
          
            end

            if (ac_present)
               
                 vehicle.components{i}.mass = vehicle.components{i}.mass + 0.265 *((vehicle.mass * constants.g * newton2lbf)^0.52)*(5^0.68)*((Avionics_mass*kg2gal)^0.17)*(equivalent_velocity * knot2m_s/ 343)^0.08  ;
           
            end
       
        end

        if (furnishings_present)
           
            %vehicle.components{i}.mass = vehicle.components{i}.mass +34.5*1*(q)^0.25 ;
        
        end
        
    elseif is_type(vehicle.components{i}, 'wing.main')
        
        vehicle.components{i}.mass = 96.948*((vehicle.mass * constants.g * newton2lbf * n / 10^5)^0.65*(vehicle.components{i}.aspect_ratio/cos(vehicle.components{i}.sweep_le))^0.57*(((((vehicle.components{i}.aspect_ratio*m2ft)*(vehicle.components{i}.mean_chord*m2ft))^2)/100)^0.61)*(((1+0.667)/((2*vehicle.components{i}.airfoil.tc_max)))^0.36)*((1+(equivalent_velocity * knot2m_s/500))^0.5)^0.993)/ newton2lbf / constants.g;
       
       if (surface_controls == true)
         
            if (surface_controls == 1)

            %vehicle.components{i}.mass = vehicle.components{i}.mass + 1.08(vehicle.mass * constants.g * newton2lbf)^0.7 ; % Surface controls

            else

            %vehicle.components{i}.mass = vehicle.components{i}.mass + 1.066(vehicle.mass * constants.g * newton2lbf)^0.626 ; % Surface controls

            end
        end
   
    elseif is_type(vehicle.components{i}, 'wing.htail')
        
         vehicle.components{i}.mass = 127*(((vehicle.mass * constants.g * newton2lbf * n / 10^5)^0.87)*(((((vehicle.components{i}.aspect_ratio*m2ft)*(vehicle.components{i}.mean_chord*m2ft))^2)/100)^1.2)*((8.5*m2ft/10)^0.483)*(((vehicle.components{i}.aspect_ratio*m2ft)*(vehicle.components{i}.mean_chord*m2ft*vehicle.components{i}.mean_chord*m2ft)/vehicle.components{i}.airfoil.tc_max*m2ft)^0.5))^0.458/ newton2lbf / constants.g;
    
    elseif is_type(vehicle.components{i}, 'wing.vtail')
      
         vehicle.components{i}.mass = 98.5*(((vehicle.mass * constants.g * newton2lbf * n / 10^5)^0.87)*(((((vehicle.components{i}.aspect_ratio*m2ft)*(vehicle.components{i}.mean_chord*m2ft))^2)/100)^1.2)*(((vehicle.components{i}.aspect_ratio*m2ft)*(vehicle.components{i}.mean_chord*m2ft)/vehicle.components{i}.mean_chord*m2ft*vehicle.components{i}.mean_chord*m2ft)^0.5))^0.5/ newton2lbf / constants.g;
   
    elseif is_type(vehicle.components{i}, 'wing.vtail')
      
         vehicle.components{i}.mass = 98.5*(((vehicle.mass * constants.g * newton2lbf * n / 10^5)^0.87)*(((((vehicle.components{i}.aspect_ratio*m2ft)*(vehicle.components{i}.mean_chord*m2ft))^2)/100)^1.2)*(((vehicle.components{i}.aspect_ratio*m2ft)*(vehicle.components{i}.mean_chord*m2ft)/vehicle.components{i}.mean_chord*m2ft*vehicle.components{i}.mean_chord*m2ft)^0.5))^0.5/ newton2lbf / constants.g;
    
    elseif (is_type(vehicle.components{i}, 'engine.prop') || is_type(vehicle.components{i}, 'engine.jet'))
      
         vehicle.components{i}.mass = 2.49*(((total_fuel_mass*kg2gal)^0.6)*((1/(1+1))^0.3)*(number_fuel_tanks^0.2)*(number_engines^0.13))^1.21/ newton2lbf / constants.g;
   
    end
end
end
