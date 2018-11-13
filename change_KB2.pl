% Open a file: consult('/home/raul/Escritorio/IA/Project1/change_KB2.pl').

%--------------------------------------------------
% Load and Save from files
%--------------------------------------------------


%KB open and save

open_kb(Route,KB):-
	open(Route,read,Stream),
	readclauses(Stream,X),
	close(Stream),
	atom_to_term(X,KB).

save_kb(Route,KB):-
	open(Route,write,Stream),
	writeq(Stream,KB),
	close(Stream).

%definicion de los operadores ---------------------------------------------------------------------------

:- op(500,xfy,'=>').  %operador de asignacion
:- op(801,xfy,'=>>'). %operador de implicación
%--------------------------------------------------------------------------------------------------------

%------------------------------
% Ejemplo:  
%------------------------------

%Cargar la base en una lista, imprimir la lista en consola y guardar todo en un nuevo archivo.
%No olvides poner las rutas correctas para localizar el archivo kb.txt en tu computadora!!!

abrir(KB):-
	open_kb('/home/raul/Escritorio/IA/Project1/KB1.txt',KB),
	write('\nReading actual data...'),
	write('\nKB: '),
	write(KB).

guardar(KB):-
	write('\nSaving new data...'),
	save_kb('/home/raul/Escritorio/IA/Project1/New_KB.txt',KB).


%predicado para abrir un archivo -------------------------------------------------------------------------
abrir1(KB):-
	open('/home/raul/Escritorio/IA/Project1/KB1.txt',read,Stream),
	readclauses(Stream,X),
	close(Stream),
	atom_to_term_conversion(X,KB).

%--------------------------------------------------------------------------------------------------------


% predicado para guardar un archivo ---------------------------------------------------------------------
guardar1(KB):-
	open('/home/raul/Escritorio/IA/Project1/New_KB.txt',write,Stream),
	writeq(Stream,KB),
	close(Stream).

%--------------------------------------------------------------------------------------------------------

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

%--------------------------------------------------------------------------------------------------------


%----------------------------------------
% Administration of lists
%----------------------------------------


%Change all ocurrences of an element X in a list for the value Y
%changeElement(X,Y,InputList,OutputList).
%Example (a,b,[p,a,p,a,y,a],[p,b,p,b,y,b])

changeElement(_,_,[],[]).

changeElement(X,Y,[X|T],[Y|N]):-
	changeElement(X,Y,T,N).

changeElement(X,Y,[H|T],[H|N]):-
	changeElement(X,Y,T,N).

changeElement(X,Y,[[X|T]],[[Y|N]]):-
	changeElement(X,Y,[X|T],[Y|N]).

changeElement(X,Y,[[H|T]],[[H|N]]):-
	changeElement(X,Y,[H|T],[H|N]).

%Delete all ocurrences of an element X in a list
%deleteElement(X,InputList,OutputList).
%Example (a,[p,a,p,a,y,a],[p,p,y])

deleteElement(_,[],[]).

deleteElement(X,[[id=>Lista|_]|T],N):-
	member(X,Lista),
	deleteElement(X,T,N).

deleteElement(X,[H|T],[H|N]):-
	deleteElement(X,T,N),
	X\=H.


%Delete all ocurrences of an element X in a list
%deleteElementPref(X,InputList,OutputList).
%Example (a,[p,a,p,a,y,a],[p,p,y])

deleteElementPref(_,_,[],[]).

deleteElementPref(X,Peso,[ [_]=>>X=>(_,Peso)|T ],N):-
	deleteElementPref(X,T,N).

deleteElementPref(X,_,[[H]=>>A=>_|T],[[H]=>>A=>_|N]):-
	deleteElementPref(X,T,N),
	X\=A.

%Verify if an element X is in a list 
%isElement(X,List)
%Example (n,[b,a,n,a,n,a])

member(X,[X|_]).
member(X,[_|T]) :- member(X,T).

isElement(X,[[id=>Lista|_]|_]):-
	member(X,Lista).

