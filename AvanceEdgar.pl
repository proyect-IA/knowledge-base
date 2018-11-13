% --- predicado para abrir un archivo ---------------------------------
abrir(KB):-
    % open('/home/edgar/Documents/Maestría_IIMASS/1erSemestre/inteligencia/knowledge-base/EstructuraBase.txt',read,Stream),
    open('d:/maestria/inteligenciaArtif/knowledge-base/EstructuraBase(edd).txt',read,Stream),
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
es_elemento(X,[X|_]).
es_elemento(X,[_|T]):-
    es_elemento(X,T).


% Cambiar el nombre de un elemento en una lista de relaciones
% ---------------------------------------------------------------------
buscar_cambiar_objeto_en_relacion(_,_,[],[]).

buscar_cambiar_objeto_en_relacion(Acc=>(Name, Val), Acc=>(NewName, Val),[Acc=>(Name, Val)|T],[Acc=>(NewName, Val)|N]):-
    buscar_cambiar_objeto_en_relacion(NextAcc=>(Name, NextVal),NextAcc=>(NewName, NextVal),T,N).

buscar_cambiar_objeto_en_relacion(A=>(Name, Val),A=>(NewName, Val),[H|T],[H|N]):-
    buscar_cambiar_objeto_en_relacion(NextAcc=>(Name, NextVal), NextAcc=>(NewName, NextVal),T,N).


cambiar_objeto_en_relacion(Objeto,NombreNuevo,Rels,Result):-
    buscar_cambiar_objeto_en_relacion(_=>(Objeto,_), _=>(NombreNuevo, _), Rels, Result).

% Cambiar el valor de una propiedad clase
% *****  Pendiente
% ---------------------------------------------------------------------
%buscar_cambiar_prop_clase(_,_,[],[]).

%buscar_cambiar_prop_clase(Acc=>(Name, Val), Acc=>(NewName, Val),[Acc=>(Name, Val)|T],[Acc=>(NewName, Val)|N]):-
%    buscar_cambiar_prop_clase(NextAcc=>(Name, NextVal),NextAcc=>(NewName, NextVal),T,N).

%buscar_cambiar_prop_clase(A=>(Name, Val),A=>(NewName, Val),[H|T],[H|N]):-
%buscar_cambiar_prop_clase(NextAcc=>(Name, NextVal), NextAcc=>(NewName, NextVal),T,N).

iterar_preferencias_relaciones_antec(_,_,[],[]).

iterar_preferencias_relaciones_antec(Name,NewName,[AntPrefRel=>>ConsPrefRel|T],[NewAntPrefRel=>>ConsPrefRel|N]):-
    cambiar_objeto_en_relacion(Name,NewName,AntPrefRel,NewAntPrefRel),
    iterar_preferencias_relaciones_antec(Name,NewName,T,N).

iterar_preferencias_relaciones_antec(Name,NewName,[H|T],[H|N]):-
    iterar_preferencias_relaciones_antec(Nem,NewName,T,N).


iterar_preferencias_relaciones_antec(_,_,[],[]).

iterar_preferencias_relaciones_antec(Name,NewName,[AntPrefRel=>>ConsPrefRel|T],[NewAntPrefRel=>>ConsPrefRel|N]):-
    cambiar_objeto_en_relacion(Name,NewName,AntPrefRel,NewAntPrefRel),
    iterar_preferencias_relaciones_antec(Name,NewName,T,N).

iterar_preferencias_relaciones_antec(Name,NewName,[H|T],[H|N]):-
    iterar_preferencias_relaciones_antec(Nem,NewName,T,N).


cambia_consc(Name, NewName, A=>(Name, Val), A=>(NewName, Val)).

iterar_preferencias_relaciones_consec(_,_,[],[]).

iterar_preferencias_relaciones_consec(Name,NewName,[AntPrefRel=>>ConsPrefRel|T],
        [AntPrefRel=>>NewConsPrefRel|N]):-
    cambia_consc(Name, NewName, ConsPrefRel, NewConsPrefRel),
    iterar_preferencias_relaciones_consec(Name,NewName,T,N).

