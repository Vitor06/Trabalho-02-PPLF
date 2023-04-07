:- consult(sintomas_doencas).
:- use_module(library(plunit)).

%% input(+Sintomas, -Doencas) is det
%
% Verdadeiro se, para cada doença que possui sintoma em Sintomas associado,
% a doença é adiciona em Doenças, podendo ser adicionado de forma repetida

input([], []).
input([Sintoma | Resto], Lista):-
    sintoma(Sintoma, T) -> 
        append(T, T1, Lista),
        input(Resto, T1) 
    ; 
        input(Resto, Lista).

:- begin_tests(test_input).
test(test_input1) :- input([], []).

test(test_input2) :- input([febre],
                           [dengue,
                           chikungunya,
                           zika,
                           febreMaculosaBrasileira,
                           febreAmarela]).

test(test_input3) :- input([febre, dorCorpo],
                           [dengue,
                           chikungunya,
                           zika,
                           febreMaculosaBrasileira,
                           febreAmarela,
                           dengue,
                           chikungunya]).

:- end_tests(test_input).