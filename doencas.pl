sintoma(febre,[dengue,chikungunya,zika,febreMaculosaBrasileira]).
sintoma(dorCorpo,[dengue,chikungunya]).
sintoma(malEstar,[dengue]).
sintoma(manchasVermelhas,[dengue,chikungunya,zika]).
sintoma(malEstar,[dengue]).
sintoma(doresArticulacoes,[dengue,zika]).

sintoma(dorDeCabeça,[chikungunya,febreAmarela,covid,zika,febreMaculosaBrasileira]).
sintoma(erupcaoAvermelhadaPele,chikungunya).

sintoma(perdaDeApetite,[febreAmarela]).
sintoma(dorMuscular,[febreAmarela]).
sintoma(febre,[febreAmarela]).
sintoma(nausea,[febreAmarela]).
sintoma(vomito,[febreAmarela]).

sintoma(contraturasMusculares,[tetanoAcidental]).
sintoma(rigidezBraços,[tetanoAcidental]).
sintoma(rigidezPernas,[tetanoAcidental]).
sintoma(rigidezAbdominal,[tetanoAcidental]).
sintoma(dificuldadeAbrirBoca,[tetanoAcidental]).

sintoma(calafrios,[covid]).
sintoma(dorDeGarganta,[covid]).
sintoma(tosse,[covid]).
sintoma(coriza,[covid]).
sintoma(faltaDeAr,[covid]).
sintoma(coriza,[covid]).

sintoma(coceira,[zika]).
sintoma(vermelhidaoOlhos,[zika]).

sintoma(diarreia,[febreMaculosaBrasileira]).
sintoma(dorCostas,[febreMaculosaBrasileira]).

sintoma(tremores,[parkinson]).
sintoma(lentidao,[parkinson]).

sintoma(apneia,[obesidade]).
sintoma(ansiedade,[obesidade]).
sintoma(depressao,[obesidade]).

sintoma(perdaDeMemoria,[alzheimer]).
sintoma(depressao,[alzheimer]).
sintoma(desorientacão,[alzheimer]).
sintoma(confusao,[alzheimer]).
sintoma(agressividade,[alzheimer]).

input([],[]).
count([],K,0).

count([X|Resto],K,N):-
	K=X -> count(Resto,K,T0),N is T0+1 ; count(Resto,K,N).

countAll([],Lista1,[]).
countAll([K|Resto],Lista,[T0|L]):-
	count(Lista,K,T0),
	countAll(Resto,Lista,L).


input([SINTOMA|RESTO],Lista):-
    sintoma(SINTOMA,T)-> append(T,T1,Lista), input(RESTO,T1); input(RESTO,Lista).

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
     Pesos = [0.886,0.178,0.00573,0.001,0.002,0.056,0.1,0.4,0.01,0.49],
     input(Sintomas,Lista),
     countAll([dengue,chikungunya,zika,febreMaculosaBrasileira,febreAmarela,tetanoAcidental,alzheimer,obesidade,parkinson,covid],Lista,R),
     sumlist(R,Total),
     calcular(R,Total,P,Pesos),
     resultado([dengue,chikungunya,zika,febreAmarela,febreMaculodaBrasileira,tetanoAcidental,alzheimer,obesidade,parkinson,covid],P).





adicionar_paciente(File,Text):-
    random(0,9,Rand),
    open(File,append,Stream),
    write(Stream,Text),write(Stream,' '),write(Stream,Rand), nl(Stream),
    close(Stream).


remover_pacientes(File,Text,id).
