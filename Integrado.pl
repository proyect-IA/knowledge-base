% --------------- Proyecto 1  -------------------
% -------- INTELIGENCIA  ARTIFICIAL  ------------
% --  Yoshio Ismael
% --  Andrick
% --  Raul
% --  Edgar Vazquez

%predicado para abrir un archivo -------------------------------------------------------------------------
abrir(KB):- 
	open('/Users/juan/Desktop/Proyecto Representacion del conocimiento/KnowledgeBase/KB2.txt',read,Stream),
	%open('d:/maestria/inteligenciaArtif/knowledge-base/bases/KBArticulo.txt',read,Stream),
	%open('d:/maestria/inteligenciaArtif/knowledge-base/bases/KBEjemploExamen.txt',read,Stream),
	readclauses(Stream,X),
	close(Stream),
	atom_to_term_conversion(X,KB).

% predicado para guardar un archivo ---------------------------------------------------------------------
guardar(KB):-
	%open('/Users/juan/Desktop/Proyecto Representacion del conocimiento/KnowledgeBase/KB.txt',write,Stream),
	open('d:/maestria/inteligenciaArtif/knowledge-base/bases/KBEjemploExamen.txt',write,Stream),
	writeq(Stream,KB),
	close(Stream).

% --------------------------------------------------------------------------------------------------------
% definicion de los operadores ---------------------------------------------------------------------------
:- op(500,xfy,'=>').  %operador de asignacion
:- op(801,xfy,'=>>'). %operador de implicación
% --------------------------------------------------------------------------------------------------------


%predicados auxiliares para el manejo de archivos -------------------------------------------------------
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

% *************************************************************************************************
%--------------------------------------------------------------------------------------------------
%  Predicados auxiliares
%--------------------------------------------------------------------------------------------------
%%************ Cambiar todas las ocurrencias de un elemento X en una lista por el valor de Y
cambiar_elemento(_,_,[],[]).

cambiar_elemento(A,B,[A|T],[B|N]):-
    cambiar_elemento(A,B,T,N).

cambiar_elemento(A,B,[H|T],[H|N]):-
    cambiar_elemento(A,B,T,N).

% ----------------------------------------------
% ----  Buscar un elemento en una lista  -------
es_elemento(X,[X|_]).
es_elemento(X,[_|T]):-
    es_elemento(X,T).

%%************ Cehca si una lista contiene elementos
list_has_elements([_|_], true).


%Change all ocurrences of an element X in a list for the value Y
%cambiarGrupoObjetos(X,Y,InputList,OutputList).
%Example (a,b,[p,a,p,a,y,a],[p,b,p,b,y,b])

cambiarGrupoObjetos(_,_,[],[]).

cambiarGrupoObjetos(X,Y,[X|T],[Y|N]):-
	cambiarGrupoObjetos(X,Y,T,N).

cambiarGrupoObjetos(X,Y,[H|T],[H|N]):-
	cambiarGrupoObjetos(X,Y,T,N).

cambiarGrupoObjetos(X,Y,[[X|T]],[[Y|N]]):-
	cambiarGrupoObjetos(X,Y,[X|T],[Y|N]).

cambiarGrupoObjetos(X,Y,[[H|T]],[[H|N]]):-
	cambiarGrupoObjetos(X,Y,[H|T],[H|N]).

%Delete all ocurrences of an element X in a list
%borrarElemento(X,InputList,OutputList).
%Example (a,[p,a,p,a,y,a],[p,p,y])

borrarElemento(_,[],[]).

borrarElemento(X,[[id=>Lista|_]|T],N):-
	member(X,Lista),
	borrarElemento(X,T,N).

borrarElemento(X,[H|T],[H|N]):-
	borrarElemento(X,T,N),
	X\=H.


%Delete all ocurrences of an element X in a list
%borrarElementoPref(X,InputList,OutputList).
%Example (a,[p,a,p,a,y,a],[p,p,y])

borrarElementoPref(_,_,[],[]).

borrarElementoPref(X,Peso,[ [_]=>>X=>(_,Peso)|T ],N):-
	borrarElementoPref(X,T,N).

borrarElementoPref(X,_,[[H]=>>A=>_|T],[[H]=>>A=>_|N]):-
	borrarElementoPref(X,T,N),
	X\=A.

%Verify if an element X is in a list 
%esObjeto(X,List)
%Example (n,[b,a,n,a,n,a])

member(X,[X|_]).
member(X,[_|T]) :- member(X,T).

esObjeto(X,[[id=>Lista|_]|_]):-
	member(X,Lista).

esObjeto(X,[ _ |T]):-
	esObjeto(X,T).


%predicados auxiliares en las validaciones ----------------------------------------
es_clase(_,[],desconocido).

es_clase(Clase,[class(Clase,_,_,_,_)|_],si).

es_clase(Clase,[_|T],Resultado):-
	es_clase(Clase,T,Resultado).

%Convert in a single list a list of lists
%Example ([[a],[b,c],[],[d]],[a,b,c,d]).
append_list_of_lists([],[]).

append_list_of_lists([H|T],X):-
	append(H,TList,X),
	append_list_of_lists(T,TList).
% --------------------------------------------------------------------------------
% ---------  Fin predicados auxiliares  ------------------------------------------
% ********************************************************************************


% ********************************************************************************
% ---------  Inicio predicados extensiones  --------------------------------------
%%************ Obetener data (clase y nombres) de un objeto
%% Caso Base
obtener_data_objeto(_,[],_,[]).
%% Checa objetos de la clase
obtener_data_objeto(ObjectName, [class(Clase,_,_,_,O)|_], ObjClass, ObjNames):-
	list_has_elements(O,R),
	busca_objecto(ObjectName, O, ObjClass, ObjNames),
	list_has_elements(ObjNames,R),
	ObjClass = Clase.
%% Itera sobre clases (KB)
obtener_data_objeto(ObjectName, [_|Resto], ObjClass, ObjNames):-
	obtener_data_objeto(ObjectName, Resto, ObjClass, ObjNames).
%% Busca nombre de objeto
busca_objecto(ObjectName, [[id=>Nombres,Prop,_]|_], ObjClass, ObjNames):-
	member(ObjectName,Nombres),
	ObjNames = Nombres.
%% Itera sobre Objetos
busca_objecto(ObjectName, [_|Resto], ObjClass, ObjNames):-
	busca_objecto(ObjectName, Resto, ObjClass, ObjNames).
%% Caso base
busca_objecto(_,[],desconocido,[]).



%--------------------------------------------------------------------------------------------------------

%este predicado es el encargado de obtiener los individos de una clase y de sus descendientes,
%recive el la clase en la que se buscar, la base, y regresa una lista de Individuos
%primero tenemos que validar que en verdad es una clase
individuos_de_una_clase(Clase,KB,Individuos):-
	es_clase(Clase,KB,R),
	validar_clase_verdadera(R,KB,Clase,Individuos).

validar_clase_verdadera(desconocido,_,_,desconocido).

validar_clase_verdadera(_,KB,Clase,Individuos):-
	individuos_especificos_de_clase(Clase,KB,IndividuosLocales),
	obtener_individuos_hijos(Clase,KB,IndivudosHijo,KB),
	append(IndividuosLocales,IndivudosHijo,Individuos).

%clase que detiene la recursividad, si no se conocen los individos, se llama este predicado
individuos_especificos_de_clase(_,[],desconocido).

%predicado que permite obtener la lista de individos especificos de una clase.
%Se llama al hecho que obtiene los nombres de los individos para concetenarlos
individuos_especificos_de_clase(Clase,[class(Clase,_,_,_,Indi)|_],Individuos):-
	obtener_nombres_individuos(Indi,Individuos). 

%Con ayuda de este predicado se puede iterar por la lista de clases hasta encontra la clase que nos interesa y obtener los individos
individuos_especificos_de_clase(Clase,[_|T],Individuos):-
	individuos_especificos_de_clase(Clase,T,Individuos).

%Predicado base para detener la recursividad, cuando ya no existen elementos
obtener_nombres_individuos([],[]).  

obtener_nombres_individuos([[id=>Nombre,_,_]|T],Individuos):-
	obtener_nombres_individuos(T,Restantes),
	append(Nombre,Restantes,Individuos).

obtener_individuos_hijos(Clase,KB,Individuos,Respaldo):-
	obtener_individuos_hijos_descendientes([Clase],KB,Individuos,Respaldo).

%se agrega un nuevo nodo por visitar
%se obtiene todos los individuos
%se llama nuevamente al predicado
obtener_individuos_hijos_descendientes([ClasePadre|R],[class(ClaseHijo,ClasePadre,_,_,[[id=>[Nombre|RestoNombres],_,_]|[A|B]])|Resto],Individuos,Respaldo):-
	append([ClasePadre|R],[ClaseHijo],Pila),												
	obtener_nombres_individuos([A|B],Restantes), 									
	append([Nombre|RestoNombres],Restantes,X),
	obtener_individuos_hijos_descendientes(Pila,Resto,IndividuosHermanos,Respaldo), 
	append(X,IndividuosHermanos,Individuos).

obtener_individuos_hijos_descendientes([ClasePadre|R],[class(ClaseHijo,ClasePadre,_,_,[[id=>[Nombre|RestoNombres],_,_]|[]])|Resto],Individuos,Respaldo):-
	append([ClasePadre|R],[ClaseHijo],Pila), 														
	obtener_individuos_hijos_descendientes(Pila,Resto,Restantes,Respaldo),
	append([Nombre|RestoNombres],Restantes,Individuos).

obtener_individuos_hijos_descendientes([ClasePadre|R],[class(ClaseHijo,ClasePadre,_,_,[])|Resto],Individuos,Respaldo):-
	append([ClasePadre|R],[ClaseHijo],Pila), 														
	obtener_individuos_hijos_descendientes(Pila,Resto,Individuos,Respaldo).

obtener_individuos_hijos_descendientes(ClasePadre,[_|X],Individuos,Respaldo):-
	obtener_individuos_hijos_descendientes(ClasePadre,X,Individuos,Respaldo).

obtener_individuos_hijos_descendientes([],[],[],_).

obtener_individuos_hijos_descendientes([_|T],[],Individuos,Respaldo):-
	obtener_individuos_hijos_descendientes(T,Respaldo,Individuos,Respaldo).
%--------------------------------------------------------------------------------------------------------

imprime_lista_resultados([]).

imprime_lista_resultados([A|B]):-write(A),tab(3),imprime_lista_resultados(B).

%Aqui obtenemos la extensión de una propiedad -----------------------------------------------------------



/* predica que permite obtener la extensión de una propiedad, regresa los individios que la poseen ya sea por que la tiene propiamente, es heredada o inferida */
obtener_extension_propiedad(Padre,PropiedadBuscar,PropiedadesPropidas,KB,Extension,PreferenciasHeredadas):-
	%primero obtiene todos sus hijos
	obtener_hijos(Padre,KB,Hijos),
	
	%obtiene las propiedades de la clase			
	obtener_propiedades_clase(Padre,KB,PropiedadesClase),

	%obtiene las preferencias de la clase
	obtener_preferencias_clase(Padre,KB,PreferenciasClase),
	append(PropiedadesClase,PropiedadesPropidas,PropiedadesHerencia),
	decide_heredar_preferencias(PreferenciasClase,PreferenciasHeredadas,PreferenciasHerencia),
	bajar_por_hijos_propiedad(Padre,Hijos,PropiedadBuscar,PropiedadesHerencia,KB,Extension,PreferenciasHerencia).

decide_heredar_preferencias([[]],Hereda,Hereda).
decide_heredar_preferencias([],Hereda,Hereda).

decide_heredar_preferencias(PreferenciasClase,PreferenciasHeredadas,PreferenciasHerencia):-
	append(PreferenciasClase,PreferenciasHeredadas,PreferenciasHerencia).

%predicado base que detine la recursividad de prolog
obtener_extension_propiedad([],_,_,_,[]).

obtener_propiedades_individuos_clase(Clase,_,_,[class(Clase,_,_,_,[])|_],[],_).

obtener_propiedades_individuos_clase(Clase,PropBus,PropHerencia,[class(Clase,_,_,_,[[id=>Nombres,PropPrefIndividuos,_]|NombresRestantes])|Resto],Extension,PrefHerencia):-	
	extraer_todas_propiedades_individuo(PropPrefIndividuos,PropHerencia,PrefHerencia,PropInferidasCompletas), % aqui se realizan todas las inferencias, ahora solo buscamos la propiedad que nos interesa	
	obtener_propiedades_individuos_clase(Clase,PropBus,PropHerencia,[class(Clase,_,_,_,NombresRestantes)|Resto],ExtensionDemasIndividuos,PrefHerencia),
	verificar_existencia_propiedad(PropBus,PropInferidasCompletas,ResultadoBusqueda,Nombres),
	append([ResultadoBusqueda],ExtensionDemasIndividuos,Extension).

obtener_propiedades_individuos_clase(Clase,PropiedadBuscar,PropiedadesHeredadas,[_|T],Extension,PreferenciasHerencia):-
	obtener_propiedades_individuos_clase(Clase,PropiedadBuscar,PropiedadesHeredadas,T,Extension,PreferenciasHerencia).

%predicado que detiene la recursividad
obtener_propiedades_individuos_clase(_,_,_,[],[],_).

%caso base que detiene la recursividad
verificar_existencia_propiedad(_,[],R,Nombres):-
 	append(Nombres,[desconocido],R).

verificar_existencia_propiedad(PropiedadBuscar,[PropiedadBuscar=>(Valor,Peso)|_],R,Nombres):-
	append(Nombres,[PropiedadBuscar=>(Valor,Peso)],R).

verificar_existencia_propiedad(PropiedadBuscar,[no(PropiedadBuscar=>(Valor,Peso))|_],R,Nombres):-
	append(Nombres,[no(PropiedadBuscar=>(Valor,Peso))],R).

verificar_existencia_propiedad(PropiedadBuscar,[_|B],R,Nombres):-
	verificar_existencia_propiedad(PropiedadBuscar,B,R,Nombres).

extraer_propiedades_individuos(PropiedadBuscar,PropiedadesHeredadas,[[id=>[Nombre|RestoNombres],[A|B],_]|Resto],Extension,PreferenciasHerencia):-
	append([A|B],PropiedadesHeredadas,PropiedadesMescladaz),
	buscar_propiedad(PropiedadBuscar,PropiedadesMescladaz,_,ValorPorDefecto),
	prepar_proceso_inferencia(PreferenciasHerencia,PropiedadBuscar,PropiedadesMescladaz,ValorInferido,ValorPorDefecto),
	extraer_propiedades_individuos(PropiedadBuscar,PropiedadesHeredadas,Resto,RestoIndividuos,PreferenciasHerencia),
	append([Nombre|RestoNombres],[ValorInferido],Ind1),
	append([Ind1],RestoIndividuos,Extension).

extraer_propiedades_individuos(PropiedadBuscar,PropiedadesHeredadas,[[id=>[Nombre|RestoNombres],[],_]|Resto],Extension,PreferenciasHerencia):-
	buscar_propiedad(PropiedadBuscar,PropiedadesHeredadas,_,ValorPorDefecto),
	prepar_proceso_inferencia(PreferenciasHerencia,PropiedadBuscar,PropiedadesHeredadas,ValorInferido,ValorPorDefecto),	
	extraer_propiedades_individuos(PropiedadBuscar,PropiedadesHeredadas,Resto,RestoIndividuos,PreferenciasHerencia),
	append([Nombre|RestoNombres],[ValorInferido],Ind1),
	append([Ind1],RestoIndividuos,Extension).

extraer_propiedades_individuos(PropiedadBuscar,PropiedadesHeredadas,[_|Resto],Extension,PreferenciasHerencia):-
	extraer_propiedades_individuos(PropiedadBuscar,PropiedadesHeredadas,Resto,Extension,PreferenciasHerencia).

extraer_propiedades_individuos(_,_,[],[],_).

inferir_propiedad([],_,_,A,A).

inferir_propiedad([Antecedentes=>>Buscar=>(variable,_)|_],Buscar,Propiedades,Resultado,Inferido):-
	compara_preferencias(Antecedentes,Propiedades,Desicion,ValorD),
	inferencia_nueva_propiedad(Desicion,variable,ValorD,Resultado,Inferido).

