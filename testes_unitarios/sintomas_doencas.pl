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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Sintomas por doença

doenca_sintomas(dengue, 
    [febre, dorCorpo, malEstar, manchasVermelhas, doresArticulacoes]).

doenca_sintomas(chikungunya, 
    [dorDeCabeca, erupcaoAvermelhadaPele, febre, dorCorpo, manchasVermelhas]).

doenca_sintomas(febreAmarela, 
    [perdaDeApetite, dorMuscular, nausea, vomito, febre, dorDeCabeca]).

doenca_sintomas(tetanoAcidental, 
    [contraturasMusculares, rigidezBracos, rigidezPernas, rigidezAbdominal, 
     dificuldadeAbrirBoca]).

doenca_sintomas(covid, 
    [calafrios, dorDeGarganta, tosse, coriza, faltaDeAr, dorDeCabeca]).

doenca_sintomas(zika, 
    [coceira, vermelhidaoOlhos, febre, manchasVermelhas, doresArticulacoes, 
     dorDeCabeca]).

doenca_sintomas(febreMaculosaBrasileira, 
    [diarreia, dorCostas, febre, dorDeCabeca]).

doenca_sintomas(parkinson, 
    [tremores, lentidao]).

doenca_sintomas(obesidade, 
    [apneia, ansiedade, depressao]).

doenca_sintomas(alzheimer, 
    [perdaDeMemoria, desorientacao, confusao, agressividade, depressao]).

