# project

authority--> passa ad auto che riconosce '//' e gli ignora passa la stringa senza '//' a userinfoauto che vede se prima trova @ e se lo fa prosegua al riconoscimento di userinfo e se fallisce passa il riconosciento ad host
(bisogna tenere in conto che stiamo passando codici ASCII dal momento che aut mi ha tolto i //)

listPos (lista, elmento, X)--> usato per sapere posizione di un certo carattere, per esempio in authority per poter sapere dove si trova @ e :

twopoints--> mi verifica dove ci sono i : se è cosi passa SubAtom a port