inferir_propiedad([Antecedentes=>>no(Buscar=>(variable,_))|_],Buscar,Propiedades,Resultado,Inferido):-
	compara_preferencias(Antecedentes,Propiedades,Desicion,ValorD),
	inferencia_nueva_propiedad(Desicion,variable,ValorD,Resultado,Inferido).

inferir_propiedad([Antecedentes=>>Buscar=>(Valor,_)|_],Buscar,Propiedades,Resultado,Inferido):-
	compara_preferencias(Antecedentes,Propiedades,Desicion,ValorD),
	inferencia_nueva_propiedad(Desicion,Valor,ValorD,Resultado,Inferido).

inferir_propiedad([Antecedentes=>>no(Buscar=>(Valor,_))|_],Buscar,Propiedades,Resultado,Inferido):-
	compara_preferencias(Antecedentes,Propiedades,Desicion,ValorD),
	inferencia_nueva_propiedad(Desicion,Valor,ValorD,Resultado,Inferido).

inferir_propiedad([_|B],Buscar,Propiedades,Resultado,Inferido):-
	inferir_propiedad(B,Buscar,Propiedades,Resultado,Inferido).

inferencia_nueva_propiedad(si,variable,Valor,Valor,_).
inferencia_nueva_propiedad(no,variable,_,Valor,Valor).

inferencia_nueva_propiedad(si,Valor,_,Valor,_).
inferencia_nueva_propiedad(no,_,_,Valor,Valor).

prepar_proceso_inferencia([],_,_,Inferido,Inferido).

prepar_proceso_inferencia(Preferencias,Buscar,Propiedades,Resultado,desconocido):-
	extraer_preferencias_por_propiedad(Preferencias,Buscar,PreferenciasFiltradas),
	ordenar_preferencias(PreferenciasFiltradas,PreferenciasOrdenadas),
	inferir_propiedad(PreferenciasOrdenadas,Buscar,Propiedades,Resultado,desconocido).

prepar_proceso_inferencia(_,_,_,Inferido,Inferido).

ordenar_preferencias([],[]).

ordenar_preferencias(Preferencias,Ordenadas):-
	orden_bur(Preferencias,EnOrden),
	reversa(EnOrden,Ordenadas).

concatener(A,B,X):-
	append(A,B,X).

reversa([],[]).

reversa([X|L1],M):-
	reversa(L1,Demas),
	concatener(Demas,[X],M).

orden_bur([Ant=>>Prop=>(Val,X)],[Ant=>>Prop=>(Val,X)]).
orden_bur([Ant=>>Prop=>(Val,X)],[Ant=>>no(Prop=>(Val,X))]).
orden_bur([Ant=>>no(Prop=>(Val,X))],[Ant=>>Prop=>(Val,X)]).
orden_bur([Ant=>>no(Prop=>(Val,X))],[Ant=>>no(Prop=>(Val,X))]).

orden_bur(L,Lord):-  
    burbuja(L,L1),
    orden_bur(L1,Lord).

orden_bur(X,X).

burbuja([],[]). 
burbuja([Ant=>>Prop=>(Val,C)],[Ant=>>Prop=>(Val,C)]).
burbuja([Ant=>>Prop=>(Val,C)],[Ant=>>no(Prop=>(Val,C))]).
burbuja([Ant=>>no(Prop=>(Val,C))],[Ant=>>Prop=>(Val,C)]).
burbuja([Ant=>>no(Prop=>(Val,C))],[Ant=>>no(Prop=>(Val,C))]).

burbuja([Ant2=>>Prop2=>(Val2,X),Ant3=>>Prop3=>(Val3,Y)|L],Lburb):-  
   X<Y,  
   burbuja([Ant2=>>Prop2=>(Val2,X)|L],L1),  
   Lburb = [Ant3=>>Prop3=>(Val3,Y)|L1]. 

burbuja([Ant2=>>no(Prop2=>(Val2,X)),Ant3=>>Prop3=>(Val3,Y)|L],Lburb):-  
   X<Y,  
   burbuja([Ant2=>>no(Prop2=>(Val2,X))|L],L1),  
   Lburb = [Ant3=>>Prop3=>(Val3,Y)|L1].

burbuja([Ant2=>>Prop2=>(Val2,X),Ant3=>>no(Prop3=>(Val3,Y))|L],Lburb):-  
   X<Y,  
   burbuja([Ant2=>>Prop2=>(Val2,X)|L],L1),  
   Lburb = [Ant3=>>no(Prop3=>(Val3,Y))|L1].

burbuja([Ant2=>>no(Prop2=>(Val2,X)),Ant3=>>no(Prop3=>(Val3,Y))|L],Lburb):-  
   X<Y,  
   burbuja([Ant2=>>no(Prop2=>(Val2,X))|L],L1),  
   Lburb = [Ant3=>>no(Prop3=>(Val3,Y))|L1].   

compara_preferencias([],_,si,_).

compara_preferencias([Propiedad=>(variable,_)|R],Prop,Desicion,Valor):-
	compara_preferencias(R,Prop,Desicion2,Valor),	
	comparar_propiedad_preferencia(Propiedad=>(variable,_),Prop,Valor,Desicion3),
	decidir(Desicion2,Desicion3,Desicion).

compara_preferencias([no(Propiedad=>(variable,_))|R],Prop,Desicion,Valor):-
	compara_preferencias(R,Prop,Desicion2,Valor),	
	comparar_propiedad_preferencia(Propiedad=>(variable,_),Prop,Valor,Desicion3),
	decidir(Desicion2,Desicion3,Desicion).

compara_preferencias([Propiedad=>(V,_)|R],Prop,Desicion,Valor):-
	compara_preferencias(R,Prop,Desicion2,Valor),	
	comparar_propiedad_preferencia(Propiedad=>(V,_),Prop,Valor,Desicion3),
	decidir(Desicion2,Desicion3,Desicion).

compara_preferencias([no(Propiedad=>(V,_))|R],Prop,Desicion,Valor):-
	compara_preferencias(R,Prop,Desicion2,Valor),	
	comparar_propiedad_preferencia(no(Propiedad=>(V,_)),Prop,Valor,Desicion3),
	decidir(Desicion2,Desicion3,Desicion).


decidir(si,si,si).
decidir(_,_,no).

comparar_propiedad_preferencia(_,[],[],no).

comparar_propiedad_preferencia(Propiedad=>(variable,_),[Propiedad=>(Valor,_)|_],Valor,si).
comparar_propiedad_preferencia([Propiedad=>(variable,_)],[Propiedad=>(Valor,_)|_],Valor,si).
comparar_propiedad_preferencia(Propiedad=>(variable,_),[Propiedad=>(Valor,_)|_],Valor2,no).

comparar_propiedad_preferencia(Propiedad=>(Valor,_),[Propiedad=>(Valor,_)|_],_,si).
comparar_propiedad_preferencia(Propiedad=>(_,_),[Propiedad=>(Valor2,_)|_],_,no).
comparar_propiedad_preferencia([Propiedad=>(Valor,_)],[Propiedad=>(Valor,_)|_],_,si).
comparar_propiedad_preferencia([Propiedad=>(_,_)],[Propiedad=>(Valor2,_)|_],_,no).

comparar_propiedad_preferencia(no(Propiedad=>(variable,_)),[Propiedad=>(Valor,_)|_],Valor,si).
comparar_propiedad_preferencia(no(Propiedad=>(variable,_)),[no(Propiedad=>(Valor,_))|_],Valor,si).
comparar_propiedad_preferencia(no(Propiedad=>(Valor,_)),[Propiedad=>(Valor,_)|_],_,si).
comparar_propiedad_preferencia(no(Propiedad=>(Valor,_)),[no(Propiedad=>(Valor,_))|_],_,si).
comparar_propiedad_preferencia(no(Propiedad=>(_,_)),[Propiedad=>(Valor2,_)|_],_,no).
comparar_propiedad_preferencia([no(Propiedad=>(Valor,_))],[Propiedad=>(Valor,_)|_],_,si).
comparar_propiedad_preferencia([no(Propiedad=>(Valor,_))],[no(Propiedad=>(Valor,_))|_],_,si).
comparar_propiedad_preferencia([no(Propiedad=>(_,_))],[Propiedad=>(Valor2,_)|_],_,no).

comparar_propiedad_preferencia(Buscar,[_|T],Valor,R):-
	comparar_propiedad_preferencia(Buscar,T,Valor,R).

extraer_preferencias_por_propiedad([],_,[]).

extraer_preferencias_por_propiedad([Ant=>>Buscar=>(Val,C)|Resto],Buscar,L):-
	extraer_preferencias_por_propiedad(Resto,Buscar,L1),
	append([Ant=>>Buscar=>(Val,C)],L1,L).

extraer_preferencias_por_propiedad([Ant=>>no(Buscar=>(Val,C))|Resto],Buscar,L):-
	extraer_preferencias_por_propiedad(Resto,Buscar,L1),
	append([Ant=>>no(Buscar=>(Val,C))],L1,L).

extraer_preferencias_por_propiedad([_|B],Buscar,L):-
	extraer_preferencias_por_propiedad(B,Buscar,L).


%si no se encuentra la propiedad se dice que no
buscar_propiedad(_,[],1000,desconocido).

%propiedades que son positivas
buscar_propiedad(Propiedad, [Propiedad=>(Valor,Peso)|_],Peso,Valor).
buscar_propiedad(Propiedad, [no(Propiedad=>(Valor,Peso))|_],Peso,Valor).

buscar_propiedad(Propiedad,[_|T],Peso,Valor):-
	buscar_propiedad(Propiedad,T,Peso,Valor).

obtener_propiedades_clase(_,[],[]).
obtener_propiedades_clase(Clase,[class(Clase,_,[[A|B]|_],_,_)|_], [A|B]).
obtener_propiedades_clase(Clase,[class(Clase,_,[[A|B]],_,_)|_], [A|B]).

%se llama recurisavamente hasta encontrar la clase correspondiente y obtener las propiedadades
obtener_propiedades_clase(Clase,[_|T],Propiedades):-
	obtener_propiedades_clase(Clase,T,Propiedades).

obtener_preferencias_clase(_,[],[]).
obtener_preferencias_clase(Clase,[class(Clase,_,[_|[A]],_,_)|_],A).
obtener_preferencias_clase(Clase,[class(Clase,_,[_|[A]],_,_)|_],A).

obtener_preferencias_clase(Clase,[_|T], Preferencias):-
	obtener_preferencias_clase(Clase,T,Preferencias).

obtener_hijos(Padre,[class(Hija,Padre,_,_,_)|Resto],Hijos):-
	obtener_hijos(Padre,Resto,Hermanos),
	append([Hija],Hermanos,Hijos).

obtener_hijos(Padre,[_|B],Hijo):-
	obtener_hijos(Padre,B,Hijo).

obtener_hijos(_,[],[]).

bajar_por_hijos_propiedad(Padre,[],PropiedadBuscar,PropiedadesHerencia,KB,Extension,PreferenciasHerencia):-
	obtener_propiedades_individuos_clase(Padre,PropiedadBuscar,PropiedadesHerencia,KB,Extension,PreferenciasHerencia).

bajar_por_hijos_propiedad(_,Hijos,PropiedadBuscar,PropiedadesHerencia,KB,Extension,PreferenciasHerencia):-
	recorre_hijos_propiedad(Hijos,PropiedadBuscar,PropiedadesHerencia,KB,Extension,PreferenciasHerencia).

recorre_hijos_propiedad([P|H],PropiedadBuscar,KB,Propiedades,Extension,PreferenciasHerencia):-
	obtener_extension_propiedad(P,PropiedadBuscar,KB,Propiedades,ExtensionNueva,PreferenciasHerencia),
	recorre_hijos_propiedad(H,PropiedadBuscar,KB,Propiedades,ExtensionNueva2,PreferenciasHerencia),
	append(ExtensionNueva2,ExtensionNueva,Extension).

recorre_hijos_propiedad([],_,_,_,[],_).
recorre_hijos_propiedad(_,_,[],_,[],_).

%--------------------------------------------------------------------------------------------------------

%predicado que permite obtener la extensión completa de una relacion en todo el árbol
%se obtienen los hijos de la clase
%se obtiene la lista de relaciones de la clase padre
%se concantenan las relaciones padre con las relaciones heredadas
%se elije el primer hijo y se busca si tiene la relacion dada
obtener_extension_relacion(ClaseActual,RelacionBuscar,RelacionesHeredadas,PreferenciasHeredadas,KB,Extension,RespaldoKB):-
	obtener_hijos(ClaseActual,KB,Hijos),											
	obtener_relaciones_clase(ClaseActual,KB,RelacionesPadre),
	obtener_preferencias_relaciones(ClaseActual,KB,PreferenciasHerencia),
	append(PreferenciasHerencia,PreferenciasHeredadas,Preferencias),									
	append(RelacionesPadre,RelacionesHeredadas,RelacionesHerencia),			
	bajar_por_hijos_relacion(ClaseActual,Hijos,RelacionBuscar,RelacionesHerencia,Preferencias,KB,Extension,RespaldoKB). 

obtener_extension_relacion([],_,_,_,_,[],_).

obtener_relaciones_individuos_clase(Clase,_,_,[class(Clase,_,_,_,[])|_],[],_).

obtener_relaciones_individuos_clase(Clase,RelacionBuscar,RelacionesHeredadas,Preferencias,[class(Clase,_,_,_,[[id=>Nombres,_,RelprefIndividuos]|NombresRestantes])|Resto],Extension,RespaldoKB):-
	extraer_todas_relaciones_individuo(RelprefIndividuos,RelacionesHeredadas,Preferencias,RelacionesInferidas,RespaldoKB),
	obtener_relaciones_individuos_clase(Clase,RelacionBuscar,RelacionesHeredadas,Preferencias,[class(Clase,_,_,_,NombresRestantes)|Resto],ExtensionDemasIndividuos,RespaldoKB),
	verificar_existencia_propiedad(RelacionBuscar,RelacionesInferidas,ResultadoBusqueda,Nombres),
	append([ResultadoBusqueda],ExtensionDemasIndividuos,Extension).

obtener_relaciones_individuos_clase(Clase,RelacionBuscar,RelacionesHeredadas,Preferencias,[class(Clase,_,_,_,[[id=>[Nombre|RestoNombres],_,[]]|Otros])|_],Extension,RespaldoKB):-
	buscar_relacion(RelacionBuscar,RelacionesHeredadas,ValorPorDefecto,RespaldoKB),
	prepar_proceso_inferencia_relacion(Preferencias,RelacionBuscar,RelacionesHeredadas,ValorInferido,ValorPorDefecto),
	append([Nombre|RestoNombres],[ValorInferido],Val1),
	extraer_relaciones_individuos(RelacionBuscar,RelacionesHeredadas,Preferencias,Otros,DemasValores,RespaldoKB),
	append([Val1],DemasValores,Extension).

obtener_relaciones_individuos_clase(Clase,RelacionBuscar,RelacionesHeredadas,Preferencias,[class(Clase,_,_,_,[[id=>[Nombre|RestoNombres],_,[]]|[]])|_],Extension,RespaldoKB):-
	buscar_relacion(RelacionBuscar,RelacionesHeredadas,ValorPorDefecto,RespaldoKB),
	prepar_proceso_inferencia_relacion(Preferencias,RelacionBuscar,RelacionesHeredadas,ValorInferido,ValorPorDefecto),
	append([Nombre|RestoNombres],[ValorInferido],Extension).

obtener_relaciones_individuos_clase(Clase,RelacionBuscar,RelacionesHeredadas,Preferencias,[_|T],Extension,RespaldoKB):-
	obtener_relaciones_individuos_clase(Clase,RelacionBuscar,RelacionesHeredadas,Preferencias,T,Extension,RespaldoKB).

obtener_relaciones_individuos_clase(_,_,_,_,[],[],_).

prepar_proceso_inferencia_relacion([],_,_,Inferido,Inferido).

