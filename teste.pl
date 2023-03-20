sintoma(febre,[dengue,chikungunya,zika,febreMaculosaBrasileira]).
sintoma(dorCorpo,[dengue,chikungunya]).
sintoma(malEstar,[dengue]).
sintoma(manchasVermelhas,[dengue,chikungunya,zika]).
sintoma(malEstar,[dengue]).
sintoma(doresArticulacoes,[dengue,zika]).

sintoma(dorDeCabeca,[chikungunya,febreAmarela,covid,zika,febreMaculosaBrasileira]).
sintoma(erupcaoAvermelhadaPele,chikungunya).

sintoma(perdaDeApetite,[febreAmarela]).
sintoma(dorMuscular,[febreAmarela]).
sintoma(febre,[febreAmarela]).
sintoma(nausea,[febreAmarela]).
sintoma(vomito,[febreAmarela]).

sintoma(contraturasMusculares,[tetanoAcidental]).
sintoma(rigidezBracos,[tetanoAcidental]).
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
sintoma(desorientacao,[alzheimer]).
sintoma(confusao,[alzheimer]).
sintoma(agressividade,[alzheimer]).

input([],[]).
input([SINTOMA|RESTO],Lista):-
    sintoma(SINTOMA,T) -> 
        append(T,T1,Lista),
        input(RESTO,T1) 
    ; 
        input(RESTO,Lista).

count([],K,0).
count([X|Resto],K,N):-
	K=X -> 
        count(Resto,K,T0),N is T0+1
    ; 
        count(Resto,K,N).

countAll([],Lista1,[]).
countAll([K|Resto],Lista,[T0|L]):-
	count(Lista,K,T0),
	countAll(Resto,Lista,L).

% input([febre, dorCorpo], Lista).
% countAll([dengue,chikungunya,zika,febreMaculosaBrasileira,febreAmarela,tetanoAcidental,alzheimer,obesidade,parkinson,covid],[dengue, chikungunya, zika, febreMaculosaBrasileira],R).