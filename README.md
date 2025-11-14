# umintCV7
Úlohy:  
1. Pomocou genetického algoritmu navrhnite parametre PID regulátora, ktoré budú robustné voči zmene dynamiky riadeného systému (tzv. „robustný regulátor“). Predpokladajme, že dynamika riadeného systému používaného v predchádzajúcich dvoch zadaniach v tvare
a2y’’+a1y’+a0y+c0y3=b00.1u 
sa mení skokovo medzi tromi „pracovnými bodmi“ (a, b, c) ktoré sú reprezentované nasledovnými koeficientami:

a)    a0=1; a1=2; a2=1; b0=0.1; c0=1; 

b)    a0=1.4; a1=2; a2=1; b0=0.2; c0=0.9;   

c)    a0=1.1; a1=0.1; a2=4; b0=0.1; c0=1.1;  

Pozrite si prednášku o návrhu robustného regulátora, urobte zmeny v programe z predchádzajúceho zadania, navrhnite regulátor a vykreslite obrázky:
   1. graf evolúcie fitness funkcie,  
   2. graf priebehu regulovanej veličiny a žiadanej hodnoty, samostatne pre všetky tri pracovné body (a, b, c),  
   3. graf priebehu riadiacej veličiny pre všetky tri pracovné body. Všetky ostatné podmienky experimentu sú rovnaké, ako v predchádzajúcom zadaní.
   
3. Grafy z úlohy 1 porovnajte s nasledovným experimentom: Navrhnite PID regulátor iba pre pracovný bod a). Tento regulátor použite aj pre riadenie systému s koeficientami b) a c).  Rovnako, ako v úlohe 1 vykreslite všetky tri obrázky, porovnajte ich navzájom s úlohou 1 a urobte diskusiu.
  
<img width="1693" height="1008" alt="image" src="https://github.com/user-attachments/assets/13104fdb-1266-4bd5-b68a-2286de059532" />

<img width="2187" height="844" alt="image" src="https://github.com/user-attachments/assets/eb9d95ca-dcf1-4dc0-a97d-283a85909a8d" />

<img width="1717" height="794" alt="image" src="https://github.com/user-attachments/assets/9267c3c8-ec98-4890-9f60-e0f09197f2b4" />