prepar_proceso_inferencia_relacion(Preferencias,Buscar,Relaciones,Resultado,desconocido):-
	extraer_preferencias_por_relacion(Preferencias,Buscar,PreferenciasFiltradas),
	ordenar_preferencias(PreferenciasFiltradas,PreferenciasOrdenadas),
	inferir_relacion(PreferenciasOrdenadas,Buscar,Relaciones,Resultado,desconocido).

prepar_proceso_inferencia_relacion(_,_,_,Inferido,Inferido).

inferir_relacion([],_,_,A,A).

inferir_relacion([Antecedentes=>>Buscar=>(variable,_)|_],Buscar,Relaciones,Resultado,Inferido):-
	compara_preferencias(Antecedentes,Relaciones,Desicion,ValorD),
	inferencia_nueva_propiedad(Desicion,variable,ValorD,Resultado,Inferido).

inferir_relacion([Antecedentes=>>no(Buscar=>(variable,_))|_],Buscar,Relaciones,Resultado,Inferido):-
	compara_preferencias(Antecedentes,Relaciones,Desicion,ValorD),
	inferencia_nueva_propiedad(Desicion,variable,ValorD,Resultado,Inferido).

inferir_relacion([Antecedentes=>>Buscar=>(Valor,_)|_],Buscar,Relaciones,Resultado,Inferido):-
	compara_preferencias(Antecedentes,Relaciones,Desicion,_),
	inferencia_nueva_propiedad(Desicion,Valor,ValorD,Resultado,Inferido).

inferir_relacion([Antecedentes=>>no(Buscar=>(Valor,_))|_],Buscar,Relaciones,Resultado,Inferido):-
	compara_preferencias(Antecedentes,Relaciones,Desicion,ValorD),
	inferencia_nueva_propiedad(Desicion,Valor,ValorD,Resultado,Inferido).

inferir_relacion([_|B],Buscar,Relaciones,Resultado,Inferido):-
	inferir_relacion(B,Buscar,Relaciones,Resultado,Inferido).

obtener_preferencias_relaciones(_,[],[]).
obtener_preferencias_relaciones(Clase,[class(Clase,_,_,[_|[A]],_)|_],A).

obtener_preferencias_relaciones(Clase,[_|T], Preferencias):-
	obtener_preferencias_relaciones(Clase,T,Preferencias).

extraer_preferencias_por_relacion([],_,[]).

extraer_preferencias_por_relacion([Ant=>>Buscar=>(Val,C)|Resto],Buscar,L):-
	extraer_preferencias_por_relacion(Resto,Buscar,L1),
	append([Ant=>>Buscar=>(Val,C)],L1,L).

extraer_preferencias_por_relacion([Ant=>>no(Buscar=>(Val,C))|Resto],Buscar,L):-
	extraer_preferencias_por_relacion(Resto,Buscar,L1),
	append([Ant=>>no(Buscar=>(Val,C))],L1,L).

extraer_preferencias_por_relacion([_|B],Buscar,L):-
	extraer_preferencias_por_relacion(B,Buscar,L).

extraer_relaciones_individuos(RelacionBuscar,RelacionesHeredadas,Preferencias,[[id=>[Nombre|RestoNombres],_,[A|B]]|Resto],Extension,RespaldoKB):-
	append([A|B],RelacionesHeredadas,RelacionesCompletas),
	buscar_relacion(RelacionBuscar,RelacionesCompletas,ValorPorDefecto,RespaldoKB),
	prepar_proceso_inferencia_relacion(Preferencias,RelacionBuscar,RelacionesCompletas,ValorInferido,ValorPorDefecto),
	extraer_relaciones_individuos(RelacionBuscar,RelacionesHeredadas,Preferencias,Resto,RestoIndividuos,RespaldoKB),
	append([Nombre|RestoNombres],[ValorInferido],Ind1),
	append([Ind1],RestoIndividuos,Extension).

extraer_relaciones_individuos(RelacionBuscar,RelacionesHeredadas,Preferencias,[[id=>[Nombre|RestoNombres],_,[]]|Resto],Extension,RespaldoKB):-
	buscar_relacion(RelacionBuscar,RelacionesHeredadas,ValorPorDefecto,RespaldoKB),
	prepar_proceso_inferencia_relacion(Preferencias,RelacionBuscar,RelacionesHeredadas,ValorInferido,ValorPorDefecto),
	extraer_relaciones_individuos(RelacionBuscar,RelacionesHeredadas,Preferencias,Resto,RestoIndividuos,RespaldoKB),
	append([Nombre|RestoNombres],[ValorInferido],Ind1),
	append(Ind1,RestoIndividuos,Extension).

extraer_relaciones_individuos(RelacionBuscar,RelacionesHeredadas,Preferencias,[_|Resto],Extension,RespaldoKB):-
	extraer_relaciones_individuos(RelacionBuscar,RelacionesHeredadas,Preferencias,Resto,Extension,RespaldoKB).

extraer_relaciones_individuos(_,_,_,[],[],_).

%si no se encuentra la propiedad se dice que no
buscar_relacion(_,[],desconocido,_).

%propiedades que son positivas
buscar_relacion(Relacion, [Relacion=>(Individuo,_)|_],Valor,RespaldoKB):-
	individuos_de_una_clase(Individuo,RespaldoKB,ValorEcontrado),
	validar_individuo_buscado(ValorEcontrado,Individuo,Valor).

buscar_relacion(Relacion, [no(Relacion=>(Individuo,_))|_],Valor,RespaldoKB):-
	individuos_de_una_clase(Individuo,RespaldoKB,ValorEcontrado),
	validar_individuo_buscado(ValorEcontrado,Individuo,Valor).

%si no unifica en la relación entonces se siguen buscando en la relaciones
buscar_relacion(Relacion,[_|T],Valor,KB):-
	buscar_relacion(Relacion,T,Valor,KB).


validar_individuo_buscado(desconocido,V,V).
validar_individuo_buscado(V,_,V).

obtener_relaciones_clase(_,[],[]).
obtener_relaciones_clase(Clase,[class(Clase,_,_,[[A|B]|_],_)|_], [A|B]).
obtener_relaciones_clase(Clase,[class(Clase,_,_,[[A|B]],_)|_], [A|B]).

%se llama recurisavamente hasta encontrar la clase correspondiente y obtener las propiedadades
obtener_relaciones_clase(Clase,[_|T],Relaciones):-
	obtener_relaciones_clase(Clase,T,Relaciones).

bajar_por_hijos_relacion(Padre,[],RelacionBuscar,RelacionesHerencia,Preferencias,KB,Extension,RespaldoKB):-
	obtener_relaciones_individuos_clase(Padre,RelacionBuscar,RelacionesHerencia,Preferencias,KB,Extension,RespaldoKB).

bajar_por_hijos_relacion(_,Hijos,RelacionBuscar,RelacionesHerencia,Preferencias,KB,Extension,RespaldoKB):-
	recorre_hijos_relacion(Hijos,RelacionBuscar,RelacionesHerencia,Preferencias,KB,Extension,RespaldoKB).

recorre_hijos_relacion([P|H],RelacionBuscar,Relaciones,Preferencias,KB,Extension,RespaldoKB):-
	obtener_extension_relacion(P,RelacionBuscar,Relaciones,Preferencias,KB,ExtensionNueva,RespaldoKB),
	recorre_hijos_relacion(H,RelacionBuscar,Relaciones,Preferencias,KB,ExtensionNueva2,RespaldoKB),
	append(ExtensionNueva2,ExtensionNueva,Extension).

recorre_hijos_relacion([],_,_,_,_,[],_).
recorre_hijos_relacion(_,_,[],_,_,[],_).

%--------------------------------------------------------------------------------------------------------

%predicados para  obtener las clases a las que pertenece un individuo -----------------------------------

clases_pertenecientes_individuo(Individuo,KB,Pertenece):-
	obtener_clases_pertenecientes_individuo(top,Individuo,KB,Pertenece,[]),
	imprime_lista_resultados(Pertenece).

obtener_clases_pertenecientes_individuo(Padre,IndividuoBuscar,KB,Pertenece,Pila):-
	obtener_hijos(Padre,KB,Hijos),
	append([Padre],Pila,Pila2),
	bajar_por_hijos_clase_pertenecen(Padre,IndividuoBuscar,Hijos,KB,Pertenece,Pila2).

bajar_por_hijos_clase_pertenecen(Padre,IndividuoBuscar,[A|B],KB,Pertenece,Pila):-
	obtener_clases_pertenecientes_individuo(A,IndividuoBuscar,KB,Pertenece,Pila),
	bajar_por_hijos_clase_pertenecen(Padre,IndividuoBuscar,B,KB,Pertenece,Pila).

bajar_por_hijos_clase_pertenecen(Padre,IndividuoBuscar,[],KB,Pertenece,Pila):-
	obtener_clases_pertenecientes_individuo_nivel(Padre,IndividuoBuscar,KB,Pertenece,Pila).

%predicado base que detiene recursividad
bajar_por_hijos_clase_pertenecen(_,_,[],[],_,[]).

%una vez que encuentra la clase revisa si tiene individios y busca el deseado
obtener_clases_pertenecientes_individuo_nivel(Clase,IndividuoBuscar,[class(Clase,_,_,_,[A|B])|_],Pertenece,Pila):-
	buscar_individuo(IndividuoBuscar,[A|B],Pertenece,Pila).

%itera por toda la lista de KB hasta encontrar la clase deseada
obtener_clases_pertenecientes_individuo_nivel(Clase,IndividuoBuscar,[_|T],Pertenece,Pila):-
	obtener_clases_pertenecientes_individuo_nivel(Clase,IndividuoBuscar,T,Pertenece,Pila).

%predicado base que detiene la recursividad
obtener_clases_pertenecientes_individuo_nivel(_,_,[],[],_).
obtener_clases_pertenecientes_individuo_nivel(_,_,[],_,_).

%cuando se encuentra el individuo, se unifica la pila con el arreglo respuesta
buscar_individuo(IndividuoBuscar,[[id=>IndividuoBuscar,_,_]|_],Pertenece,Pertenece):-!.

%este predicado permite buscar en toda la lista de individios
buscar_individuo(IndividuoBuscar,[_|B],Pertenece,Pila):-
	buscar_individuo(IndividuoBuscar,B,Pertenece,Pila).

%predicado base que detiene la busqueda
buscar_individuo(_,[],[],_).

buscar_individuo(_,[],_,_).

%--------------------------------------------------------------------------------------------------------

% predicados para obtener todas las propiedades de un objeto --------------------------------------------

%predicado para obtener 
obtener_propiedades_completas_por_objeto(ClaseActual,KB,IndividuoBuscar,PropiedadesHeredadas,PreferenciasHeredadas,Resultado):-
	obtener_hijos(ClaseActual,KB,Hijos), 								 %obtiene los hijos de esta clase actual
	obtener_propiedades_clase(ClaseActual,KB,PropiedadesClase), 		 % obtiene las propiedades de la clase actual
	obtener_preferencias_clase(ClaseActual,KB,PreferenciasClase), 	 	 % obtiene las preferencias de la clase actual
	append(PropiedadesClase,PropiedadesHeredadas,PropiedadesHerencia),	 % concatena las propiedades heredadas y las propiedades propias de la clase
	decide_heredar_preferencias(PreferenciasClase,PreferenciasHeredadas,PreferenciasHerencia),
	iterar_por_hijos_propiedades_completas(ClaseActual,Hijos,KB,IndividuoBuscar,PropiedadesHerencia,PreferenciasHerencia,Resultado).

% este predicado unifica cuando ya no se tienen hijos entonces se tiene que buscar el objeto especifico
iterar_por_hijos_propiedades_completas(ClaseActual,[],KB,IndividuoBuscar,PropiedadesHerencia,PreferenciasHerencia,Resultado):-
	encontrar_objeto_especifico_por_clase(ClaseActual,KB,IndividuoBuscar,PropiedadesHerencia,PreferenciasHerencia,Resultado).

% este predicado unifica cuando aun se tienen que visitar mas clases
iterar_por_hijos_propiedades_completas(_,Hijos,KB,IndividuoBuscar,PropiedadesHerencia,PreferenciasHerencia,Resultado):-
	recorrer_arbol_propiedades_completos_objetos(Hijos,KB,IndividuoBuscar,PropiedadesHerencia,PreferenciasHerencia,Resultado).

%en este predicado se unifica cuando se encuentra la clase actual
encontrar_objeto_especifico_por_clase(ClaseActual,[class(ClaseActual,_,_,_,[[id=>Individios,PropInd,_]|Otros])|_],IndividuoBuscar,PropiedadesHerencia,PreferenciasHerencia,Resultado):-
	iterar_por_lista_propiedades_de_individuos([[id=>Individios,PropInd,_]|Otros],IndividuoBuscar,PropiedadesHerencia,PreferenciasHerencia,Resultado).

% si no se unifica en la claseactual se sigue buscando en el resto de la lista
encontrar_objeto_especifico_por_clase(ClaseActual,[_|B],IndividuoBuscar,PropiedadesHerencia,PreferenciasHerencia,Resultado):-
	encontrar_objeto_especifico_por_clase(ClaseActual,B,IndividuoBuscar,PropiedadesHerencia,PreferenciasHerencia,Resultado).

% predicado base que detiene la recursividad, ya no sigue buscando mas adentro arbol
encontrar_objeto_especifico_por_clase(_,[],_,_,_,[]).

iterar_por_lista_propiedades_de_individuos([],_,_,_,[]).

iterar_por_lista_propiedades_de_individuos([[id=>ListaIndividuoBuscar,PropInd,_]|Demas],IndividuoBuscar,PropHerencia,PrefHerencia,R):-
	buscar_propiedad_individuo_lista(ListaIndividuoBuscar,PropInd,IndividuoBuscar,PropHerencia,PrefHerencia,R),
	iterar_por_lista_propiedades_de_individuos(Demas,IndividuoBuscar,PropHerencia ,PrefHerencia,R).	

iterar_por_lista_propiedades_de_individuos(_,_,_,_,_).

buscar_propiedad_individuo_lista([],_,_,_,_,_).

buscar_propiedad_individuo_lista([IndividuoBuscar|_],PropIndi,IndividuoBuscar,PropHerencia ,PrefHerencia,R):-
	extraer_todas_propiedades_individuo(PropIndi,PropHerencia ,PrefHerencia,R).

buscar_propiedad_individuo_lista([_|Resto],PropIndi,IndividuoBuscar,PropHerencia ,PrefHerencia,R):-
	buscar_propiedad_individuo_lista(Resto,PropIndi,IndividuoBuscar,PropHerencia ,PrefHerencia,R).

%predicado base que detiene la recursividad
%extraer_todas_propiedades_individuo([],_,_,[]).

%  precidado que permite obtener todas las propiedades de un individuo, las propias y las inferidas ----------------
extraer_todas_propiedades_individuo([[PropIndI]|[PrefIndI]],PropHerencia,PrefHerencia,Resultado):-
	obtener_nuevas_propiedades_individuo(PropIndI,PrefIndI,PropHerencia,PrefHerencia,Resultado).

extraer_todas_propiedades_individuo([[PropIndI]|[]],PropHerencia,PrefHerencia,Resultado):-
	obtener_nuevas_propiedades_individuo(PropIndI,[],PropHerencia,PrefHerencia,Resultado).
	
extraer_todas_propiedades_individuo([[PropIndI]|PrefIndI],PropHerencia,PrefHerencia,Resultado):-
	obtener_nuevas_propiedades_individuo(PropIndI,[],PropHerencia,PrefHerencia,Resultado).
	
extraer_todas_propiedades_individuo([PropIndI|[PrefIndI]],PropHerencia,PrefHerencia,Resultado):-
	obtener_nuevas_propiedades_individuo(PropIndI,[],PropHerencia,PrefHerencia,Resultado).
	
extraer_todas_propiedades_individuo([PropIndI|PrefIndI],PropHerencia,PrefHerencia,Resultado):-
	obtener_nuevas_propiedades_individuo(PropIndI,[],PropHerencia,PrefHerencia,Resultado).
	
extraer_todas_propiedades_individuo([PropIndI|[]],PropHerencia,PrefHerencia,Resultado):-
	obtener_nuevas_propiedades_individuo(PropIndI,[],PropHerencia,PrefHerencia,Resultado).