isElement(X,[ _ |T]):-
	isElement(X,T).

%Convert in a single list a list of lists
%Example ([[a],[b,c],[],[d]],[a,b,c,d]).

append_list_of_lists([],[]).

append_list_of_lists([H|T],X):-
	append(H,TList,X),
	append_list_of_lists(T,TList).


%Delete all elements with a specific property in a property-value list
%deleteAllElementsWithSameProperty(P,InputList,OutputList).
%Example (p2,[p1=>v1,p2=>v2,p3=>v3,p2=>v4,p4=>v4],[p1=>v1,p3=>v3,p4=>v4])

deleteAllElementsWithSameProperty(_,[],[]).

deleteAllElementsWithSameProperty(X,[X=>_|T],N):-
	write("T:"),
	write(T),
	deleteAllElementsWithSameProperty(X,T,N).

deleteAllElementsWithSameProperty(X,[H|T],[H|N]):-
	write("H:"),
	write(H),
	deleteAllElementsWithSameProperty(X,T,N).


%Delete all elements with a specific property preference in a property-value list
%deleteAllElementsWithSamePropertyPref(P,InputList,OutputList).
%Example (pref, peso,[ [trabaja=>(X)]=>>pref=>(X,peso),p2=>v2,p3=>v3,p2=>v4,p4=>v4],[p1=>v1,p3=>v3,p4=>v4])

deleteAllElementsWithSamePropertyPref(_,_,[],[]).

deleteAllElementsWithSamePropertyPref(X,Peso,[ [_|_]=>>X=>(_,Peso)|T ],N):-
	write("Entra"),
	deleteAllElementsWithSamePropertyPref(X,Peso,T,N).

deleteAllElementsWithSamePropertyPref(X,Peso,[H|T],[H|N]):-
	write("H:"),
	write(H),
	deleteAllElementsWithSamePropertyPref(X,Peso,T,N).


%Delete all elements with a specific negated property in a property-value list
%deleteAllElementsWithSameNegatedProperty(P,InputList,OutputList).
%Example (p2,[p1=>v1,no(p2=>v2),no(p3=>v3),p2=>v4,p4=>v4],[p1=>v1,no(p3=>v3),p2=>v4,p4=>v4])

deleteAllElementsWithSameNegatedProperty(_,[],[]).

deleteAllElementsWithSameNegatedProperty(X,[no(X=>_)|T],N):-
	deleteAllElementsWithSameNegatedProperty(X,T,N).

deleteAllElementsWithSameNegatedProperty(X,[H|T],[H|N]):-
	deleteAllElementsWithSameNegatedProperty(X,T,N).

%Delete all elements with a specific negated property in a property-value list
%deleteAllElementsWithSameNegatedPropertyPref(P,InputList,OutputList).
%Example (p2,[p1=>v1,no(p2=>v2),not(p3=>v3),p2=>v4,p4=>v4],[p1=>v1,not(p3=>v3),p2=>v4,p4=>v4])

deleteAllElementsWithSameNegatedPropertyPref(_,_,[],[]).

deleteAllElementsWithSameNegatedPropertyPref(X,Peso,[ [_|_]=>>no(X)=>(_,Peso)|T ],N):-
	deleteAllElementsWithSameNegatedPropertyPref(X,Peso,T,N).

deleteAllElementsWithSameNegatedPropertyPref(X,Peso,[H|T],[H|N]):-
	deleteAllElementsWithSameNegatedPropertyPref(X,Peso,T,N).

%--------------------------------------------------------------------------------------------------
%Operations for removing classes, objects or properties into the Knowledge Base
%--------------------------------------------------------------------------------------------------

% 3a) Remove a class
% Example: abrir1(KB), rm_class(raton,KB,NewKB), guardar1(NewKB).
% Example: abrir1(KB), rm_class(humano,KB,NewKB), guardar1(NewKB).
% Example: abrir1(KB), rm_class(mamiferos,KB,NewKB), guardar1(NewKB).

