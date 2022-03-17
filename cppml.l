%option noyywrap
			/*----- Seccion de Declaraciones ----------------*/

%{

#include <iostream>
#include <stdio.h>
#include <string>
#include <fstream>

using namespace std;

ifstream fichero;
string lib , numbers , name , aux;
int  nc, np, nl , i , j=1 , tam_mark;
bool comparar_string( int tam , string cad1 , string cad2 );

%}

%s library
%s namesp
%s vector
%S loop
%s num_vector
%s char_vector
%s for0c
%s for1c
%s while0c
%s while1c
%s if0c
%s if1c
%s else0c

blank		[\ \t]
word		[a-z]+
num			[0-9]+
end			%
comp		>=|>|<|<=
lib			[A-Z]+%{blank}
content		.+?
mark		%+[A-Z]+{blank}
inc         [+--]{num}
attrib		[A-Z]:
name_vector	[A-Z]+{blank}{attrib}
		

%%

			/*----- Seccion de Reglas ----------------*/ 

<INITIAL>{lib}	{

	if( comparar_string(8,yytext,"LYBRARY% ") ){
		
		BEGIN(library);

	}	if( comparar_string(10,yytext,"NAMESPACE% ") ){
		
		BEGIN(namesp);

	}
}

<INITIAL>{mark}	{

	if(  comparar_string(7,yytext,"%VECTOR ") ) {
		
		BEGIN(vector);

	}else if( comparar_string(5,yytext,"%LOOP ") ){

		BEGIN(loop);

	}else if( comparar_string(3,yytext,"%IF") ){
		printf("if");
		BEGIN(if0c);

	}else if( comparar_string(5,yytext,"%ELSE") ){
		printf("else");
		BEGIN(else0c);

	}
	else{

		BEGIN(INITIAL);

	}

}

<loop>{name_vector}	{

	if ( comparar_string(6,yytext,"FOR C:") ){

		BEGIN(for0c);
		printf("for");

	}
	if ( comparar_string(6,yytext,"WHILE C:") ){

		BEGIN(while0c);
		printf("while");

	}

}

<while0c>{word}{comp}{num}	{

	printf("( %s ){\n",yytext);

}

<while0c>{word}{comp}{word}	{

	printf("( %s ){\n",yytext);

}

<while0c>{word}	{

	printf("( %s ){\n",yytext);

}

<while0c>{attrib}	{

	if( comparar_string(2,yytext,"B:") ){

		BEGIN(while1c);
		
	}

}

<while1c>{content};	{

	printf("\n");
	printf("	%s\n",yytext);
	printf("\n");

}

<while1c>{end}	{

	printf("}\n");
	printf("\n");	
	BEGIN(INITIAL);

}

<while1c>{mark}	{

	if(  comparar_string(7,yytext,"%VECTOR ") ) {
		
		BEGIN(vector);

	}else if( comparar_string(5,yytext,"%LOOP ") ){

		BEGIN(loop);

	}else if( comparar_string(3,yytext,"%IF") ){
		printf("if");
		BEGIN(if0c);

	}else if( comparar_string(5,yytext,"%ELSE") ){
		printf("else");
		BEGIN(else0c);

	}
	else{

		BEGIN(INITIAL);

	}

}


<if0c>{word}{comp}{num}	{

	printf("( %s ){\n",yytext);

}

<if0c>{word}{comp}{word}	{

	printf("( %s ){\n",yytext);

}

<if0c>{word}	{

	printf("( %s ){\n",yytext);

}

<if0c>{attrib}	{

	if( comparar_string(2,yytext,"B:") ){

		BEGIN(if1c);
		
	}

}

<if1c>{content};	{

	printf("\n");
	printf("	%s\n",yytext);
	printf("\n");

}

<if1c>{mark}	{

	if(  comparar_string(7,yytext,"%VECTOR ") ) {
		
		BEGIN(vector);

	}else if( comparar_string(5,yytext,"%LOOP ") ){

		BEGIN(loop);

	}else if( comparar_string(3,yytext,"%IF") ){
		printf("if");
		BEGIN(if0c);

	}else if( comparar_string(5,yytext,"%ELSE") ){
		printf("else");
		BEGIN(else0c);

	}
	else{

		BEGIN(INITIAL);

	}

}

<if1c>{end}	{

	printf("}\n");
	printf("\n");	
	BEGIN(INITIAL);

}

<else0c>{content};	{

	printf("\n");
	printf("	%s\n",yytext);
	printf("\n");

}

<for0c>{num};	{

	printf("(int i=%s",yytext);

}

<for0c>{comp}{num};	{

	printf("i%s",yytext);

}



<for0c>{inc}	{

	if (comparar_string(1,yytext,"+")){

		printf( "i=i%s ){\n" , yytext );

	}else if (comparar_string(1,yytext,"-")){

		printf( "i=i%s ){\n" , yytext );

	}

}

<for0c>{end}	{

	BEGIN(INITIAL);

}

<for0c>{attrib}	{

	if( comparar_string(2,yytext,"B:") ){

		BEGIN(for1c);
		
	}

}

<for1c>{content};	{

	printf("\n");
	printf("	%s\n",yytext);
	printf("\n");

}

<for1c>{end}	{

	printf("}\n");	
	BEGIN(INITIAL);

}

<for1c>{mark}	{

	if(  comparar_string(7,yytext,"%VECTOR ") ) {
		
		BEGIN(vector);

	}else if( comparar_string(5,yytext,"%LOOP ") ){

		BEGIN(loop);

	}else if( comparar_string(3,yytext,"%IF") ){
		printf("if");
		BEGIN(if0c);

	}else if( comparar_string(5,yytext,"%ELSE") ){
		printf("else");
		BEGIN(else0c);

	}
	else{

		BEGIN(INITIAL);

	}

}

<vector>{name_vector} {

	if( comparar_string(10,yytext,"NATURAL N: ") ){

		BEGIN(num_vector);
		printf("int ");

	}else if( comparar_string(10,yytext,"DECIMAL N: ") ){

		BEGIN(num_vector);
		printf("double ");

	}else if ( comparar_string(10,yytext,"BOOLEAN N: ") ){

		BEGIN(num_vector);
		printf("bool ");		

	}
	else{

		BEGIN(INITIAL);

	}

}

<num_vector>{word}	{

	printf("%s",yytext);

}

<num_vector>{num}	{

	printf("[%s]",yytext);

}

<namesp>{word}	{

	printf("using namespace %s;\n",yytext);

}

<namesp>{end}	{

	BEGIN(INITIAL);

}

<library>{word}	{

	printf("#include <%s>\n",yytext);

}

<library>{word}.h	{

	printf("#include <%s>\n",yytext);

}

<library>{end}	{

	BEGIN(INITIAL);

}

<num_vector>{end}	{

	printf(";\n");
	BEGIN(INITIAL);

}


%%
			/*----- Seccion de Procedimientos --------*/

int main (int argc, char *argv[]){

	if (argc == 2){
		fichero.open (argv[1]);

	}else
	 exit(1);

	yyFlexLexer flujo (&fichero,0);
	flujo.yylex();

	return 0;

}

bool comparar_string( int tam , string cad1 , string cad2 ){ 

	bool igual= true;
	for ( int i=0 ; ( (i<tam) && (igual==true) ) ; i++ )
	{
		if( cad1[i] != cad2[i] )
			igual = false;
	}
	return igual;

}