extraer_todas_propiedades_individuo([[]|[PrefIndI]],PropHerencia,PrefHerencia,Resultado):-
	obtener_nuevas_propiedades_individuo([],PrefIndI,PropHerencia,PrefHerencia,Resultado).

extraer_todas_propiedades_individuo([],PropHerencia,PrefHerencia,Resultado):-
	obtener_nuevas_propiedades_individuo([],[],PropHerencia,PrefHerencia,Resultado).

obtener_nuevas_propiedades_individuo(PropIndI,PrefIndI,PropHerencia,PrefHerencia,Resultado):-
	%se concatenan las preferencias de los individios con las heredadas
	decide_heredar_preferencias(PrefIndI,PrefHerencia,PrefIndiHeren),

	%en esta parte se acomodan las preferencias en orden de implicación
	ordenar_preferencias_por_implicacion(PrefIndiHeren,PrefIndiHeren,PreferenciasOrdendas),

	eliminar_repetidos(PreferenciasOrdendas,PrefIndiHeren,Propiedades),
	
	% en esta parte se concatenan las preferencias en orden con las heredadas
	append(Propiedades,PrefIndiHeren,OrdenadasPorPreferencia), 

	%reversea la lista para poder realizar correctamente las inferencias
	reversa(PropHerencia,PropHerenciaInvertidas),

	eliminar_propiedades_por_especificidad(PropHerenciaInvertidas,PropiedadesEspecificidad),

	%aqui se encarga de eliminar las propiedades repetidas, se da prioridad a las del individuo	
	recorrer_propiedades_heredadas(PropiedadesEspecificidad,PropIndI,Filtradas),	

	%aqui se concantenan las propiedades propias del individuo con las propiedades heredadas
	append(PropIndI,Filtradas,PropiedadesCompletas),
	
	%reversea la lista para poder realizar correctamente las inferencias
	reversa(OrdenadasPorPreferencia,OrdenadasPorPreferenciaInvertidas),

	%inicia con el proceso de inferencia multiple
	iniciar_inferencias_multiples(OrdenadasPorPreferenciaInvertidas,PropiedadesCompletas,Inferido,OrdenadasPorPreferenciaInvertidas),

	%concatena la lista de propiedades del individuo con las inferidas
	append(PropiedadesCompletas,Inferido,Resultado).

eliminar_propiedades_por_especificidad([],[]).

eliminar_propiedades_por_especificidad([Propiedad=>(Valor,Pes)|D],C):-
 	eliminar_propiedades_por_especificidad(D,C2),
	buscar_propiedad(Propiedad,C2,_,X),
	verificar_resultado_repetido(X,Propiedad=>(Valor,Pes),C2,C).

eliminar_propiedades_por_especificidad([no(Propiedad=>(Valor,Pes))|D],C):-
 	eliminar_propiedades_por_especificidad(D,C2),
	buscar_propiedad(Propiedad,C2,_,X),
	verificar_resultado_repetido(X,no(Propiedad=>(Valor,Pes)),C2,C).

ordenar_preferencias_por_implicacion([],_,[]).

ordenar_preferencias_por_implicacion(P,_,P).

ordenar_preferencias_por_implicacion([Antecedentes=>>_=>(_,_)|D],Pref,R):-
	iterar_implicaciones_propiedades(Antecedentes,Pref,R2),
	ordenar_preferencias_por_implicacion(D,Pref,R3),
	append(R2,R3,R).

ordenar_preferencias_por_implicacion([Antecedentes=>>no(_=>(_,_))|D],Pref,R):-
	iterar_implicaciones_propiedades(Antecedentes,Pref,R2),
	ordenar_preferencias_por_implicacion(D,Pref,R3),
	append(R2,R3,R).

eliminar_repetidos([],_,[]).

eliminar_repetidos([Antecedentes=>>Consecuente=>(V,P)|D],PropIndi,R):-
	eliminar_repetidos(D,PropIndi,R2),
	buscar_propiedad(Consecuente,PropIndi,_,X),
	verificar_resultado_repetido(X,Antecedentes=>>Consecuente=>(V,P),R2,R).

eliminar_repetidos([Antecedentes=>>no(Consecuente=>(V,P))|D],PropIndi,R):-
	eliminar_repetidos(D,PropIndi,R2),
	buscar_propiedad(Consecuente,PropIndi,_,X),
	verificar_resultado_repetido(X,Antecedentes=>>no(Consecuente=>(V,P)),R2,R).

eliminar_repetidos(A,A,[]).

iterar_implicaciones_propiedades([],_,[]).

iterar_implicaciones_propiedades([Prop=>(_,_)|D],Pref,R):-
	buscar_propiedad_consecuente(Prop,Pref,R2),
	iterar_implicaciones_propiedades(D,Pref,R3),
	append(R2,R3,R).

iterar_implicaciones_propiedades([no(Prop=>(_,_))|D],Pref,R):-
	buscar_propiedad_consecuente(Prop,Pref,R2),
	iterar_implicaciones_propiedades(D,Pref,R3),
	append(R2,R3,R).

buscar_propiedad_consecuente(Consecuente,[Antecedentes=>>Consecuente=>(Valor,Peso)|_],R):-
	R = [Antecedentes=>>Consecuente=>(Valor,Peso)].

buscar_propiedad_consecuente(Consecuente,[Antecedentes=>>no(Consecuente=>(Valor,Peso))|_],R):-
	R = [Antecedentes=>>no(Consecuente=>(Valor,Peso))].

buscar_propiedad_consecuente(Consecuente,[_|B],R):-
	buscar_propiedad_consecuente(Consecuente,B,R).

%caso base que detiene la recursividad
buscar_propiedad_consecuente(_,[],[]).

%caso base que detiene la recursividad
recorrer_propiedades_heredadas([],_,[]).

recorrer_propiedades_heredadas(A,[],A).

%predicado que permite obtener las propiedades heredades que no se repiten en las propiedades propias
recorrer_propiedades_heredadas([Propiedad=>(Valor,Pes)|B],PropIndI,Resultado):-	
	recorrer_propiedades_heredadas(B,PropIndI,Resultado2),
	append(Resultado2,PropIndI,Completas),
	buscar_propiedad(Propiedad,Completas,_,X),
	verificar_resultado_repetido(X,Propiedad=>(Valor,Pes),Resultado2,Resultado).

recorrer_propiedades_heredadas([no(Propiedad=>(Valor,Pes))|B],PropIndI,Resultado):-	
	recorrer_propiedades_heredadas(B,PropIndI,Resultado2),
	append(Resultado2,PropIndI,Completas),
	buscar_propiedad(Propiedad,Completas,_,X),
	verificar_resultado_repetido(X,no(Propiedad=>(Valor,Pes)),Resultado2,Resultado).

%predicado que permite verificar que efectivamente no este la propiedad repetida
verificar_resultado_repetido(desconocido,PropPref,Resultado2,Resultado):-
	append([PropPref],Resultado2,Resultado).

%este predicado se ejecuta si ya existe la propiedad
verificar_resultado_repetido(_,_,Resultado2,Resultado2).

iniciar_inferencias_multiples([],_,[],[]).

%caso base que detiene la recursividad
iniciar_inferencias_multiples([],_,[],_).

iniciar_inferencias_multiples([_=>>Propiedad=>(_,Peso)|Resto],Propiedades,PropiedadesInferidas,Preferencias):-
	iniciar_inferencias_multiples(Resto,Propiedades,PropiedadesInferidas2,Preferencias), % se llama recursivamente hasta encontrar el caso base
	buscar_propiedad(Propiedad,PropiedadesInferidas2,_,X), %primero verificamos que no exista ya la propiedad inferida en las propiedades inferidas
	append(Propiedades,PropiedadesInferidas2,Completas),
	validar_no_existencia(X,Propiedad,Preferencias,Completas,Inferir),
	verificar_inferencia(Inferir,[Propiedad=>(Inferir,0)],Peso,ResultadoInferido),
	append(ResultadoInferido,PropiedadesInferidas2,PropiedadesInferidas).

iniciar_inferencias_multiples([_=>>no(Propiedad=>(_,Peso))|Resto],Propiedades,PropiedadesInferidas,Preferencias):-
	iniciar_inferencias_multiples(Resto,Propiedades,PropiedadesInferidas2,Preferencias), % se llama recursivamente hasta encontrar el caso base
	buscar_propiedad(Propiedad,PropiedadesInferidas2,_,X), %primero verificamos que no exista ya la propiedad inferida en las propiedades inferidas
	append(Propiedades,PropiedadesInferidas2,Completas),
	validar_no_existencia(X,Propiedad,Preferencias,Completas,Inferir),
	verificar_inferencia(Inferir,[no(Propiedad=>(_,Peso))],Peso,ResultadoInferido),
	append(ResultadoInferido,PropiedadesInferidas2,PropiedadesInferidas).

verificar_inferencia(desconocido,_,_,[]).
verificar_inferencia([],_,_,[]).
verificar_inferencia(_,Propiedad,_,Resultado):-
	Resultado = Propiedad.

validar_no_existencia(desconocido,Propiedad,Preferencias,PropiedadesCompletas,Inferido):-
	extraer_preferencias_por_propiedad(Preferencias,Propiedad,Filtradas),
	ordenar_preferencias(Filtradas,PreferenciasOrdenadas),
	inferir_propiedad(PreferenciasOrdenadas,Propiedad,PropiedadesCompletas,Inferido,desconocido).

validar_no_existencia(_,_,_,_,[]).


% predicado que recorre el resto de las clase árbol
recorrer_arbol_propiedades_completos_objetos([A|B],KB,IndividuoBuscar,PropiedadesHerencia,PreferenciasHerencia,Resultado):-
	obtener_propiedades_completas_por_objeto(A,KB,IndividuoBuscar,PropiedadesHerencia,PreferenciasHerencia,ResultadoA),
	recorrer_arbol_propiedades_completos_objetos(B,KB,IndividuoBuscar,PropiedadesHerencia,PreferenciasHerencia,ResultadoB),
	append(ResultadoA,ResultadoB,Resultado).

% predicado case base que detiene la recursividad
recorrer_arbol_propiedades_completos_objetos([],_,_,_,_,[]).

%--------------------------------------------------------------------------------------------------------

buscar_propiedades_clase(ClaseBuscar,ClaseBuscar,KB,PropiedadesHeredadas,PrefHerencia,Propiedades):-
	obtener_propiedades_clase(ClaseBuscar,KB,PropiedadesClase),
	obtener_preferencias_clase(ClaseBuscar,KB,PreferenciasClase), 
	extraer_todas_propiedades_individuo([PropiedadesClase,PreferenciasClase],PropiedadesHeredadas,PrefHerencia,Propiedades).

buscar_propiedades_clase(ClaseActual,ClaseBuscar,KB,PropiedadesHeredadas,PrefHerencia,Propiedades):-
	obtener_hijos(ClaseActual,KB,Hijos),
	obtener_propiedades_clase(ClaseActual,KB,PropiedadesClase),
	obtener_preferencias_clase(ClaseActual,KB,PreferenciasClase), 	 	 
	append(PropiedadesClase,PropiedadesHeredadas,PropiedadesHerencia),
	decide_heredar_preferencias(PreferenciasClase,PrefHerencia,PreferenciasHerencia),
	bajar_por_hijos_propiedades_clase(Hijos,ClaseBuscar,KB,PropiedadesHerencia,PreferenciasHerencia,Propiedades).

%si ya no tiene hijos se detiene
bajar_por_hijos_propiedades_clase([],_,_,_,_,_).

bajar_por_hijos_propiedades_clase(Hijos,ClaseBuscar,KB,PropiedadesHerencia,PrefHerencia,Propiedades):-
	recorre_hijos_propiedad_clase(Hijos,ClaseBuscar,KB,PropiedadesHerencia,PrefHerencia,Propiedades).

recorre_hijos_propiedad_clase([P|H],ClaseBuscar,KB,PropiedadesHeredadas,PrefHerencia,Propiedades):-
	buscar_propiedades_clase(P,ClaseBuscar,KB,PropiedadesHeredadas,PrefHerencia,Propiedades2),
	recorre_hijos_propiedad_clase(H,ClaseBuscar,KB,PropiedadesHeredadas,PrefHerencia,Propiedades3),
	append(Propiedades2,Propiedades3,Propiedades).

recorre_hijos_propiedad_clase([],_,_,_,_,[]).
recorre_hijos_propiedad_clase(_,_,[],_,_,[]).

%--------------------------------------------------------------------------------------------------------

% predicados para obtener todas las relaciones de una clase ---------------------------------------------


buscar_relaciones_clase(ClaseBuscar,ClaseBuscar,KB,RelHerencia,PrefHerencia,Relaciones):-
	obtener_relaciones_clase(ClaseBuscar,KB,RelInd),
	obtener_preferencias_relaciones(ClaseBuscar,KB,PrefIndI),
	extraer_todas_relaciones_individuo([RelInd,PrefIndI],RelHerencia,PrefHerencia,Relaciones,KB).

buscar_relaciones_clase(ClaseActual,ClaseBuscar,KB,RelacionesHeredadas,PreferenciasHerencia,Relaciones):-
	obtener_hijos(ClaseActual,KB,Hijos),
	obtener_relaciones_clase(ClaseActual,KB,RelacionesClase),
	append(RelacionesClase,RelacionesHeredadas,RelacionesHerencia),
	obtener_preferencias_relaciones(ClaseActual,KB,PreferenciasClase),
	decide_heredar_preferencias(PreferenciasClase,PreferenciasHerencia,PrefCompletas), 
	bajar_por_hijos_relaciones_clase(Hijos,ClaseBuscar,KB,RelacionesHerencia,PrefCompletas,Relaciones).

%si ya no tiene hijos se detiene
bajar_por_hijos_relaciones_clase([],_,_,_,_,_).

bajar_por_hijos_relaciones_clase(Hijos,ClaseBuscar,KB,RelacionesHerencia,PrefHerencia,Relaciones):-
	recorre_hijos_relacion_clase(Hijos,ClaseBuscar,KB,RelacionesHerencia,PrefHerencia,Relaciones).

recorre_hijos_relacion_clase([P|H],ClaseBuscar,KB,RelacionesHeredadas,PrefHerencia,Relaciones):-
	buscar_relaciones_clase(P,ClaseBuscar,KB,RelacionesHeredadas,PrefHerencia,Propiedades2),
	recorre_hijos_relacion_clase(H,ClaseBuscar,KB,RelacionesHeredadas,PrefHerencia,Propiedades3),
	append(Propiedades2,Propiedades3,Relaciones).

recorre_hijos_relacion_clase([],_,_,_,_,[]).
recorre_hijos_relacion_clase(_,_,[],_,_,[]).
%--------------------------------------------------------------------------------------------------------


%predicado para obtener 
obtener_relaciones_completas_por_objeto(ClaseActual,KB,IndividuoBuscar,RelacionesHeredadas,PreferenciasHeredadas,Resultado,KB):-
	obtener_hijos(ClaseActual,KB,Hijos), %obtiene los hijos de esta clase actual
	obtener_relaciones_clase(ClaseActual,KB,RelacionesClase), 		 % obtiene las relaciones de la clase actual
	obtener_preferencias_relaciones(ClaseActual,KB,PreferenciasClase), 	 % obtiene las preferencias de la clase actual
	append(RelacionesClase,RelacionesHeredadas,RelacionesHerencia),% concatena las relaciones heredadas y las relaciones propias de la clase
	decide_heredar_preferencias(PreferenciasClase,PreferenciasHeredadas,PreferenciasHerencia),
	iterar_por_hijos_relaciones_completas(ClaseActual,Hijos,KB,IndividuoBuscar,RelacionesHerencia,PreferenciasHerencia,Resultado,KB).

% este predicado unifica cuando ya no se tienen hijos entonces se tiene que buscar el objeto especifico
iterar_por_hijos_relaciones_completas(ClaseActual,[],KB,IndividuoBuscar,RelacionesHerencia,PreferenciasHerencia,Resultado,KB):-
	encontrar_objeto_especifico_por_clase_relacion(ClaseActual,KB,IndividuoBuscar,RelacionesHerencia,PreferenciasHerencia,Resultado,KB).