iterar_preferencias_relaciones_consec(Name,NewName,[H|T],[H|N]):-
    iterar_preferencias_relaciones_consec(Name,NewName,T,N).



cambiar_padre(_,_,[],[]).

cambiar_padre(OldFather,NewFather,[class(C,OldFather,P,R,O)|T],[class(C,NewFather,P,R,O)|N]):-
    cambiar_padre(OldFather,NewFather,T,N).

cambiar_padre(OldFather,NewFather,[H|T],[H|N]):-
    cambiar_padre(OldFather,NewFather,T,N).


% -- Predicado para cambiar nombre a un elemento en una relacion ---
% -----------     A nivel de CLASE  ----------------------------
cambiar_relaciones_nivelClase(_,_,[],[]).

cambiar_relaciones_nivelClase(Nombre,NombreNuevo,
            [class(C,Padre,P,[Rels,PrefRel],O)|T],[class(C,Padre,P,[RelsNew,PrefRel],O)|N]):-
    cambiar_objeto_en_relacion(Nombre,NombreNuevo,Rels,RelsNew),    
    cambiar_relaciones_nivelClase(Nombre,NombreNuevo,T,N).

cambiar_relaciones_nivelClase(Nombre,NombreNuevo,[H|T],[H|N]):-
    cambiar_relaciones_nivelClase(Nombre,NombreNuevo,T,N).


cambiar_relaciones_antecedentes_nivelClase(_,_,[],[]).

cambiar_relaciones_antecedentes_nivelClase(Nombre,NombreNuevo,
            [class(C,Padre,P,[Rels,PrefRel],O)|T],
            [class(C,Padre,P,[Rels,NewPrefRel],O)|N]):-
    iterar_preferencias_relaciones_antec(Nombre,NombreNuevo,PrefRel,NewPrefRel),    
    cambiar_relaciones_antecedentes_nivelClase(Nombre,NombreNuevo,T,N).

cambiar_relaciones_antecedentes_nivelClase(Nombre,NombreNuevo,[H|T],[H|N]):-
    cambiar_relaciones_antecedentes_nivelClase(Nombre,NombreNuevo,T,N).


cambiar_relaciones_consecuentes_nivelClase(_,_,[],[]).

cambiar_relaciones_consecuentes_nivelClase(Nombre,NombreNuevo,
            [class(C,Padre,P,[Rels,PrefRel ],O)|T],
            [class(C,Padre,P,[Rels,NewPrefRel],O)|N]):-
    iterar_preferencias_relaciones_consec(Nombre, NombreNuevo, PrefRel,NewPrefRel),    
    cambiar_relaciones_consecuentes_nivelClase(Nombre,NombreNuevo,T,N).

cambiar_relaciones_consecuentes_nivelClase(Nombre,NombreNuevo,[H|T],[H|N]):-
    cambiar_relaciones_consecuentes_nivelClase(Nombre,NombreNuevo,T,N).


% -- Predicado para cambiar nombre a un elemento en una relacion ---
% -----------     A nivel de INDIVIDUO  ----------------------------
cambiar_relaciones_nivelIndividuo(_,_,[],[]).

cambiar_relaciones_nivelIndividuo(Nombre,NombreNuevo, 
        [class(C,Padre,P,R,[[id=>Id,Prop,[Rels,PrefRel]]|H])|T],
        [class(C,Padre,P,R,[[id=>Id,Prop,[RelsNew,PrefRel]]|H])|N]):-
    cambiar_objeto_en_relacion(Nombre,NombreNuevo,Rels,RelsNew),    
    cambiar_relaciones_nivelIndividuo(Nombre,NombreNuevo,T,N).

cambiar_relaciones_nivelIndividuo(Nombre,NombreNuevo,[H|T],[H|N]):-
    cambiar_relaciones_nivelIndividuo(Nombre,NombreNuevo,T,N).

