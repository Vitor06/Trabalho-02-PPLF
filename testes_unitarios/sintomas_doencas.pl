%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Doenças por sintoma
sintoma(febre,[dengue,chikungunya,zika,febreMaculosaBrasileira,febreAmarela]).
sintoma(dorCorpo,[dengue,chikungunya]).
sintoma(malEstar,[dengue]).
sintoma(manchasVermelhas,[dengue,chikungunya,zika]).
sintoma(doresArticulacoes,[dengue,zika]).

sintoma(dorDeCabeca,[chikungunya,febreAmarela,covid,zika,febreMaculosaBrasileira]).
sintoma(erupcaoAvermelhadaPele,[chikungunya]).

sintoma(perdaDeApetite,[febreAmarela]).
sintoma(dorMuscular,[febreAmarela]).
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

sintoma(coceira,[zika]).
sintoma(vermelhidaoOlhos,[zika]).

sintoma(diarreia,[febreMaculosaBrasileira]).
sintoma(dorCostas,[febreMaculosaBrasileira]).

sintoma(tremores,[parkinson]).
sintoma(lentidao,[parkinson]).

sintoma(apneia,[obesidade]).
sintoma(ansiedade,[obesidade]).
sintoma(depressao,[obesidade, alzheimer]).

sintoma(perdaDeMemoria,[alzheimer]).
sintoma(desorientacao,[alzheimer]).
sintoma(confusao,[alzheimer]).
sintoma(agressividade,[alzheimer]).