% este predicado unifica cuando aun se tienen que visitar mas clases
iterar_por_hijos_relaciones_completas(_,Hijos,KB,IndividuoBuscar,RelacionesHerencia,PreferenciasHerencia,Resultado,KB):-
	recorrer_arbol_relaciones_completos_objetos(Hijos,KB,IndividuoBuscar,RelacionesHerencia,PreferenciasHerencia,Resultado,KB).

%en este predicado se unifica cuando se encuentra la clase actual
encontrar_objeto_especifico_por_clase_relacion(ClaseActual,[class(ClaseActual,_,_,_,[[id=>Individios,_,RelInd]|Otros])|_],IndividuoBuscar,RelacionesHerencia,PreferenciasHerencia,Resultado,KB):-
	iterar_por_lista_relaciones_de_indidividuos([[id=>Individios,_,RelInd]|Otros],IndividuoBuscar,RelacionesHerencia,PreferenciasHerencia,Resultado,KB).

encontrar_objeto_especifico_por_clase_relacion(ClaseActual,[class(ClaseActual,_,_,_,[[id=>Individios,_,[]]|Otros])|_],IndividuoBuscar,RelacionesHerencia,PreferenciasHerencia,Resultado,KB):-
	iterar_por_lista_relaciones_de_indidividuos(IndividuoBuscar,[[id=>Individios,_,[]]|Otros],IndividuoBuscar,RelacionesHerencia,PreferenciasHerencia,Resultado,KB).

encontrar_objeto_especifico_por_clase_relacion(ClaseActual,[class(ClaseActual,_,_,_,[[id=>Individios,_,[]]|[]])|_],IndividuoBuscar,RelacionesHerencia,PreferenciasHerencia,Resultado,KB):-
	iterar_por_lista_relaciones_de_indidividuos(IndividuoBuscar,[[id=>Individios,_,[]]|[]],IndividuoBuscar,RelacionesHerencia,PreferenciasHerencia,Resultado,KB).

% si no se unifica en la claseactual se sigue buscando en el resto de la lista
encontrar_objeto_especifico_por_clase_relacion(ClaseActual,[_|B],IndividuoBuscar,RelacionesHerencia,PreferenciasHerencia,Resultado,KB):-
	encontrar_objeto_especifico_por_clase_relacion(ClaseActual,B,IndividuoBuscar,RelacionesHerencia,PreferenciasHerencia,Resultado,KB).

% predicado base que detiene la recursividad, ya no sigue buscando mas adentro arbol
encontrar_objeto_especifico_por_clase_relacion(_,[],_,_,_,[],_).

iterar_por_lista_relaciones_de_indidividuos([],_,_,_,[],_).

iterar_por_lista_relaciones_de_indidividuos([[id=>ListaIndividuoBuscar,_,RelInd]|Demas],IndividuoBuscar,RelHerencia,PrefHerencia,R,KB):-
	buscar_relacion_individuo_lista(ListaIndividuoBuscar,RelInd,IndividuoBuscar,RelHerencia,PrefHerencia,R,KB),
	iterar_por_lista_relaciones_de_indidividuos(Demas,IndividuoBuscar,RelHerencia,PrefHerencia,R,KB).

iterar_por_lista_relaciones_de_indidividuos(_,_,_,_,_,_).

buscar_relacion_individuo_lista([],_,_,_,_,_,_).

buscar_relacion_individuo_lista([IndividuoBuscar|_],RelIndi, IndividuoBuscar,RelacionesHerencia,PreferenciasHerencia,Resultado,KB):-
	extraer_todas_relaciones_individuo(RelIndi,RelacionesHerencia,PreferenciasHerencia,Resultado,KB).

buscar_relacion_individuo_lista([_|Resto],RelIndi, IndividuoBuscar,RelacionesHerencia,PreferenciasHerencia,Resultado,KB):-
	buscar_relacion_individuo_lista(Resto,RelIndi, IndividuoBuscar,RelacionesHerencia,PreferenciasHerencia,Resultado,KB).

%predicado base que detiene la recursividad
%extraer_todas_relaciones_individuo(_,[],_,_,[],_).

extraer_todas_relaciones_individuo([RelIndi|[PrefIndi]],RelHerencia,PrefHerencia,Resultado,KB):-
	obtener_nuevas_relaciones_inidividuo(RelIndi,PrefIndi,RelHerencia,PrefHerencia,Resultado,KB).

extraer_todas_relaciones_individuo([RelIndi|[]],RelHerencia,PrefHerencia,Resultado,KB):-
	obtener_nuevas_relaciones_inidividuo(RelIndi,[],RelHerencia,PrefHerencia,Resultado,KB).
	
extraer_todas_relaciones_individuo([[RelIndi]|PrefIndi],RelHerencia,PrefHerencia,Resultado,KB):-
	obtener_nuevas_relaciones_inidividuo(RelIndi,[],RelHerencia,PrefHerencia,Resultado,KB).

extraer_todas_relaciones_individuo([RelIndi|[PrefIndi]],RelHerencia,PrefHerencia,Resultado,KB):-
	obtener_nuevas_relaciones_inidividuo(RelIndi,PrefIndi,RelHerencia,PrefHerencia,Resultado,KB).

extraer_todas_relaciones_individuo([RelIndi|PrefIndi],RelHerencia,PrefHerencia,Resultado,KB):-
	obtener_nuevas_relaciones_inidividuo(RelIndi,PrefIndi,RelHerencia,PrefHerencia,Resultado,KB).

extraer_todas_relaciones_individuo([[]|PrefIndi],RelHerencia,PrefHerencia,Resultado,KB):-
	obtener_nuevas_relaciones_inidividuo([],PrefIndi,RelHerencia,PrefHerencia,Resultado,KB).

extraer_todas_relaciones_individuo([],RelHerencia,PrefHerencia,Resultado,KB):-
	obtener_nuevas_relaciones_inidividuo([],[],RelHerencia,PrefHerencia,Resultado,KB).

obtener_nuevas_relaciones_inidividuo(RelInd,PrefIndI,RelHerencia,PrefHerencia,Resultado,KB):-
	decide_heredar_preferencias(PrefIndI,PrefHerencia,PrefIndiHeren),
	ordenar_preferencias_por_implicacion(PrefIndiHeren,PrefIndiHeren,PreferenciasOrdendas),
	eliminar_repetidos(PreferenciasOrdendas,PrefIndiHeren,Propiedades),	
	append(Propiedades,PrefIndiHeren,OrdenadasPorPreferencia),
	reversa(RelHerencia,RelHerenciaInvertidas),
	eliminar_propiedades_por_especificidad(RelHerenciaInvertidas,RelEspecificidad),
	recorrer_relaciones_heredadas(RelEspecificidad,RelInd,Filtradas,KB),
	append(RelInd,Filtradas,RelacionesCompletas),
	reversa(OrdenadasPorPreferencia,OrdenadasPorPreferenciaInvertidas),
	iniciar_inferencias_multiples_relacion(OrdenadasPorPreferenciaInvertidas,RelacionesCompletas,Inferido,OrdenadasPorPreferenciaInvertidas,KB),
	append(RelacionesCompletas,Inferido,PropiedadesNuevas),
	obtener_nombres_extension_relacion(PropiedadesNuevas,Resultado,KB).


validar_nombre_extension_vacia([],V,V).
validar_nombre_extension_vacia(V,_,V).

obtener_nombres_extension_relacion([],[],_).

obtener_nombres_extension_relacion([Relacion=>(Valor,Pes)|Resto],Relaciones,KB):-
	obtener_nombres_extension_relacion(Resto,Relaciones2,KB),
	extension_de_clase(Valor,KB,ExtensionClase),
	validar_nombre_extension_vacia(ExtensionClase,Valor,Extension),
	verificar_relacion_desconocida(ExtensionClase,Relacion=>(Extension,Pes),Relacion=>(Valor,Pes),Relaciones2,Relaciones).

obtener_nombres_extension_relacion([no(Relacion=>(Valor,Pes))|Resto],Relaciones,KB):-
	obtener_nombres_extension_relacion(Resto,Relaciones2,KB),
	extension_de_clase(Valor,KB,ExtensionClase),
	validar_nombre_extension_vacia(ExtensionClase,Valor,Extension),
	verificar_relacion_desconocida(ExtensionClase,no(Relacion=>(Extension,Pes)),no(Relacion=>(Valor,Pes)),Relaciones2,Relaciones).

verificar_relacion_desconocida(desconocido,_,Valor,R1,R):-
	append([Valor],R1,R).

verificar_relacion_desconocida(_,Relacion,_,R1,R):-
	append([Relacion],R1,R).

recorrer_relaciones_heredadas([],_,[],_).

recorrer_relaciones_heredadas([Relacion=>(Valor,Pes)|B], RelacionesPropias,Resultado,KB):-	
	recorrer_relaciones_heredadas(B,RelacionesPropias,Resultado2,KB),	
	buscar_relacion_sin_nombres(Relacion,RelacionesPropias,X,KB),
	verificar_resultado_repetido_relacion(X,Relacion=>(Valor,Pes),Resultado2,Resultado).

recorrer_relaciones_heredadas([no(Relacion=>(Valor,Pes))|B], RelacionesPropias,Resultado,KB):-	
	recorrer_relaciones_heredadas(B,RelacionesPropias,Resultado2,KB),	
	buscar_relacion_sin_nombres(Relacion,RelacionesPropias,X,KB),
	verificar_resultado_repetido_relacion(X,no(Relacion=>(Valor,Pes)),Resultado2,Resultado).

	%si no se encuentra la propiedad se dice que no
buscar_relacion_sin_nombres(_,[],desconocido,_).

%propiedades que son positivas
buscar_relacion_sin_nombres(Relacion, [Relacion=>(Individuo,_)|_],Individuo,_).
buscar_relacion_sin_nombres(Relacion, [no(Relacion=>(Individuo,_))|_],Individuo,_).

%si no unifica en la relación entonces se siguen buscando en la relaciones
buscar_relacion_sin_nombres(Relacion,[_|T],Individuo,KB):-
	buscar_relacion_sin_nombres(Relacion,T,Individuo,KB).

verificar_resultado_repetido_relacion(desconocido,Relacion,Resultado2,Resultado):-
	append([Relacion],Resultado2,Resultado).

verificar_resultado_repetido_relacion(_,_,Resultado2,Resultado2).

iniciar_inferencias_multiples_relacion([],_,[],[],_).

iniciar_inferencias_multiples_relacion([],_,[],_,_).

iniciar_inferencias_multiples_relacion([_=>>Relacion=>(_,Peso)|Resto],Relaciones,RelacionesInferidas,Preferencias,KB):-
	iniciar_inferencias_multiples_relacion(Resto,Relaciones,RelacionesInferidas2,Preferencias,KB),	
	append(Relaciones,RelacionesInferidas2,Completas),
	buscar_relacion(Relacion,Completas,X,KB), 	
	validar_no_existencia_relacion(X,Relacion,Preferencias,Completas,Inferir),
	verificar_inferencia_relacion(Inferir,[Relacion=>(Inferir,Peso)],Peso,ResultadoInferido),
	append(ResultadoInferido,RelacionesInferidas2,RelacionesInferidas).

iniciar_inferencias_multiples_relacion([_=>>no(Relacion=>(_,Peso))|Resto],Relaciones,RelacionesInferidas,Preferencias,KB):-
	iniciar_inferencias_multiples_relacion(Resto,Relaciones,RelacionesInferidas2,Preferencias,KB),	
	append(Relaciones,RelacionesInferidas2,Completas),
	buscar_relacion(Relacion,Completas,X,KB), 	
	validar_no_existencia_relacion(X,Relacion,Preferencias,Completas,Inferir),
	verificar_inferencia_relacion(Inferir,[no(Relacion=>(Inferir,Peso))],Peso,ResultadoInferido),
	append(ResultadoInferido,RelacionesInferidas2,RelacionesInferidas).
	
verificar_inferencia_relacion(desconocido,_,_,[]).
verificar_inferencia_relacion([],_,_,[]).
verificar_inferencia_relacion(_,Relacion,_,Resultado):-
	Resultado = Relacion.

validar_no_existencia_relacion(desconocido,Relacion,Preferencias,PropiedadesCompletas,Inferido):-
	extraer_preferencias_por_propiedad(Preferencias,Relacion,Filtradas),
	ordenar_preferencias(Filtradas,PreferenciasOrdenadas),
	inferir_propiedad(PreferenciasOrdenadas,Relacion,PropiedadesCompletas,Inferido,desconocido).

validar_no_existencia_relacion(_,_,_,_,[]).


% predicado que recorre el resto de las clase árbol
recorrer_arbol_relaciones_completos_objetos([A|B],KB,IndividuoBuscar,RelacionesHerencia,PreferenciasHerencia,Resultado,KB):-
	obtener_relaciones_completas_por_objeto(A,KB,IndividuoBuscar,RelacionesHerencia,PreferenciasHerencia,ResultadoA,KB),
	recorrer_arbol_relaciones_completos_objetos(B,KB,IndividuoBuscar,RelacionesHerencia,PreferenciasHerencia,ResultadoB,KB),
	append(ResultadoA,ResultadoB,Resultado).

% predicado case base que detiene la recursividad
recorrer_arbol_relaciones_completos_objetos([],_,_,_,_,[],_).
%-----------------------------------------------------------------------------------------
%  ---- Fin de predicados auxiliares para obtener extension ------------------------------
% ****************************************************************************************



% ****************************************************************************************
%  ---- Inicio de predicados auxiliares para agregar extension ---------------------------
padre_clase(_,[],desconocido).
padre_clase(Class,[class(Class,Padre,_,_,_)|_],Padre).
padre_clase(Class,[_|T],Padre):-
	padre_clase(Class,T,Padre).

ancestros_clase(desconocido,_,[]).
ancestros_clase(top,_,[]).
ancestros_clase(Class,KB,Ancestro):-
	padre_clase(Class,KB,Padre),
	append([Padre],Abuelo,Ancestro),
	ancestros_clase(Padre,KB,Abuelo).

%%************ Predicados para agregar una nueva propiedad o relacion de clase/individuo
agregar_propiedad_relacion([],NuevaPropRel,Valor,si,ListaNuevasPropRelPref):-
	append([],[[no(NuevaPropRel=>Valor)], []],ListaNuevasPropRelPref).

agregar_propiedad_relacion([PropsRels|Pref],NuevaPropRel,Valor,si,ListaNuevasPropRelPref):-
	append(PropsRels,[no(NuevaPropRel=>Valor)],ListaActualPropRel),
	append([ListaActualPropRel],Pref,ListaNuevasPropRelPref).

agregar_propiedad_relacion([],NuevaPropRel,Valor,no,ListaNuevasPropRelPref):-
	append([],[[NuevaPropRel=>Valor], []],ListaNuevasPropRelPref).

agregar_propiedad_relacion([PropsRels|Pref],NuevaPropRel,Valor,no,ListaNuevasPropRelPref):-
	append(PropsRels,[NuevaPropRel=>Valor],ListaActualPropRel),
	append([ListaActualPropRel],Pref,ListaNuevasPropRelPref).

%%************ Predicados para agregar nueva preferencia de propiedad o relacion de clase/individuo
agregar_preferencia([], Antecedente, Consecuente, Valor, si, ListaNuevasPropPref):-
	append([], [[], [Antecedente=>>no(Consecuente=>Valor)]], ListaNuevasPropPref).

agregar_preferencia([Props|[Pref|_]], Antecedente, Consecuente, Valor, si, ListaNuevasPropPref):-
	append(Pref, [Antecedente=>>no(Consecuente=>Valor)], ListaActualPref),
	append([Props], [ListaActualPref], ListaNuevasPropPref).

agregar_preferencia([Props|[[]]], Antecedente, Consecuente, Valor, si, ListaNuevasPropPref):-
	append([], [Antecedente=>>no(Consecuente=>Valor)], ListaActualPref),
	append([Props], [ListaActualPref], ListaNuevasPropPref).

agregar_preferencia([], Antecedente, Consecuente, Valor, no, ListaNuevasPropPref):-
	append([], [[], [Antecedente=>>Consecuente=>Valor]], ListaNuevasPropPref).

