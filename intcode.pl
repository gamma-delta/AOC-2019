% Include this file to get intcode capabilities.
:- use_module(library(clpfd)).

%! ic_step(Memory, Pc, MemoryOut, PcOut, Halt)
%! Execute the instruction at the program counter.
%! `Halt` will be `continue` if the program should keep going, or `stop` otherwise.
%  Memory is a Dict.
ic_step(Memory, Pc, MemoryOut, PcOut, Halt) :-
    % writeln(Memory), writeln(Pc),
    Instr = Memory.get(Pc),
    ic_instr(Instr, Memory, Pc, MemoryOut, PcOut, Halt).

%! ic_execute(Memory, Pc, MemoryOut, PcOut)
%  Continually execute until Halt and return the state of the program
ic_execute(Memory, Pc, MemoryOut, PcOut) :- 
    ic_execute(Memory, Pc, MemoryOut, PcOut, continue).

% Keep executing
ic_execute(Memory, Pc, MemoryOut, PcOut, continue) :-
    ic_step(Memory, Pc, NewMemory, NewPc, Halt),
    % do we do the next step?
    ic_execute(NewMemory, NewPc, MemoryOut, PcOut, Halt).

% Nope, stop executing, and just return what I got in
ic_execute(Memory, Pc, Memory, Pc, stop).

%! ic_instr(Code, Memory, Pc, Memory_, Pc_, Halt)
%  Execute the given opcode.

% 1: Add
ic_instr(1, Memory, Pc, MemoryOut, PcOut, Halt) :-
    % Get indices
    Idx1 #= Pc + 1,
    Idx2 #= Pc + 2,
    Idx3 #= Pc + 3,
    IdxAddend1 = Memory.get(Idx1),
    IdxAddend2 = Memory.get(Idx2),
    IdxSum = Memory.get(Idx3),
    % Get values
    Addend1 = Memory.get(IdxAddend1),
    Addend2 = Memory.get(IdxAddend2),
    % Sum
    Sum #= Addend1 + Addend2,
    % And assign
    MemoryOut = Memory.put(IdxSum, Sum),
    % Move the PC by 4
    PcOut #= Pc + 4,
    % And do not halt
    Halt = continue.

% 2: Multiply
ic_instr(2, Memory, Pc, MemoryOut, PcOut, Halt) :-
    % Get indices
    Idx1 #= Pc + 1,
    Idx2 #= Pc + 2,
    Idx3 #= Pc + 3,
    IdxMultiplicand = Memory.get(Idx1),
    IdxMultiplier = Memory.get(Idx2),
    IdxProduct = Memory.get(Idx3),
    % Get values
    Multiplicand = Memory.get(IdxMultiplicand),
    Multiplier = Memory.get(IdxMultiplier),

    Product #= Multiplicand * Multiplier,
    % And assign
    MemoryOut = Memory.put(IdxProduct, Product),
    % Move the PC by 4
    PcOut #= Pc + 4,
    % And do not halt
    Halt = continue.

% 99: Halt
ic_instr(99, Memory, Pc, Memory, Pc, stop).

%! ic_new_memory(Input, Memory)
ic_new_memory(Input, Memory) :-
    % Split on commas
    split_string(Input, ",", "", Split),
    % Map to ints
    maplist(number_string, Ints, Split),
    
    new_memory(Ints, _{}, 0, Memory).

new_memory([Int | Tail], MemoryWIP, Index, Memory) :-
    % Add the new code to the memory
    MemoryWIPMore = MemoryWIP.put(Index, Int),
    % And advance the index. Use the #= to make it evaluate
    NextIndex #= Index + 1,
    new_memory(Tail, MemoryWIPMore, NextIndex, Memory).

% We're done getting ints! Unify the wip memory with the complete memory
% because it's complete now
new_memory([], MemoryWIP, _, MemoryWIP).