rm_class(Class,OriginalKB,NewKB) :-
	deleteClass(class(Class,Mother,_,_,_),OriginalKB,TemporalKB),
	changeMother(Class,Mother,TemporalKB,TemporalKB2),
	delete_relations_with_class(Class,TemporalKB2,NewKB).

changeMother(_,_,[],[]).

changeMother(OldMother,NewMother,[class(C,OldMother,P,R,O)|T],[class(C,NewMother,P,R,O)|N]):-
	changeMother(OldMother,NewMother,T,N).

changeMother(OldMother,NewMother,[H|T],[H|N]):-
	changeMother(OldMother,NewMother,T,N).

deleteClass(_,[],[]).

deleteClass(X,[X|T],N):-
	deleteClass(X,T,N).

deleteClass(X,[H|T],[H|N]):-
	deleteClass(X,T,N),
	X\=H.

deleteClass(X,[P],N):-
	deleteClass(X,P,N).

delete_relations_with_class(_,[],[]).

delete_relations_with_class(Object,[class(C,M,P,R,O)|T],[class(C,M,P,NewR,NewO)|NewT]):-
	write("R:"),
	write(R),
	cancel_relation_class(Object,R,NewR),
	del_relations_class(Object,O,NewO),
	delete_relations_with_class(Object,T,NewT).

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

%Remove an object where Object is IDObject (id=>Object) --Borrar relación con objectos
% Example: abrir1(KB), rm_object(pinocho,KB,NewKB), guardar1(NewKB).
% Example: abrir1(KB), rm_object(monstruo,KB,NewKB), guardar1(NewKB).
% Example: abrir1(KB), rm_object(miky,KB,NewKB), guardar1(NewKB).
% Example: abrir1(KB), rm_object(timothy,KB,NewKB), guardar1(NewKB).

rm_object(Object,OriginalKB,NewKB) :-
	changeElement(class(Class,Mother,Props,Rels,Objects),class(Class,Mother,Props,Rels,NewObjects),OriginalKB,TemporalKB),
	isElement(Object,Objects),
	deleteElement(Object,Objects,NewObjects),
	delete_relations_with_object(Object,TemporalKB,NewKB).
	
delete_relations_with_object(_,[],[]).

delete_relations_with_object(Object,[class(C,M,P,R,O)|T],[class(C,M,P,NewR,NewO)|NewT]):-
	cancel_relation(Object,R,NewR),
	write("Relaciones:"),
	write(R),
	del_relations(Object,O,NewO),
	delete_relations_with_object(Object,T,NewT).

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

%Remove a class property
% Example: abrir1(KB), rm_class_property(ballena,ponen_huevos,KB,NewKB), guardar1(NewKB).
% Example: abrir1(KB), rm_class_property(humano,muerde,KB,NewKB), guardar1(NewKB).

rm_class_property(Class,Property,OriginalKB,NewKB) :-
	changeElement(class(Class,Mother,[Props|T],Rels,Objects),class(Class,Mother,[NewProps|T],Rels,Objects),OriginalKB,NewKB),
	deleteAllElementsWithSameProperty(Property,Props,Aux),
	deleteElement(no(Property),Aux,Aux2),
	deleteElement(Property,Aux2,NewProps).

% Remove a class property preference
% Example: abrir1(KB), rm_class_property_preference(humano,carnivoro,2,KB,NewKB), guardar1(NewKB).

rm_class_property_preference(Class,Preference,Peso,OriginalKB,NewKB) :-
	changeElement(class(Class,Mother,[H,Prefs],Rels,Objects),class(Class,Mother,[H,NewPrefs],Rels,Objects),OriginalKB,NewKB),
	write("Pref:"),
	write(Prefs),
	deleteAllElementsWithSamePropertyPref(Preference,Peso,Prefs,Aux),
	deleteElement(no(Preference),Aux,Aux2),
	deleteElement(Preference,Aux2,NewPrefs).

