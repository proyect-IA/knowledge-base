% --- predicado para abrir un archivo ---------------------------------
abrir(KB):-
    % open('/home/edgar/Documents/Maestría_IIMASS/1erSemestre/inteligencia/knowledge-base/EstructuraBase.txt',read,Stream),
    open('d:/maestria/inteligenciaArtif/knowledge-base/EstructuraBase.txt',read,Stream),
    readclauses(Stream,X),
    close(Stream),
    atom_to_term_conversion(X,KB).

% ----------------------------------------------------------------------
% --- predicado para guardar un archivo --------------------------------
guardar(KB):-
    % open('/home/edgar/Documents/Maestría_IIMASS/1erSemestre/inteligencia/knowledge-base/update_KB(edd).txt',write,Stream),
    open('d:/maestria/inteligenciaArtif/knowledge-base/update_KB(edd).txt',write,Stream),
    writeq(Stream,KB),
    close(Stream).

% ----------------------------------------------------------------------------
% --- predicados auxiliares para el manejo de archivos -----------------------
readclauses(InStream,W) :-
    get0(InStream,Char),
    checkCharAndReadRest(Char,Chars,InStream),
    atom_chars(W,Chars). 

checkCharAndReadRest(-1,[],_) :- !.  % End of Stream	
checkCharAndReadRest(end_of_file,[],_) :- !.

checkCharAndReadRest(Char,[Char|Chars],InStream) :-
    get0(InStream,NextChar),
    checkCharAndReadRest(NextChar,Chars,InStream).

atom_to_term_conversion(ATOM, TERM) :-
    atom(ATOM),
    atom_to_chars(ATOM,STR),
    atom_to_chars('.',PTO),
    append(STR,PTO,STR_PTO),
    read_from_chars(STR_PTO,TERM).

% ---------------------------------------------------------
% ------------ definicion de los operadores ---------------
:- op(500,xfy,'=>').  %operador de asignacion
:- op(801,xfy,'=>>'). %operador de implicación

% -------------------------------------------
% Cambiar un elemento por otro en la lista
% --------------------------------------------
% Sustituye los atomos A por B en un lista X
% y los devuelve en otra lista Y (A, B, [X], [Y])
% Ejemplo (r,s,[c,a,r,r,o],[c,a,s,s,o])
cambiar_elemento(_,_,[],[]).

cambiar_elemento(A,B,[A|T],[B|N]):-
    cambiar_elemento(A,B,T,N).

cambiar_elemento(A,B,[H|T],[H|N]):-
    cambiar_elemento(A,B,T,N).

% -------------------------------------------
% Buscar un elemento en una lista
% --------------------------------------------
es_elemento(X,[X|_]).
es_elemento(X,[_|T]):-
	es_elemento(X,T).



cambiar_padre(_,_,[],[]).

cambiar_padre(OldFather,NewFather,[class(C,OldFather,P,R,O)|T],[class(C,NewFather,P,R,O)|N]):-
    cambiar_padre(OldFather,NewFather,T,N).

cambiar_padre(OldFather,NewFather,[H|T],[H|N]):-
    cambiar_padre(OldFather,NewFather,T,N).


% --------------------------------------------------------------------
% Predicados para realizar modificaciones a Knowledge Base
% --------------------------------------------------------------------

change_relations(_,_,[],[]).

change_relations(Object,NewName,[Id=>(R, Val)|T],[Id=>(NewR, Val)|NewT]):-
	change_relation(Object,NewName,R,NewR),
	change_relations(Object,NewName,T,NewT).



change_relation(_,_,[],[]).

change_relation(OldName,NewName,[R=>(OldName, Val)|T],[R=>(NewName, Val)|NewT]):-
	change_relation(OldName,NewName,T,NewT).

change_relation(OldName,NewName,[not(R=>OldName)|T],[not(R=>NewName)|NewT]):-
	change_relation(OldName,NewName,T,NewT).

change_relation(OldName,NewName,[H|T],[H|NewT]):-
	change_relation(OldName,NewName,T,NewT).
		



cambiar_relacion_objeto(_,_,[],[]).

cambiar_relacion_objeto(Object,NewName,[class(C,M,P,R,O)|T],[class(C,M,P,NewR,NewO)|NewT]):-
	change_relations(Object,NewName,O,NewO),
	change_relation(Object,NewName,R,NewR),
	cambiar_relacion_objeto(Object,NewName,T,NewT).

buscar_objeto_en_relacion([],_,_,[]).

buscar_objeto_en_relacion([Prop=>(Id, Val)|_], Id, NewId, R):-
	R=[Prop=>(NewId, Val)].

buscar_objeto_en_relacion([_|B], Id, NewId, R):-
	buscar_objeto_en_relacion(B, Id, NewId, R).

% -------------------------------------------------
% ---  Cambiar el nombre de un objeto particular --
cambiar_nombre_de_objeto(Objeto,NewName,OriginalKB,NewKB) :-
	cambiar_elemento(class(Clase,Padre,Props,Rels,Objects),class(Clase,Padre,Props,Rels,NewObjects),OriginalKB,TemporalKB),
	es_elemento([id=>Objeto|Properties],Objects),
	cambiar_elemento([id=>Objeto|Properties],[id=>NewName|Properties],Objects,NewObjects),
	cambiar_relacion_objeto(Objeto,NewName,TemporalKB,NewKB).

% ------------------------------------------------
% -- Predicado para cambiar nombre a una clase ---
cambiar_nombre_de_clase(Clase,NombreNuevo,KB,NewKB):-
    cambiar_elemento(class(Clase,Padre,Propiedades,Relaciones,Objetos),class(NombreNuevo,Padre,Propiedades,Relaciones,Objectos),KB,AUX),
    cambiar_padre(Clase,NombreNuevo,AUX,AUX2),
    cambiar_relacion_objeto(Clase,NombreNuevo,AUX2,NewKB).

% ------------------------------------------------
% -- Predicado para cambiar nombre a un elemento en una relacion ---
cambiar_objeto_en_relacion(Objeto,NombreNuevo,KB,NewKB):-
    cambiar_elemento(class(Clase,Padre,Propiedades,Relaciones,Objetos), class(Clase,Padre,Propiedades,Relaciones2,Objetos),KB,AUX),
    es_elemento([Id=>(Objeto,Val)|Properties],Relaciones),
    buscar_objeto_en_relacion([Prop=>(Objeto, Val)|_], Objeto, NombreNuevo, R),
    %cambiar_elemento([Id=>(Objeto,Val)|Properties],[Id=>(NombreNuevo,Val)|Properties],Relaciones,RelNueva),
    cambiar_relacion_objeto(Objeto,NombreNuevo,AUX,NewKB).