:- consult(testes_unitarios/sintomas_doencas).
:- use_module(library(pairs)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Lógica Principal

main(Sintomas,Lista,P) :-
    Doencas = [dengue,chikungunya,zika,febreMaculosaBrasileira,febreAmarela,
               tetanoAcidental,alzheimer,obesidade,parkinson,covid],

    %% Pesos referentes a cada doença
    Pesos = [0.886,0.178,0.00573,0.001,0.002,0.056,0.1,0.4,0.01,0.49],

    %% Buscar doenças relacionadas com sintomas
    input(Sintomas,Lista),

    %% Contar quantas vezes cada doença está relacionada com um sintoma
    countAll(Doencas, Lista, R),

    %% Calcular doenças mais prováveis
    sumlist(R,Total),
    calcular(R,Total,P,Pesos),

    %% Corrigir o cálculo para somar 100%
    sumlist(P, Total2),
    calcular(P, Total2, P2, [1,1,1,1,1,1,1,1,1,1]),

    %% Ordenar doenças das mais prováveis para menos
    pairs_keys_values(Pairs, P2, Doencas),
    keysort(Pairs, PairsSorted),
    pairs_keys_values(PairsSorted, PorcentagensSorted, DoencasSorted),
    reverse(DoencasSorted, DoencasSortedReverse),
    reverse(PorcentagensSorted, PorcentagensSortedReverse),

    %% Imprimir resultado na tela
    write('---------- Resultado da Consulta ----------\n'),
    resultado(DoencasSortedReverse, PorcentagensSortedReverse),
    write('Obs: o resultado do prototipo e apenas informativo. E necessario
     consultar um medico para obter um diagnostico correto e preciso.\n\n'),
    write(
        'Deseja obter mais informacoes sobre a doenca diagnosticada (s/n): '),
    read(MaisInformacoes),
    get_char(_),  % Limpar \n
    MaisInformacoes == s ->
        (nth0(0, DoencasSortedReverse, DoencaDiagnosticada),
        doenca_sintomas(DoencaDiagnosticada, SintomasDoencaDiagnosticada),
        write('\n'),
        write('Sintomas da doenca '), write(DoencaDiagnosticada), write(': '),
        atomic_list_concat(SintomasDoencaDiagnosticada, ', ', 
            SintomasDoencaDiagnosticadaFormatados),
        write(SintomasDoencaDiagnosticadaFormatados),
        write('\n\n'))
    ;
        write('\n').

%% Regras auxilirares
count([],_,0).
count([X|Resto],K,N):-
	K=X -> count(Resto,K,T0),N is T0+1 ; count(Resto,K,N).

countAll([],_,[]).
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

calcular([],_,[],[]).
calcular([X|Resto],Total,[T|L],[Peso|RestoPeso]):-
	T is (X /Total)*Peso*100,
	calcular(Resto,Total,L,RestoPeso).

ordenar([],_,[]).
ordenar([P|R],ProbabilidadesAux,[I|K]):-
	sort(0,@>=,ProbabilidadesAux,O),
	nth0(I,O,P),
	ordenar(R,ProbabilidadesAux,K).

resultado([],[]).
resultado([Doenca|Resto],[X|R]):-
    format(atom(XArredondado), '~1f', [X]),
	write(Doenca),write(->), write(XArredondado), write("%"),nl,nl,
	resultado(Resto,R).

imprimirLista([]).
imprimirLista([Head | Tail]) :-
    write('    '), write(Head), write('\n'),
    imprimirLista(Tail).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Interação Humano-Computador

main_menu :-
    Opcoes = ['Sair', 
              'Fazer diagnostico',
              'Inserir paciente',
              'Ler informacoes paciente',
              'Atualizar paciente',
              'Remover paciente'],
    write('---------- Menu de Acoes ----------\n'),
    imprimir_opcoes(Opcoes, Opcao, 0),
    (Opcao == 0 -> false ; true),  % Sair retorna false

    (Opcao == 1 -> % Fazer consulta de doencas
        (exists_file('pacientes.txt') -> 
            (escolher_id_sintomas(Id, Sintomas) ->
                length(Sintomas, Length),
                (Length \= 0 ->
                    main(Sintomas, _, _),
                    atualizar_paciente_sintomas(Id, Sintomas)
                ;
                    write('Selecione um sintoma!\n\n'))
            ;
                true)
        ;
            write('Nenhum paciente cadastrado!\n\n'))

    ; Opcao == 2 -> % Inserir paciente
        (escolher_nome(Nome) -> 
            inserir_paciente(Nome)
        ; 
            true)

    ; Opcao == 3 -> % Ler paciente
        (exists_file('pacientes.txt') ->
            (escolher_id(Id) -> 
                ler_paciente(Id)
            ;
                true)
        ;
            write('Nenhum paciente cadastrado!\n\n'))

    ; Opcao == 4 -> % Atualizar paciente
        (exists_file('pacientes.txt') ->
            (escolher_id_nome(Id, Nome) ->
                atualizar_paciente_nome(Id, Nome)
            ;
                true)
        ;
            write('Nenhum paciente cadastrado!\n\n'))

    ; Opcao == 5 -> % Remover paciente
        (exists_file('pacientes.txt') ->
            (escolher_id(Id) ->
                remover_paciente(Id) 
            ;
                true)
        ;
            write('Nenhum paciente cadastrado!\n\n'))
    ; 
        write('Opcao invalida!\n\n')),
        
    main_menu.

%% CRUD
inserir_paciente(Nome) :-
    open('pacientes.txt', append, Stream),
    write(Stream, Nome),
    write(Stream, '|'),
    nl(Stream),
    close(Stream).

ler_paciente(Id) :-
    pacientes_to_list(Pacientes),
    nth0(Id, Pacientes, Paciente),
    split_string(Paciente, "|", "", PacienteContents),

    PacienteContents = [Nome | Consultas],
    write('---------- Consultas do paciente '),
    write(Nome),
    write(' ----------\n'),
    ler_pacientes_aux(Consultas).

atualizar_paciente_nome(Id, Nome) :-
    pacientes_to_list(Pacientes),

    nth0(Id, Pacientes, Paciente),
    split_string(Paciente, "|", "", PacienteContents),

    PacienteContents = [NomeAnterior | _],
    select(NomeAnterior, PacienteContents, Nome, PacienteAtualizado1),
    atomic_list_concat(PacienteAtualizado1, "|", PacienteAtualizado2),
    select(Paciente, Pacientes, PacienteAtualizado2, PacientesAtualizado),

    open('pacientes.txt', write, FileAtualizado),
    list_to_file(PacientesAtualizado, FileAtualizado),
    close(FileAtualizado).

atualizar_paciente_sintomas(Id, Sintomas) :-
    get_time(TimeStamp),
    NovaConsulta = [TimeStamp | Sintomas],
    atomic_list_concat(NovaConsulta, ',', NovaConsultaFormatada1),
    string_concat(NovaConsultaFormatada1, '|', NovaConsultaFormatada2),
    pacientes_to_list(Pacientes),
    nth0(Id, Pacientes, Paciente),
    string_concat(Paciente, NovaConsultaFormatada2, PacienteAtualizado),

    select(Paciente, Pacientes, PacienteAtualizado, PacientesAtualizado),

    open('pacientes.txt', write, FileAtualizado),
    list_to_file(PacientesAtualizado, FileAtualizado),
    close(FileAtualizado).

remover_paciente(Id) :-
    pacientes_to_list(Pacientes),
    (length(Pacientes, 1) ->
        delete_file('pacientes.txt')
    ;
        delete(Pacientes, "", PacientesContents),
        valid_list_index(PacientesContents, Id),
        nth0(Id, Pacientes, Elem),
        delete(Pacientes, Elem, PacientesAtualizado),
        delete_file('pacientes.txt'),
        open('pacientes.txt', write, FileAtualizado),
        list_to_file(PacientesAtualizado, FileAtualizado),
        close(FileAtualizado)).

%% Regras auxiliares
list_to_file([], _).
list_to_file([Head | Tail], File) :-
    write(File, Head),
    nl(File),
    list_to_file(Tail, File).

pacientes_to_list(PacientesContents) :-
    setup_call_cleanup(open('pacientes.txt', read, In),
       pacientes_to_list_aux(In, Lines),
       close(In)),
    delete(Lines, "", PacientesContents).
pacientes_to_list_aux(In, Lines) :-
    read_string(In, _, Str),
    split_string(Str, "\n", "", Lines).

valid_list_index(List, Index) :-
    length(List, ListLength),
    Index >= 0,
    Index < ListLength.

imprimir_opcoes([], Opcao, _) :-
    write('\nDigite: '),
    read(Opcao),
    get_char(_),  % Limpar \n
    write('\n').
imprimir_opcoes([Head | Tail], Opcao, CountStart) :-
    write(CountStart),
    write(' - '),
    write(Head),
    write('\n'),

    CountStartAtualizado is CountStart + 1,
    imprimir_opcoes(Tail, Opcao, CountStartAtualizado).

pacientes_nomes([], NomesTail) :- 
    NomesTail = [].
pacientes_nomes([LinesHead | LinesTail], Nomes) :-
    split_string(LinesHead, "|", "", PacienteCampos),
    nth0(0, PacienteCampos, Nome),
    Nomes = [Nome | NomesTail],
    pacientes_nomes(LinesTail, NomesTail).

escolher_id_sintomas(Id, Escolhidos) :-
    Sintomas = [febre, dorCorpo, malEstar, manchasVermelhas, malEstar, 
                doresArticulacoes, dorDeCabeca, erupcaoAvermelhadaPele, 
                perdaDeApetite, dorMuscular, nausea, vomito, 
                contraturasMusculares, rigidezBracos, rigidezPernas,
                rigidezAbdominal, dificuldadeAbrirBoca, calafrios,
                dorDeGarganta, tosse, coriza, faltaDeAr, coriza, coceira,
                vermelhidaoOlhos, diarreia, dorCostas, tremores, lentidao,
                apneia, ansiedade, depressao, perdaDeMemoria, depressao,
                desorientacao, confusao, agressividade],

    escolher_id(Id) ->
        (escolher_sintomas(Sintomas, Escolhidos, []) ->
            true
        ;
            escolher_id_sintomas(Id, Escolhidos)).

escolher_sintomas(Sintomas, Escolhidos, Acumulador) :-
    append(['Voltar', 'Continuar'], Sintomas, Opcoes),

    write('---------- Menu de Sintomas ----------\n'),
    atomic_list_concat(Acumulador, ', ', AcumuladorFormatado),
    write('Selecionados: '), write(AcumuladorFormatado), write('\n\n'),
    imprimir_opcoes(Opcoes, Opcao, 0),

    Opcao \= 0,
    (nth0(Opcao, Opcoes, Sintoma) -> true ; true),
    
    (valid_list_index(Opcoes, Opcao) ->
        (Sintoma \= 'Continuar' ->
            (nth0(Opcao, Opcoes, Escolhido),
            Escolhidos = [Escolhido | RestoEscolhidos],
            delete(Sintomas, Escolhido, SintomasDisponiveis),
            append(Acumulador, [Sintoma], AcumuladorAux),
            escolher_sintomas(SintomasDisponiveis, RestoEscolhidos, 
                AcumuladorAux))
        ;
            Escolhidos = [])
    ;
        (write('Opcao invalida!\n\n'),
            escolher_sintomas(Sintomas, Escolhidos, Acumulador))).

        

escolher_nome(Nome) :- 
    write('0 - Voltar\nEscolha um nome (entre \'\'): '),
    read(Nome),
    get_char(_),  % Limpar \n
    write('\n'),

    Nome \= 0.

escolher_id(Id) :-
    pacientes_to_list(Lines),
    pacientes_nomes(Lines, Nomes),
    append(['Voltar'], Nomes, Opcoes),
    write('---------- Menu de Pacientes ----------\n'),
    imprimir_opcoes(Opcoes, Opcao, 0),
    Opcao \= 0,
    (\+ valid_list_index(Opcoes, Opcao)  ->
        write('Opcao invalida!\n\n'),
        escolher_id(Id)
    ;
        Id is Opcao - 1).

escolher_id_nome(Id, Nome) :-
    escolher_id(Id) ->
        (escolher_nome(Nome) -> 
            true
        ; 
            escolher_id_nome(Id, Nome)).

ler_pacientes_aux("") :-
    write('Nenhuma consulta encontrada!\n').
ler_pacientes_aux([""]).
ler_pacientes_aux(Consultas) :-
    [ConsultaAtual | RestoConsultas] = Consultas,
    split_string(ConsultaAtual, ",", "", Campos),
    Campos = [TimeStampString | Sintomas],
    number_string(TimeStampFloat, TimeStampString),
    stamp_date_time(TimeStampFloat, DateTime, 'UTC'),
    DateTime = date(Y, M, D, H, Min, Sec, _, _, _),
    HBrazil is (H - 3) mod 24,
    round(Sec, SecInt),
    format(atom(DFormated), '~|~`0t~d~2+', [D]),
    format(atom(MFormated), '~|~`0t~d~2+', [M]),
    format(atom(HFormated), '~|~`0t~d~2+', [HBrazil]),
    format(atom(MinFormated), '~|~`0t~d~2+', [Min]),
    format(atom(SecFormated), '~|~`0t~d~2+', [SecInt]),
    write('Consulta do dia '),
    write(DFormated), write('/'),
    write(MFormated), write('/'),
    write(Y), write(', as '),
    write(HFormated), write(':'),
    write(MinFormated), write(':'),
    write(SecFormated), write(' horas: '),
    ler_pacientes_aux2(Sintomas),
    ler_pacientes_aux(RestoConsultas).
ler_pacientes_aux2([]).
ler_pacientes_aux2(Sintomas) :-
    [Sintoma | RestoSintomas] = Sintomas,
    write(Sintoma),
    (RestoSintomas \= [] ->
        write(', ')
    ;
        write('\n\n')),

    ler_pacientes_aux2(RestoSintomas).

% main([febre, perdaDeMemoria], Lista, P).