agregar_preferencia([Props|[[]]], Antecedente, Consecuente, Valor, no, ListaNuevasPropPref):-
	append([], [Antecedente=>>Consecuente=>Valor], ListaActualPref),
	append([Props], [ListaActualPref], ListaNuevasPropPref).

agregar_preferencia([Props|[Pref|_]], Antecedente, Consecuente, Valor, no, ListaNuevasPropPref):-
	append(Pref, [Antecedente=>>Consecuente=>Valor], ListaActualPref),
	append([Props], [ListaActualPref], ListaNuevasPropPref).
%  -----------------------------------------------------------------------------------
%  ---- Fin de predicados auxiliares para agregar infor ------------------------------


% ************************************************************************************
%  ---- Inicios de predicados auxiliares para Eliminar Informacion  ------------------
% ------------------------------------------------------------------------------------
%Delete all elements with a specific property in a property-value list
%borrarElementosConPropiedad(P,InputList,OutputList).
%Example (p2,[p1=>v1,p2=>v2,p3=>v3,p2=>v4,p4=>v4],[p1=>v1,p3=>v3,p4=>v4])

borrarElementosConPropiedad(_,[],[]).

borrarElementosConPropiedad(X,[X=>_|T],N):-
	write("T:"),
	write(T),
	borrarElementosConPropiedad(X,T,N).

borrarElementosConPropiedad(X,[H|T],[H|N]):-
	write("H:"),
	write(H),
	borrarElementosConPropiedad(X,T,N).

%Delete all elements with a specific property preference in a property-value list
%borrarElementosConPropiedadPref(P,InputList,OutputList).
%Example (pref, peso,[ [trabaja=>(X)]=>>pref=>(X,peso),p2=>v2,p3=>v3,p2=>v4,p4=>v4],[p1=>v1,p3=>v3,p4=>v4])

borrarElementosConPropiedadPref(_,_,[],[]).

borrarElementosConPropiedadPref(X,Peso,[ [_|_]=>>X=>(_,Peso)|T ],N):-
	write("Entra"),
	borrarElementosConPropiedadPref(X,Peso,T,N).

borrarElementosConPropiedadPref(X,Peso,[H|T],[H|N]):-
	write("H:"),
	write(H),
	borrarElementosConPropiedadPref(X,Peso,T,N).

%Delete all elements with a specific negated property in a property-value list
%borrarElementosConPropiedadNegada(P,InputList,OutputList).
%Example (p2,[p1=>v1,no(p2=>v2),no(p3=>v3),p2=>v4,p4=>v4],[p1=>v1,no(p3=>v3),p2=>v4,p4=>v4])

borrarElementosConPropiedadNegada(_,[],[]).

borrarElementosConPropiedadNegada(X,[no(X=>_)|T],N):-
	borrarElementosConPropiedadNegada(X,T,N).

borrarElementosConPropiedadNegada(X,[H|T],[H|N]):-
	borrarElementosConPropiedadNegada(X,T,N).

%Delete all elements with a specific negated property in a property-value list
%borrarElementosConPropiedadNegadaPref(P,InputList,OutputList).
%Example (p2,[p1=>v1,no(p2=>v2),not(p3=>v3),p2=>v4,p4=>v4],[p1=>v1,not(p3=>v3),p2=>v4,p4=>v4])

borrarElementosConPropiedadNegadaPref(_,_,[],[]).

borrarElementosConPropiedadNegadaPref(X,Peso,[ [_|_]=>>no(X)=>(_,Peso)|T ],N):-
	borrarElementosConPropiedadNegadaPref(X,Peso,T,N).

borrarElementosConPropiedadNegadaPref(X,Peso,[H|T],[H|N]):-
	borrarElementosConPropiedadNegadaPref(X,Peso,T,N).

%--------------------------------------------------------------------------------------------------
%Operations for removing classes, objects or properties into the Knowledge Base
%--------------------------------------------------------------------------------------------------

cambiarPadre(_,_,[],[]).

cambiarPadre(OldFather,NewFather,[class(C,OldFather,P,R,O)|T],[class(C,NewFather,P,R,O)|N]):-
	cambiarPadre(OldFather,NewFather,T,N).

cambiarPadre(OldFather,NewFather,[H|T],[H|N]):-
	cambiarPadre(OldFather,NewFather,T,N).

borrar_clase(_,[],[]).

borrar_clase(X,[X|T],N):-
	borrar_clase(X,T,N).

borrar_clase(X,[H|T],[H|N]):-
	borrar_clase(X,T,N),
	X\=H.

borrar_clase(X,[P],N):-
	borrar_clase(X,P,N).

borrar_relacion_con_clase(_,[],[]).

borrar_relacion_con_clase(Object,[class(C,M,P,R,O)|T],[class(C,M,P,NewR,NewO)|NewT]):-
	write("R:"),
	write(R),
	cancel_relation_class(Object,R,NewR),
	del_relations_class(Object,O,NewO),
	borrar_relacion_con_clase(Object,T,NewT).

del_relations_class(_,[],[]).

del_relations_class(Object,[[id=>N,P,R]|T],[[id=>N,P,NewR]|NewT]):-
	cancel_relation_class(Object,R,NewR),
	del_relations_class(Object,T,NewT).

cancel_relation_class(_,[],[]).

cancel_relation_class(Object,[[_=>(Object,_)|_]|T],NewT):-
	write("Entra:"),
	cancel_relation_class(Object,T,NewT).

cancel_relation_class(Object,[[no(_=>(Object,_))|_]|T],NewT):-
	write("Entra:"),
	cancel_relation_class(Object,T,NewT).

cancel_relation_class(Object,[H|T],[H|NewT]):-
	write("H:"),
	write(H),
	cancel_relation_class(Object,T,NewT).
	
borrar_relacion_con_objeto(_,[],[]).

borrar_relacion_con_objeto(Object,[class(C,M,P,R,O)|T],[class(C,M,P,NewR,NewO)|NewT]):-
	cancel_relation(Object,R,NewR),
	write("Relaciones:"),
	write(R),
	del_relations(Object,O,NewO),
	borrar_relacion_con_objeto(Object,T,NewT).

del_relations(_,[],[]).

del_relations(Object,[[id=>N,P,R]|T],[[id=>N,P,NewR]|NewT]):-
	write("Resto:"),
	write(R),
	cancel_relation(Object,R,NewR),
	del_relations(Object,T,NewT).

cancel_relation(_,[],[]).
cancel_relation(Object,[[_=>(Object,_)|_]|T],NewT):-
	write("Entra:"),
	cancel_relation(Object,T,NewT).

cancel_relation(Object,[[no(_=>(Object,_))|_]|T],NewT):-
	write("Entra:"),
	cancel_relation(Object,T,NewT).

cancel_relation(Object,[H|T],[H|NewT]):-
	write("H:"),
	write(H),
	cancel_relation(Object,T,NewT).

esObjetoCompleto([id=>Object,Properties,Relations],[[id=>Lista,Properties,Relations]|_],Lista):-
	write("elements:"),
	write(Lista),
	member(Object,Lista).

esObjetoCompleto(X,[_|T],AObject):-
	write("T:"),
	write(T),
	esObjetoCompleto(X,T,AObject).	

% Establish the adecuate structure for clases and objects
unificarListas([],[],[]).
unificarListas([A|C],[],[[A|C],[]]).
unificarListas([],[B|D],[[],[B|D]]).
unificarListas([A|C],[B|D],[[A|C],[B|D]]).
% ------------------------------------------------------------------------------------
% ---- Fin de predicados auxiliares para Eliminar Informacion  -------------------
% ************************************************************************************





%  -----------------------------------------------------------------------------------
%  ---- Inicios de predicados auxiliares para hacer cambios --------------------------
% ------------------------------------------------------------------------------------
% Cambiar el nombre de un elemento en una lista de relaciones
% ---------------------------------------------------------------------
% Cambiar el nombre de un elemento en una lista de relaciones
% ---------------------------------------------------------------------
buscar_objeto_cambiar_objeto_en_relacion(_,_,[],[]).

buscar_objeto_cambiar_objeto_en_relacion(Acc=>(Name, Val), Acc=>(NewName, Val),[Acc=>(Name, Val)|T],[Acc=>(NewName, Val)|N]):-
    buscar_objeto_cambiar_objeto_en_relacion(NextAcc=>(Name, NextVal),NextAcc=>(NewName, NextVal),T,N).

buscar_objeto_cambiar_objeto_en_relacion(Acc=>(Name, Val),Acc=>(NewName, Val),[H|T],[H|N]):-
    buscar_objeto_cambiar_objeto_en_relacion(NextAcc=>(Name, NextVal), NextAcc=>(NewName, NextVal),T,N).

cambiar_objeto_objeto_en_relacion(Objeto,NombreNuevo,Rels,Result):-
    buscar_objeto_cambiar_objeto_en_relacion(_=>(Objeto,_), _=>(NombreNuevo, _), Rels, Result).


buscar_acc_cambiar_objeto_en_relacion(_,_,[],[]).

buscar_acc_cambiar_objeto_en_relacion(Acc=>(Name, Val), Acc=>(NewName, Val),[Acc=>(Name, Val)|T],[Acc=>(NewName, Val)|N]):-
    buscar_acc_cambiar_objeto_en_relacion(NextAcc=>(Name, NextVal),NextAcc=>(NewName, NextVal),T,N).

buscar_acc_cambiar_objeto_en_relacion(Acc=>(Name, Val),Acc=>(NewName, Val),[H|T],[H|N]):-
    buscar_acc_cambiar_objeto_en_relacion(NextAcc=>(Name, NextVal), NextAcc=>(NewName, NextVal),T,N).

cambiar_accion_objeto_en_relacion(Acc,NombreNuevo,Rels,Result):-
    buscar_acc_cambiar_objeto_en_relacion(Acc=>(_,_), _=>(NombreNuevo, _), Rels, Result).


buscar_cambiar_objeto_en_relacion(_,_,[],[]).

buscar_cambiar_objeto_en_relacion(Acc=>(Name, Val), Acc=>(NewName, Val),[Acc=>(Name, Val)|T],[Acc=>(NewName, Val)|N]):-
    buscar_cambiar_objeto_en_relacion(NextAcc=>(Name, NextVal),NextAcc=>(NewName, NextVal),T,N).

buscar_cambiar_objeto_en_relacion(no(Acc=>(Name, Val)), no(Acc=>(NewName, Val)),[no(Acc=>(Name, Val))|T],[no(Acc=>(NewName, Val))|N]):-
    buscar_cambiar_objeto_en_relacion(NextAcc=>(Name, NextVal),NextAcc=>(NewName, NextVal),T,N).

buscar_cambiar_objeto_en_relacion(A=>(Name, Val),A=>(NewName, Val),[H|T],[H|N]):-
    buscar_cambiar_objeto_en_relacion(NextAcc=>(Name, NextVal), NextAcc=>(NewName, NextVal),T,N).

% Busca por un objeto en una relacion  y lo cambia de nombre
cambiar_objeto_en_relacion(Objeto,NombreNuevo,Rels,Result):-
    buscar_cambiar_objeto_en_relacion(_=>(Objeto,_), _=>(NombreNuevo, _), Rels, Result).


buscar_cambiar_objeto_en_relacion_neg(_,_,[],[]).

buscar_cambiar_objeto_en_relacion_neg(no(Acc=>(Name, Val)), no(Acc=>(NewName, Val)),[no(Acc=>(Name, Val))|T],[no(Acc=>(NewName, Val))|N]):-
    buscar_cambiar_objeto_en_relacion_neg(no(NextAcc=>(Name, NextVal)),no(NextAcc=>(NewName, NextVal)),T,N).

buscar_cambiar_objeto_en_relacion_neg(no(A=>(Name, Val)),no(A=>(NewName, Val)),[H|T],[H|N]):-
    buscar_cambiar_objeto_en_relacion_neg(no(NextAcc=>(Name, NextVal)), no(NextAcc=>(NewName, NextVal)),T,N).

% Busca por un objeto en una relacion  y lo cambia de nombre
cambiar_objeto_objeto_en_relacion_neg(Objeto,NombreNuevo,Rels,Result):-
    buscar_cambiar_objeto_en_relacion_neg(no(_=>(Objeto,_)), no(_=>(NombreNuevo, _)), Rels, Result).


buscar_acc_cambiar_objeto_en_relacion_neg(_,_,[],[]).

buscar_acc_cambiar_objeto_en_relacion_neg(no(Acc=>(Name, Val)), no(Acc=>(NewName, Val)),[no(Acc=>(Name, Val))|T],[no(Acc=>(NewName, Val))|N]):-
    buscar_acc_cambiar_objeto_en_relacion_neg(no(NextAcc=>(Name, NextVal)),no(NextAcc=>(NewName, NextVal)),T,N).

buscar_acc_cambiar_objeto_en_relacion_neg(no(A=>(Name, Val)),no(A=>(NewName, Val)),[H|T],[H|N]):-
    buscar_acc_cambiar_objeto_en_relacion_neg(no(NextAcc=>(Name, NextVal)), no(NextAcc=>(NewName, NextVal)),T,N).

% Busca por Acc y cambia a los elementos que cumplen esa accion.
cambiar_accion_objeto_en_relacion_neg(Acc,NombreNuevo,Rels,Result):-
    buscar_acc_cambiar_objeto_en_relacion_neg(no(Acc=>(_,_)), no(_=>(NombreNuevo, _)), Rels, Result).



% Cambiar el valor de una propiedad clase
% ---------------------------------------------------------------------
buscar_cambiar_valor_prop(_,_,[],[]).

buscar_cambiar_valor_prop(Prop=>(Val, Peso), Prop=>(NuevoVal, Peso),
        [Prop=>(Val, Peso)|T],
        [Prop=>(NuevoVal, Peso)|N]):-
    buscar_cambiar_valor_prop(NextProp=>(Val, NextPeso),NextProp=>(NuevoVal, NextPeso),T,N).

buscar_cambiar_valor_prop(no(Prop=>(Val, Peso)), no(Prop=>(NuevoVal, Peso)),
        [no(Prop=>(Val, Peso))|T],
        [no(Prop=>(NuevoVal, Peso))|N]):-
    buscar_cambiar_valor_prop(NextProp=>(Val, NextPeso),NextProp=>(NuevoVal, NextPeso),T,N).

buscar_cambiar_valor_prop(Prop=>(Val, Peso), Prop=>(NuevoVal, Peso),[H|T],[H|N]):-
    buscar_cambiar_valor_prop(NextProp=>(Val, NextPeso),NextProp=>(NuevoVal, NextPeso),T,N).

cambiar_valor_prop(Prop, NuevoValor,PropList,Result):-
    buscar_cambiar_objeto_en_relacion(Prop=>(_,_), Prop=>(NuevoValor, _), PropList, Result).

buscar_cambiar_valor_prop_neg(_,_,[],[]).

buscar_cambiar_valor_prop_neg(no(Prop=>(Val, Peso)), no(Prop=>(NuevoVal, Peso)), [no(Prop=>(Val, Peso))|T], [no(Prop=>(NuevoVal, Peso))|N]):-
    buscar_cambiar_valor_prop_neg(no(NextProp=>(Val, NextPeso)), no(NextProp=>(NuevoVal, NextPeso)),T,N).

buscar_cambiar_valor_prop_neg(no(Prop=>(Val, Peso)), no(Prop=>(NuevoVal, Peso)),[H|T],[H|N]):-
    buscar_cambiar_valor_prop_neg(no(NextProp=>(Val, NextPeso)),no(NextProp=>(NuevoVal, NextPeso)),T,N).

% Cambia el valor de una propiedad negada en una lista de propiedades
cambiar_valor_prop_neg(Prop,NuevoValor,PropList,Result):-
    buscar_cambiar_valor_prop_neg(no(Prop=>(_,_)), no(Prop=>(NuevoValor, _)), PropList, Result).



iterar_individuos_nombre(_,_,[],[]).

iterar_individuos_nombre(Name,NewName,
        [[id=>Ids,Prop,Rels]|T],[[id=>NewIds,Prop,Rels]|N]):-
    cambiar_elemento(Name,NewName,Ids,NewIds),
    iterar_individuos_nombre(Name,NewName,T,N).