%(class(Name, Father, Props, Rels, [[id=>Objs, PropObjs, [Rel, [Antec=>>Consecuente|R]]]|H])
cambiar_relaciones_antecedentes_nivelIndividuo(_,_,[],[]).

cambiar_relaciones_antecedentes_nivelIndividuo(Nombre,NombreNuevo,
        [class(C,Padre,P,R,[[id=>Id,Prop,[Rels,PrefRela]]|H])|T],
        [class(C,Padre,P,R,[[id=>Id,Prop,[Rels,NewPrefRela]]|H])|N]):-
    iterar_preferencias_relaciones_antec(Nombre,NombreNuevo,PrefRela,NewPrefRela),    
    cambiar_relaciones_antecedentes_nivelIndividuo(Nombre,NombreNuevo,T,N).

cambiar_relaciones_antecedentes_nivelIndividuo(Nombre,NombreNuevo,[H|T],[H|N]):-
    cambiar_relaciones_antecedentes_nivelIndividuo(Nombre,NombreNuevo,T,N).


cambiar_relaciones_consecuentes_nivelIndividuo(_,_,[],[]).

cambiar_relaciones_consecuentes_nivelIndividuo(Nombre,NombreNuevo,
        [class(C,Padre,P,R,[[id=>Id,Prop,[Rels,PrefRel]]|H])|T],
        [class(C,Padre,P,R,[[id=>Id,Prop,[Rels,NewPrefRel]]|H])|N]):-
    iterar_preferencias_relaciones_consec(Nombre, NombreNuevo, PrefRel,NewPrefRel),    
    cambiar_relaciones_consecuentes_nivelIndividuo(Nombre,NombreNuevo,T,N).

cambiar_relaciones_consecuentes_nivelIndividuo(Nombre,NombreNuevo,[H|T],[H|N]):-
    cambiar_relaciones_consecuentes_nivelIndividuo(Nombre,NombreNuevo,T,N).








% --------------------------------------------------------------------
% Predicados para realizar modificaciones a Knowledge Base
% --------------------------------------------------------------------

% ---  Cambiar el nombre de un objeto particular --
cambiar_nombre_de_objeto(Objeto,NewName,OriginalKB,NewKB):-
	cambiar_elemento(class(Clase,Padre,Props,Rels,Objects),
                class(Clase,Padre,Props,Rels,NewObjects),OriginalKB,TemporalKB),
	es_elemento([id=>Objeto|Properties],Objects),
	cambiar_elemento([id=>Objeto|Properties],[id=>NewName|Properties],Objects,NewObjects),
	cambiar_relacion_objeto(Objeto,NewName,TemporalKB,NewKB).


% ------------------------------------------------
% -- Predicado para cambiar nombre a una clase ---
cambiar_nombre_de_clase(Clase,NombreNuevo,KB,NewKB):-
    cambiar_elemento(class(Clase,Padre,Propiedades,Relaciones,Objetos),
                    class(NombreNuevo,Padre,Propiedades,Relaciones,Objetos),KB,KBnameUpdate),
    cambiar_padre(Clase,NombreNuevo,KBnameUpdate,KBfatherUpdate),
    cambiar_relaciones_nivelClase(Clase,NombreNuevo,KBfatherUpdate,KBrelationUpdate),
    cambiar_relaciones_antecedentes_nivelClase(Clase, NombreNuevo, KBrelationUpdate, KBantePrefUpdate),
    cambiar_relaciones_consecuentes_nivelClase(Clase, NombreNuevo, KBantePrefUpdate, KBconsecPrefUpdate),
    cambiar_relaciones_nivelIndividuo(Clase,NombreNuevo,KBconsecPrefUpdate,KBrelation2Update),
    cambiar_relaciones_antecedentes_nivelIndividuo(Clase, NombreNuevo, KBrelation2Update, KBantePref2Update),
    cambiar_relaciones_consecuentes_nivelIndividuo(Clase, NombreNuevo, KBantePref2Update, NewKB).

