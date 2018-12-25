%predicado para abrir un archivo -------------------------------------------------------------------------
abrir(KB):- 
	open('/Users/juan/Desktop/Proyecto Representacion del conocimiento/KnowledgeBase/KB2.txt',read,Stream),
	readclauses(Stream,X),
	close(Stream),
	atom_to_term_conversion(X,KB).

%--------------------------------------------------------------------------------------------------------

 
% predicado para guardar un archivo ---------------------------------------------------------------------
guardar(KB):-
	open('/Users/juan/Desktop/Proyecto Representacion del conocimiento/KnowledgeBase/KB.txt',write,Stream),
	writeq(Stream,KB),
	close(Stream).

%--------------------------------------------------------------------------------------------------------

iniciar(KB,R):-
write('Hola, yo sere su mesero, que desea??'), nl,
read(Orden), % se hace la lectura del teclado y se almacena en la variable Orden
write('Muy bien, entonces le traire ->'),tab(1),write(Orden).


% modulo de diagnostico --------------------------------------------------------------------------------------------------------
% este modulo tiene como objetivo consultar el conocimiento en la base de datos

%-------------------------------------------------------------------------------------------------------------------------------



% modulo de planeación  --------------------------------------------------------------------------------------------------------
% este modulo tiene como objetivo relizar una planeacion de acciones que nos lleven a un objetivo
%-------------------------------------------------------------------------------------------------------------------------------



% modulo de ejecucion   --------------------------------------------------------------------------------------------------------
% este modulo tiene como objetivo ejecucion cada una de las acciones del modulo anterior mas especificamente
%-------------------------------------------------------------------------------------------------------------------------------