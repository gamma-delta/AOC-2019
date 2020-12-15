:- use_module(library(clpfd)).
:- include('../aoc_prelude').


fuelRequired(Mass, Fuel) :-
    % make sure there is no negative fuel
    Fuel #= max(Mass div 3 - 2, 0).

% if there is 0 mass, 0 fuel.
fuelRequiredButFuelHasMass(0, Fuel) :-
    Fuel #= 0.
% otherwise, calculate...
fuelRequiredButFuelHasMass(Mass, Fuel) :-
    % Here's the fuel required to lift the payload...
    fuelRequired(Mass, PayloadFuel),
    % But that fuel also requires fuel...
    fuelRequiredButFuelHasMass(PayloadFuel, FuelFuel),
    % The total fuel is the fuel for the payload,
    % and the fuel for the fuel.
    Fuel #= PayloadFuel + FuelFuel.


allFuelRequired(ModuleMasses, Sum) :-
    % Get the masses of each module
    maplist(fuelRequired, ModuleMasses, FuelAmounts),
    foldl((plus), FuelAmounts, 0, Sum).

part1(Answer) :- 
    read_input(Lines),
    % Map into numbers
    maplist(number_string, ModuleMasses, Lines),
    
    % and the answer
    allFuelRequired(ModuleMasses, Answer).
    

part2(Answer) :- 
    read_input(Lines),
    % Map into numbers
    maplist(number_string, ModuleMasses, Lines),
    % Get the mass of fuel required for the fuel and the payload
    maplist(fuelRequiredButFuelHasMass, ModuleMasses, FuelAmounts),
    foldl((plus), FuelAmounts, 0, Answer).