%Remove a class relation
%Example: abrir1(KB), rm_class_relation(elefante,odia,KB,NewKB), guardar1(NewKB). 

rm_class_relation(Class,no(Relation),OriginalKB,NewKB) :-
	changeElement(class(Class,Mother,Props,[Rels|T],Objects),class(Class,Mother,Props,[NewRels|T],Objects),OriginalKB,NewKB),
	deleteAllElementsWithSameNegatedProperty(Relation,Rels,NewRels).

rm_class_relation(Class,Relation,OriginalKB,NewKB) :-
	changeElement(class(Class,Mother,Props,[Rels|T],Objects),class(Class,Mother,Props,[NewRels|T],Objects),OriginalKB,NewKB),
	deleteAllElementsWithSameProperty(Relation,Rels,NewRels).

%Remove a class relation preference
% Example: abrir1(KB), rm_class_relation_preference(mamiferos,amigo,2,KB,NewKB), guardar1(NewKB).
% Example: abrir1(KB), rm_class_relation_preference(mamiferos,dentro,0,KB,NewKB), guardar1(NewKB).
% Example: abrir1(KB), rm_class_relation_preference(humano,no(ecologista),1,KB,NewKB), guardar1(NewKB).

rm_class_relation_preference(Class,no(Preference),Peso,OriginalKB,NewKB) :-
	changeElement(class(Class,Mother,Props,[H,Prefs],Objects),class(Class,Mother,Props,[H,NewPrefs],Objects),OriginalKB,NewKB),
	deleteAllElementsWithSameNegatedPropertyPref(Preference,Peso,Prefs,NewPrefs).

rm_class_relation_preference(Class,Preference,Peso,OriginalKB,NewKB) :-
	changeElement(class(Class,Mother,Props,[H,Prefs],Objects),class(Class,Mother,Props,[H,NewPrefs],Objects),OriginalKB,NewKB),
	deleteAllElementsWithSamePropertyPref(Preference,Peso,Prefs,NewPrefs).

%Remove an object property
%Example: abrir1(KB), rm_object_property(dumbito,vuela,KB,NewKB), guardar1(NewKB).
%Example: abrir1(KB), rm_object_property(msJumbo,no(vuela),KB,NewKB), guardar1(NewKB).

rm_object_property(Object,Property,OriginalKB,NewKB) :-
	changeElement(class(Class,Mother,Props,Rels,Objects),class(Class,Mother,Props,Rels,NewObjects),OriginalKB,NewKB),
	write("Objects:"),
	write(Objects),
	isElementC([id=>Object,[Properties|T],Relations],Objects,AObject),
	write(Properties),
	changeElement([id=>AObject,[Properties|T],Relations],[id=>AObject,[NewProperties|T],Relations],Objects,NewObjects),
	deleteAllElementsWithSameProperty(Property,Properties,Aux),
	deleteElement(no(Property),Aux,Aux2),
	deleteElement(Property,Aux2,NewProperties).

rm_object_property(Object,no(Property),OriginalKB,NewKB) :-
	changeElement(class(Class,Mother,Props,Rels,Objects),class(Class,Mother,Props,Rels,NewObjects),OriginalKB,NewKB),
	write("Objects:"),
	write(Objects),
	isElementC([id=>Object,[Properties|T],Relations],Objects,AObject),
	write(Properties),
	changeElement([id=>AObject,[Properties|T],Relations],[id=>AObject,[NewProperties|T],Relations],Objects,NewObjects),
	deleteAllElementsWithSameNegatedProperty(Property,Properties,Aux),
	deleteElement(no(Property),Aux,Aux2),
	deleteElement(Property,Aux2,NewProperties).

%Remove an object property preference
%Example: abrir1(KB), rm_object_property_preference(miky,no(miedoso),0,KB,NewKB), guardar1(NewKB).
%Example: abrir1(KB), rm_object_property_preference(timothy,animal,0,KB,NewKB), guardar1(NewKB).

