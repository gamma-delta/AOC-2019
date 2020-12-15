:- ensure_loaded('../aoc_prelude').
:- ensure_loaded('../intcode').

:- use_module(library(clpfd)).

part1(Answer) :- 
    % Get input
    read_input([Ints | _]),
    % Make it into memory
    ic_new_memory(Ints, MemoryUnfixed),
    % Change the addresses
    Memory = MemoryUnfixed.put(1, 12).put(2, 2),
    % Execute
    ic_execute(Memory, 0, NewMemory, _),
    % And get the output
    Answer = NewMemory.get(0).

part2(Answer) :- 
    % Get input
    read_input([Ints | _]),
    % Make it into memory
    ic_new_memory(Ints, MemoryUnfixed),
    % We are looking for Val1 and Val2
    change_addresses(MemoryUnfixed, Memory, Noun, Verb),
    % Execute
    ic_execute(Memory, 0, NewMemory, _),
    % Verify the output
    19690720 #= NewMemory.get(0),
    % and get the answer
    Answer #= 100 * Noun + Verb.

% Change up addresses 1 and 2 of memory
change_addresses(Memory, MemoryOut, Val1, Val2) :-
    0 #=< Val1, Val1 #=< 99, 0 #=< Val2, Val2 #=< 99, 
    MemoryOut = Memory.put(1, Val1).put(2, Val2).