:- use_module(library(plunit)).

%% count(+Lista, +X, ?Y) is semidet
%
% Verdadeiro se Y é o número de vezes que X aparece em Lista.

count([],K,0).
count([X|Resto],K,N):-
	K=X -> 
        count(Resto,K,T0),N is T0+1
    ; 
        count(Resto,K,N).

:- begin_tests(test_count).
test(test_count1) :- count([], dengue, 0).

test(test_count2) :- count([dengue,
                           chikungunya,
                           dengue,
                           chikungunya,
                           dengue,
                           zika],
                           covid,
                           0).

test(test_count3) :- count([dengue,
                           chikungunya,
                           dengue,
                           chikungunya,
                           dengue,
                           zika],
                           dengue,
                           3).

test(test_count4) :- count([dengue,
                           chikungunya,
                           dengue,
                           chikungunya,
                           dengue,
                           zika],
                           chikungunya,
                           2).

test(test_count5) :- count([dengue,
                           chikungunya,
                           dengue,
                           chikungunya,
                           dengue,
                           zika],
                           zika,
                           1).

:- end_tests(test_count).