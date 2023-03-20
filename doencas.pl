:- consult(testes_unitarios/sintomas_doencas).
:- use_module(library(pairs)).

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
    format(atom(XArredondado), '~1f', [X]),
	write(Doenca),write(->), write(XArredondado), write("%"),nl,nl,
	resultado(Resto,R).


main(Sintomas,Lista,P):-
    %% Pesos referentes a cada doença
    Pesos = [0.886,0.178,0.00573,0.001,0.002,0.056,0.1,0.4,0.01,0.49],

    %% Buscar doenças relacionadas com sintomas
    input(Sintomas,Lista),

    %% Contar quantas vezes cada doença está relacionada com um sintoma
    countAll([dengue,chikungunya,zika,febreMaculosaBrasileira,febreAmarela,
        tetanoAcidental,alzheimer,obesidade,parkinson,covid],Lista,R),

    %% Calcular doenças mais prováveis
    sumlist(R,Total),
    calcular(R,Total,P,Pesos),

    %% Corrigir o cálculo para somar 100%
    sumlist(P, Total2),
    calcular(P, Total2, P2, [1,1,1,1,1,1,1,1,1,1]),

    %% Ordenar doenças das mais prováveis para menos
    pairs_keys_values(Pairs, P2, [dengue,chikungunya,zika,febreAmarela,
        febreMaculodaBrasileira,tetanoAcidental,alzheimer,obesidade,
        parkinson,covid]),
    keysort(Pairs, PairsSorted),
    pairs_keys_values(PairsSorted, PorcentagensSorted, DoencasSorted),
    reverse(DoencasSorted, DoencasSortedReverse),
    reverse(PorcentagensSorted, PorcentagensSortedReverse),

    %% Imprimir resultado na tela
    resultado(DoencasSortedReverse, PorcentagensSortedReverse).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Interação Humano-Computador

adicionar_paciente(File,Text):-
    random(0,9,Rand),
    open(File,append,Stream),
    write(Stream,Text),write(Stream,' '),write(Stream,Rand), nl(Stream),
    close(Stream).


consultar_paciente(Id,File):-
	open(File,read,Stream),
	get_char(Stream,Char1),
	proximo(Char1,Stream,[Char1],Id),
	close(Stream).

comparar(Palavra,Id):-
	 atomics_to_string(Palavra,S),
	 S=Id,
	 !.

proximo(end_of_file,_,_,_):-!.
proximo(Char,Stream,Lista,Id):-
	write(Char),
	get_char(Stream,Char2),
	Char2 \= '\n'->append(Lista,[Char2],L),proximo(Char2,Stream,L,Id);
	comparar(Lista,Id);nl, proximo('',Stream,[],Id).

consultar_paciente(Id, Nome).

remover_pacientes(Id).

% main([febre, perdaDeMemoria], Lista, P).