iterar_individuos_nombre(Name,NewName,[H|T],[H|N]):-
    iterar_individuos_nombre(Name,NewName,T,N).



iterar_preferencias_relaciones_antec(_,_,[],[]).

iterar_preferencias_relaciones_antec(Name,NewName,[AntPrefRel=>>ConsPrefRel|T],[NewAntPrefRel=>>ConsPrefRel|N]):-
    cambiar_objeto_objeto_en_relacion(Name,NewName,AntPrefRel,NewAntPrefRelAux),
    cambiar_objeto_objeto_en_relacion_neg(Name,NewName,NewAntPrefRelAux, NewAntPrefRel),
    iterar_preferencias_relaciones_antec(Name,NewName,T,N).

iterar_preferencias_relaciones_antec(Name,NewName,[H|T],[H|N]):-
    iterar_preferencias_relaciones_antec(Name,NewName,T,N).


cambia_consc(Name, NewName, A=>(Name, Val), A=>(NewName, Val)).
cambia_consc(Name, NewName, no(A=>(Name, Val)), no(A=>(NewName, Val))).

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



cambiar_nombre(_,_,[],[]).

cambiar_nombre(Nombre,NombreNuevo,
        [class(C,F,P,R,Objectos)|T],
        [class(C,F,P,R,ObjetosNuevos)|N]):-
    iterar_individuos_nombre(Nombre, NombreNuevo, Objectos, ObjetosNuevos),
    cambiar_nombre(Nombre,NombreNuevo,T,N).

cambiar_nombre(Nombre,NombreNuevo,[H|T],[H|N]):-
    cambiar_nombre(Nombre,NombreNuevo,T,N).




% -- Predicado para cambiar nombre a un elemento en una relacion ---
% -----------     A nivel de CLASE  ----------------------------
cambiar_relaciones_nivelClase(_,_,[],[]).

cambiar_relaciones_nivelClase(Nombre,NombreNuevo,
            [class(C,Padre,P,[Rels,PrefRel],O)|T],[class(C,Padre,P,[RelsNew,PrefRel],O)|N]):-
    cambiar_objeto_objeto_en_relacion(Nombre,NombreNuevo,Rels,RelsNewAux),
    cambiar_objeto_objeto_en_relacion_neg(Nombre,NombreNuevo,RelsNewAux, RelsNew),    
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


cambiar_propiedades_nivelClase(Clase, Prop, NewValue, KB,NewKB):-
    cambiar_elemento(class(Clase,Padre,[PropList,PrefProps],Rels,Objects),
                class(Clase,Padre,[NewProps,PrefProps],Rels,Objects),KB,NewKB),
    cambiar_valor_prop(Prop,NewValue,PropList, NewProps).

cambiar_propiedades_nivelClase_neg(Clase, Prop, NewValue, KB,NewKB):-
    cambiar_elemento(class(Clase,Padre,[PropList,PrefProps],Rels,Objects),
                class(Clase,Padre,[NewProps,PrefProps],Rels,Objects),KB,NewKB),
    cambiar_valor_prop_neg(Prop,NewValue,PropList, NewProps).

cambiar_relacion_nivelClase(Clase, Relacion, NuevoSujeto,KB,NewKB):-
    cambiar_elemento(class(Clase,Padre,Props,[RelsList, PrefRels],Objects), class(Clase,Padre,Props,[NewRels,PrefRels],Objects),KB,NewKB),
    cambiar_accion_objeto_en_relacion(Relacion,NuevoSujeto,RelsList,NewRels).

cambiar_relacion_nivelClase_neg(Clase, Relacion, NuevoSujeto,KB,NewKB):-
    cambiar_elemento(class(Clase,Padre,Props,[RelsList, PrefRels],Objects), class(Clase,Padre,Props,[NewRels,PrefRels],Objects),KB,NewKB),
    cambiar_accion_objeto_en_relacion_neg(Relacion,NuevoSujeto,RelsList,NewRels).




% -- Predicado para cambiar nombre a un elemento en una relacion ---
% -----------     A nivel de INDIVIDUO  ----------------------------
cambiar_relaciones_nivelIndividuo(_,_,[],[]).

cambiar_relaciones_nivelIndividuo(Nombre,NombreNuevo, 
        [class(C,Padre,P,R,[[id=>Id,Prop,[Rels,PrefRel]]|H])|T],
        [class(C,Padre,P,R,[[id=>Id,Prop,[RelsNew,PrefRel]]|H])|N]):-
    cambiar_objeto_objeto_en_relacion(Nombre,NombreNuevo,Rels,RelsNewAux),
    cambiar_objeto_objeto_en_relacion_neg(Nombre,NombreNuevo,RelsNewAux,RelsNew),    
    cambiar_relaciones_nivelIndividuo(Nombre,NombreNuevo,T,N).

cambiar_relaciones_nivelIndividuo(Nombre,NombreNuevo,[H|T],[H|N]):-
    cambiar_relaciones_nivelIndividuo(Nombre,NombreNuevo,T,N).


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


cambiar_propiedades_nivelIndividuo(Objeto, Prop, NewValue, KB,NewKB):-
    cambiar_elemento(class(Clase,Padre,Prop,Rels,[id>Objects,PropList,Rels] ),
                    class(Clase,Padre,Prop,Rels,[id=>Objects,NewProps,Rels] ),KB,NewKB),
    es_elemento(Objeto, Objects),
    cambiar_valor_prop(Prop,NewValue,PropList, NewProps).

%  -------------------------------------------------------------------------------
%  ---- Fin de predicados auxiliares para hacer cambios --------------------------







% ------------------------------------------------------------------------------
% ----------  PREDICADOS PRINCIPALES  ------------------------------------------ 

% ------------------------------------------------------------------------------
%    CONSULTAS PRINCIPALES PARA OBTENER EXTENSION INFORMACION KB
% ------------------------------------------------------------------------------
%Ejercicio 1 -> Extensiones clases, objetos, propiedades, relaciones y preferencias
% Inciso  a)
extension_de_clase(Clase,KB,Individuos):-
	individuos_de_una_clase(Clase,KB,Individuos).

% Inciso  b)
extension_propiedad(Propiedad,KB,Extension):-
	obtener_extension_propiedad(top,Propiedad,[],KB,Extension,[]),	
	imprime_lista_resultados(Extension).

% Inciso c)
% Extensión de una relación-----------------------------------------------------------
extension_relacion(Relacion,KB,Extension):-
	obtener_extension_relacion(top,Relacion,[],[],KB,Extension,KB),
	imprime_lista_resultados(Extension).

%------------------------------------------------------------------------------
%Inciso  d) -> Todas las clases a las que pertenece un objeto
obtener_clases_objeto(ObjectName, KB, Clases):-
	obtener_data_objeto(ObjectName,KB,ObjClass,ObjNames),
	ancestros_clase(ObjClass,KB,Ancestros),
	append([ObjClass], Ancestros, Clases).

% ------------------------------------------------------------
% Inciso e)
% predicados para obtener todas las propiedades de una clase -------------
obtener_propiedades_completas_clase(ClaseBuscar,KB,Propiedades):-
	buscar_propiedades_clase(top,ClaseBuscar,KB,[],[],Propiedades),
	imprime_lista_resultados(Propiedades).

%predicado que se encarga de obtener todas las propiedades de un objeto especifico
obtener_propiedades_completas_objeto(Individuo,KB,Resultado):-
	obtener_propiedades_completas_por_objeto(top,KB,Individuo,[],[],Resultado), %llama al predicado principal que recorre el arbol recursivamente
	imprime_lista_resultados(Resultado).

% ------------------------------------------------------------
% Inciso f)
% predicados para obtener todas las relaciones de un objeto ---------------
obtener_relaciones_completas_clase(ClaseBuscar,KB,Relaciones):-
	buscar_relaciones_clase(top,ClaseBuscar,KB,[],[],Relaciones),
	imprime_lista_resultados(Relaciones).

obtener_relaciones_completas_objeto(Individuo,KB,Resultado):-
	obtener_relaciones_completas_por_objeto(top,KB,Individuo,[],[],Resultado,KB),
	imprime_lista_resultados(Resultado).

% Ejercicio 1 -> Extensiones clases, objetos, propiedades, relaciones y preferencias
% ------------------------------------------------------------------------------------



% -------------------------------------------------------------------------------------------------
%    CONSULTAS PRINCIPALES PARA AGREGAR INFORMACION KB
%--------------------------------------------------------------------------------------------------
%Ejercicio 2 -> Agregar clases, objetos, propiedades, relaciones y preferencias
%--------------------------------------------------------------------------------------------------
%% 2a) Agregar Clase
agregar_clase(NewClass,Padre,KB,NuevaKB) :-
	append(KB,[class(NewClass,Padre,[],[],[])],NuevaKB).

%% 2a) Agregar Individuo/Objeto
agregar_individuo(NuevoIndiv,Class,KB,NuevaKB) :-
	cambiar_elemento(class(Class,Padre,PropPref,RelPref,Indiv),class(Class,Padre,PropPref,RelPref,ListaNuevosIndiv),KB,NuevaKB),
	append(Indiv,[[id=>NuevoIndiv,[],[]]],ListaNuevosIndiv).

%% 2b) Agregar nueva propiedad de clase
agregar_propiedad_clase(Class,NuevaProp,Valor,Negacion,KB,NuevaKB) :-
	cambiar_elemento(class(Class,Padre,PropPref,PropRel,Indiv),class(Class, Padre, ListaNuevasPropPref, PropRel, Indiv),KB,NuevaKB),
	agregar_propiedad_relacion(PropPref,NuevaProp,Valor,Negacion,ListaNuevasPropPref).

% 2b) Agregar nueva propiedad de Individuo/Objeto
agregar_propiedad_objeto(ObjectName,NuevaProp,Valor,Negacion,KB,NuevaKB):-
	obtener_data_objeto(ObjectName,KB,ObjClass,ObjNames),
	cambiar_elemento(class(ObjClass,Padre,PropPref,RelPref,Indivs),class(ObjClass,Padre,PropPref,RelPref,ListaNuevosIndiv),KB,NuevaKB),
	cambiar_elemento([id=>ObjNames,PropPrefIndiv,RelPrefIndiv],[id=>ObjNames,ListaNuevaPropPref,RelPrefIndiv],Indivs,ListaNuevosIndiv),
	agregar_propiedad_relacion(PropPrefIndiv,NuevaProp,Valor,Negacion,ListaNuevaPropPref).

%% 2c) Agregar nueva relacion de clase
agregar_relacion_clase(Class,NuevaRel,Valor,Negacion,KB,NuevaKB) :-
	cambiar_elemento(class(Class,Padre,PropPref,RelPref,Indiv),class(Class,Padre,PropPref,ListaNuevaRelPref,Indiv),KB,NuevaKB),
	agregar_propiedad_relacion(RelPref,NuevaRel,Valor,Negacion,ListaNuevaRelPref).

%% 2c) Agregar nueva relacion de Individuo/Objeto
agregar_relacion_objeto(ObjectName,NuevaRel,Valor,Negacion,KB,NuevaKB):-
	obtener_data_objeto(ObjectName,KB,ObjClass,ObjNames),
	cambiar_elemento(class(ObjClass,Padre,PropPref,RelPref,Indivs),class(ObjClass,Padre,PropPref,RelPref,ListaNuevosIndiv),KB,NuevaKB),
	cambiar_elemento([id=>ObjNames,PropPrefIndiv,RelPrefIndiv],[id=>ObjNames,PropPrefIndiv,ListaNuevaRelPref],Indivs,ListaNuevosIndiv),
	agregar_propiedad_relacion(RelPrefIndiv,NuevaRel,Valor,Negacion,ListaNuevaRelPref).

%% 2d) Agregar nueva preferencia de propiedades de clase
agregar_preferencia_propiedad_clase(Class, Antecedente, Consecuente, Valor, Negacion, KB, NuevaKB) :-
	cambiar_elemento(class(Class, Padre, PropPref, PropRel, Indiv),class(Class, Padre, ListaNuevasPropPref, PropRel, Indiv), KB, NuevaKB),
	agregar_preferencia(PropPref, Antecedente, Consecuente, Valor, Negacion, ListaNuevasPropPref).

%% 2d) Agregar nueva preferencia de relacion de clase
agregar_preferencia_relacion_clase(Class, Antecedente, Consecuente, Valor, Negacion, KB, NuevaKB) :-
	cambiar_elemento(class(Class,Padre,PropPref,RelPref,Indiv),class(Class,Padre,PropPref,ListaNuevaRelPref,Indiv),KB,NuevaKB),
	agregar_preferencia(RelPref, Antecedente, Consecuente, Valor, Negacion, ListaNuevaRelPref).

%% 2d) Agregar nueva preferencia de propiedades de Individuos/Objeto
agregar_preferencia_propiedad_objeto(ObjectName,Antecedente,Consecuente,Valor,Negacion,KB,NuevaKB):-
	obtener_data_objeto(ObjectName,KB,ObjClass,ObjNames),
	cambiar_elemento(class(ObjClass,Padre,PropPref,RelPref,Indivs),class(ObjClass,Padre,PropPref,RelPref,ListaNuevosIndiv),KB,NuevaKB),
	cambiar_elemento([id=>ObjNames,PropPrefIndiv,RelPrefIndiv],[id=>ObjNames,ListaNuevaPropPref,RelPrefIndiv],Indivs,ListaNuevosIndiv),
	agregar_preferencia(PropPrefIndiv,Antecedente,Consecuente,Valor,Negacion,ListaNuevaPropPref).

%% 2d) Agregar nueva preferencia de relacion de Individuo/Objeto
agregar_preferencia_relacion_objeto(ObjectName,Antecedente,Consecuente,Valor,Negacion,KB,NuevaKB):-
	obtener_data_objeto(ObjectName,KB,ObjClass,ObjNames),
	cambiar_elemento(class(ObjClass,Padre,PropPref,RelPref,Indivs),class(ObjClass,Padre,PropPref,RelPref,ListaNuevosIndiv),KB,NuevaKB),
	cambiar_elemento([id=>ObjNames,PropPrefIndiv,RelPrefIndiv],[id=>ObjNames,PropPrefIndiv,ListaNuevaRelPref],Indivs,ListaNuevosIndiv),
	agregar_preferencia(RelPrefIndiv,Antecedente,Consecuente,Valor,Negacion,ListaNuevaRelPref).

% --------------------------------------------------------------------
%    CONSULTAS PRINCIPALES PARA ELIMINAR INFO KB
% --------------------------------------------------------------------
% 3 a)  Eliminar clases u objetos
% Example: abrir1(KB), eliminar_clase(raton,KB,NewKB), guardar1(NewKB).
% Example: abrir1(KB), eliminar_clase(humano,KB,NewKB), guardar1(NewKB).
% Example: abrir1(KB), eliminar_clase(mamiferos,KB,NewKB), guardar1(NewKB).
eliminar_clase(Class,OriginalKB,NewKB) :-
	borrar_clase(class(Class,Father,_,_,_),OriginalKB,TemporalKB),
	cambiarPadre(Class,Father,TemporalKB,TemporalKB2),
	borrar_relacion_con_clase(Class,TemporalKB2,NewKB).

%Remove an object where Object is IDObject (id=>Object) --Borrar relación con objectos
% Example: abrir1(KB), eliminar_objeto(pinocho,KB,NewKB), guardar1(NewKB).
% Example: abrir1(KB), eliminar_objeto(monstruo,KB,NewKB), guardar1(NewKB).
% Example: abrir1(KB), eliminar_objeto(miky,KB,NewKB), guardar1(NewKB).
% Example: abrir1(KB), eliminar_objeto(timothy,KB,NewKB), guardar1(NewKB).
eliminar_objeto(Object,OriginalKB,NewKB) :-
	cambiarGrupoObjetos(class(Class,Father,Props,Rels,Objects),class(Class,Father,Props,Rels,NewObjects),OriginalKB,TemporalKB),
	esObjeto(Object,Objects),
	borrarElemento(Object,Objects,NewObjects),
	borrar_relacion_con_objeto(Object,TemporalKB,NewKB).