rm_object_property_preference(Object,Preference,Peso,OriginalKB,NewKB) :-
	changeElement(class(Class,Mother,Props,Rels,Objects),class(Class,Mother,Props,Rels,NewObjects),OriginalKB,NewKB),
	isElementC([id=>Object,[H,Preferences],Relations],Objects,AObject),
	write("Pref:"),
	write(Preferences),
	changeElement([id=>AObject,[H,Preferences],Relations],[id=>AObject,[H,NewPreferences],Relations],Objects,NewObjects),
	deleteAllElementsWithSamePropertyPref(Preference,Peso,Preferences,Aux),
	deleteElement(no(Preference),Aux,Aux2),
	deleteElement(Preference,Aux2,NewPreferences).

%Remove an object relation
%Example: abrir1(KB), rm_object_relation(dumbo,no(odia),KB,NewKB), guardar1(NewKB).
%Example: abrir1(KB), rm_object_relation(timothy,come,KB,NewKB), guardar1(NewKB).

rm_object_relation(Object,no(Relation),OriginalKB,NewKB) :-
	changeElement(class(Class,Mother,Props,Rels,Objects),class(Class,Mother,Props,Rels,NewObjects),OriginalKB,NewKB),
	isElementC([id=>Object,Properties,[Relations|T]],Objects,AObject),
	changeElement([id=>AObject,Properties,[Relations|T]],[id=>AObject,Properties,[NewRelations|T]],Objects,NewObjects),
	deleteAllElementsWithSameNegatedProperty(Relation,Relations,NewRelations).

rm_object_relation(Object,Relation,OriginalKB,NewKB) :-
	changeElement(class(Class,Mother,Props,Rels,Objects),class(Class,Mother,Props,Rels,NewObjects),OriginalKB,NewKB),
	isElementC([id=>Object,Properties,[Relations|T]],Objects, AObject),
	write(Relations),
	changeElement([id=>AObject,Properties,[Relations|T]],[id=>AObject,Properties,[NewRelations|T]],Objects,NewObjects),
	deleteAllElementsWithSameProperty(Relation,Relations,NewRelations).

isElementC([id=>Object,Properties,Relations],[[id=>Lista,Properties,Relations]|_],Lista):-
	write("elements:"),
	write(Lista),
	member(Object,Lista).

isElementC(X,[_|T],AObject):-
	write("T:"),
	write(T),
	isElementC(X,T,AObject).	

%Remove an object relation preference
%Example: abrir1(KB), rm_object_relation_pref(monstruo,ecologista,1,KB,NewKB), guardar1(NewKB).
%Example: abrir1(KB), rm_object_relation_pref(monstruo,ecologista,2,KB,NewKB), guardar1(NewKB).
rm_object_relation_pref(Object,no(Preference),Peso,OriginalKB,NewKB) :-
	changeElement(class(Class,Mother,Props,Rels,Objects),class(Class,Mother,Props,Rels,NewObjects),OriginalKB,NewKB),
	isElementC([id=>Object,Properties,[Relations,Preferences]],Objects,AObject),
	write(Preferences),
	changeElement([id=>AObject,Properties,[Relations,Preferences]],[id=>AObject,Properties,[Relations, NewPreferences]],Objects,NewObjects),
	deleteAllElementsWithSameNegatedPropertyPref(Preference,Peso,Preferences,NewPreferences).

rm_object_relation_pref(Object,Preference,Peso,OriginalKB,NewKB) :-
	changeElement(class(Class,Mother,Props,Rels,Objects),class(Class,Mother,Props,Rels,NewObjects),OriginalKB,NewKB),
	isElementC([id=>Object,Properties,[Relations,Preferences]],Objects, AObject),
	write(Preferences),
	changeElement([id=>AObject,Properties,[Relations,Preferences]],[id=>AObject,Properties,[Relations,NewPreferences]],Objects,NewObjects),
	deleteAllElementsWithSamePropertyPref(Preference,Peso,Preferences,NewPreferences).
