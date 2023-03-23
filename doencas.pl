:- consult(testes_unitarios/sintomas_doencas).
:- use_module(library(pairs)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Lógica Principal

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


get_nome_pacientes(Nome):-
	read(Nome).
insere_barra([],[]).
insere_barra([X|Resto],[S|R]):-

       string_concat(X,'|',S),
       insere_barra(Resto,R).


main(Sintomas,Lista,P):-
    get_nome_pacientes(Nome),

    insere_barra(Sintomas,SintomasResult),
    atomics_to_string(SintomasResult,S),
    string_concat(Nome,'|',NomeResult),
    string_concat(NomeResult,S,Resultado),


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
    resultado(DoencasSortedReverse, PorcentagensSortedReverse),
   [Doenca|_] = DoencasSortedReverse,
   string_concat(Resultado,Doenca,PacienteCompleto),

    inserir_paciente(PacienteCompleto).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Interação Humano-Computador

%% Regras auxiliares
list_to_file([""], File).
list_to_file([Head | Tail], File) :-
    write(File, Head),
    nl(File),
    list_to_file(Tail, File).

file_lines(File, Lines) :-
    setup_call_cleanup(open(File, read, In),
       stream_lines(In, Lines),
       close(In)).

stream_lines(In, Lines) :-
    read_string(In, _, Str),
    split_string(Str, "\n", "", Lines).

check_id_exist(Id) :-
    exists_file('pacientes.txt'),
    file_lines('pacientes.txt', Lines),
    length(Lines, LinesAmount),
    IdsAmounts is LinesAmount - 1,
    Id >= 0,
    Id < IdsAmounts.

%% CRUD
inserir_paciente(Nome) :-
    open('pacientes.txt', append, Stream),
    write(Stream, Nome),
    nl(Stream),
    close(Stream).

remover_paciente(Id) :-
    check_id_exist(Id),
    file_lines('pacientes.txt', Lines),
    nth0(Id, Lines, Elem),
    delete(Lines, Elem, LinesAtualizado),
    delete_file('pacientes.txt'),
    open('pacientes.txt', write, FileAtualizado),
    list_to_file(LinesAtualizado, FileAtualizado),
    close(FileAtualizado).

% main([febre, perdaDeMemoria], Lista, P).
