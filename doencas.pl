sintoma(febre,[dengue,chikungunya,zika,febreMaculosaBrasileira]).
sintoma(dorCorpo,[dengue,chikungunya]).
sintoma(malEstar,[dengue]).
sintoma(manchasVermelhas,[dengue,chikungunya,zika]).
sintoma(malEstar,[dengue]).
sintoma(doresArticulacoes,[dengue,zika]).

sintoma(dorDeCabeça,[chikungunya,febreAmarela,covid,zika,febreMaculosaBrasileira]).
sintoma(erupcaoAvermelhadaPele,chikungunya).

sintoma(perdaDeApetite,febreAmarela).
sintoma(dorMuscular,febreAmarela).
sintoma(febre,febreAmarela).
sintoma(nausea,febreAmarela).
sintoma(vomito,febreAmarela).

sintoma(contraturasMusculares,tetanoAcidental).
sintoma(rigidezBraços,tetanoAcidental).
sintoma(rigidezPernas,tetanoAcidental).
sintoma(rigidezAbdominal,tetanoAcidental).
sintoma(dificuldadeAbrirBoca,tetanoAcidental).

sintoma(calafrios,covid).
sintoma(dorDeGarganta,covid).
sintoma(tosse,covid).
sintoma(coriza,covid).
sintoma(faltaDeAr,covid).
sintoma(coriza,covid).

sintoma(coceira,zika).
sintoma(vermelhidaoOlhos,zika).

sintoma(diarreia,febreMaculosaBrasileira).
sintoma(dorCostas,febreMaculosaBrasileira).

sintoma(tremores,parkinson).
sintoma(lentidao,parkinson).

sintoma(apneia,obesidade).
sintoma(ansiedade,obesidade).
sintoma(depressao,obesidade).

sintoma(perdaDeMemoria,alzheimer).
sintoma(depressao,alzheimer).
sintoma(desorientacão,alzheimer).
sintoma(confusao,alzheimer).
sintoma(agressividade,alzheimer).

input([],[]).
input([SINTOMA|RESTO],Lista):-
    sintoma(SINTOMA,T)-> append(T,T1,Lista), input(RESTO,T1); input(RESTO,Lista).


adicionar_paciente(File,Text):-
    random(0,9,Rand),
    open(File,append,Stream),
    write(Stream,Text),write(Stream,' '),write(Stream,Rand), nl(Stream),
    close(Stream).

remover_pacientes(File,Text,id).
