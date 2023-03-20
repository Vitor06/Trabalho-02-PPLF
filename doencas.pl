:- consult(sintomas_doencas).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Lógica Principal

count([],K,0).
count([X|Resto],K,N):-
	K=X -> count(Resto,K,T0),N is T0+1 ; count(Resto,K,N).

countAll([],Lista1,[]).
countAll([K|Resto],Lista,[T0|L]):-
	count(Lista,K,T0),
	countAll(Resto,Lista,L).

input([],[]).
input([SINTOMA|RESTO],Lista):-
    sintoma(SINTOMA,T) -> 
        append(T,T1,Lista),
        input(RESTO,T1) 
    ; 
        input(RESTO,Lista).

calcular([],T,[],[]).
calcular([X|Resto],Total,[T|L],[Peso|RestoPeso]):-
	T is (X /Total)*Peso*100,
	calcular(Resto,Total,L,RestoPeso).

ordenar([],X,[]).
ordenar([P|R],ProbabilidadesAux,[I|K]):-
	sort(0,@>=,ProbabilidadesAux,O),
	nth0(I,O,P),
	ordenar(R,ProbabilidadesAux,K).

resultado([],[]).
resultado([Doenca|Resto],[X|R]):-

	write(Doenca),write(->), write(X), write("%"),nl,nl,
	resultado(Resto,R).


main(Sintomas,Lista,P):-
    %% Pesos referentes a cada doença
    Pesos = [0.886,0.178,0.00573,0.001,0.002,0.056,0.1,0.4,0.01,0.49],
    input(Sintomas,Lista),
    % print(Lista),
    countAll([dengue,chikungunya,zika,febreMaculosaBrasileira,febreAmarela,
        tetanoAcidental,alzheimer,obesidade,parkinson,covid],Lista,R),
    % print(R),
    sumlist(R,Total),
    calcular(R,Total,P,Pesos),
    resultado([dengue,chikungunya,zika,febreAmarela,febreMaculodaBrasileira,
        tetanoAcidental,alzheimer,obesidade,parkinson,covid],P).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Interação Humano-Computador

adicionar_paciente(Nome):-
    random(0,9,Rand),
    open('pacientes.txt',append,Stream),
    write(Stream,Nome),write(Stream,' '),write(Stream,Rand), nl(Stream),
    close(Stream).

consultar_paciente(Id).

consultar_paciente(Id, Nome).

remover_pacientes(Id).

% main([febre, dorCorpo], Lista, P).