% 3 b) Eliminar propiedades de clase u objeto
%Remove a class property
% Example: abrir1(KB), eliminar_clase_propiedad(ballena,ponen_huevos,KB,NewKB), guardar1(NewKB).
% Example: abrir1(KB), eliminar_clase_propiedad(humano,muerde,KB,NewKB), guardar1(NewKB).
eliminar_clase_propiedad(Class,Property,OriginalKB,NewKB) :-
	cambiarGrupoObjetos(class(Class,Father,[Props,T],Rels,Objects),class(Class,Father,ListProp,Rels,Objects),OriginalKB,NewKB),
	borrarElementosConPropiedad(Property,Props,Aux),
	borrarElemento(no(Property),Aux,Aux2),
	borrarElemento(Property,Aux2,NewProps),
	unificarListas(NewProps,T,ListProp),
	write(ListProp).

%Remove an object property
%Example: abrir1(KB), eliminar_objeto_propiedad(dumbito,vuela,KB,NewKB), guardar1(NewKB).
%Example: abrir1(KB), eliminar_objeto_propiedad(msJumbo,no(vuela),KB,NewKB), guardar1(NewKB).
eliminar_objeto_propiedad(Object,Property,OriginalKB,NewKB) :-
	cambiarGrupoObjetos(class(Class,Father,Props,Rels,Objects),class(Class,Father,Props,Rels,NewObjects),OriginalKB,NewKB),
	write("Objects:"),
	write(Objects),
	esObjetoCompleto([id=>Object,[Properties,T],Relations],Objects,AObject),
	write(Properties),
	cambiarGrupoObjetos([id=>AObject,[Properties,T],Relations],[id=>AObject,ListProp,Relations],Objects,NewObjects),
	borrarElementosConPropiedad(Property,Properties,Aux),
	borrarElemento(no(Property),Aux,Aux2),
	borrarElemento(Property,Aux2,NewProperties),
	unificarListas(NewProperties,T,ListProp).

eliminar_objeto_propiedad(Object,no(Property),OriginalKB,NewKB) :-
	cambiarGrupoObjetos(class(Class,Father,Props,Rels,Objects),class(Class,Father,Props,Rels,NewObjects),OriginalKB,NewKB),
	write("Objects:"),
	write(Objects),
	esObjetoCompleto([id=>Object,[Properties,T],Relations],Objects,AObject),
	write(Properties),
	cambiarGrupoObjetos([id=>AObject,[Properties,T],Relations],[id=>AObject,ListProp,Relations],Objects,NewObjects),
	borrarElementosConPropiedadNegada(Property,Properties,Aux),
	borrarElemento(no(Property),Aux,Aux2),
	borrarElemento(Property,Aux2,NewProperties),
	unificarListas(NewProperties,T,ListProp).

% 3 c) Eliminar relaciones de clase u objeto
%Remove a class relation
%Example: abrir1(KB), eliminar_clase_relacion(elefante,odia,KB,NewKB), guardar1(NewKB). 
eliminar_clase_relacion(Class,no(Relation),OriginalKB,NewKB) :-
	cambiarGrupoObjetos(class(Class,Father,Props,[Rels,T],Objects),class(Class,Father,Props,ListRel,Objects),OriginalKB,NewKB),
	borrarElementosConPropiedadNegada(Relation,Rels,NewRels),
	unificarListas(NewRels,T,ListRel).

eliminar_clase_relacion(Class,Relation,OriginalKB,NewKB) :-
	cambiarGrupoObjetos(class(Class,Father,Props,[Rels,T],Objects),class(Class,Father,Props,ListRel,Objects),OriginalKB,NewKB),
	borrarElementosConPropiedad(Relation,Rels,NewRels),
	unificarListas(NewRels,T,ListRel).

%Remove an object relation
%Example: abrir1(KB), eliminar_objeto_relacion(dumbo,no(odia),KB,NewKB), guardar1(NewKB).
%Example: abrir1(KB), eliminar_objeto_relacion(timothy,come,KB,NewKB), guardar1(NewKB).

eliminar_objeto_relacion(Object,no(Relation),OriginalKB,NewKB) :-
	cambiarGrupoObjetos(class(Class,Father,Props,Rels,Objects),class(Class,Father,Props,Rels,NewObjects),OriginalKB,NewKB),
	esObjetoCompleto([id=>Object,Properties,[Relations,T]],Objects,AObject),
	cambiarGrupoObjetos([id=>AObject,Properties,[Relations,T]],[id=>AObject,Properties,ListRel],Objects,NewObjects),
	borrarElementosConPropiedadNegada(Relation,Relations,NewRelations),
	unificarListas(NewRelations,T,ListRel).

eliminar_objeto_relacion(Object,Relation,OriginalKB,NewKB) :-
	cambiarGrupoObjetos(class(Class,Father,Props,Rels,Objects),class(Class,Father,Props,Rels,NewObjects),OriginalKB,NewKB),
	esObjetoCompleto([id=>Object,Properties,[Relations,T]],Objects, AObject),
	write(Relations),
	cambiarGrupoObjetos([id=>AObject,Properties,[Relations,T]],[id=>AObject,Properties,ListRel],Objects,NewObjects),
	borrarElementosConPropiedad(Relation,Relations,NewRelations),
	unificarListas(NewRelations,T,ListRel).

% 3 d) Eliminar preferencias de clase u objeto
%Remove an object relation preference
%Example: abrir1(KB), eliminar_objeto_relacion_pref(monstruo,ecologista,1,KB,NewKB), guardar1(NewKB).
%Example: abrir1(KB), eliminar_objeto_relacion_pref(monstruo,ecologista,2,KB,NewKB), guardar1(NewKB).
eliminar_objeto_relacion_pref(Object,no(Preference),Peso,OriginalKB,NewKB) :-
	cambiarGrupoObjetos(class(Class,Father,Props,Rels,Objects),class(Class,Father,Props,Rels,NewObjects),OriginalKB,NewKB),
	esObjetoCompleto([id=>Object,Properties,[Relations,Preferences]],Objects,AObject),
	write(Preferences),
	cambiarGrupoObjetos([id=>AObject,Properties,[Relations,Preferences]],[id=>AObject,Properties,ListPref],Objects,NewObjects),
	borrarElementosConPropiedadNegadaPref(Preference,Peso,Preferences,NewPreferences),
	unificarListas(Relations,NewPreferences,ListPref).

eliminar_objeto_relacion_pref(Object,Preference,Peso,OriginalKB,NewKB) :-
	cambiarGrupoObjetos(class(Class,Father,Props,Rels,Objects),class(Class,Father,Props,Rels,NewObjects),OriginalKB,NewKB),
	esObjetoCompleto([id=>Object,Properties,[Relations,Preferences]],Objects, AObject),
	write(Preferences),
	cambiarGrupoObjetos([id=>AObject,Properties,[Relations,Preferences]],[id=>AObject,Properties,ListPref],Objects,NewObjects),
	borrarElementosConPropiedadPref(Preference,Peso,Preferences,NewPreferences),
	unificarListas(Relations,NewPreferences,ListPref).

% Remove a class property preference
% Example: abrir1(KB), eliminar_clase_propiedad_preference(humano,carnivoro,2,KB,NewKB), guardar1(NewKB).
eliminar_clase_propiedad_preference(Class,Preference,Peso,OriginalKB,NewKB) :-
	cambiarGrupoObjetos(class(Class,Father,[H,Prefs],Rels,Objects),class(Class,Father,ListPref,Rels,Objects),OriginalKB,NewKB),
	write("Pref:"),
	write(Prefs),
	borrarElementosConPropiedadPref(Preference,Peso,Prefs,Aux),
	borrarElemento(no(Preference),Aux,Aux2),
	borrarElemento(Preference,Aux2,NewPrefs),
	unificarListas(H, NewPrefs, ListPref).

%Remove an object property preference
%Example: abrir1(KB), eliminar_objeto_propiedad_preference(miky,no(miedoso),0,KB,NewKB), guardar1(NewKB).
%Example: abrir1(KB), eliminar_objeto_propiedad_preference(timothy,animal,0,KB,NewKB), guardar1(NewKB).
eliminar_objeto_propiedad_preference(Object,Preference,Peso,OriginalKB,NewKB) :-
	cambiarGrupoObjetos(class(Class,Father,Props,Rels,Objects),class(Class,Father,Props,Rels,NewObjects),OriginalKB,NewKB),
	esObjetoCompleto([id=>Object,[H,Preferences],Relations],Objects,AObject),
	write("Pref:"),
	write(Preferences),
	cambiarGrupoObjetos([id=>AObject,[H,Preferences],Relations],[id=>AObject,ListPref,Relations],Objects,NewObjects),
	borrarElementosConPropiedadPref(Preference,Peso,Preferences,Aux),
	borrarElemento(no(Preference),Aux,Aux2),
	borrarElemento(Preference,Aux2,NewPreferences),
	unificarListas(H,NewPreferences,ListPref).

%Remove a class relation preference
% Example: abrir1(KB), eliminar_clase_relacion_preferencia(mamiferos,amigo,2,KB,NewKB), guardar1(NewKB).
% Example: abrir1(KB), eliminar_clase_relacion_preferencia(mamiferos,dentro,0,KB,NewKB), guardar1(NewKB).
% Example: abrir1(KB), eliminar_clase_relacion_preferencia(humano,no(ecologista),1,KB,NewKB), guardar1(NewKB).
eliminar_clase_relacion_preferencia(Class,no(Preference),Peso,OriginalKB,NewKB) :-
	cambiarGrupoObjetos(class(Class,Father,Props,[H,Prefs],Objects),class(Class,Father,Props,ListPref,Objects),OriginalKB,NewKB),
	borrarElementosConPropiedadNegadaPref(Preference,Peso,Prefs,NewPrefs),
	unificarListas(H,NewPrefs,ListPref).

eliminar_clase_relacion_preferencia(Class,Preference,Peso,OriginalKB,NewKB) :-
	cambiarGrupoObjetos(class(Class,Father,Props,[H,Prefs],Objects),class(Class,Father,Props,ListPref,Objects),OriginalKB,NewKB),
	borrarElementosConPropiedadPref(Preference,Peso,Prefs,NewPrefs),
	unificarListas(H,NewPrefs,ListPref).



% --------------------------------------------------------------------
%    CONSULTAS PRINCIPALES PARA MODIFICAR KB
% --------------------------------------------------------------------
% ---  Cambiar el nombre de un objeto particular --
% 4  a)
cambiar_nombre_de_individuo(Objeto,NombreNuevo,KB,NewKB):-
    cambiar_nombre(Objeto, NombreNuevo, KB, KBnameUpdate),
    cambiar_relaciones_nivelClase(Clase,NombreNuevo,KBnameUpdate,KBrelationUpdate),
    cambiar_relaciones_antecedentes_nivelClase(Clase, NombreNuevo, KBrelationUpdate, KBantePrefUpdate),
    cambiar_relaciones_consecuentes_nivelClase(Clase, NombreNuevo, KBantePrefUpdate, KBconsecPrefUpdate),
    cambiar_relaciones_nivelIndividuo(Clase,NombreNuevo,KBconsecPrefUpdate,KBrelation2Update),
    cambiar_relaciones_antecedentes_nivelIndividuo(Clase, NombreNuevo, KBrelation2Update, KBantePref2Update),
    cambiar_relaciones_consecuentes_nivelIndividuo(Clase, NombreNuevo, KBantePref2Update, NewKB).

% -- Predicado para cambiar nombre a una clase ---
% 4  a)
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


% -- Predicado para cambiar valor de una propiedad de clase ---
% 4 b)
cambiar_valor_propiedad_clase(Clase, Propiedad, NuevoValor, KB, NewKB):-
    cambiar_propiedades_nivelClase(Clase, Propiedad, NuevoValor,KB,NewKB).

% -- Predicado para cambiar valor de una propiedad de clase ---
%4 b)
%cambiar_valor_propiedad_objeto(Objeto, Propiedad, NuevoValor, KB, NewKB):-
%.


% -- Predicado para cambiar con quien tiene relacion una clase ---
% 4 c)
cambiar_valor_relacion_especifica_en_clase(Clase, Relacion, NuevoSujeto, KB, NewKB):-
    cambiar_relacion_nivelClase(Clase, Relacion, NuevoSujeto,KB,NewKB).


% -- Predicado para cambiar con quien tiene relacion una clase ---
% 4 c)
% cambiar_valor_relacion_especifica_en_clase(Clase, Propiedad, NuevoValor, KB, NewKB):-
%    cambiar_propiedades_nivelClase(Clase, Propiedad, NuevoValor,KB,NewKB).

% --  Modificar el peso de una preferencia de propiedad/relacion a una clase/objeto ---
% 4 d)
cambia_peso_preferencias_clase(Clase,Preferencia,PreferenciaNueva,KB,NuevaKB):-
	cambia_peso_preferencia_propiedad_clase(Clase,Preferencia,PreferenciaNueva,KB,AuxNuevaKB),
	cambia_peso_preferencia_relacion_clase(Clase,Preferencia,PreferenciaNueva,AuxNuevaKB,NuevaKB).

cambia_peso_preferencia_propiedad_clase(Clase,Preferencia,PreferenciaNueva,KB,NuevaKB):-
	cambiaElemento(class(Clase,Padre,[Prop|[Pref|_]],RelPref,Indivs),class(Clase,Padre,ListaNuevasPropPref,RelPref,Indivs),KB,NuevaKB),
	cambiaElemento(A=>>Preferencia,A=>>PreferenciaNueva,Pref,Aux),
	append([Prop],[Aux],ListaNuevasPropPref).

cambia_peso_preferencia_relacion_clase(Clase,Preferencia,PreferenciaNueva,KB,NuevaKB):-
	cambiaElemento(class(Clase,Padre,PropPref,[Rel|[Pref|_]],Indivs),class(Clase,Padre,PropPref,ListaNuevaRelPref,Indivs),KB,NuevaKB),
	cambiaElemento(A=>>Preferencia,A=>>PreferenciaNueva,Pref,Aux),
	append([Rel],[Aux],ListaNuevaRelPref).

cambia_peso_preferencias_individuo(ObjectName,Preferencia,PreferenciaNueva,KB,NuevaKB):-
	cambia_peso_preferencia_propiedad_individuo(ObjectName,Preferencia,PreferenciaNueva,KB,AuxNuevaKB),
	cambia_peso_preferencia_relacion_individuo(ObjectName,Preferencia,PreferenciaNueva,AuxNuevaKB,NuevaKB).

cambia_peso_preferencia_propiedad_individuo(ObjectName,Preferencia,PreferenciaNueva,KB,NuevaKB):-
	obtener_data_objeto(ObjectName,KB,ObjClass,ObjNames),
	cambiaElemento(class(ObjClass,Padre,PropPref,RelPref,Indivs),class(ObjClass,Padre,PropPref,RelPref,ListaNuevosIndiv),KB,NuevaKB),
	cambiaElemento([id=>ObjNames,[Prop|[Pref|_]],RelPrefIndiv],[id=>ObjNames,ListaNuevasPropPref,RelPrefIndiv],Indivs,ListaNuevosIndiv),
	cambiaElemento(A=>>Preferencia,A=>>PreferenciaNueva,Pref,Aux),
	append([Prop],[Aux],ListaNuevasPropPref).

cambia_peso_preferencia_relacion_individuo(ObjectName,Preferencia,PreferenciaNueva,KB,NuevaKB):-
	obtener_data_objeto(ObjectName,KB,ObjClass,ObjNames),
	cambiaElemento(class(ObjClass,Padre,PropPref,RelPref,Indivs),class(ObjClass,Padre,PropPref,RelPref,ListaNuevosIndiv),KB,NuevaKB),
	cambiaElemento([id=>ObjNames,PropPrefIndiv,[Rel|[Pref|_]]],[id=>ObjNames,PropPrefIndiv,ListaNuevaRelPref],Indivs,ListaNuevosIndiv),
	cambiaElemento(A=>>Preferencia,A=>>PreferenciaNueva,Pref,Aux),
	append([Rel],[Aux],ListaNuevaRelPref).
